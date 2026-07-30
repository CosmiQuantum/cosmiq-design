# Useful Cubit Scripts

This file contains a few Cubit scripts for geometry preparation and automation.

---

## Simplify Imprint Script

Use this script to imprint and merge overlapping surfaces and curves.

    set curve imprint cleanup tolerance 1e-5
    set surface imprint cleanup tolerance 1e-5
    imprint all
    merge all

---

## Composite Curve Sections Script

A helper script to combine multiple curve segments into composite curves, divided into user-specified sections.

    #!python

    import cubit

    def composite_curve_sections(surface_id, num_sections):
        curve_ids = list(cubit.parse_cubit_list("curve", f"in surface {surface_id}"))
        n = len(curve_ids)
        section_size = n // num_sections
        remainder = n % num_sections

    sections = []
    start = 0
    for i in range(num_sections):
        extra = 1 if i < remainder else 0
        end = start + section_size + extra
        section = curve_ids[start:end]
        sections.append(section)
        start = end

    for section in sections:
        vol_ids = ' '.join(map(str, section))
        cmd = f"composite create curve {vol_ids}"
        print(f"Running: {cmd}")
        cubit.cmd(cmd)

    surface_ids = cubit.get_entities("surface")
    num_sections = 4 # number of total sections to reduce the curves to

    # I found putting this in a for loop and just reducing the # curves of all entities does not hurt anything and automates the process better.
    for surface_id in surface_ids:
    composite_curve_sections(surface_id=surface_id, num_sections=num_sections)


