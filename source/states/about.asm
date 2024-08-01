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

    ld a, WINDOW_OFF
    call _ScreenOn

    ; fallthrough
    
_AboutLoop:
    ei
    call _WaitForVBLInterrupt

    call _RexAnimate

    check_keys_start wAboutButtonsEnabled, \
                     wAboutDelayFrameCounter, \
                     _AboutLoop

    check_keys_add hKeysPressed, PADF_B
    ld a, SFX_MENU_B
    call _PlaySound
    jp _SwitchStateToPrevious

    check_keys_end _AboutLoop

ENDSECTION


SECTION "About State Variables", WRAM0

wAboutDelayFrameCounter:
    DB

wAboutButtonsEnabled:
    DB

ENDSECTION
