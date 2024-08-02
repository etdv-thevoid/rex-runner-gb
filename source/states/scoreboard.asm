INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Scoreboard State", ROM0

_Scoreboard::
    call _ResetScreen
    
    call _LoadTilemapScoreboard

    ld a, [wPreviousState]
    cp a, STATE_SECRET
    jr z, .secret

    call _DrawScoreboard
    jr .skip

.secret:
    call _DrawScoreboardHard

.skip:
    call _RexStand
    
    ld hl, STARTOF("Scoreboard State Variables")
    ld b, SIZEOF("Scoreboard State Variables")
    xor a
    call _MemSetFast

    ld bc, _ScoreboardVBlankHandler
    rst _SetVBLHandler

    ld a, IEF_VBLANK | IEF_TIMER
    ldh [rIE], a

    ld a, WINDOW_OFF
    call _ScreenOn

    ; fallthrough
    
_ScoreboardLoop:
    ei
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

_ScoreboardVBlankHandler:
    call _ScanKeys
    call _RefreshOAM
    
    call _RexIncFrameCounter

    ret

_DrawScoreboard:
    xor a
    ld hl, wHighScore0
    ld b, SCORE_BYTES
    ld c, "0"
    ld de, vSCRN0.y5x9 + SCORE_DIGITS - 1
    call _DrawBCDNumber
    
    xor a
    ld hl, wHighScore1
    ld b, SCORE_BYTES
    ld c, "0"
    ld de, vSCRN0.y7x9 + SCORE_DIGITS - 1
    call _DrawBCDNumber
    
    xor a
    ld hl, wHighScore2
    ld b, SCORE_BYTES
    ld c, "0"
    ld de, vSCRN0.y9x9 + SCORE_DIGITS - 1
    call _DrawBCDNumber
    
    xor a
    ld hl, wHighScore3
    ld b, SCORE_BYTES
    ld c, "0"
    ld de, vSCRN0.y11x9 + SCORE_DIGITS - 1
    call _DrawBCDNumber
    
    xor a
    ld hl, wHighScore4
    ld b, SCORE_BYTES
    ld c, "0"
    ld de, vSCRN0.y13x9 + SCORE_DIGITS - 1
    jp _DrawBCDNumber

_DrawScoreboardHard:
    xor a
    ld hl, wHighScore0Hard
    ld b, SCORE_BYTES
    ld c, "0"
    ld de, vSCRN0.y5x9 + SCORE_DIGITS - 1
    call _DrawBCDNumber
    
    xor a
    ld hl, wHighScore1Hard
    ld b, SCORE_BYTES
    ld c, "0"
    ld de, vSCRN0.y7x9 + SCORE_DIGITS - 1
    call _DrawBCDNumber
    
    xor a
    ld hl, wHighScore2Hard
    ld b, SCORE_BYTES
    ld c, "0"
    ld de, vSCRN0.y9x9 + SCORE_DIGITS - 1
    call _DrawBCDNumber
    
    xor a
    ld hl, wHighScore3Hard
    ld b, SCORE_BYTES
    ld c, "0"
    ld de, vSCRN0.y11x9 + SCORE_DIGITS - 1
    call _DrawBCDNumber
    
    xor a
    ld hl, wHighScore4Hard
    ld b, SCORE_BYTES
    ld c, "0"
    ld de, vSCRN0.y13x9 + SCORE_DIGITS - 1
    jp _DrawBCDNumber

ENDSECTION


SECTION "Scoreboard State Variables", WRAM0

wScoreboardDelayFrameCounter:
    DB

wScoreboardButtonsEnabled:
    DB

ENDSECTION
