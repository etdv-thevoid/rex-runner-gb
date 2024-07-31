INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"


SECTION "Main", ROM0

/*******************************************************************************
**                                                                            **
**      MAIN LOOP                                                             **
**                                                                            **
*******************************************************************************/

/*
gbc-engine-core hands off code execution to a function labeled `_Main` when done with initial setup.

The function can assume the following:
 - All ram areas are cleared
 - LCD is off
 - Interrupts are disabled
*/
_Main::
    ld a, 1
    ld [rROMB0], a
    
    call _EnableSoftReset

    call _InitGraphics
    
    call _InitSound

    ; fallthrough

_MainLoop:
    di

    ld hl, _StateJumpTable
    ld a, [wCurrentState]
    cp a, NUMBER_OF_STATES
    jr c, .jump
    ld a, NUMBER_OF_STATES
.jump:
    call _JumpTable
    jr _MainLoop

_StateJumpTable:
    DW _InitEngine
    DW _Menu
    DW _Secret
    DW _Controls
    DW _About
    DW _Game
    DW _Pause
    DW _Dead
    DW _NULL


/*******************************************************************************
**                                                                            **
**      STATE FUNCTIONS                                                       **
**                                                                            **
*******************************************************************************/

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
