INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "About State", ROM0

_About::
    call _ScreenOff
    
    call _LoadTilemapAbout

    call _RexStand
    
    xor a
    ld [wAboutDelayFrameCounter], a
    ld [wAboutButtonsEnabled], a

    ld a, SFX_JUMP
    call _PlaySound

    ld a, WINDOW_OFF
    call _ScreenOn

    ; fallthrough
    
_AboutLoop:
    ei
    call _WaitForVBLInterrupt

    call _RexAnimate
    
    ld a, [wAboutButtonsEnabled]
    and a
    jr nz, .checkKeys

    ld a, [wAboutDelayFrameCounter]
    inc a
    ld [wAboutDelayFrameCounter], a
    and a, BUTTON_DELAY_FRAMES_MASK
    jr nz, _AboutLoop

    ld a, TRUE
    ld [wAboutButtonsEnabled], a

    jr _AboutLoop

.checkKeys:
    ldh a, [hKeysPressed]
    and a, PADF_B | PADF_A
    jr z, _AboutLoop
    jp _SwitchStateToPrevious

ENDSECTION


SECTION "About State Variables", WRAM0

wAboutDelayFrameCounter:
    DB

wAboutButtonsEnabled:
    DB

ENDSECTION
