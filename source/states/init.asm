INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Init", ROM0

_Init::
    call _InitEngine

    ld a, STATE_MENU
    jp _SwitchStateToNew

ENDSECTION
