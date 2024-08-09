INCLUDE "libraries/gbc-engine-core/gbc-engine-core-macros.inc"
    gbc_engine_core_version 1.0.0

; Add your macros here!

/*
    - p1    = buttons enabled variable label
    - p2    = delay frame counter label
    - p3    = return label
*/
MACRO check_keys_start
    ld a, [\1]
    and a
    jr nz, .checkKeys

    ld a, [\2]
    inc a
    ld [\2], a
    and a, MENU_BUTTON_DELAY_MASK
    jr nz, \3

    ld a, TRUE
    ld [\1], a

    jr \3

.checkKeys:
ENDM

/*
    - p1    = `hKeys*` variable
    - p2    = `PADF_*` variables
*/
MACRO check_keys_add
ASSERT (\1 == hKeysHeld || \1 == hKeysPressed || \1 == hKeysReleased)
:
    ldh a, [\1]
    and a, (\2)
    jr z, :+
ENDM

/*
    - p1    = return label
*/
MACRO check_keys_end
:
    jr \1
ENDM
    