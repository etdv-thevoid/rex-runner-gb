INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Game State", ROM0

_Game::
    call _ResetScreen
    
    ld hl, STARTOF("Game State Variables")
    ld b, SIZEOF("Game State Variables")
    xor a
    call _MemSetFast
    
    call _InitGameOverHUD

    ld a, [wPreviousState]
    cp a, STATE_SECRET
    jr z, .secret

.init:
    call _LoadTilemapBackground
    call _LoadTilemapBackgroundDay
    call _LoadMonochromeColorPalette
    
    ld a, INITIAL_DIFFICULTY_SPEED
    ld [wBaseDifficultySpeed], a

    ld a, CACTUS_INIT_SPAWN_CHANCE
    ld [wCactusSpawnChance], a

    call _InitCactus1
    call _InitCactus2
    call _InitCactus3
    call _InitCactus4
    call _InitCactus5
    call _InitCactus6
    
    ld a, PTERO_INIT_SPAWN_CHANCE
    ld [wPteroSpawnChance], a

    call _InitPtero1
    call _InitPtero2

    jr .continue

.secret:
    call _LoadTilemapBackground
    call _LoadTilemapBackgroundNight
    call _LoadMonochromeColorPaletteInverted
    
    ld a, INITIAL_DIFFICULTY_SPEED_HARD
    ld [wBaseDifficultySpeed], a

    ld a, CACTUS_INIT_SPAWN_CHANCE_HARD
    ld [wCactusSpawnChance], a

    call _InitCactus1
    call _InitCactus2
    call _InitCactus3
    call _InitCactus4
    call _InitCactus5
    call _InitCactus6
    
    ld a, PTERO_INIT_SPAWN_CHANCE_HARD
    ld [wPteroSpawnChance], a

    call _InitPtero1
    call _InitPtero2

    ;call _InitMeteor

.continue:
    call _RexJumpFull

    ld bc, _VBlankHandler
    rst _SetVBLHandler

    ld bc, _LCDStatHandler
    rst _SetLCDHandler

    ld a, LYC_HUD_STOP_LINE
    ldh [rLYC], a

    ld a, STATF_LYC
    ldh [rSTAT], a

    ld a, IEF_VBLANK | IEF_STAT | IEF_TIMER
    ldh [rIE], a

    ; fallthrough

_GameLoop:
    ld a, [wGameState]
    cp a, NUMBER_OF_GAME_STATES
    jr c, .jump
    ld a, NUMBER_OF_GAME_STATES
    
.jump:
    ld hl, .jumpTable
    call _JumpTable
    
    ld a, [wGameState]
    cp a, GAME_STATE_RESTART
    jp z, _Game
    cp a, GAME_STATE_EXIT
    jp z, _SwitchStateToPrevious

    jr _GameLoop

.jumpTable:
    DW _Play
    DW _Pause
    DW _Dead
    DW _NULL
    DW _NULL

_GameStateSwitch:
    ld [wGameState], a
    ret

/*******************************************************************************
**                                                                            **
**      PLAY LOOP                                                             **
**                                                                            **
*******************************************************************************/

_Play:
    call _DrawGameHUD
    
    ld a, WINDOW_ON
    call _ScreenOn

    ; fallthrough

_PlayLoop:
    ei
    call _WaitForVBLInterrupt

    call _UpdateScore
    
    call _UpdateGameHUD
    
    call _CheckCollision
    ld a, GAME_STATE_DEAD
    jp c, _GameStateSwitch

    call _SpawnEnemies

    call _AnimateEnemies

    call _RexAnimate

    check_keys_start wGameButtonsEnabled, \
                     wGameDelayFrameCounter, \
                     _PlayLoop

    check_keys_add hKeysHeld, PADF_DOWN
    call _RexDuckOn

    check_keys_add hKeysReleased, PADF_DOWN
    call _RexDuckOff

    check_keys_add hKeysHeld, PADF_A
    call _RexChargeJump

    check_keys_add hKeysReleased, PADF_A
    call _RexJump

    check_keys_add hKeysPressed, PADF_START
    ld a, SFX_MENU_A
    call _PlaySound
    ld a, GAME_STATE_PAUSE
    jp _GameStateSwitch

    check_keys_end _PlayLoop


/*******************************************************************************
**                                                                            **
**      PAUSE LOOP                                                            **
**                                                                            **
*******************************************************************************/

_Pause:
    call _DrawPauseHUD
    
    xor a
    ld [wGameButtonsEnabled], a
    ld [wGameDelayFrameCounter], a
    
    ld a, WINDOW_ON
    call _ScreenOn

    ; fallthrough

