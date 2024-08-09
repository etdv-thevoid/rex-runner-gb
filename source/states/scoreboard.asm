INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Scoreboard State", ROM0

_Scoreboard::
    call _ResetScreen
    
    ld hl, STARTOF("Scoreboard State Variables")
    ld b, SIZEOF("Scoreboard State Variables")
    xor a
    call _MemSetFast
    
    call _LoadTilemapScoreboard

    ld a, [wPreviousState]
    cp a, STATE_SECRET
    jr z, .secret

    call _DrawScoreboard
    jr .continue

.secret:
    call _DrawScoreboardHard

.continue:
    ld a, WINDOW_OFF
    ldh [rLCDC], a

    ; fallthrough
    
_ScoreboardLoop:
    call _WaitForVBLInterrupt

    call _RexAnimate

    check_keys_start wScoreboardButtonsEnabled, \
                     wScoreboardDelayFrameCounter, \
                     _ScoreboardLoop

    check_keys_add hKeysPressed, PADF_B
    ld a, SFX_MENU_B
    call _PlaySound
    jp _SwitchStateToPrevious

    check_keys_end _ScoreboardLoop

_DrawScoreboard:
    ld hl, wHighScore0

    xor a
    ld b, SCORE_BYTES
    ld c, "0"
    ld de, vSCRN0.y5x7 + SCORE_DIGITS - 1
    call _DrawBCDNumber
    
    xor a
    ld b, SCORE_BYTES
    ld c, $00
    ld de, vSCRN0.y7x7 + SCORE_DIGITS - 1
    call _DrawBCDNumber
    
    xor a
    ld b, SCORE_BYTES
    ld de, vSCRN0.y9x7 + SCORE_DIGITS - 1
    call _DrawBCDNumber
    
    xor a
    ld b, SCORE_BYTES
    ld de, vSCRN0.y11x7 + SCORE_DIGITS - 1
    call _DrawBCDNumber
    
    xor a
    ld b, SCORE_BYTES
    ld de, vSCRN0.y13x7 + SCORE_DIGITS - 1
    jp _DrawBCDNumber

_DrawScoreboardHard:
    ld hl, wHighScore0Hard

    xor a
    ld b, SCORE_BYTES
    ld c, "0"
    ld de, vSCRN0.y5x7 + SCORE_DIGITS - 1
    call _DrawBCDNumber
    
    xor a
    ld b, SCORE_BYTES
    ld c, $00
    ld de, vSCRN0.y7x7 + SCORE_DIGITS - 1
    call _DrawBCDNumber
    
    xor a
    ld b, SCORE_BYTES
    ld de, vSCRN0.y9x7 + SCORE_DIGITS - 1
    call _DrawBCDNumber
    
    xor a
    ld b, SCORE_BYTES
    ld de, vSCRN0.y11x7 + SCORE_DIGITS - 1
    call _DrawBCDNumber
    
    xor a
    ld b, SCORE_BYTES
    ld de, vSCRN0.y13x7 + SCORE_DIGITS - 1
    jp _DrawBCDNumber

ENDSECTION


SECTION "Scoreboard State Variables", WRAM0

wScoreboardDelayFrameCounter:
    DB

wScoreboardButtonsEnabled:
    DB

ENDSECTION
