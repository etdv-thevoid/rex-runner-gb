INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"


SECTION "Engine Functions", ROM0

/*******************************************************************************
**                                                                            **
**      CORE ENGINE FUNCTIONS                                                 **
**                                                                            **
*******************************************************************************/

; Initialize all core engine variables
_InitEngine::
    call _ScreenOff

    xor a
    ldh [rSCY], a
    ldh [rSCX], a
    ldh [rWY], a
    add WX_OFS
    ldh [rWX], a

    ld hl, wShadowOAM
    ld b, (wShadowOAM.end - wShadowOAM)
    ld a, $00
    call _MemSetFast
    call _RefreshOAM
    
    ld hl, STARTOF("Engine Variables")
    ld b, SIZEOF("Engine Variables")
    ld a, $00
    call _MemSetFast

    call _LoadHighScore

    ld a, INITIAL_DIFFICULTY_SPEED
    ld [wBaseDifficultySpeed], a

    ld a, DEFAULT_PALETTE
    ld [wCurrentPalette], a
    call _LoadMonochromeColorPalette

    call _InitCactus
    call _InitPtero
    call _InitMeteor
    call _InitRex

    call _InitGameOverHUD
    
    ld bc, _VBlankHandler
    rst _SetVBLHandler

    ld bc, _LCDStatHandler
    rst _SetLCDHandler

    ld a, LYC_HUD_STOP_LINE
    ldh [rLYC], a

    ld a, STATF_LYC
    ldh [rSTAT], a

    ldh a, [rIE]
    or a, IEF_VBLANK | IEF_LCDC
    ldh [rIE], a

    call _GetStatePrevious
    cp a, STATE_DEAD
    ld a, STATE_GAME
    jp z, _SwitchStateToNew

    ld a, STATE_MENU
    jp _SwitchStateToNew

; Get per frame ground level scroll speed differential
_GetGroundSpeedDifferential::
    ld a, [wGroundSpeedDifferential]
    ret

_GetAirSpeedDifferential::
    ld a, [wGroundSpeedDifferential]
    ld b, a
    ld a, [wScoreIncreaseDifferential]
    add a, b
    ret

; Try to spawn an enemy
_EngineTrySpawn::
    ld a, [wSpawnDistanceCounter]
    cp a, MINIMUM_SPAWN_DISTANCE
    ret c

    call _GetRandom
    and %00000011
    cp a, NUMBER_OF_OBJECTS
    jr c, .jump
    ld a, DEFAULT_OBJECT
.jump:
    ld hl, _EngineSpawnJumpTable
    call _JumpTable
    ret nc
    xor a
    ld [wSpawnDistanceCounter], a
    ret

; Spawn Rotation Jump Table
_EngineSpawnJumpTable:
    DW _CactusTrySpawn
    DW _PteroTrySpawn
    ;DW _MeteorTrySpawn
    DW _NULL

; Animate all objects
_EngineAnimate::
    call _CactusAnimate
    call _PteroAnimate

    jp _RexAnimate

/*
Checks for Rex collisions with any other oam objects, ignoring Rex's tail.
Uses Rex Sprite 3, which is always in the top right,
and Rex Sprite 1, which is always in the bottom middle;
Regardless of Rex's current animation.

Returns:
- carry = collision
- no carry = no collision
*/
_EngineCheckCollision::
    ld hl, {REX_SPRITE_3}       ; Top right sprite
    ld a, [hl+]
    sub a, (OAM_Y_OFS - COLLISION_PIXEL_OVERLAP_TOP)
    ld b, a                     ; b = Rex top y
    ld a, [hl]
    sub a, COLLISION_PIXEL_OVERLAP_RIGHT
    ld c, a                     ; c = Rex right x

    ld hl, {REX_SPRITE_1}       ; Bottom middle sprite
    ld a, [hl+]
    sub a, COLLISION_PIXEL_OVERLAP_BOTTOM
    ld d, a                     ; d = Rex bottom y
    ld a, [hl]
    sub a, (OAM_X_OFS - COLLISION_PIXEL_OVERLAP_LEFT)
    ld e, a                     ; e = Rex left x

FOR SPRITE, NUMBER_OF_REX_SPRITES, OAM_COUNT
    ld hl, wShadowOAM + (SPRITE * sizeof_OAM_ATTRS) + OAMA_Y
    ld a, [hl]
    sub a, COLLISION_PIXEL_OVERLAP_OBJ
    cp a, b
    jr c, :+
    ld a, [hl]
    sub a, (OAM_Y_OFS - COLLISION_PIXEL_OVERLAP_OBJ)
    cp a, d
    jr nc, :+
    inc hl
    ld a, [hl]
    sub a, (OAM_X_OFS - COLLISION_PIXEL_OVERLAP_OBJ)
    cp a, c
    jr nc, :+
    ld a, [hl]
    sub a, COLLISION_PIXEL_OVERLAP_OBJ
    cp a, e
    jr c, :+
    jp .collision
:
ENDR
    scf
    ccf
    ret

.collision:
    scf
    ret

