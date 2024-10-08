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

    call _LoadHighScores

    ld hl, STARTOF("Main Variables")
    ld b, SIZEOF("Main Variables")
    xor a
    call _MemSetFast

    ld bc, _DefaultTimerHandler
    rst _SetTIMHandler
    
    ld a, STATF_LYC
    ldh [rSTAT], a

    ld a, IEF_VBLANK | IEF_STAT
    ldh [rIE], a

    ld a, SFX_SCORE
    call _PlaySound

    ; fallthrough

_MainLoop:
    di

    xor a
    ldh [rLYC], a

    ; reset handlers to default
    ld bc, _DefaultVBlankHandler
    rst _SetVBLHandler
    
    ld bc, _DefaultLCDStatHandler
    rst _SetLCDHandler

    ei

    ld a, [wCurrentState]
    cp a, NUMBER_OF_STATES
    jr c, .jump
    ld a, NUMBER_OF_STATES
    
.jump:
    ld hl, .jumpTable
    call _JumpTable
    jr _MainLoop

.jumpTable:
    DW _Menu
    DW _Menu
    DW _Controls
    DW _Scoreboard
    DW _About
    DW _Game
    DW _NULL


/*******************************************************************************
**                                                                            **
**      STATE FUNCTIONS                                                       **
**                                                                            **
*******************************************************************************/

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


/*******************************************************************************
**                                                                            **
**      DEFAULT INTERRUPT FUNCTIONS                                           **
**                                                                            **
*******************************************************************************/

_DefaultVBlankHandler:
    call _ScanKeys
    call _RefreshOAM
    
    call _RexIncFrameCounter

    ret

_DefaultLCDStatHandler:
    ret

_DefaultTimerHandler:
    call _CheckForStackOverflow

    call _UpdateSound

    call _CheckForStackUnderflow

    ret

ENDSECTION


SECTION "Main Variables", WRAM0

wCurrentState::
    DB

wPreviousState::
    DB

ENDSECTION
