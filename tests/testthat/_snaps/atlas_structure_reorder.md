# atlas_structure_reorder() / errors when a structure has no geometry

    Code
      atlas_structure_reorder(a, "ghost")
    Condition
      Error in `resolve_structures()`:
      ! `structures` names nothing that this atlas draws.
      i "ghost" is in core but has no geometry.

# atlas_structure_reorder() / errors on an unknown structure

    Code
      atlas_structure_reorder(aseg(), "notastructure")
    Condition
      Error in `resolve_structures()`:
      ! `structures` names a structure not in this atlas.
      x Unknown: "notastructure".

# atlas_structure_reorder() / errors when given both anchors

    Code
      atlas_structure_reorder(a, drawn(a)[1], .before = drawn(a)[2], .after = drawn(a)[
        3])
    Condition
      Error in `atlas_structure_reorder()`:
      ! Give at most one of `.before` and `.after`.

# atlas_structure_reorder() / errors when the anchor is one of the structures moved

    Code
      atlas_structure_reorder(a, drawn(a)[1], .after = drawn(a)[1])
    Condition
      Error in `atlas_structure_reorder()`:
      ! Cannot move a structure next to itself.

# atlas_structure_reorder() / errors on a non-atlas

    Code
      atlas_structure_reorder(list(), "x")
    Condition
      Error in `atlas_structure_reorder()`:
      ! `atlas` must be a <ggseg_atlas> object.

