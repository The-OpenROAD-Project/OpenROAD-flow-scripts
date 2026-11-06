"""DRC decks in Python on the PyPI klayout module.

KLayout's DRC language is Ruby, which the klayout Python module does not
include (KLayout/klayout#1772). The language is a thin layer over
klayout.db's Region, Edges and EdgePairs (KLayout/klayout#1980). This
module is that layer for the operations ORFS's decks use: each Layer
method calls klayout.db the way KLayout's DRC language does
(src/drc/drc/built-in-macros/_drc_layer.rb), with the same defaults, so
a deck translated line by line reports the same violations.

Values follow the DRC language: a float is in microns (nm(20), um(1.5)),
an int is in database units; ranges are (min, max) tuples, either end
None for unbounded.
"""

import argparse
import importlib.util
import os
import sys
import time

try:
    import klayout.db as db
    import klayout.rdb as rdb
except ImportError:
    db = None
    rdb = None


def nm(v):
    return v * 0.001


def um(v):
    return float(v)


def mm(v):
    return v * 1000.0


class _Option:
    def __init__(self, kind, value):
        self.kind = kind
        self.value = value


# Check options, as the DRC language's keywords of the same names
projection = _Option("metrics", "Projection")
euclidian = _Option("metrics", "Euclidian")
square = _Option("metrics", "Square")
whole_edges = _Option("whole_edges", True)
both = _Option("both", True)


def _rect_filter(name):
    return _Option("rect_filter", name)


one_side_allowed = _rect_filter("OneSideAllowed")
two_sides_allowed = _rect_filter("TwoSidesAllowed")
two_connected_sides_allowed = _rect_filter("TwoConnectedSidesAllowed")
two_opposite_sides_allowed = _rect_filter("TwoOppositeSidesAllowed")
three_sides_allowed = _rect_filter("ThreeSidesAllowed")
four_sides_allowed = _rect_filter("FourSidesAllowed")


def angle_limit(a):
    return _Option("angle_limit", a)


def projection_limits(lo, hi=None):
    return _Option("projection_limits", (lo, hi))


transparent = _Option("shielded", False)
shielded = _Option("shielded", True)
ortho = _Option("edge_kind", "OrthoEdges")
diagonal = _Option("edge_kind", "DiagonalEdges")
diagonal_only = _Option("edge_kind", "DiagonalOnlyEdges")
diamond_limit = _Option("size_mode", 0)
octagon_limit = _Option("size_mode", 1)
square_limit = _Option("size_mode", 2)
acute_limit = _Option("size_mode", 3)
no_limit = _Option("size_mode", 4)
padding_zero = _Option("padding", "zero")
padding_ignore = _Option("padding", "ignore")


def tile_size(deck, x, y=None):
    """The DRC language's tile_size, in microns."""
    return _Option("tile_size", (deck.v(x) * deck.dbu, deck.v(y or x) * deck.dbu))


def tile_step(deck, x, y=None):
    return _Option("tile_step", (deck.v(x) * deck.dbu, deck.v(y or x) * deck.dbu))


def tile_origin(x, y):
    """In microns, as DRCTileOrigin."""
    return _Option("tile_origin", (x, y))


def tile_count(x, y):
    return _Option("tile_count", (x, y))


def tile_boundary(layer):
    return _Option("tile_boundary", layer)


class _Universal:
    """A width/space/notch/separation/enclosing check inside drc().

    Built by width(...) and compared with a value, as in the DRC
    language: drc(width(projection) < nm(108)).
    """

    def __init__(self, check, other, opts):
        self.check = check
        self.other = other
        self.opts = opts
        self.lt = self.le = self.gt = self.ge = None
        self.mode_or = False

    def _copy(self):
        c = _Universal(self.check, self.other, self.opts)
        return c

    def __lt__(self, v):
        c = self._copy()
        c.lt = v
        return c

    def __le__(self, v):
        c = self._copy()
        c.le = v
        return c

    def __gt__(self, v):
        c = self._copy()
        c.gt = v
        return c

    def __ge__(self, v):
        c = self._copy()
        c.ge = v
        return c

    def __ne__(self, v):
        c = self._copy()
        c.lt = v
        c.gt = v
        c.mode_or = True
        return c

    def node(self, deck):
        """CompoundRegionOperationNode, as DRCOpNodeCheck.do_create_node."""
        f = getattr(db.CompoundRegionOperationNode, "new_%s_check" % self.check)
        o = deck._check_options(self.check, self.opts, universal=True)
        oargs = []
        if self.other is not None:
            oargs.append(db.CompoundRegionOperationNode.new_secondary(self.other.data))
        res = None
        if self.lt is not None or self.le is not None:
            dmin = deck.v(self.le) + 1 if self.le is not None else deck.v(self.lt)
            res = f(*(oargs + [dmin] + o))
        if self.gt is not None or self.ge is not None:
            dmax = deck.v(self.ge) if self.ge is not None else deck.v(self.gt) + 1
            if res is None:
                res = f(*(oargs + [dmax] + o + [True]))
            elif self.mode_or:
                max_check = f(*(oargs + [dmax] + o + [True]))
                if self.check in ("width", "notch"):
                    other = db.CompoundRegionOperationNode.new_edges(res)
                else:
                    other = db.CompoundRegionOperationNode.new_edge_pair_to_first_edges(
                        res
                    )
                res_max = db.CompoundRegionOperationNode.new_edge_pair_to_first_edges(
                    max_check
                )
                res = db.CompoundRegionOperationNode.new_join([other, res_max])
            else:
                raise ValueError("min and max bounds are not supported")
        return res