/*******************************************************************************
**                                                                            **
**      HUD & SCORE FUNCTIONS                                                 **
**                                                                            **
*******************************************************************************/

_LoadHighScore:
    ld hl, sHighScore
    ld bc, SCORE_BYTES ; (sHighScore.end - sHighScore)
    ld de, wHighScore
    jp _LoadFromSRAM

_SaveHighScore::
    call _CompareScores
    ret nc

    ld hl, wCurrentScore
    ld b, SCORE_BYTES ; (wCurrentScore.end - wCurrentScore)
    ld de, wHighScore
    call _MemCopyFast

    ld hl, wHighScore
    ld bc, SCORE_BYTES ; (wHighScore.end - wHighScore)
    ld de, sHighScore
    jp _SaveToSRAM

_InitGameOverHUD:
    ld hl, {GAME_OVER_SPRITE_0}
    ld a, OFFSCREEN_SPRITE_Y_POS
    ld [hl+], a
    ld a, GAME_OVER_X_POS_0
    ld [hl+], a
    ld a, GAME_OVER_SPRITE_0_TILE
    ld [hl], a

    ld hl, {GAME_OVER_SPRITE_1}
    ld a, OFFSCREEN_SPRITE_Y_POS
    ld [hl+], a
    ld a, GAME_OVER_X_POS_1
    ld [hl+], a
    ld a, GAME_OVER_SPRITE_1_TILE
    ld [hl], a

    ret

_DrawGameOverHUD::
    ld hl, {GAME_OVER_SPRITE_0}
    ld a, GAME_OVER_Y_POS_0
    ld [hl], a

    ld hl, {GAME_OVER_SPRITE_1}
    ld a, GAME_OVER_Y_POS_0
    ld [hl], a

    xor a
    ld hl, _GameOverString
    ld b, (_GameOverString.end - _GameOverString)
    ld de, vSCRN1.y0x0
    jp _VideoMemCopyFast

_GameOverString:
    DB $18, $19, $1A, $1B, " ", $1C, $1D, $1E, $1F
.end:

_DrawPauseHUD::
    xor a
    ld hl, _PausedString
    ld b, (_PausedString.end - _PausedString)
    ld de, vSCRN1.y0x0
    jp _VideoMemCopyFast

_PausedString:
    DB " ", $12, $13, $14, $15, $16, $17, " ", " "
.end:

_DrawGameHUD::
    xor a
    ld hl, _HighScoreTiles
    ld b, (_HighScoreTiles.end - _HighScoreTiles)
    ld de, vSCRN1.y0x0
    call _VideoMemCopyFast

    xor a
    ld hl, wHighScore
    ld b, (wHighScore.end - wHighScore)
    ld c, $00
    ld de, vSCRN1.y0x3 + SCORE_DIGITS - 1
    call _DrawBCDNumber

    ; fallthrough

_UpdateGameHUD::
    xor a
    ld hl, wCurrentScore
    ld b, (wCurrentScore.end - wCurrentScore)
    ld c, "0"
    ld de, vSCRN1.y0x14 + SCORE_DIGITS - 1
    ; fallthrough

_DrawBCDNumber:
    ldh [rVBK], a
.loop:
    call _WaitForScreenBlank
    ld a, [hl]          ; low nibble
    and a, %00001111
    add a, c
    ld [de], a
    dec de
    ld a, [hl+]         ; high nibble
    swap a
    and a, %00001111
    add a, c
    ld [de], a
    dec de
    dec b
    jr nz, .loop
    ret

_HighScoreTiles:
    DB $10, $11, " ", $00, $00, $00, $00, $00, $00
.end:

_UpdateScore::
    ld a, [wScoreIncreaseDifferential]
    ld c, a

    ld hl, wCurrentScore + 1
    ld a, [hl]
    and a, %00001111
    ld b, a

    scf
    ccf

    ld hl, wCurrentScore
    ld a, [hl]
    add a, c
    daa
    ld [hl+], a
REPT SCORE_BYTES - 1
    ld a, [hl]
    adc a, 0
    daa
    ld [hl+], a
ENDR

    ld hl, wCurrentScore + 1
    ld a, [hl]
    and a, %00001111
    ld c, a
    cp a, b
    ret z

    ld a, c
    and a, %00000001
    jr z, .noSpeedIncrease

    ld a, [wBaseDifficultySpeed]
    add a, DIFFICULTY_SPEED_INCREASE
    ld [wBaseDifficultySpeed], a
    cp a, MAX_DIFFICULTY_SPEED
    jr c, .noSpeedIncrease
    ld a, MAX_DIFFICULTY_SPEED
    ld [wBaseDifficultySpeed], a

.noSpeedIncrease:
    ld a, c
    cp a, PALETTE_SWITCH_100_DIGIT
    ret nz
    
    ld a, SFX_SCORE
    call _PlaySound
    
    ld a, [wPaletteChangeFlag]
    inc a
    ld [wPaletteChangeFlag], a
    
    ;call _CactusIncSpawnChance
    ;jp _PteroIncSpawnChance

    ret
    

