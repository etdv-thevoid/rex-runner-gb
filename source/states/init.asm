INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Init", ROM0

_Init::
    call _InitGraphics
    call _InitScore
    call _InitInterrupts

    call _InitRex

    ld a, STATE_MENU
    jp _SwitchStateToNew

ENDSECTION
