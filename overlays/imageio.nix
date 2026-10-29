# imageio 2.37.2 on nixos-26.05 fails two PNG tests against Pillow 13.0.0,
# which tightened mode/dtype validation:
#   tests/test_pillow.py::test_png_16bit   ValueError: Invalid mode for data type
#   tests/test_pillow_legacy.py::test_png  ValueError: Invalid mode for data type
# This breaks immich-machine-learning, which depends on imageio.
# Upstream tried to disable these in NixOS/nixpkgs#580329, but that PR was
# closed unmerged, so there is nothing to backport yet. Drop this overlay once
# a fix reaches nixos-26.05.
final: prev: {
  pythonPackagesExtensions =
    prev.pythonPackagesExtensions
    ++ [
      (pyFinal: pyPrev: {
        imageio = pyPrev.imageio.overridePythonAttrs (old: {
          pytestFlags =
            (old.pytestFlags or [])
            ++ [
              "--deselect=tests/test_pillow.py::test_png_16bit"
              "--deselect=tests/test_pillow_legacy.py::test_png"
            ];
        });
      })
    ];
}
