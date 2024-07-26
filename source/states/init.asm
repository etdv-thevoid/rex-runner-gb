INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Init", ROM0

_Init::
    call _InitGraphics
    call _InitDifficulty
    call _InitScore
    call _InitInterrupts

    call _InitRex
    call _InitCactus
    call _InitPtero1
    call _InitPtero2
    call _InitMeteor

    ld a, STATE_MENU
    jp _SwitchStateToNew

ENDSECTION