def width(*opts):
    return _Universal("width", None, opts)


def space(*opts):
    return _Universal("space", None, opts)


class Deck:
    """The engine: the layout, the mode, and the report database."""

    def __init__(self, in_gds, report_file, description, mode="deep", threads=1):
        if db is None:
            print(
                "ERROR: the klayout Python module is not installed, pip install"
                " klayout (etc/requirements-common_lock.txt)"
            )
            sys.exit(1)
        self.t0 = time.time()
        self.layout = db.Layout()
        print("Reading %s .." % in_gds)
        self.layout.read(in_gds)
        self.top = self.layout.top_cell()
        self.dbu = self.layout.dbu
        self.threads = threads
        self.tiles = None
        self.tile_borders = None
        self.dss = None
        self.l2n = None
        if mode == "deep":
            self.dss = db.DeepShapeStore()
            self.dss.text_property_name = "LABEL"
            self.dss.text_enlargement = 0
            self.dss.threads = threads
        elif mode != "flat":
            raise ValueError("mode is deep or flat, got %r" % mode)
        self.report_file = report_file
        self.rdb = rdb.ReportDatabase(report_file.split("/")[-1])
        self.rdb.generator = "klayout_drc.py"
        self.rdb.top_cell_name = self.top.name
        self.rdb.description = description
        self.rdb_cell = self.rdb.create_cell(self.top.name)
        self.categories = {}

    # Values, as the DRC engine's _prep_value

    def v(self, a):
        if a is None:
            return None
        if isinstance(a, float):
            return int((0.5 + a / self.dbu) // 1)
        return a

    def area(self, a):
        if a is None:
            return None
        if isinstance(a, float):
            return int((0.5 + a / (self.dbu * self.dbu)) // 1)
        return a

    def select(self, *sel):
        """A source with a cell selection, as the DRC language's
        source.select("-CELL", "+CELL", ...)."""
        return Source(self, list(sel))

    def input(self, layer, datatype=0):
        return Source(self, []).input(layer, datatype)

    def polygons(self, layer, datatype=0):
        return Source(self, []).polygons(layer, datatype)

    def labels(self, layer, datatype=0):
        return Source(self, []).labels(layer, datatype)

    def _input(self, layer, datatype, flags, sel, cls=None):
        if isinstance(layer, str):
            # A layer map expression, "67/0-4,6-43,45-*"
            lm = db.LayerMap()
            lm.map(layer, 0)
            layers = [
                li
                for li in self.layout.layer_indexes()
                if lm.is_mapped(self.layout.get_info(li))
            ]
        else:
            li = self.layout.find_layer(layer, datatype)
            layers = [] if li is None else [li]
        cls = cls or db.Region
        if not layers and self.dss is None:
            return Layer(self, cls())
        it = db.RecursiveShapeIterator(self.layout, self.top, layers)
        it.shape_flags = flags
        for c in sel:
            if c == "-":
                it.unselect_cells([self.top.cell_index()])
            elif c == "-*":
                it.unselect_all_cells()
            elif c == "+*":
                it.select_all_cells()
            elif c.startswith("-"):
                it.unselect_cells(c[1:])
            elif c.startswith("+"):
                it.select_cells(c[1:])
            else:
                it.select_cells(c)
        if self.dss is not None:
            r = cls(it, self.dss, db.ICplxTrans(1.0))
        else:
            r = cls(it, db.ICplxTrans(1.0))
        return Layer(self, r)

    def polygon_layer(self):
        return Layer(self, db.Region())

    # Connectivity, as the DRC language's netter (_drc_netter.rb)

    def _l2n_register(self, data):
        if self.l2n is None:
            if self.dss is not None:
                self.l2n = db.LayoutToNetlist(self.dss)
            else:
                self.l2n = db.LayoutToNetlist(self.top.name, self.dbu)
            self.l2n.name = "DRC"
            self.l2n_layers = {}
        if data.data_id() in self.l2n_layers:
            return
        name = "l%d" % (len(self.l2n_layers) + 1)
        self.l2n_layers[data.data_id()] = data
        self.l2n.register(data, name)

    def connect(self, a, b):
        self._l2n_register(a.data)
        self._l2n_register(b.data)
        self.l2n.connect(a.data)
        self.l2n.connect(b.data)
        self.l2n.connect(a.data, b.data)

    def clear_connections(self):
        self.l2n = None

    def _l2n_data(self):
        if not self.l2n.is_extracted():
            self.l2n.clear_join_net_names()
            self.l2n.clear_join_nets()
            self.l2n.extract_netlist()
            self.l2n.check_extraction_errors()
        return self.l2n

    def antenna_check(self, gate, metal, ratio, *diodes):
        """Gate and metal are layers (area only); diodes are layers or
        (layer, area per diode) pairs."""
        dl = []
        for d in diodes:
            if isinstance(d, tuple):
                dl.append([d[0].data, float(d[1])])
            else:
                dl.append([d.data, 0.0])
        return Layer(
            self,
            self._l2n_data().antenna_check(
                gate.data, 1.0, 0.0, metal.data, 1.0, 0.0, ratio, dl
            ),
        )

    def info(self, msg):
        print("%7.1fs %s" % (time.time() - self.t0, msg), flush=True)

    def output(self, data, name, description=None):
        cat = self.categories.get(name)
        if cat is None:
            cat = self.rdb.create_category(name)
            self.categories[name] = cat
        if description:
            cat.description = description
        cat.scan_collection(self.rdb_cell, db.CplxTrans(self.dbu), data)

    def write(self):
        self.info("Writing report database: %s .." % self.report_file)
        self.rdb.save(self.report_file)

    def _check_options(self, check, opts, universal=False):
        """The positional arguments after the value, as _drc_layer.rb."""
        metrics = db.Region.Euclidian
        minp = maxp = alim = None
        whole = False
        shield = None
        rect_filter = 0
        for a in opts:
            if isinstance(a, _Option) and a.kind == "metrics":
                metrics = getattr(db.Region, a.value)
            elif isinstance(a, _Option) and a.kind == "whole_edges":
                whole = a.value
            elif isinstance(a, _Option) and a.kind == "angle_limit":
                alim = a.value
            elif isinstance(a, _Option) and a.kind == "projection_limits":
                lo, hi = a.value
                minp = self.v(lo)
                maxp = None if hi is None else self.v(hi)
            elif isinstance(a, _Option) and a.kind == "shielded":
                shield = a.value
            elif isinstance(a, _Option) and a.kind == "rect_filter":
                rect_filter |= getattr(db.Region, a.value).to_i()
            else:
                raise ValueError("unexpected check option %r" % (a,))
        args = [whole, metrics, alim, minp, maxp]
        args.append(True if shield is None else shield)
        if check not in ("width", "notch"):
            args.append(db.Region.NoOppositeFilter)
            args.append(db.Region.RectFilter(rect_filter))
        if not universal:
            args.append(False)  # negative
            args.append(db.Region.IgnoreProperties)
        args.append(db.Region.IncludeZeroDistanceWhenTouching)
        return args


class Source:
    """The layout's top cell, with a cell selection."""

    def __init__(self, deck, sel):
        self.deck = deck
        self.sel = sel

    def select(self, *sel):
        return Source(self.deck, self.sel + list(sel))

    def input(self, layer, datatype=0):
        """All shapes of a layer, texts as well."""
        return self.deck._input(layer, datatype, db.Shapes.SAll, self.sel)

    def polygons(self, layer, datatype=0):
        """The polygons, boxes and paths of a layer."""
        flags = (
            db.Shapes.SBoxes
            | db.Shapes.SPaths
            | db.Shapes.SPolygons
            | db.Shapes.SEdgePairs
        )
        return self.deck._input(layer, datatype, flags, self.sel)

    def labels(self, layer, datatype=0):
        """The texts of a layer."""
        return self.deck._input(layer, datatype, db.Shapes.STexts, self.sel, db.Texts)


def _is_region(d):
    return isinstance(d, db.Region)


def _is_edges(d):
    return isinstance(d, db.Edges)


def _is_edge_pairs(d):
    return isinstance(d, db.EdgePairs)


def _range(deck, args, conv):
    """(min, max) from one value, a (min, max) tuple, or two values."""
    if len(args) == 1:
        a = args[0]
        if isinstance(a, tuple):
            return [conv(a[0]), conv(a[1])]
        return [conv(a)]
    if len(args) == 2:
        return [conv(args[0]), conv(args[1])]
    raise ValueError("1 or 2 range arguments expected")


class Layer:
    """A DRC layer: a Region, Edges or EdgePairs."""

    def __init__(self, deck, data):
        self.deck = deck
        self.data = data

    def _new(self, data):
        return Layer(self.deck, data)

    def output(self, name, description=None):
        self.deck.output(self.data, name, description)

    def forget(self):
        self.data = None

    # Booleans

    def __and__(self, other):
        return self._new(self.data & other.data)

    def __sub__(self, other):
        return self._new(self.data - other.data)

    def __or__(self, other):
        return self._new(self.data | other.data)

    def __add__(self, other):
        return self._new(self.data + other.data)

    def and_(self, other):
        return self & other

    def not_(self, other):
        return self - other

    def or_(self, other):
        return self | other

    def join(self, other):
        return self + other

    def andnot(self, other):
        a, b = self.data.andnot(other.data)
        return self._new(a), self._new(b)

    # Interactions

    def interacting(self, other, *count):
        return self._new(self.data.interacting(other.data, *count))

    def not_interacting(self, other, *count):
        return self._new(self.data.not_interacting(other.data, *count))

    def overlapping(self, other, *count):
        return self._new(self.data.overlapping(other.data, *count))

    def not_overlapping(self, other, *count):
        return self._new(self.data.not_overlapping(other.data, *count))

    def inside(self, other):
        return self._new(self.data.inside(other.data))

    def not_inside(self, other):
        return self._new(self.data.not_inside(other.data))

    def outside(self, other):
        return self._new(self.data.outside(other.data))

    def covering(self, other, *count):
        return self._new(self.data.covering(other.data, *count))

    # Checks

    def _check(self, check, *args):
        value = None
        other = None
        rest = []
        for a in args:
            if isinstance(a, Layer):
                other = a
            elif isinstance(a, (int, float)) and not isinstance(a, bool):
                if value is not None:
                    raise ValueError("value already specified")
                value = a
            else:
                rest.append(a)
        if value is None:
            raise ValueError("a check value must be specified")
        opts = self.deck._check_options(check, rest)
        if not _is_region(self.data):
            # Edges checks take no shielded, filters, negative or properties
            opts = opts[:5] + opts[-1:]
        f = getattr(self.data, "%s_check" % check)
        if other is None:
            return self._new(f(self.deck.v(value), *opts))
        return self._new(f(other.data, self.deck.v(value), *opts))

    def width(self, *args):
        return self._check("width", *args)

    def space(self, *args):
        return self._check("space", *args)

    def notch(self, *args):
        return self._check("notch", *args)

    def isolated(self, *args):
        return self._check("isolated", *args)

    def separation(self, *args):
        return self._check("separation", *args)

    def enclosing(self, *args):
        return self._check("enclosing", *args)

    def enclosed(self, *args):
        return self._check("enclosed", *args)

    def overlap(self, *args):
        return self._check("overlap", *args)

    def drc(self, op):
        node = op.node(self.deck)
        return self._new(self.data.complex_op(node, db.Region.IgnoreProperties))

    def ongrid(self, gx, gy=None):
        gy = gx if gy is None else gy
        return self._new(self.data.grid_check(self.deck.v(gx), self.deck.v(gy)))

    # Filters

    def with_area(self, *args):
        return self._new(
            self.data.with_area(*_range(self.deck, args, self.deck.area), False)
        )

    def without_area(self, *args):
        return self._new(
            self.data.with_area(*_range(self.deck, args, self.deck.area), True)
        )

    def _bbox(self, f, inv, args):
        return self._new(
            getattr(self.data, "with_" + f)(*_range(self.deck, args, self.deck.v), inv)
        )

    def with_bbox_height(self, *args):
        return self._bbox("bbox_height", False, args)

    def without_bbox_height(self, *args):
        return self._bbox("bbox_height", True, args)

    def with_bbox_width(self, *args):
        return self._bbox("bbox_width", False, args)

    def without_bbox_width(self, *args):
        return self._bbox("bbox_width", True, args)

    def with_bbox_min(self, *args):
        return self._bbox("bbox_min", False, args)

    def without_bbox_min(self, *args):
        return self._bbox("bbox_min", True, args)

    def with_length(self, *args):
        return self._length(False, args)

    def without_length(self, *args):
        return self._length(True, args)

    def _length(self, inv, args):
        f = "with_length"
        if args and args[-1] is both:
            f = "with_length_both"
            args = args[:-1]
        return self._new(
            getattr(self.data, f)(*_range(self.deck, args, self.deck.v), inv)
        )

    def with_angle(self, *args):
        return self._angle(False, args)

    def without_angle(self, *args):
        return self._angle(True, args)

    def _angle(self, inv, args):
        f = "with_angle"
        if both in args:
            f = "with_angle_both"
            args = tuple(a for a in args if a is not both)
        if len(args) == 1 and isinstance(args[0], _Option):
            kind = getattr(db.Edges, args[0].value)
            return self._new(getattr(self.data, f)(kind, inv))
        return self._new(getattr(self.data, f)(*_range(None, args, float), inv))

    def with_holes(self, *args):
        return self._holes(False, args)

    def without_holes(self, *args):
        return self._holes(True, args)

    def _holes(self, inv, args):
        if not args:
            lo, hi = 1, None
        elif len(args) == 1 and isinstance(args[0], tuple):
            lo, hi = args[0]
            hi = None if hi is None else hi + 1
        elif len(args) == 1:
            lo, hi = args[0], args[0] + 1
        else:
            lo, hi = args[0], None if args[1] is None else args[1] + 1
        return self._new(self.data.with_holes(lo, hi, inv))

    # Conversions

    def edges(self):
        if _is_region(self.data):
            return self._new(self.data.edges(db.EdgeMode.All))
        return self._new(self.data.edges())

    def first_edges(self):
        return self._new(self.data.first_edges())

    def second_edges(self):
        return self._new(self.data.second_edges())

    def polygons(self, e=None):
        if e is None:
            return self._new(self.data.polygons())
        return self._new(self.data.polygons(self.deck.v(e)))

    def holes(self):
        return self._new(self.data.holes())

    def hulls(self):
        return self._new(self.data.hulls())

    def merged(self):
        return self._new(self.data.merged())

    def extents(self):
        return self._new(self.data.extents())

    def extended_out(self, d):
        return self._new(self.data.extended_out(self.deck.v(d)))

    def extended_in(self, d):
        return self._new(self.data.extended_in(self.deck.v(d)))

    def extended(self, b=0, e=0, o=0, i=0, joined=False):
        v = self.deck.v
        return self._new(self.data.extended(v(b), v(e), v(o), v(i), joined))

    def end_segments(self, length, fraction=0.0):
        return self._new(self.data.end_segments(self.deck.v(length), fraction))

    def corners(self, amin=-180.0, amax=None):
        if isinstance(amin, tuple):
            amin, amax = amin
        amax = amin if amax is None else amax
        return self._new(
            self.data.corners(float(amin), float(amax), 1, True, True, False, False)
        )

    def sized(self, *args):
        """sized(d), sized(dx, dy), each with a sizing mode option."""
        mode = 2
        values = []
        for a in args:
            if isinstance(a, _Option) and a.kind == "size_mode":
                mode = a.value
            else:
                values.append(self.deck.v(a))
        return self._new(self.data.sized(values[0], values[-1], mode))

    # Merged semantics and copies

    def raw(self):
        self.data.merged_semantics = False
        return self

    def clean(self):
        self.data.merged_semantics = True
        return self

    def merge(self, *args):
        """Merges in place."""
        self.data.merge(*[self.deck.v(a) for a in args])
        return self

    def dup(self):
        return self._new(self.data.dup())

    def is_merged(self):
        return self.data.is_merged()

    def hier_count(self):
        return self.data.hier_count()

    def bbox(self):
        """The bounding box in microns."""
        return db.DBox.from_ibox(self.data.bbox()) * self.deck.dbu

    def select_inside(self, other):
        """Selects in place."""
        self.data.select_inside(other.data)
        return self

    def texts(self, pattern="*"):
        if isinstance(self.data, db.Texts):
            return self._new(self.data.with_match(pattern, False))
        return self._new(self.data.texts(pattern, True))

    def with_distance(self, *args):
        return self._new(
            self.data.with_distance(*_range(self.deck, args, self.deck.v), False)
        )

    def without_distance(self, *args):
        return self._new(
            self.data.with_distance(*_range(self.deck, args, self.deck.v), True)
        )

    def with_density(self, *args):
        return self._with_density(False, args)

    def without_density(self, *args):
        return self._with_density(True, args)

    def _with_density(self, inverse, args):
        """Tiles whose density is in a range, as the DRC language's
        _with_density: a TilingProcessor with its expression script."""
        limits = [None, None]
        size = step = origin = count = boundary = None
        padding = "zero"
        for a in args:
            if isinstance(a, tuple):
                limits = list(a)
            elif a.kind == "tile_size":
                size = a.value
            elif a.kind == "tile_step":
                step = a.value
            elif a.kind == "tile_origin":
                origin = a.value
            elif a.kind == "tile_count":
                count = a.value
            elif a.kind == "tile_boundary":
                boundary = a.value
            elif a.kind == "padding":
                padding = a.value
            else:
                raise ValueError("unexpected density option %r" % (a,))
        if size is None:
            raise ValueError("at least the tile_size option needs to be present")
        step = step or size
        tp = db.TilingProcessor()
        tp.dbu = self.deck.dbu
        tp.scale_to_dbu = False
        tp.tile_size(*step)
        if size != step:
            xb = 0.5 * (size[0] - step[0])
            yb = 0.5 * (size[1] - step[1])
            tp.tile_border(xb, yb)
            tp.var("xoverlap", xb / tp.dbu)
            tp.var("yoverlap", yb / tp.dbu)
        else:
            tp.var("xoverlap", 0)
            tp.var("yoverlap", 0)
        if origin:
            tp.tile_origin(*origin)
        if count:
            tp.tiles(*count)
        res = db.Region()
        tp.output("res", res)
        tp.input("input", self.data)
        tp.threads = self.deck.threads
        if boundary is not None:
            bnd = boundary.data
        else:
            bnd = db.Region(self.data.bbox())
        tp.input("boundary", bnd)
        tp.var("vmin", limits[0] if limits[0] is not None else 0.0)
        tp.var("vmax", limits[1] if limits[1] is not None else 1.0)
        tp.var("inverse", inverse)
        if padding == "zero":
            tp.queue("""
          _tile && (
            var bx = _tile.bbox.enlarged(xoverlap, yoverlap);
            var d = to_f(input.area(bx)) / to_f(bx.area);
            ((d > vmin - 1e-10 && d < vmax + 1e-10) != inverse) && _output(res, bx, false)
          )
""")
        else:
            tp.queue("""
          _tile && (
            var bx = _tile.bbox.enlarged(xoverlap, yoverlap);
            var ba = boundary.area(bx);
            ba > 0 && (
              var d = to_f(input.area(bx)) / to_f(ba);
              ((d > vmin - 1e-10 && d < vmax + 1e-10) != inverse) && _output(res, bx, false)
            )
          )
""")
        tp.execute("Tiled density")
        return self._new(res)

    # Queries

    def is_empty(self):
        return self.data.is_empty()

    def count(self):
        return self.data.count()


def parse_args(argv):
    parser = argparse.ArgumentParser(
        description="Run a Python DRC deck on a GDS/OAS file and write a"
        " KLayout report database (.lyrdb)."
    )
    parser.add_argument("--deck", required=True, help="the deck, a .py file")
    parser.add_argument("--in-gds", required=True)
    parser.add_argument("--report-file", required=True)
    return parser.parse_args(argv)


def load_deck(path):
    # No __pycache__ next to the deck, in the platform directory
    sys.dont_write_bytecode = True
    spec = importlib.util.spec_from_file_location("klayout_drc_deck", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main(argv):
    args = parse_args(argv)
    module = load_deck(args.deck)
    deck = Deck(
        args.in_gds,
        args.report_file,
        module.DESCRIPTION,
        mode=module.MODE,
        threads=module.THREADS,
    )
    module.drc(deck)
    deck.write()
    deck.info("Total violations: %d" % deck.rdb.num_items())
    return 0


if __name__ == "__main__":
    # The deck imports this module as klayout_drc; run that one, not
    # __main__, so the options it passes are the objects checked here.
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    import klayout_drc

    sys.exit(klayout_drc.main(sys.argv[1:]))
