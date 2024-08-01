INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Pause State", ROM0

_Pause::
    call _DrawPauseHUD

    xor a
    ld [wPauseDelayFrameCounter], a
    ld [wPauseButtonsEnabled], a

    ; fallthrough
    
_PauseLoop:
    ei
    call _WaitForVBLInterrupt
    
    call _DrawPauseHUD

    check_keys_start wPauseButtonsEnabled, \
                     wPauseDelayFrameCounter, \
                     _PauseLoop

    check_keys_add hKeysPressed, PADF_START
    ld a, SFX_MENU_B
    call _PlaySound
    jp _SwitchStateToPrevious

    check_keys_end _PauseLoop


ENDSECTION


SECTION "Pause State Variables", WRAM0

wPauseDelayFrameCounter:
    DB

wPauseButtonsEnabled:
    DB

ENDSECTION
