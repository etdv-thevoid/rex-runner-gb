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

    ld a, [wDeadButtonsEnabled]
    and a
    jr nz, .checkKeys

    ld a, [wDeadDelayFrameCounter]
    inc a
    ld [wDeadDelayFrameCounter], a
    and a, BUTTON_DELAY_FRAMES_MASK
    jr nz, _DeadLoop

    ld a, TRUE
    ld [wDeadButtonsEnabled], a

    jr _DeadLoop

.checkKeys:
    ldh a, [hKeysPressed]
    and a, PADF_B
    jr z, :+
    
    ld a, STATE_MENU
    jp _SwitchStateToNew
:
    ldh a, [hKeysPressed]
    and a, PADF_A
    jr z, :+
    
    ld a, STATE_GAME
    jp _SwitchStateToNew
:
    jr _DeadLoop

ENDSECTION


SECTION "Dead Variables State", WRAM0

wDeadDelayFrameCounter:
    DB

wDeadButtonsEnabled:
    DB

ENDSECTION