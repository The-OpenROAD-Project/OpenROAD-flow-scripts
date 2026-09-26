#!/usr/bin/env python3

# Writes one HTML image gallery per design under reports/, one column per
# platform and one row per view, from the images the flow saved under
# reports/<platform>/<design>/<variant>/. The metrics comparison table this
# script used to write next to the galleries was removed: the QoR gate is the
# dashboard check in `make metadata`, and the table judged runs against
# committed golden files that are gone.

import os
from collections import defaultdict

# make sure the working dir is flow/
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))

cssOutput = "reports/table.css"

cssStyle = """/* gallery styles */
table {
  border-collapse: collapse;
  margin: 25px 0;
  font-size: 0.9em;
  font-family: sans-serif;
  min-width: 400px;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);
}
table thead tr {
  background-color: #009879;
  color: #ffffff;
  text-align: left;
}
table th,
table td {
  padding: 12px 15px;
}
table tbody tr {
  border-bottom: 1px solid #dddddd;
}
table tbody tr:nth-of-type(even) {
  background-color: #f3f3f3;
}
table td:nth-child(n+2) {
  text-align: center;
}
table tbody tr:last-of-type {
  border-bottom: 2px solid #009879;
}
table th,
table td:nth-child(1),
.image-table td {
  border-right: solid 2px;
  border-left: solid 2px;
}
table th {
  border-top: solid 2px;
}
div.gallery {
  margin: 5px;
  float: left;
  height: 300px;
}
div.gallery:hover {
  border: 1px solid #777;
}
div.gallery img {
  max-height: 300px;
  width: auto;
}
div.desc {
  padding: 10px;
  text-align: center;
}
"""

head = """<!DOCTYPE html>
<html lang="en">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="table.css">
</head>

<body>
"""

tail = """</body>
</html>
"""


def add_image(path, platform, view):
    return f"""<td>
  <div class="gallery">
    <div class="desc">
      {platform} - {view}
    </div>
    <a target="_blank" href="{path}">
      <img src="{path}" alt="{platform}/{view}">
    </a>
  </div>
</td>
"""


# save_images.tcl asks OpenROAD for .webp, but the GUI silently falls back to
# .png when the Qt build has no webp writer, which used to leave the gallery
# empty. Accept either, and derive the view name by stripping whatever image
# extensions the file ended up with rather than a fixed number of characters.
IMAGE_EXTENSIONS = (".webp", ".png")


def image_view_name(file):
    view, ext = os.path.splitext(file)
    while ext.lower() in IMAGE_EXTENSIONS:
        file = view
        view, ext = os.path.splitext(file)
    return file


def collect_images():
    """Map design -> platform -> view -> image path, relative to reports/."""
    images = defaultdict(lambda: defaultdict(dict))
    for parents, dirs, files in sorted(os.walk("reports", topdown=False)):
        for file in files:
            if file.lower().endswith(IMAGE_EXTENSIONS):
                path = os.path.join(parents, file).replace("reports", ".")
                platform, design = path.split(os.sep)[1:3]
                images[design][platform][image_view_name(file)] = path
    return images


def write_gallery(design, images, platforms, views):
    htmlGallery = f"reports/report-gallery-{design}.html"
    with open(htmlGallery, "w") as f:
        gallery = "  <h1>Image Gallery</h1>\n"
        gallery += '<table class="image-table">\n'
        gallery += "<tr>\n"
        for key in platforms:
            gallery += f"<th>{key}</th>\n"
        gallery += "</tr>\n"
        for view in views:
            gallery += "<tr>\n"
            for platform in platforms:
                if platform in images[design] and view in images[design][platform]:
                    gallery += add_image(images[design][platform][view], platform, view)
                else:
                    gallery += "<td>\n</td>\n"
            gallery += "</tr>\n"
        gallery += "</table>\n"
        f.writelines(head + gallery + tail)


images = collect_images()
platforms = sorted({p for d in images.values() for p in d})
views = sorted({v for d in images.values() for p in d.values() for v in p})

os.makedirs("reports", exist_ok=True)
with open(cssOutput, "w") as f:
    f.writelines(cssStyle)

for design in sorted(images):
    write_gallery(design, images, platforms, views)
