INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Scores State", ROM0

_Scores::
    call _ScreenOff
    
    call _LoadTilemapScores

    call _DrawScoreboard

    call _RexStand
    
    ld hl, STARTOF("Scores State Variables")
    ld b, SIZEOF("Scores State Variables")
    xor a
    call _MemSetFast

    ld a, WINDOW_OFF
    call _ScreenOn

    ; fallthrough
    
_ScoresLoop:
    ei
    call _WaitForVBLInterrupt

    call _RexAnimate

    check_keys_start wScoresButtonsEnabled, \
                     wScoresDelayFrameCounter, \
                     _ScoresLoop

    check_keys_add hKeysPressed, PADF_B
    ld a, SFX_MENU_B
    call _PlaySound
    jp _SwitchStateToPrevious

    check_keys_end _ScoresLoop


ENDSECTION


SECTION "Scores State Variables", WRAM0

wScoresDelayFrameCounter:
    DB

wScoresButtonsEnabled:
    DB

ENDSECTION