_PauseLoop:
    ei
    call _WaitForVBLInterrupt
    
    call _DrawPauseHUD

    check_keys_start wGameButtonsEnabled, \
                     wGameDelayFrameCounter, \
                     _PauseLoop

    check_keys_add hKeysPressed, PADF_START
    ld a, SFX_MENU_B
    call _PlaySound
    ld a, GAME_STATE_PLAY
    jp _GameStateSwitch

    check_keys_end _PauseLoop


/*******************************************************************************
**                                                                            **
**      DEAD LOOP                                                             **
**                                                                            **
*******************************************************************************/

_Dead:
    call _RexDead

    call _DrawGameOverHUD

    xor a
    ld [wGameButtonsEnabled], a
    ld [wGameDelayFrameCounter], a

    ld a, [wPreviousState]
    cp a, STATE_SECRET
    jr z, .secret

    call _SaveHighScores
    jr .skip

.secret:
    call _SaveHighScoresHard

.skip:
    ld a, SFX_DEAD
    call _PlaySound
    
    ; fallthrough

_DeadLoop:
    ei
    call _WaitForVBLInterrupt

    call _DrawGameOverHUD

    check_keys_start wGameButtonsEnabled, \
                     wGameDelayFrameCounter, \
                     _DeadLoop

    check_keys_add hKeysPressed, PADF_B
    ld a, SFX_MENU_B
    call _PlaySound
    ld a, GAME_STATE_EXIT
    jp _GameStateSwitch

    check_keys_add hKeysPressed, PADF_A
    ld a, GAME_STATE_RESTART
    jp _GameStateSwitch

    check_keys_end _DeadLoop

/*******************************************************************************
**                                                                            **
**      GAME PLAY LOGIC FUNCTION                                              **
**                                                                            **
*******************************************************************************/

_IncreaseSpawnChances:
    ld a, [wCactusSpawnChance]
    add a, CACTUS_SPAWN_INCREMENT
    ld [wCactusSpawnChance], a
    cp a, CACTUS_MAX_SPAWN_CHANCE
    jr c, .ptero
    ld a, CACTUS_MAX_SPAWN_CHANCE
    ld [wCactusSpawnChance], a
    
.ptero:
    ld a, [wPteroSpawnChance]
    add a, PTERO_SPAWN_INCREMENT
    ld [wPteroSpawnChance], a
    cp a, PTERO_MAX_SPAWN_CHANCE
    ret c
    ld a, PTERO_MAX_SPAWN_CHANCE
    ld [wPteroSpawnChance], a

    ret


; Try to spawn an enemy
_SpawnEnemies:
    call _GetRandom
    and %00000111
    cp a, NUMBER_OF_OBJECTS
    jr c, .jump
    ld a, NUMBER_OF_OBJECTS
    
.jump:
    ld hl, .jumpTable
    jp _JumpTable

.jumpTable:
    DW _SpawnCactus1
    DW _SpawnCactus2
    DW _SpawnCactus3
    DW _SpawnCactus4
    DW _SpawnCactus5
    DW _SpawnCactus6
    DW _SpawnPtero1
    DW _SpawnPtero2
    DW _NULL

; Animates all on-screen enemy objects
_AnimateEnemies:
    ld a, [wCactus1IsSpawned]
    and a
    call nz, _AnimateCactus1
    
    ld a, [wCactus2IsSpawned]
    and a
    call nz, _AnimateCactus2
    
    ld a, [wCactus3IsSpawned]
    and a
    call nz, _AnimateCactus3
    
    ld a, [wCactus4IsSpawned]
    and a
    call nz, _AnimateCactus4
    
    ld a, [wCactus5IsSpawned]
    and a
    call nz, _AnimateCactus5
    
    ld a, [wCactus6IsSpawned]
    and a
    call nz, _AnimateCactus6
    
    ld a, [wPtero1IsSpawned]
    and a
    call nz, _AnimatePtero1

    ld a, [wPtero2IsSpawned]
    and a
    call nz, _AnimatePtero2

    ret

/*
Checks for Rex collisions with any enemy objects, ignoring Rex's tail.
Uses Rex Sprite 3, which is always in the top right,
and Rex Sprite 1, which is always in the bottom middle;
Regardless of Rex's current animation.

Returns:
- carry = collision
- no carry = no collision
*/
_CheckCollision:
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
    sub a, (OAM_X_OFS + COLLISION_PIXEL_OVERLAP_LEFT)
    ld e, a                     ; e = Rex left x

