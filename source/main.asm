INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Main", ROM0

_Main::
    call _LoadHighScore

    call _LoadGraphics

    ; fallthrough

_MainLoop:
    di

    call _ScreenOff

    ld hl, _StateJumpTable
    ld a, [wCurrentState]
    cp a, NUMBER_OF_STATES
    jr c, .jump
    ld a, NUMBER_OF_STATES
.jump:
    call _JumpTable
    jr _MainLoop

_StateJumpTable:
    DW _Init
    DW _Menu
    DW _Credits
    DW _Game
    DW _Pause
    DW _Dead
    DW _NULL

_GetStateCurrent::
    ld a, [wCurrentState]
    ret

_GetStatePrevious::
    ld a, [wPreviousState]
    ret

_SwitchStateToPrevious::
    ld a, [wPreviousState]
    ;fallthrough

_SwitchStateToNew::
    push af
    ld a, [wCurrentState]
    ld [wPreviousState], a
    pop af
    ld [wCurrentState], a
    ret

ENDSECTION


SECTION "Main Variables", WRAM0

wCurrentState:
    DB

wPreviousState:
    DB

ENDSECTION
