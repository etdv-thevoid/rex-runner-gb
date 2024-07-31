INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Credits", ROM0

_Credits::
    call _ScreenOff
    
    call _LoadTilemapCredits
    
    xor a
    ld [wCreditsDelayFrameCounter], a
    ld [wCreditsButtonsEnabled], a

    ld a, SFX_JUMP
    call _PlaySound

    ld a, WINDOW_OFF
    call _ScreenOn

    ; fallthrough
    
_CreditsLoop:
    ei
    call _WaitForVBLInterrupt

    call _RexAnimate
    
    ld a, [wCreditsButtonsEnabled]
    and a
    jr nz, .checkKeys

    ld a, [wCreditsDelayFrameCounter]
    inc a
    ld [wCreditsDelayFrameCounter], a
    and a, BUTTON_DELAY_FRAMES_MASK
    jr nz, _CreditsLoop

    ld a, TRUE
    ld [wCreditsButtonsEnabled], a

    jr _CreditsLoop

.checkKeys:
    ldh a, [hKeysPressed]
    and a, PADF_B | PADF_A
    jr z, _CreditsLoop
    
    ld a, SFX_JUMP
    call _PlaySound
    jp _SwitchStateToPrevious

ENDSECTION


SECTION "Credits Variables", WRAM0

wCreditsDelayFrameCounter:
    DB

wCreditsButtonsEnabled:
    DB

ENDSECTION
