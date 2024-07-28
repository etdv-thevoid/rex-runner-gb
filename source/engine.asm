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
    xor a
    ldh [rSCY], a
    ldh [rSCX], a
    ldh [rWY], a
    add WX_OFS
    ldh [rWX], a

    xor a
    ld hl, vSCRN0
    ld bc, (vSCRN0.end - vSCRN0)
    ld d, $FF
    call _VideoMemSet
    
    xor a
    ld hl, vSCRN1
    ld bc, (vSCRN1.end - vSCRN1)
    ld d, $FF
    call _VideoMemSet

    xor a
    ld hl, vSCRN1.y0x0
    ld b, 20
    ld d, " "
    call _VideoMemSetFast

    xor a
    ld hl, wShadowOAM
    ld bc, (wShadowOAM.end - wShadowOAM)
    ld d, $00
    call _MemSet
    call _RefreshOAM
    
    ld hl, STARTOF("Engine Variables")
    ld bc, SIZEOF("Engine Variables")
    ld d, $00
    call _MemSet

    ld a, INITIAL_SPEED
    ld [wDifficultySpeed], a

    ld a, DEFAULT_PALETTE
    ld [wBackgroundPalette], a
    call _SetDMGPalettes

    call _InitCactus
    call _InitPtero
    call _InitMeteor
    call _InitRex
    
    ld bc, _VBlankHandler
    rst _SetVBLHandler

    ld bc, _LCDStatHandler
    rst _SetLCDHandler

    ld a, LYC_HUD_START_LINE
    ldh [rLYC], a

    ld a, STATF_LYC
    ldh [rSTAT], a

    ld a, IEF_VBLANK | IEF_LCDC
    ldh [rIE], a

    ld a, STATE_MENU
    jp _SwitchStateToNew

; Get per frame ground level scroll differential
_GetBackgroundScrolllDifferential::
    ld a, [wBackgroundScrollDifferential]
    ret

; Increment all difficulty related variables
_EngineIncrementDifficulty::
    ld a, [wDifficultySpeed]
    inc a
    ld [wDifficultySpeed], a

    call _CactusIncSpawnChance
    jp _PteroIncSpawnChance

; Increment all frame counters
_EngineIncrementFrameCounters::
    ld a, [wCurrentSpawnFrameCounter]
    inc a
    ld [wCurrentSpawnFrameCounter], a

    call _PteroIncFrameCounter
    jp _RexIncFrameCounter

; Try to spawn an enemy
_EngineTrySpawn::
    ld a, [wCurrentSpawnFrameCounter]
    and a, SPAWN_FRAME_MASK
    ld [wCurrentSpawnFrameCounter], a
    ret nz

    ld hl, _EngineSpawnJumpTable
    ld a, [wCurrentSpawnTarget]
    cp a, NUMBER_OF_OBJECTS
    jr c, .jump
    ld a, NUMBER_OF_OBJECTS
.jump:
    call _JumpTable
    ld a, [wCurrentSpawnTarget]
    inc a
    ld [wCurrentSpawnTarget], a
    cp a, NUMBER_OF_OBJECTS
    ret c
    xor a
    ld [wCurrentSpawnTarget], a
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
Uses Rex Sprite 1, which is always in the bottom middle,
and Rex Sprite 3, which is always in the top right;
Regardless of Rex's current animation.

Returns:
- carry = collision
- no carry = no collision
*/
_EngineCheckCollision::
    ld hl, {REX_SPRITE_1}
    ld a, [hl+]
    sub a, COLLISION_PIXEL_OVERLAP
    ld d, a
    ld a, [hl+]
    sub a, (OAM_X_OFS - COLLISION_PIXEL_OVERLAP)
    ld e, a

    ld hl, {REX_SPRITE_3}
    ld a, [hl+]
    sub a, (OAM_Y_OFS - COLLISION_PIXEL_OVERLAP)
    ld b, a
    ld a, [hl+]
    sub a, COLLISION_PIXEL_OVERLAP
    ld c, a

/*
- b = Rex top y
- c = Rex right x
- d = Rex bottom y
- e = Rex left x - tail
*/
FOR SPRITE, NUMBER_OF_REX_SPRITES, OAM_COUNT
    ld hl, wShadowOAM + (SPRITE * sizeof_OAM_ATTRS) + OAMA_Y
    ld a, [hl]
    sub a, COLLISION_PIXEL_OVERLAP
    cp a, b
    jr c, :+
    ld a, [hl]
    sub a, (OAM_Y_OFS - COLLISION_PIXEL_OVERLAP)
    cp a, d
    jr nc, :+

    ld hl, wShadowOAM + (SPRITE * sizeof_OAM_ATTRS) + OAMA_X
    ld a, [hl]
    sub a, COLLISION_PIXEL_OVERLAP
    cp a, c
    jr nc, :+
    ld a, [hl]
    sub a, (OAM_X_OFS - COLLISION_PIXEL_OVERLAP)
    cp a, e
    jr c, :+

    scf
    ret
:
ENDR
    scf
    ccf 
    ret


/*******************************************************************************
**                                                                            **
**      HUD & SCORE FUNCTIONS                                                 **
**                                                                            **
*******************************************************************************/

