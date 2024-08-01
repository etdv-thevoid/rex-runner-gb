INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Dead State", ROM0

_Dead::
    call _RexDead

    call _DrawGameOverHUD

    ld hl, STARTOF("Dead State Variables")
    ld b, SIZEOF("Dead State Variables")
    xor a
    call _MemSetFast

    ld a, SFX_DEAD
    call _PlaySound
    
    ; fallthrough
    
_DeadLoop:
    ei
    call _WaitForVBLInterrupt

    call _DrawGameOverHUD

    check_keys_start wDeadButtonsEnabled, \
                     wDeadDelayFrameCounter, \
                     _DeadLoop

    check_keys_add hKeysPressed, PADF_B
    ld a, SFX_MENU_B
    call _PlaySound
    ld a, STATE_MENU
    jp _SwitchStateToNew

    check_keys_add hKeysPressed, PADF_A
    jp _SwitchStateToPrevious

    check_keys_end _DeadLoop

ENDSECTION


SECTION "Dead State Variables", WRAM0

wDeadDelayFrameCounter:
    DB

wDeadButtonsEnabled:
    DB

ENDSECTION