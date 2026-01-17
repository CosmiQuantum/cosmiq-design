import pya

# -----------------------
# USER SETTINGS
# -----------------------

gds_in  = "qubit.gds"
dxf_out = "qubit.dxf"

# may need to play around with the layers you want to keep depedning on design.
KEEP_LAYERS = [
    (1, 0),
    (1, 10),
    (1,99)
    ]

# -----------------------
# LOAD GDS
# -----------------------
layout = pya.Layout()
layout.read(gds_in)

top = layout.top_cell()
if top is None:
    raise RuntimeError("No TOP cell found")

# -----------------------
# FLATTEN EVERYTHING
# -----------------------
# deep = True ensures all hierarchy is removed
top.flatten(True)

# -----------------------
# DELETE UNWANTED LAYERS
# -----------------------
keep_layer_indices = set()

for layer, datatype in KEEP_LAYERS:
    li = layout.layer(pya.LayerInfo(layer, datatype))
    keep_layer_indices.add(li)

# Iterate over ALL layers in the layout
for li in list(layout.layer_indices()):
    if li not in keep_layer_indices:
        top.clear(li)
        layout.delete_layer(li)

# -----------------------
# SAVE AS DXF
# -----------------------
layout.write(dxf_out)

print("Successfully converted {} to {}".format(gds_in,dxf_out))