_LoadHighScore::
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

_DrawHUD::
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

_UpdateHUD::
    call _CompareScores
    jr nc, .skip

    xor a
    ld hl, wCurrentScore
    ld b, (wCurrentScore.end - wCurrentScore)
    ld c, $00
    ld de, vSCRN1.y0x3 + SCORE_DIGITS - 1
    call _DrawBCDNumber

.skip
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
    DB $10, $11, $12, $00, $00, $00, $00, $00, $00
.end:

/*
Returns:
    - zero if no change of thousands digit
    - not zero if thousands digit changed
*/
_IncrementScore:
    ld a, [wScoreFrameCounter]
    inc a
    and SCORE_INCREMENT_MASK
    ld [wScoreFrameCounter], a
    ret nz

    ld hl, wCurrentScore + 1
    ld a, [hl]
    swap a
    and a, %00001111
    ld b, a

    scf
    ccf

    ld hl, wCurrentScore
    ld a, [hl]
    add a, 1
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
    swap a
    and a, %00001111
    ld c, a
    ld a, b
    cp a, c
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
**      BACKGROUND FUNCTIONS                                                  **
**                                                                            **
*******************************************************************************/

_BackgroundIncScroll:
    ld a, [wDifficultySpeed]
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

    ld a, [wBackgroundParallaxGround]
    ld d, a
REPT PARALLAX_BIT_SHIFTS_INITIAL
    srl c
    rr b
ENDR
    ld a, b
    ld [wBackgroundParallaxGround], a
    sub a, d
    ld [wBackgroundScrollDifferential], a
    
REPT PARALLAX_BIT_SHIFTS_PER_SECTION
    srl c
    rr b
ENDR
    ld a, b
    ld [wBackgroundParallaxBottom], a
  
REPT PARALLAX_BIT_SHIFTS_PER_SECTION
    srl c
    rr b
ENDR
    ld a, b
    ld [wBackgroundParallaxMiddle], a

REPT PARALLAX_BIT_SHIFTS_PER_SECTION
    srl c
    rr b
ENDR
    ld a, b
    ld [wBackgroundParallaxTop], a

    ret

_BackgroundInvertPalette::
    ld a, [wBackgroundPalette]
    cpl
    ld [wBackgroundPalette], a
    call _SetDMGPalettes
    cpl
    cp a, DEFAULT_PALETTE
    jp z, _LoadTilemapBackground
    jp _LoadTilemapBackgroundNight


/*******************************************************************************
**                                                                            **
**      INTERRUPT FUNCTIONS                                                   **
**                                                                            **
*******************************************************************************/

_VBlankHandler:
    call _ScanKeys
    call _RefreshOAM

    call _GetStateCurrent
    cp a, STATE_PAUSE
    ret z
    cp a, STATE_DEAD
    ret z

    call _EngineIncrementFrameCounters

    call _GetStateCurrent
    cp a, STATE_GAME
    ret nz

    call _BackgroundIncScroll

    call _IncrementScore
    ret nc

    call _EngineIncrementDifficulty

    jp _BackgroundInvertPalette

_LCDStatHandler:
    ldh a, [rLYC]
    cp a, LYC_PARALLAX_TOP_START_LINE
    jr z, .top
    cp a, LYC_PARALLAX_MIDDLE_START_LINE
    jr z, .middle
    cp a, LYC_PARALLAX_BOTTOM_START_LINE
    jr z, .bottom
    cp a, LYC_PARALLAX_GROUND_START_LINE
    jr z, .ground

.default:
    ld a, LYC_PARALLAX_TOP_START_LINE
    ldh [rLYC], a
    xor a
    ldh [rSCX], a
    ld a, WINDOW_ON
    jp _ScreenOn

.top:
    ld a, LYC_PARALLAX_MIDDLE_START_LINE
    ldh [rLYC], a
    ld a, [wBackgroundParallaxTop]
    ldh [rSCX], a
    ld a, WINDOW_OFF
    jp _ScreenOn

.middle:
    ld a, LYC_PARALLAX_BOTTOM_START_LINE
    ldh [rLYC], a
    ld a, [wBackgroundParallaxMiddle]
    ldh [rSCX], a
    ret

.bottom:
    ld a, LYC_PARALLAX_GROUND_START_LINE
    ldh [rLYC], a
    ld a, [wBackgroundParallaxBottom]
    ldh [rSCX], a
    ret

.ground:
    ld a, LYC_HUD_START_LINE
    ldh [rLYC], a
    ld a, [wBackgroundParallaxGround]
    ldh [rSCX], a
    ret

ENDSECTION



SECTION "Engine Variables", WRAM0

wBackgroundPalette:
    DB

wBackgroundScrollPosition:
    DW

wBackgroundScrollDifferential:
    DB

wBackgroundParallaxTop:
    DB

wBackgroundParallaxMiddle:
    DB

wBackgroundParallaxBottom:
    DB

wBackgroundParallaxGround:
    DB

wDifficultySpeed:
    DB

wDifficultyDistance:
    DB

wCurrentSpawnFrameCounter:
    DB

wCurrentSpawnTarget:
    DB

wScoreFrameCounter:
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