FOR SPRITE, (NUMBER_OF_REX_SPRITES + NUMBER_OF_IGNORED_PTERO_SPRITES), OAM_COUNT
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

_DrawGameOverHUD:
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

_DrawPauseHUD:
    xor a
    ld hl, _PausedString
    ld b, (_PausedString.end - _PausedString)
    ld de, vSCRN1.y0x0
    jp _VideoMemCopyFast

_PausedString:
    DB " ", $12, $13, $14, $15, $16, $17, " ", " "
.end:

_DrawGameHUD:
    xor a
    ld hl, _HighScoreTiles
    ld b, (_HighScoreTiles.end - _HighScoreTiles)
    ld de, vSCRN1.y0x0
    call _VideoMemCopyFast

    ld a, [wPreviousState]
    cp a, STATE_SECRET
    jr z, .secret

    ld hl, wHighScore0
    jr .skip

.secret:
    ld hl, wHighScore0Hard

.skip:
    xor a
    ld b, SCORE_BYTES
    ld c, $00
    ld de, vSCRN1.y0x3 + SCORE_DIGITS - 1
    call _DrawBCDNumber

    ; fallthrough

_UpdateGameHUD:
    xor a
    ld hl, wCurrentScore
    ld b, SCORE_BYTES
    ld c, "0"
    ld de, vSCRN1.y0x14 + SCORE_DIGITS - 1
    jp _DrawBCDNumber

_HighScoreTiles:
    DB $10, $11, " ", $00, $00, $00, $00, $00, $00
.end:

_UpdateScore:
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
    
    jp _IncreaseSpawnChances


/*******************************************************************************
**                                                                            **
**      VBLANK FUNCTION                                                       **
**                                                                            **
*******************************************************************************/

_VBlankHandler:
    call _ScanKeys
    call _RefreshOAM
    
    xor a
    ldh [rSCX], a
    ld a, WINDOW_ON
    call _ScreenOn

    ld a, [wGameState]
    cp a, GAME_STATE_PAUSE
    ret nc

    call _RexIncFrameCounter

    ld a, [wPtero1IsSpawned]
    and a
    call nz, _Ptero1IncFrameCounter
    
    ld a, [wPtero2IsSpawned]
    and a
    call nz, _Ptero2IncFrameCounter

    ld a, [wPaletteChangeFlag]
    and a
    jr z, .noPaletteChange

    xor a
    ld [wPaletteChangeFlag], a

    ld a, [wCurrentPalette]
    cpl
    ld [wCurrentPalette], a
    cp a, DEFAULT_BG_PALETTE
    jr nz, .invertedPalette
    call _LoadMonochromeColorPalette
    call _LoadTilemapBackgroundDay
    jr .noPaletteChange

.invertedPalette:
    call _LoadMonochromeColorPaletteInverted
    call _LoadTilemapBackgroundNight

.noPaletteChange:
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
    ld e, a
REPT PARALLAX_BIT_SHIFTS_BOTTOM
    srl c
    rr b
ENDR
    ld a, b
    ld [wBackgroundParallaxBottom], a
    sub a, e
    ld [wGroundSpeedDifferential], a
    ld d, a
    ld a, [wGroundSpawnDistanceCounter]
    add a, d
    ld [wGroundSpawnDistanceCounter], a
    
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
    add a, d
    ld [wAirSpeedDifferential], a
    ld d, a
    ld a, [wAirSpawnDistanceCounter]
    add a, d
    ld [wAirSpawnDistanceCounter], a

REPT PARALLAX_BIT_SHIFTS_TOP
    srl c
    rr b
ENDR
    ld a, b
    ld [wBackgroundParallaxTop], a

    ret

/*******************************************************************************
**                                                                            **
**      LCD STAT FUNCTION                                                     **
**                                                                            **
*******************************************************************************/

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


SECTION "Game State Variables", WRAM0

wGameDelayFrameCounter:
    DB

wGameButtonsEnabled:
    DB

wGameState:
    DB

wCurrentScore::
    DS SCORE_BYTES
    
wPaletteChangeFlag:
    DB

wBaseDifficultySpeed:
    DB
    
wBackgroundScrollPosition:
    DW

wBackgroundParallaxTop:
    DB

wBackgroundParallaxMiddle:
    DB

wBackgroundParallaxBottom:
    DB

wScoreIncreaseDifferential:
    DB

wGroundSpeedDifferential::
    DB

wAirSpeedDifferential::
    DB

wGroundSpawnDistanceCounter::
    DB

wAirSpawnDistanceCounter::
    DB

wCactusSpawnChance::
    DB

wPteroSpawnChance::
    DB

ENDSECTION
