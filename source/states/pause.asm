INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Pause State", ROM0

_Pause::
    call _DrawPauseHUD

    xor a
    ld [wPauseDelayFrameCounter], a
    ld [wPauseButtonsEnabled], a

    ld a, SFX_JUMP
    call _PlaySound

    ; fallthrough
    
_PauseLoop:
    ei
    call _WaitForVBLInterrupt
    
    call _DrawPauseHUD

    ld a, [wPauseButtonsEnabled]
    and a
    jr nz, .checkKeys

    ld a, [wPauseDelayFrameCounter]
    inc a
    ld [wPauseDelayFrameCounter], a
    and a, BUTTON_DELAY_FRAMES_MASK
    jr nz, _PauseLoop

    ld a, TRUE
    ld [wPauseButtonsEnabled], a

    jr _PauseLoop

.checkKeys:
    ldh a, [hKeysPressed]
    and a, PADF_START
    jr z, _PauseLoop
    
    jp _SwitchStateToPrevious

ENDSECTION


SECTION "Pause State Variables", WRAM0

wPauseDelayFrameCounter:
    DB

wPauseButtonsEnabled:
    DB

ENDSECTION
