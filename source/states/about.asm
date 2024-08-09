INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "About State", ROM0

_About::
    call _ResetScreen
    
    ld hl, STARTOF("About State Variables")
    ld b, SIZEOF("About State Variables")
    xor a
    call _MemSetFast

    call _LoadTilemapAbout

    ld a, WINDOW_OFF
    ldh [rLCDC], a

    ; fallthrough
    
_AboutLoop:
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
