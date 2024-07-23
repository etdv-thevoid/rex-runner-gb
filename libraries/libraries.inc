/*
Add any libraries that need to be directly compiled here!

`libraries.inc` will be individually compiled by `make` and passed to
rgblink, adding any libraries present here in the final rom.
*/

; included here for any libraries that need it to compile
INCLUDE "libraries/hardware.inc/hardware.inc"
    rev_Check_hardware_inc 4.9.1

INCLUDE "libraries/gbc-engine-core/gbc-engine-core.inc"
    gbc_engine_core_version 0.4.1
