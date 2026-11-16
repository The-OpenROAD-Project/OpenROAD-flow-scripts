# Copyright 2025 IHP PDK Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""IHP SG13G2 minimal DRC deck, run by flow/util/klayout_drc.py on the
klayout module.

Translated line by line from the KLayout DRC language deck
sg13g2_minimal.lydrc, including the ext_* layer methods it adds to the
DRC language, which this deck adds to klayout_drc.Layer.
"""

import math

import klayout.db as db

from klayout_drc import (
    Layer,
    _Option,
    acute_limit,
    angle_limit,
    both,
    euclidian,
    ortho,
    padding_ignore,
    tile_boundary,
    tile_count,
    tile_origin,
    tile_size,
    tile_step,
    um,
)

DESCRIPTION = "design rules: sg13g2_minimal"
MODE = "deep"
THREADS = 1

DENSITY_RULES = True

CRON = db.CompoundRegionOperationNode


def _ip(edge_pair):
    """The point the two edges of an edge pair share, or None."""
    if (
        edge_pair.first.p1 == edge_pair.second.p1
        or edge_pair.first.p1 == edge_pair.second.p2
    ):
        return edge_pair.first.p1
    if (
        edge_pair.first.p2 == edge_pair.second.p1
        or edge_pair.first.p2 == edge_pair.second.p2
    ):
        return edge_pair.first.p2
    return None


def _angle(edge_pair):
    ep = edge_pair.normalized()
    v1 = ep.first.swapped_points().d()
    v2 = ep.second.d()
    return math.acos((v1.sprod(v2)) / (v1.length() * v2.length())) / math.pi * 180


class AbuttingEdges(db.EdgePairToEdgeOperator):
    def __init__(self):
        self.is_isotropic_and_scale_invariant()

    def process(self, edge_pair):
        if edge_pair.first.coincident(edge_pair.second):
            if edge_pair.first.length() < edge_pair.second.length():
                return [edge_pair.first]
            return [edge_pair.second]
        return []


class IntersectingEdgeErrorFilter(db.EdgePairOperator):
    def __init__(self, abutting_edges):
        self.abutting_edges = abutting_edges

    def process(self, edge_pair):
        ip = _ip(edge_pair)
        if ip is not None and not edge_pair.first.coincident(edge_pair.second):
            edges = db.Edges([edge_pair.first, edge_pair.second])
            region = self.abutting_edges.extents(1)
            if edges.interacting(region).count() == 2:
                if _angle(edge_pair) >= 90:
                    return []
        return [edge_pair]


class IntersectingEdgeErrorAngleFilter(db.EdgePairOperator):
    def __init__(self, min_angle, max_angle, include_min_angle, include_max_angle):
        self.is_isotropic_and_scale_invariant()
        self.min_angle = min_angle + (-1e-6 if include_min_angle else 1e-6)
        self.max_angle = max_angle + (1e-6 if include_max_angle else -1e-6)

    def process(self, edge_pair):
        if _ip(edge_pair) is not None:
            angle = _angle(edge_pair)
            if angle < self.min_angle or angle > self.max_angle:
                return []
        return [edge_pair]


def find_intersecting_edges_errors(
    deck,
    dbu_value,
    error_edge_pairs_90,
    error_edge_pairs_180,
    error_edge_pairs_90_180=None,
    inverse_error_edge_pairs_90=None,
    inverse_error_edge_pairs_180=None,
    consider_intersecting_edges=False,
    consider_touch_points=False,
    ignore_non_axis_aligned_edges=False,
    min_angle=0,
    max_angle=90,
    include_min_angle=True,
    include_max_angle=False,
):
    errors_ep = db.EdgePairs()
    touch_point_errors_ep = db.EdgePairs()
    abutting_edges_errors_ep = db.EdgePairs()
    intersecting_edges_error_candidates = {}
    no_touch_point_error = {}
    for edge_pair in error_edge_pairs_90.data.each():
        ip = _ip(edge_pair)
        if (
            ip is not None
            and not edge_pair.first.is_degenerate()
            and not edge_pair.second.is_degenerate()
        ):
            if (
                edge_pair.first.contains(edge_pair.second.p1)
                and edge_pair.first.contains(edge_pair.second.p2)
            ) or (
                edge_pair.second.contains(edge_pair.first.p1)
                and edge_pair.second.contains(edge_pair.first.p2)
            ):
                no_touch_point_error[ip] = True
    if consider_intersecting_edges or consider_touch_points:
        touch_point_candidates = {}
        touch_point_errors = {}
        if inverse_error_edge_pairs_90 and inverse_error_edge_pairs_180:
            for edge_pair in (
                inverse_error_edge_pairs_90 + inverse_error_edge_pairs_180
            ).data.each():
                ip = edge_pair.first.intersection_point(edge_pair.second)
                if ip is not None:
                    if ip in touch_point_candidates:
                        touch_point_errors[ip] = True
                        del touch_point_candidates[ip]
                    elif not no_touch_point_error.get(ip):
                        touch_point_candidates[ip] = edge_pair
        touch_point_candidates = {}
        if not error_edge_pairs_90_180:
            error_edge_pairs_90_180 = error_edge_pairs_90 + error_edge_pairs_180
        for edge_pair in error_edge_pairs_90_180.data.each():
            ip = _ip(edge_pair)
            if (
                ip is None
                and edge_pair.first.intersection_point(edge_pair.second) is not None
            ):
                abutting_edges_errors_ep.insert(edge_pair)
            if (
                ip
                and not edge_pair.first.is_degenerate()
                and not edge_pair.second.is_degenerate()
            ):
                intersecting_edges_error_candidates[ip] = edge_pair
                if touch_point_errors.get(ip):
                    touch_point_errors_ep.insert(edge_pair)
                    del intersecting_edges_error_candidates[ip]
                elif ip in touch_point_candidates:
                    touch_point_errors_ep.insert(edge_pair)
                    touch_point_errors_ep.insert(touch_point_candidates[ip])
                    del touch_point_candidates[ip]
                    del intersecting_edges_error_candidates[ip]
                elif not no_touch_point_error.get(ip):
                    touch_point_candidates[ip] = edge_pair
        if consider_intersecting_edges:
            errors_ep = db.EdgePairs(list(intersecting_edges_error_candidates.values()))
            errors_ep.process(
                IntersectingEdgeErrorAngleFilter(
                    min_angle, max_angle, include_min_angle, include_max_angle
                )
            )
            if min_angle == 0 and include_min_angle:
                errors_ep = errors_ep + abutting_edges_errors_ep
    if ignore_non_axis_aligned_edges:
        errors_ep = errors_ep.with_angle_both(db.Edges.OrthoEdges, False)
    if consider_touch_points:
        errors_ep = errors_ep + touch_point_errors_ep
    return Layer(deck, errors_ep)


class _MinCoherence:
    """min_coherence set to a value on layers for a block, then restored."""

    def __init__(self, value, *layers):
        self.value = value
        self.layers = layers

    def __enter__(self):
        self.saved = [lay.data.min_coherence for lay in self.layers]
        for lay in self.layers:
            lay.data.min_coherence = self.value

    def __exit__(self, *exc):
        for lay, s in zip(self.layers, self.saved):
            lay.data.min_coherence = s


def _dbu_value(deck, value):
    if isinstance(value, float):
        return round(value / deck.dbu)
    return value


def ext_merged(self, min_coherence, overlap_count):
    return self._new(self.data.merged(min_coherence, overlap_count))


def ext_merge(self, min_coherence, overlap_count):
    self.data.merge(min_coherence, overlap_count)
    return self


def ext_and(self, other):
    with _MinCoherence(True, self, other):
        return self & other


def ext_with_area(self, constraint):
    lower_bound = upper_bound = output_layer = None
    with _MinCoherence(True, self):
        d2 = self.deck.dbu**2
        for relation, value in constraint:
            if relation == ">":
                lower_bound = value + d2
            elif relation == "<":
                upper_bound = value
            elif relation == "==":
                output_layer = self.with_area(value)
            elif relation == "!=":
                output_layer = self.without_area(value)
            elif relation == ">=":
                lower_bound = value
            elif relation == "<=":
                upper_bound = value + d2
            else:
                raise ValueError("invalid expression")
        if lower_bound is not None or upper_bound is not None:
            output_layer = self.with_area(lower_bound, upper_bound)
    return output_layer


def ext_covering(self, other):
    with _MinCoherence(True, self, other):
        return self.covering(other.inside(self))


def ext_separation_at_intersecting_edges(
    self,
    other,
    value,
    metric=None,
    consider_intersecting_edges=False,
    consider_touch_points=False,
    ignore_non_axis_aligned_edges=False,
    min_angle=0,
    max_angle=90,
    include_min_angle=True,
    include_max_angle=False,
    polygons=False,
):
    metric = _metric(metric)
    with _MinCoherence(True, self, other):
        dbu_value = _dbu_value(self.deck, value)
        sd, od = self.data, other.data
        error_edge_pairs_90 = self._new(
            sd.separation_check(od, dbu_value, False, metric, 90, 1, None)
        )
        error_edge_pairs_90_180 = self._new(
            sd.separation_check(od, dbu_value, False, metric, 180)
        )
        width_error_edge_pairs_90 = self._new(
            sd.width_check(dbu_value, False, metric, 90, 1, None)
            + od.width_check(dbu_value, False, metric, 90, 1, None)
        )
        width_error_edge_pairs_180 = self._new(
            sd.width_check(dbu_value, False, metric, 180, None, 1)
            + od.width_check(dbu_value, False, metric, 180, None, 1)
        )
        errors = find_intersecting_edges_errors(
            self.deck,
            dbu_value,
            error_edge_pairs_90,
            None,
            error_edge_pairs_90_180,
            width_error_edge_pairs_90,
            width_error_edge_pairs_180,
            consider_intersecting_edges=consider_intersecting_edges,
            consider_touch_points=consider_touch_points,
            ignore_non_axis_aligned_edges=ignore_non_axis_aligned_edges,
            min_angle=min_angle,
            max_angle=max_angle,
            include_min_angle=include_min_angle,
            include_max_angle=include_max_angle,
        )
    if polygons:
        errors = errors.polygons().ext_merge(True, 0)
    return errors


def _metric(metric):
    """A metric option of klayout_drc, or a db.Region metric constant."""
    if metric is None:
        return db.Region.Euclidian
    if hasattr(metric, "kind"):
        return getattr(db.Region, metric.value)
    return metric


def ext_separation(
    self,
    other,
    value,
    metric=euclidian,
    consider_intersecting_edges=True,
    consider_touch_points=True,
    consider_overlaps=False,
    ignore_non_axis_aligned_edges=False,
    inside_edges_are_errors=False,
    min_angle=0,
    max_angle=90,
    include_min_angle=True,
    include_max_angle=False,
    polygon_output=False,
):
    with _MinCoherence(True, self, other):
        if consider_overlaps:
            raise NotImplementedError("consider_overlaps is not used by this deck")
        limit = max_angle
        if include_max_angle:
            limit += 1e-6
        output_layer = self.separation(other, value, metric, angle_limit(limit))
        if not consider_intersecting_edges and not consider_touch_points:
            output_layer = output_layer.without_distance(0)
            if ignore_non_axis_aligned_edges:
                output_layer = output_layer.with_angle(ortho, both)
        elif (consider_intersecting_edges != consider_touch_points) or not (
            min_angle == 0
            and max_angle == 90
            and include_min_angle
            and not include_max_angle
        ):
            intersecting_edges_errors = output_layer.with_distance(0).edges()
            candidate_layer1 = self.interacting(intersecting_edges_errors)
            candidate_layer2 = other.interacting(intersecting_edges_errors)
            output_layer = output_layer.without_distance(0)
            output_layer = (
                output_layer
                + candidate_layer1.ext_separation_at_intersecting_edges(
                    candidate_layer2,
                    value,
                    metric,
                    consider_intersecting_edges,
                    consider_touch_points,
                    ignore_non_axis_aligned_edges,
                    min_angle,
                    max_angle,
                    include_min_angle,
                    include_max_angle,
                    False,
                )
            )
        if inside_edges_are_errors:
            raise NotImplementedError(
                "inside_edges_are_errors is not used by this deck"
            )
    if polygon_output:
        output_layer = output_layer.polygons().ext_merge(True, 0)
    return output_layer


def ext_not(self, other):
    with _MinCoherence(True, self, other):
        return self - other


def ext_or(self, other, *further_layers):
    with _MinCoherence(True, self, other):
        output_layer = self.join(other)
        for further_layer in further_layers:
            with _MinCoherence(True, further_layer):
                output_layer = output_layer.join(further_layer)
    return output_layer


def _corners_count(primary, angle):
    """(corners == angle).count == 4, or corners.count == 4 without angle."""
    lo, hi = (-180.0, 180.0) if angle is None else (angle, angle)
    corners = CRON.new_corners_as_rectangles(
        primary, lo, True, hi, True, 2, False, False
    )
    return CRON.new_count_filter(corners, False, 4, 5)


def ext_rectangles(
    self,
    axis_aligned=False,
    use_bbox=False,
    constraint1=None,
    constraint2=None,
    aspect_ratio_constraint=None,
    inverted=False,
):
    """Rectangles, or squares of a side, as universal DRC expressions."""
    if (
        (
            constraint1
            and (not constraint2 or len(constraint1) > 1 or constraint1[0][0] != "==")
        )
        or (constraint2 and (len(constraint2) > 1 or constraint2[0][0] != "=="))
        or (constraint1 and constraint2 and constraint1[0][1] != constraint2[0][1])
    ):
        raise ValueError("ext_rectangle: unsupported options")
    if use_bbox:
        raise NotImplementedError("use_bbox is not used by this deck")
    with _MinCoherence(True, self):
        primary = CRON.new_primary()
        if axis_aligned:
            shape_filter = CRON.new_rectangle_filter(primary, False, False)
        else:
            shape_filter = CRON.new_logical_boolean(
                CRON.LogicalOp.LogAnd,
                False,
                [_corners_count(primary, 270.0), _corners_count(primary, None)],
            )
        if constraint1:
            side = self.deck.v(constraint1[0][1])
            lengths = CRON.new_edge_length_filter(
                CRON.new_edges(primary), False, side, side + 1
            )
            square_filter = CRON.new_count_filter(lengths, False, 4, 5)
            shape_filter = CRON.new_logical_boolean(
                CRON.LogicalOp.LogAnd, False, [shape_filter, square_filter]
            )
        if inverted:
            empty = CRON.new_empty(CRON.ResultType.Region)
            shape_filter = CRON.new_case([shape_filter, empty, CRON.new_primary()])
        return self._new(self.data.complex_op(shape_filter, db.Region.IgnoreProperties))


def _single_at_intersecting_edges(
    self,
    main,
    inverse,
    value,
    metric,
    consider_intersecting_edges,
    consider_touch_points,
    ignore_non_axis_aligned_edges,
    min_angle,
    max_angle,
    include_min_angle,
    include_max_angle,
    polygons,
):
    """ext_space_at_intersecting_edges and ext_width_at_intersecting_edges:
    the main check and the inverse one, at 90 and 180 degrees."""
    metric = _metric(metric)
    with _MinCoherence(True, self):
        dbu_value = _dbu_value(self.deck, value)
        m = getattr(self.data, main + "_check")
        i = getattr(self.data, inverse + "_check")
        errors = find_intersecting_edges_errors(
            self.deck,
            dbu_value,
            self._new(m(dbu_value, False, metric, 90, 1, None)),
            self._new(m(dbu_value, False, metric, 180, None, 1)),
            None,
            self._new(i(dbu_value, False, metric, 90, 1, None)),
            self._new(i(dbu_value, False, metric, 180, None, 1)),
            consider_intersecting_edges=consider_intersecting_edges,
            consider_touch_points=consider_touch_points,
            ignore_non_axis_aligned_edges=ignore_non_axis_aligned_edges,
            min_angle=min_angle,
            max_angle=max_angle,
            include_min_angle=include_min_angle,
            include_max_angle=include_max_angle,
        )
    if polygons:
        errors = errors.polygons().ext_merge(True, 0)
    return errors


def ext_space_at_intersecting_edges(self, value, metric=None, *args):
    return _single_at_intersecting_edges(self, "space", "width", value, metric, *args)


def ext_width_at_intersecting_edges(self, value, metric=None, *args):
    return _single_at_intersecting_edges(self, "width", "space", value, metric, *args)


def _single(
    self,
    check,
    min_coherence,
    value,
    metric,
    consider_intersecting_edges,
    consider_touch_points,
    ignore_non_axis_aligned_edges,
    min_angle,
    max_angle,
    include_min_angle,
    include_max_angle,
    polygon_output,
):
    """ext_space and ext_width."""
    with _MinCoherence(min_coherence, self):
        output_layer = getattr(self, check)(value, metric, angle_limit(max_angle))
        if not consider_intersecting_edges and not consider_touch_points:
            output_layer = output_layer.with_distance(1, None)
            if ignore_non_axis_aligned_edges:
                output_layer = output_layer.with_angle(ortho, both)
        elif consider_intersecting_edges != consider_touch_points:
            candidate_layer = self.interacting(output_layer.with_distance(0).edges())
            output_layer = output_layer.with_distance(1, None)
            output_layer = output_layer + getattr(
                candidate_layer, "ext_%s_at_intersecting_edges" % check
            )(
                value,
                metric,
                consider_intersecting_edges,
                consider_touch_points,
                ignore_non_axis_aligned_edges,
                min_angle,
                max_angle,
                include_min_angle,
                include_max_angle,
                False,
            )
        if polygon_output:
            output_layer = output_layer.polygons().ext_merge(True, 0)
    return output_layer


def ext_space(
    self,
    value,
    metric=euclidian,
    consider_intersecting_edges=True,
    consider_touch_points=True,
    ignore_non_axis_aligned_edges=False,
    min_angle=0,
    max_angle=90,
    include_min_angle=True,
    include_max_angle=False,
    polygon_output=False,
):
    return _single(
        self,
        "space",
        True,
        value,
        metric,
        consider_intersecting_edges,
        consider_touch_points,
        ignore_non_axis_aligned_edges,
        min_angle,
        max_angle,
        include_min_angle,
        include_max_angle,
        polygon_output,
    )


def ext_width(
    self,
    value,
    metric=euclidian,
    consider_intersecting_edges=True,
    consider_touch_points=True,
    ignore_non_axis_aligned_edges=False,
    min_angle=0,
    max_angle=90,
    include_min_angle=True,
    include_max_angle=False,
    polygon_output=False,
):
    return _single(
        self,
        "width",
        False,
        value,
        metric,
        consider_intersecting_edges,
        consider_touch_points,
        ignore_non_axis_aligned_edges,
        min_angle,
        max_angle,
        include_min_angle,
        include_max_angle,
        polygon_output,
    )


def ext_interacting_with_text(self, text_layer, text):
    initial_merged_semantics = self.data.merged_semantics
    self.data.merged_semantics = False
    result = self.interacting(text_layer.texts(text))
    self.data.merged_semantics = initial_merged_semantics
    return result


def _ext_with_density(self, inverse, value_range, *args, tiles_stay_inside=False):
    method = "without_density" if inverse else "with_density"
    deck = self.deck
    if self.is_merged():
        merged_layer = self
    else:
        merged_layer = self.ext_merged(True, 0)
    origin = "cc"
    size = step = None
    arguments = [value_range]
    for a in args:
        if isinstance(a, str):
            origin = a
        elif a.kind == "tile_size":
            size = a.value
            arguments.append(a)
        elif a.kind == "tile_step":
            step = a.value
            arguments.append(a)
        else:
            raise ValueError("argument error")
    bbox = Layer(deck, db.Region(deck.top.bbox())).bbox()
    if origin == "ll":
        origin_x = bbox.left
        origin_y = bbox.bottom
        if size and step and (size[0] != step[0] or size[1] != step[1]):
            origin_x = bbox.left + (size[0] - step[0]) / 2
            origin_y = bbox.bottom + (size[1] - step[1]) / 2
        origin_xy = (origin_x, origin_y)
        arguments.append(tile_origin(*origin_xy))
    elif origin == "cc":
        origin_xy = (bbox.center().x, bbox.center().y)
    else:
        raise ValueError("Unknown origin: 'cc' or 'll' expected")

    def run(*extra):
        # A later tile_origin overrides one in arguments, as in the DRC
        # language
        return getattr(merged_layer, method)(*(arguments + list(extra)))

    def itype(box):
        return box.to_itype(deck.dbu)

    if size:
        boundary_layer = Layer(deck, db.Region(itype(bbox)))
        boundary = tile_boundary(boundary_layer)
        if tiles_stay_inside:
            if origin != "ll":
                raise ValueError("Option 'tiles_stay_inside' requires origin='ll'")
            tile_width, tile_height = size
            enlarged_bbox = bbox.dup()
            if tile_width > bbox.width():
                enlarged_bbox.right = bbox.left + tile_width
            if tile_height > bbox.height():
                enlarged_bbox.top = bbox.bottom + tile_height
            enlarged_boundary_layer = Layer(deck, db.Region(itype(enlarged_bbox)))
            step_x, step_y = step if step else (tile_width, tile_height)
            count_x = max(1, 1 + math.floor((bbox.width() - tile_width) / step_x))
            count_y = max(1, 1 + math.floor((bbox.height() - tile_height) / step_y))
            if count_x == 1 and count_y == 1:
                count = tile_count(count_x, 2)
            else:
                count = tile_count(count_x, count_y)
            result = run(count, boundary, padding_ignore)
            need_top_row = need_right_column = False
            if bbox.height() > tile_height + (count_y - 1) * step_y:
                need_top_row = True
                origin2 = tile_origin(
                    origin_xy[0], origin_xy[1] + bbox.height() - tile_height
                )
                result += run(
                    origin2, tile_count(max(2, count_x), 1), boundary, padding_ignore
                )
            if bbox.width() > tile_width + (count_x - 1) * step_x:
                need_right_column = True
                origin2 = tile_origin(
                    origin_xy[0] + bbox.width() - tile_width, origin_xy[1]
                )
                result += run(
                    origin2, tile_count(1, max(2, count_y)), boundary, padding_ignore
                )
            if (need_top_row and bbox.width() > tile_width) or (
                need_right_column and bbox.height() > tile_height
            ):
                origin2 = tile_origin(
                    origin_xy[0] + bbox.width() - tile_width,
                    origin_xy[1] + bbox.height() - tile_height,
                )
                result += run(origin2, tile_count(1, 2), boundary, padding_ignore)
            result.raw().select_inside(enlarged_boundary_layer)
        else:
            result = run(boundary, padding_ignore)
        return result.and_(boundary_layer)
    size = _size_option(bbox.width(), bbox.height())
    count = tile_count(1, 3)
    enlarged_bbox = itype(bbox.enlarged(1.1))
    boundary = tile_boundary(Layer(deck, db.Region(enlarged_bbox)))
    result = run(size, count, boundary, padding_ignore)
    return result.raw().overlapping(Layer(deck, db.Region(itype(bbox))))


def _size_option(w, h):
    """A tile size in microns, as DRCTileSize.new(w, h)."""
    return _Option("tile_size", (w, h))


def ext_with_density(self, *args, **kargs):
    return _ext_with_density(self, False, *args, **kargs)


def ext_without_density(self, *args, **kargs):
    return _ext_with_density(self, True, *args, **kargs)


def ext_outside(self, other):
    output_layer = self.dup().raw().outside(other)
    output_layer.data.merged_semantics = True
    return output_layer


for _f in (
    ext_merged,
    ext_merge,
    ext_and,
    ext_with_area,
    ext_covering,
    ext_separation_at_intersecting_edges,
    ext_separation,
    ext_not,
    ext_or,
    ext_rectangles,
    ext_space_at_intersecting_edges,
    ext_space,
    ext_width_at_intersecting_edges,
    ext_width,
    ext_interacting_with_text,
    ext_with_density,
    ext_without_density,
    ext_outside,
):
    setattr(Layer, _f.__name__, _f)


def drc(deck):

    Activ = deck.polygons("1/0")
    Activ_pin = deck.polygons("1/2")
    Activ_filler = deck.polygons("1/22")
    BiWind = deck.polygons("3/0")
    GatPoly = deck.polygons("5/0")
    GatPoly_pin = deck.polygons("5/2")
    GatPoly_filler = deck.polygons("5/22")
    Cont = deck.polygons("6/0")
    Metal1 = deck.polygons("8/0")
    Metal1_pin = deck.polygons("8/2")
    Metal1_filler = deck.polygons("8/22")
    Metal1_slit = deck.polygons("8/24")
    Passiv = deck.polygons("9/0")
    Metal2 = deck.polygons("10/0")
    Metal2_pin = deck.polygons("10/2")
    Metal2_filler = deck.polygons("10/22")
    Metal2_slit = deck.polygons("10/24")
    BasPoly = deck.polygons("13/0")
    Via1 = deck.polygons("19/0")
    SRAM = deck.polygons("25/0")
    TRANS = deck.polygons("26/0")
    Via2 = deck.polygons("29/0")
    Metal3 = deck.polygons("30/0")
    Metal3_pin = deck.polygons("30/2")
    Metal3_filler = deck.polygons("30/22")
    Metal3_slit = deck.polygons("30/24")
    DeepCo = deck.polygons("35/0")
    EdgeSeal = deck.polygons("39/0")
    ThickGateOx = deck.polygons("44/0")
    Via3 = deck.polygons("49/0")
    Metal4 = deck.polygons("50/0")
    Metal4_pin = deck.polygons("50/2")
    Metal4_filler = deck.polygons("50/22")
    Metal4_slit = deck.polygons("50/24")
    EmPoly = deck.polygons("55/0")
    TEXT = deck.labels("63/0")
    Via4 = deck.polygons("66/0")
    Metal5 = deck.polygons("67/0")
    Metal5_pin = deck.polygons("67/2")
    Metal5_filler = deck.polygons("67/22")
    Metal5_slit = deck.polygons("67/24")
    TopVia1 = deck.polygons("125/0")
    TopMetal1 = deck.polygons("126/0")
    TopMetal1_pin = deck.polygons("126/2")
    TopMetal1_filler = deck.polygons("126/22")
    TopMetal1_slit = deck.polygons("126/24")
    Vmim = deck.polygons("129/0")
    TopVia2 = deck.polygons("133/0")
    TopMetal2 = deck.polygons("134/0")
    TopMetal2_pin = deck.polygons("134/2")
    TopMetal2_filler = deck.polygons("134/22")
    TopMetal2_slit = deck.polygons("134/24")
    ColWind = deck.polygons("139/0")
    LBE = deck.polygons("157/0")
    PEmWind = deck.polygons("11/0")
    PEmPoly = deck.polygons("53/0")
    LDMOS = deck.polygons("57/0")
    PBiWind = deck.polygons("58/0")
    Flash = deck.polygons("71/0")
    Activ_Act_a = Activ.ext_width(um(0.15))
    Act_density = Activ.ext_or(Activ_filler)
    Gat_density = GatPoly.ext_or(GatPoly_filler)
    Cont_SQ = Cont.ext_rectangles(
        True, False, [["==", um(0.16)]], [["==", um(0.16)]], None
    )
    ContBar = Cont.ext_with_area([[">", (0.16 * 0.16)]])
    Metal1_Nslit = Metal1.ext_not(Metal1_slit)
    Metal2_Nslit = Metal2.ext_not(Metal2_slit)
    Act_Nsram = Activ.ext_not(SRAM)
    GP_Nsram = GatPoly.ext_not(SRAM)
    Metal3_Nslit = Metal3.ext_not(Metal3_slit)
    Via1_edgC1_out = Via1.ext_not(EdgeSeal)
    Via2_edgC1_out = Via2.ext_not(EdgeSeal)
    Cont_outside_EdgeSeal = Cont.ext_outside(EdgeSeal)
    ThickGateOx_TGO_f = ThickGateOx.ext_width(
        um(0.86), consider_intersecting_edges=False, polygon_output=True
    )
    Via3_edgC1_out = Via3.ext_not(EdgeSeal)
    Metal4_Nslit = Metal4.ext_not(Metal4_slit)
    Via4_edgC1_out = Via4.ext_not(EdgeSeal)
    Metal5_Nslit = Metal5.ext_not(Metal5_slit)
    TopVia1_edgC1_out = TopVia1.ext_not(EdgeSeal)
    TopMetal1_Nslit = TopMetal1.ext_not(TopMetal1_slit)
    TopVia1_or_Vmim = TopVia1.ext_or(Vmim)
    TopVia2_edgC1_out = TopVia2.ext_not(EdgeSeal)
    TopMetal2_Nslit = TopMetal2.ext_not(TopMetal2_slit)
    M1_density = Metal1.ext_or(Metal1_filler).ext_not(Metal1_slit)
    M2_density = Metal2.ext_or(Metal2_filler).ext_not(Metal2_slit)
    emi2Pin = Metal2_pin.ext_and(TRANS).ext_interacting_with_text(TEXT, "E")
    M3_density = Metal3.ext_or(Metal3_filler).ext_not(Metal3_slit)
    M4_density = Metal4.ext_or(Metal4_filler).ext_not(Metal4_slit)
    M5_density = Metal5.ext_or(Metal5_filler).ext_not(Metal5_slit)
    TM1_density = TopMetal1.ext_or(TopMetal1_filler).ext_not(TopMetal1_slit)
    TM2_density = TopMetal2.ext_or(TopMetal2_filler).ext_not(TopMetal2_slit)
    M1_Nsram = Metal1_Nslit.ext_not(SRAM)
    M2_Nsram = Metal2_Nslit.ext_not(SRAM)
    GP_Nsram_Gat_a = GP_Nsram.ext_width(
        um(0.13), consider_intersecting_edges=False, polygon_output=True
    )
    GP_Nsram_Gat_b = GP_Nsram.ext_space(
        um(0.18), consider_intersecting_edges=False, polygon_output=True
    )
    M3_Nsram = Metal3_Nslit.ext_not(SRAM)
    M4_Nsram = Metal4_Nslit.ext_not(SRAM)
    M5_Nsram = Metal5_Nslit.ext_not(SRAM)
    transG2L = TRANS.ext_interacting_with_text(TEXT, "npn13G2L").ext_covering(emi2Pin)
    Activ_Act_a.dup().output("Act.a", "Min. Activ width = 0.15")
    Act_Nsram.ext_space(um(0.21)).output("Act.b", "Min. Activ space or notch = 0.21")

    if DENSITY_RULES:
        Act_density.ext_without_density((0.35, 0.55), "ll").output(
            "AFil.g/g1", "Global Activ density [%] = 35.00 .. 55.00"
        )
        Act_density.ext_without_density(
            (0.25, 0.65),
            "ll",
            tile_size(deck, um(800.0)),
            tile_step(deck, um(400.0)),
            tiles_stay_inside=True,
        ).output(
            "AFil.g2/g3",
            "Activ coverage ratio for any 800 x 800 µm² chip area [%] = 25.00 .. 65.00",
        )

    ThickGateOx_TGO_f.dup().output("TGO.f", "Min. ThickGateOx width = 0.86")
    GP_Nsram_Gat_a.dup().output("Gat.a", "Min. GatPoly width = 0.13")
    GP_Nsram_Gat_b.dup().output("Gat.b", "Min. GatPoly space or notch = 0.18")
    GP_Nsram.ext_separation(Act_Nsram, um(0.07)).output(
        "Gat.d", "Min. GatPoly space to Activ = 0.07"
    )

    if DENSITY_RULES:
        Gat_density.ext_with_density((0.0, 0.15), "ll").output(
            "GFil.g", "Min. global GatPoly density [%] = 15.00"
        )

    Cont_outside_EdgeSeal.ext_not(ContBar.ext_or(Cont_SQ)).output(
        "Cnt.a", "Min. and max. Cont width = 0.16"
    )
    Cont_outside_EdgeSeal.ext_space(um(0.18), consider_intersecting_edges=False).output(
        "Cnt.b", "Min. Cont space = 0.18"
    )
    Metal1_Nslit.ext_width(um(0.16)).output("M1.a", "Min. Metal1 width = 0.16")
    M1_Nsram.ext_space(um(0.18)).output("M1.b", "Min. Metal1 space or notch = 0.18")

    if DENSITY_RULES:
        M1_density.ext_without_density((0.35, 0.6), "ll").output(
            "M1.j/k", "Global Metal1 density [%] = 35.0 .. 60.0"
        )

    Metal2_Nslit.ext_width(um(0.2)).output("M2.a", "Min. Metal2 width = 0.20")
    M2_Nsram.ext_space(um(0.21)).output("M2.b", "Min. Metal2 space or notch = 0.21")

    if DENSITY_RULES:
        M2_density.ext_without_density((0.35, 0.6), "ll").output(
            "M2.j/k", "Global Metal2 density [%] = 35.00 .. 60.00"
        )

    Metal3_Nslit.ext_width(um(0.2)).output("M3.a", "Min. Metal3 width = 0.20")
    M3_Nsram.ext_space(um(0.21)).output("M3.b", "Min. Metal3 space or notch = 0.21")

    if DENSITY_RULES:
        M3_density.ext_without_density((0.35, 0.6), "ll").output(
            "M3.j/k", "Global Metal3 density [%] = 35.00 .. 60.00"
        )

    Metal4_Nslit.ext_width(um(0.2)).output("M4.a", "Min. Metal4 width = 0.20")
    M4_Nsram.ext_space(um(0.21)).output("M4.b", "Min. Metal4 space or notch = 0.21")

    if DENSITY_RULES:
        M4_density.ext_without_density((0.35, 0.6), "ll").output(
            "M4.j/k", "Global Metal4 density [%] = 35.00 .. 60.00"
        )

    Metal5_Nslit.ext_width(um(0.2)).output("M5.a", "Min. Metal5 width = 0.20")
    M5_Nsram.ext_space(um(0.21)).output("M5.b", "Min. Metal5 space or notch = 0.21")

    if DENSITY_RULES:
        M5_density.ext_without_density((0.35, 0.6), "ll").output(
            "M5.j/k", "Global Metal5 density [%] = 35.00 .. 60.00"
        )
        M1_density.ext_without_density(
            (0.25, 0.75),
            "ll",
            tile_size(deck, um(800.0)),
            tile_step(deck, um(400.0)),
            tiles_stay_inside=True,
        ).output(
            "M1Fil.h/k",
            "Metal1 and Metal1:filler coverage ratio for any 800 x 800 µm² chip area [%] = 25.00 .. 75.00",
        )
        M2_density.ext_without_density(
            (0.25, 0.75),
            "ll",
            tile_size(deck, um(800.0)),
            tile_step(deck, um(400.0)),
            tiles_stay_inside=True,
        ).output(
            "M2Fil.h/k",
            "Metal2 and Metal2:filler coverage ratio for any 800 x 800 µm² chip area [%] = 25.00 .. 75.00",
        )
        M3_density.ext_without_density(
            (0.25, 0.75),
            "ll",
            tile_size(deck, um(800.0)),
            tile_step(deck, um(400.0)),
            tiles_stay_inside=True,
        ).output(
            "M3Fil.h/k",
            "Metal3 and Metal3:filler coverage ratio for any 800 x 800 µm² chip area [%] = 25.00 .. 75.00",
        )
        M4_density.ext_without_density(
            (0.25, 0.75),
            "ll",
            tile_size(deck, um(800.0)),
            tile_step(deck, um(400.0)),
            tiles_stay_inside=True,
        ).output(
            "M4Fil.h/k",
            "Metal4 and Metal4:filler coverage ratio for any 800 x 800 µm² chip area [%] = 25.00 .. 75.00",
        )
        M5_density.ext_without_density(
            (0.25, 0.75),
            "ll",
            tile_size(deck, um(800.0)),
            tile_step(deck, um(400.0)),
            tiles_stay_inside=True,
        ).output(
            "M5Fil.h/k",
            "Metal5 and Metal5:filler coverage ratio for any 800 x 800 µm² chip area [%] = 25.00 .. 75.00",
        )

    Via1_edgC1_out.ext_outside(transG2L).ext_rectangles(
        False, False, [["==", um(0.19)]], [["==", um(0.19)]], None, inverted=True
    ).output("V1.a", "Min. and max. Via1 width = 0.19")
    Via1_edgC1_out.ext_space(um(0.22), consider_intersecting_edges=False).output(
        "V1.b", "Min. Via1 space = 0.22"
    )
    Via2_edgC1_out.ext_outside(transG2L).ext_rectangles(
        False, False, [["==", um(0.19)]], [["==", um(0.19)]], None, inverted=True
    ).output("V2.a", "Min. and max. Via2 width = 0.19")
    Via2_edgC1_out.ext_space(um(0.22), consider_intersecting_edges=False).output(
        "V2.b", "Min. Via2 space = 0.22"
    )
    Via3_edgC1_out.ext_outside(transG2L).ext_rectangles(
        False, False, [["==", um(0.19)]], [["==", um(0.19)]], None, inverted=True
    ).output("V3.a", "Min. and max. Via3 width = 0.19")
    Via3_edgC1_out.ext_space(um(0.22), consider_intersecting_edges=False).output(
        "V3.b", "Min. Via3 space = 0.22"
    )
    Via4_edgC1_out.ext_outside(transG2L).ext_rectangles(
        False, False, [["==", um(0.19)]], [["==", um(0.19)]], None, inverted=True
    ).output("V4.a", "Min. and max. Via4 width = 0.19")
    Via4_edgC1_out.ext_space(um(0.22), consider_intersecting_edges=False).output(
        "V4.b", "Min. Via4 space = 0.22"
    )
    TopVia1_edgC1_out.ext_or(Vmim).ext_rectangles(
        False, False, [["==", um(0.42)]], [["==", um(0.42)]], None, inverted=True
    ).output("TV1.a", "Min. and max. TopVia1 width = 0.42")
    TopVia1_or_Vmim.ext_space(um(0.42)).output("TV1.b", "Min. TopVia1 space = 0.42")
    TopMetal1_Nslit.ext_width(um(1.64)).output("TM1.a", "Min. TopMetal1 width = 1.64")
    TopMetal1_Nslit.ext_space(um(1.64)).output(
        "TM1.b", "Min. TopMetal1 space or notch = 1.64"
    )

    if DENSITY_RULES:
        TM1_density.ext_without_density((0.25, 0.7), "ll").output(
            "TM1.c/d", "Global TopMetal1 density [%] = 25.00 .. 70.00"
        )

    TopVia2_edgC1_out.ext_rectangles(
        False, False, [["==", um(0.9)]], [["==", um(0.9)]], None, inverted=True
    ).output("TV2.a", "Min. and max. TopVia2 width = 0.90")
    TopVia2.ext_space(um(1.06)).output("TV2.b", "Min. TopVia2 space = 1.06")
    TopMetal2_Nslit.ext_width(um(2.0)).output("TM2.a", "Min. TopMetal2 width = 2.00")
    TopMetal2_Nslit.ext_space(um(2.0)).output(
        "TM2.b", "Min. TopMetal2 space or notch = 2.00"
    )

    if DENSITY_RULES:
        TM2_density.ext_without_density((0.25, 0.7), "ll").output(
            "TM2.c/d", "Global TopMetal2 density [%] = 25.00 .. 70.00"
        )

    Passiv.ext_width(um(2.1)).output("Pas.a", "Min. Passiv width = 2.10")
    Passiv.ext_space(um(3.5)).output("Pas.b", "Min. Passiv space or notch = 3.50")
    Activ_pin.ext_not(Activ).output("Pin.a", "Min. Activ enclosure of Activ:pin = 0.00")
    GatPoly_pin.ext_not(GatPoly).output(
        "Pin.b", "Min. GatPoly enclosure of GatPoly:pin = 0.00"
    )
    Metal1_pin.ext_not(Metal1_Nslit).output(
        "Pin.e", "Min. Metal1 enclosure of Metal1:pin = 0.00"
    )
    Metal2_pin.ext_not(Metal2_Nslit).output(
        "Pin.f.M2", "Min. Metal2 enclosure of Metal2:pin = 0.00"
    )
    Metal3_pin.ext_not(Metal3_Nslit).output(
        "Pin.f.M3", "Min. Metal3 enclosure of Metal3:pin = 0.00"
    )
    Metal4_pin.ext_not(Metal4_Nslit).output(
        "Pin.f.M4", "Min. Metal4 enclosure of Metal4:pin = 0.00"
    )
    Metal5_pin.ext_not(Metal5_Nslit).output(
        "Pin.f.M5", "Min. Metal5 enclosure of Metal5:pin = 0.00"
    )
    TopMetal1_pin.ext_not(TopMetal1_Nslit).output(
        "Pin.g", "Min. TopMetal1 enclosure of TopMetal1:pin = 0.00"
    )
    TopMetal2_pin.ext_not(TopMetal2_Nslit).output(
        "Pin.h", "Min. TopMetal2 enclosure of TopMetal2:pin = 0.00"
    )
    LBE.ext_width(um(100.0)).output("LBE.a", "Min. LBE width = 100.00")
    LBE.sized(-um(1500.0) / 2.0, acute_limit).sized(
        um(1500.0) / 2.0, acute_limit
    ).output("LBE.b", "Max. LBE width = 1500.00")
    LBE.ext_with_area([[">", 250000.0]]).output(
        "LBE.b1", "Max. LBE area (µm²) = 250000.00"
    )
    LBE.ext_space(
        um(100.0), consider_intersecting_edges=False, ignore_non_axis_aligned_edges=True
    ).output("LBE.c", "Min. LBE space or notch = 100.00")
    lbe_in_seal = LBE.inside(EdgeSeal.holes().merge())
    lbe_in_seal.ext_separation(
        EdgeSeal,
        um(150.0),
        consider_intersecting_edges=False,
        ignore_non_axis_aligned_edges=True,
    ).output("LBE.d", "Min. LBE space to inner edge of EdgeSeal = 150.00")
    LBE.with_holes().dup().output("LBE.h", "No LBE ring allowed")

    if DENSITY_RULES:
        LBE.ext_with_density((0.2, 1.0), "ll").output(
            "LBE.i", "Max. global LBE density [%] = 20.00"
        )

    BiWind.dup().output(
        "forbidden.BiWind", "Forbidden drawn layer BiWind on GDS layer 3/0 = 3/0"
    )
    PEmWind.dup().output(
        "forbidden.PEmWind", "Forbidden drawn layer PEmWind on GDS layer 11/0 = 11/0"
    )
    BasPoly.dup().output(
        "forbidden.BasPoly", "Forbidden drawn layer BasPoly on GDS layer 13/0 = 13/0"
    )
    DeepCo.dup().output(
        "forbidden.DeepCo", "Forbidden drawn layer DeepCo on GDS layer 35/0 = 35/0"
    )
    PEmPoly.dup().output(
        "forbidden.PEmPoly", "Forbidden drawn layer PEmPoly on GDS layer 53/0 = 53/0"
    )
    EmPoly.dup().output(
        "forbidden.EmPoly", "Forbidden gen./drawn layer EmPoly on GDS layer 53/0 = 53/0"
    )
    LDMOS.dup().output(
        "forbidden.LDMOS", "Forbidden drawn layer LDMOS on GDS layer 57/0 = 57/0"
    )
    PBiWind.dup().output(
        "forbidden.PBiWind", "Forbidden drawn layer PBiWind on GDS layer 58/0 = 58/0"
    )
    Flash.dup().output(
        "forbidden.Flash", "Forbidden drawn layer Flash on GDS layer 71/0 = 71/0"
    )
    ColWind.dup().output(
        "forbidden.ColWind", "Forbidden drawn layer ColWind on GDS layer 139/0 = 139/0"
    )
