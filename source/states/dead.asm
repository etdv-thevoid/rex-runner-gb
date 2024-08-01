INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Dead State", ROM0

_Dead::
    call _RexDead

    call _DrawGameOverHUD

    xor a
    ld [wDeadDelayFrameCounter], a
    ld [wDeadButtonsEnabled], a

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
    ld a, SFX_SCORE
    call _PlaySound
    ld a, STATE_MENU
    jp _SwitchStateToNew

    check_keys_add hKeysPressed, PADF_A
    jp _SwitchStateToPrevious

    check_keys_end _DeadLoop

ENDSECTION


SECTION "Dead Variables State", WRAM0

wDeadDelayFrameCounter:
    DB

wDeadButtonsEnabled:
    DB

ENDSECTION