/**
Returns:
    - carry if high < current
    - no carry if high >= current
*/
_CompareScores:
    ld de, wCurrentScore.end
    ld hl, wHighScore.end
REPT SCORE_BYTES
    dec de
    dec hl
    ld a, [de]
    ld b, a             ; b = current score byte
    ld a, [hl]          ; a = high score byte
    cp a, b
    jr c, .lessThan     ; exit if high < current
    jr nz, .greaterThan ; exit if high > current
                        ; else compare next byte
ENDR
.greaterThan:           ; exit with no carry if high >= current
    scf
    ccf
    ret

.lessThan:              ; exit with carry if high < current
    scf
    ret


/*******************************************************************************
**                                                                            **
**      INTERRUPT FUNCTIONS                                                   **
**                                                                            **
*******************************************************************************/

_VBlankHandler:
    call _ScanKeys
    call _RefreshOAM
    
    xor a
    ldh [rSCX], a
    ld a, WINDOW_ON
    call _ScreenOn

    call _GetStateCurrent
    cp a, STATE_PAUSE
    ret nc

    call _RexIncFrameCounter

    call _GetStateCurrent
    cp a, STATE_GAME
    ret nz

    ld a, [wPaletteChangeFlag]
    and a
    jr z, .noPaletteChange

    xor a
    ld [wPaletteChangeFlag], a

    ld a, [wCurrentPalette]
    cpl
    ld [wCurrentPalette], a
    cp a, DEFAULT_PALETTE
    jr nz, .invertedPalette
    call _LoadMonochromeColorPalette
    call _LoadTilemapBackgroundDay
    jr .noPaletteChange

.invertedPalette:
    call _LoadMonochromeColorPaletteInverted
    call _LoadTilemapBackgroundNight

.noPaletteChange:
    call _PteroIncFrameCounter

    ld a, [wBaseDifficultySpeed]
    ld b, a

    scf
    ccf

    ld hl, wBackgroundScrollPosition
    ld a, [hl]
    add a, b
    ld [hl+], a
    ld a, [hl]
    adc a, 0
    ld [hl], a

    scf
    ccf

    ld a, [wBackgroundScrollPosition]
    ld b, a
    ld a, [wBackgroundScrollPosition+1]
    ld c, a

    ld a, [wBackgroundParallaxBottom]
    ld d, a
REPT PARALLAX_BIT_SHIFTS_BOTTOM
    srl c
    rr b
ENDR
    ld a, b
    ld [wBackgroundParallaxBottom], a
    sub a, d
    ld [wGroundSpeedDifferential], a
    ld d, a
    ld a, [wSpawnDistanceCounter]
    add a, d
    ld [wSpawnDistanceCounter], a
    
    ld a, [wBackgroundParallaxMiddle]
    ld e, a
REPT PARALLAX_BIT_SHIFTS_MIDDLE
    srl c
    rr b
ENDR
    ld a, b
    ld [wBackgroundParallaxMiddle], a
    sub a, e
    ld [wScoreIncreaseDifferential], a

REPT PARALLAX_BIT_SHIFTS_TOP
    srl c
    rr b
ENDR
    ld a, b
    ld [wBackgroundParallaxTop], a

    ret


_LCDStatHandler:
    ldh a, [rLYC]
    cp a, LYC_PARALLAX_BOTTOM_START_LINE
    jr z, .bottom
    cp a, LYC_PARALLAX_MIDDLE_START_LINE
    jr z, .middle
    cp a, LYC_PARALLAX_TOP_START_LINE
    jr z, .top

    ld a, LYC_PARALLAX_TOP_START_LINE
    ldh [rLYC], a
    ld a, WINDOW_OFF
    jp _ScreenOn
    
.top:
    ld a, LYC_PARALLAX_MIDDLE_START_LINE
    ldh [rLYC], a
    ld a, [wBackgroundParallaxTop]
    ldh [rSCX], a
    ret

.middle:
    ld a, LYC_PARALLAX_BOTTOM_START_LINE
    ldh [rLYC], a
    ld a, [wBackgroundParallaxMiddle]
    ldh [rSCX], a
    ret

.bottom:
    ld a, LYC_HUD_STOP_LINE
    ldh [rLYC], a
    ld a, [wBackgroundParallaxBottom]
    ldh [rSCX], a
    ret

ENDSECTION



SECTION "Engine Variables", WRAM0

wCurrentPalette:
    DB
wPaletteChangeFlag:
    DB

wBaseDifficultySpeed:
    DB

wGroundSpeedDifferential:
    DB
    
wBackgroundScrollPosition:
    DW

wBackgroundParallaxTop:
    DB

wBackgroundParallaxMiddle:
    DB

wBackgroundParallaxBottom:
    DB

wSpawnDistanceCounter:
    DB

wScoreIncreaseDifferential:
    DB

wCurrentScore:
    DS SCORE_BYTES
.end:

wHighScore:
    DS SCORE_BYTES
.end:

ENDSECTION


SECTION "Save Data", SRAM

sHighScore:
    DS SCORE_BYTES
.end:

ENDSECTION
