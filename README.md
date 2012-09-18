slurm-fhcrc-plugins
===================

This project installs just the Center-specific plugins we need for
running gizmo.

Building:
---------

Submodules might be a better way of doing it, but until I can
figure out how to use those, we'll just clone into this repository
for the build.

1. clone this repo:

        git clone git://github.com/atombaby/slurm-fhcrc-plugins.git

1. clone the slurm-spank-plugins from google inside there:

        cd slurm-fhcrc-plugins
        git clone https://code.google.com/p/slurm-spank-plugins/

1. clone the x11 plugin:

        git://github.com/edf-hpc/slurm-spank-x11.git

1. this creates the subdirectories "slurm-spank-x11" and
"slurm-spank-plugins".  Now make the .orig.tar file:

        make orig

1. Now build the package:

        debuild -uc -us



