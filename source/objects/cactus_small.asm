INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Cactus (Small) Functions", ROM0

; Initializes both Small Cactus
_InitCactusSmall::
    ld a, CACTUS_SMALL_1_INIT_SPAWN_CHANCE
    ld [wCactusSmall1SpawnChance], a
    
    ld a, CACTUS_SMALL_2_INIT_SPAWN_CHANCE
    ld [wCactusSmall2SpawnChance], a

    call _InitCactusSmall1
    jp _InitCactusSmall2

; Initializes Small Cactus 1
_InitCactusSmall1:
    xor a
    ld [wCactusSmall1IsSpawned], a
    ld [wCactusSmall1Type], a

.random:
    call _GetRandomByte
    and a, %00000011
    ld [wCactusSmall1Type], a
    cp a, CACTUS_SMALL_TYPE_1
    jr z, .type1
    cp a, CACTUS_SMALL_TYPE_2
    jr z, .type2

.type3:
    ld hl, {CACTUS_SMALL_1_SPRITE_2}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_2_X
    ld [hl+], a
    ld a, CACTUS_SMALL_TYPE_3_SPRITE_1
    ld [hl], a

.type2:
    ld hl, {CACTUS_SMALL_1_SPRITE_1}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, CACTUS_SMALL_TYPE_2_SPRITE_1
    ld [hl], a

.type1:
    ld hl, {CACTUS_SMALL_1_SPRITE_0}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, CACTUS_SMALL_TYPE_1_SPRITE_0
    ld [hl], a

    ret 

; Initializes Small Cactus 2
_InitCactusSmall2:
    xor a
    ld [wCactusSmall2IsSpawned], a
    ld [wCactusSmall2Type], a

.random:
    call _GetRandomByte
    and a, %00000011
    ld [wCactusSmall2Type], a
    cp a, CACTUS_SMALL_TYPE_1
    jr z, .type1
    cp a, CACTUS_SMALL_TYPE_2
    jr z, .type2

.type3:
    ld hl, {CACTUS_SMALL_2_SPRITE_2}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_2_X
    ld [hl+], a
    ld a, CACTUS_SMALL_TYPE_3_SPRITE_1
    ld [hl], a

.type2:
    ld hl, {CACTUS_SMALL_2_SPRITE_1}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, CACTUS_SMALL_TYPE_2_SPRITE_1
    ld [hl], a

.type1:
    ld hl, {CACTUS_SMALL_2_SPRITE_0}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, CACTUS_SMALL_TYPE_1_SPRITE_0
    ld [hl], a

    ret

/*******************************************************************************
**                                                                            **
**      SMALL SPAWN FUNCTIONS                                                 **
**                                                                            **
*******************************************************************************/

; Increments Small Cactus spawn chance variables
_CactusSmallIncSpawnChance::
    ld a, [wCactusSmall1SpawnChance]
    cp a, $FF
    jr z, .cactus2
    inc a
    ld [wCactusSmall1SpawnChance], a
    
.cactus2:
    ld a, [wCactusSmall2SpawnChance]
    cp a, $00
    jr z, .done
    dec a
    ld [wCactusSmall2SpawnChance], a

.done:
    ret

; Attempts to spawn Small Cactus 1
_CactusSmall1TrySpawn::
    call _GetRandom

    ld a, [wCactusSmall1IsSpawned]
    and a
    jr nz, .done

    ld a, [wCactusSmall1SpawnChance]
    cp a, b
    jr nc, .done
    cp a, c
    jr nc, .done

    ld a, [wCactusSmall1IsSpawned]
    ld a, TRUE
    ld [wCactusSmall1IsSpawned], a

    ld a, [wCactusSmall1Type]
    cp a, CACTUS_SMALL_TYPE_1
    jr z, .type1
    cp a, CACTUS_SMALL_TYPE_2
    jr z, .type2

.type3:
    ld hl, {CACTUS_SMALL_1_SPRITE_2} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl], a

.type2:
    ld hl, {CACTUS_SMALL_1_SPRITE_1} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl], a

.type1:
    ld hl, {CACTUS_SMALL_1_SPRITE_0} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl], a

.done:
    ret

; Attempts to spawn Small Cactus 2
_CactusSmall2TrySpawn::
    call _GetRandom

    ld a, [wCactusSmall2IsSpawned]
    and a
    jr nz, .done

    ld a, [wCactusSmall2SpawnChance]
    cp a, b
    jr c, .done
    cp a, c
    jr c, .done

    ld a, [wCactusSmall2IsSpawned]
    ld a, TRUE
    ld [wCactusSmall2IsSpawned], a
    
    ld a, [wCactusSmall2Type]
    cp a, CACTUS_SMALL_TYPE_1
    jr z, .type1
    cp a, CACTUS_SMALL_TYPE_2
    jr z, .type2

.type3:
    ld hl, {CACTUS_SMALL_2_SPRITE_2} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl], a

.type2:
    ld hl, {CACTUS_SMALL_2_SPRITE_1} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl], a

.type1:
    ld hl, {CACTUS_SMALL_2_SPRITE_0} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl], a

.done:
    ret

/*******************************************************************************
**                                                                            **
**      CACTUS ANIMATION FUNCTIONS                                             **
**                                                                            **
*******************************************************************************/

; Animate both CactusSmalls
_CactusSmallAnimate::
    call _GetBackgroundScrolllDifferential
    ld b, a

    ld a, [wCactusSmall1IsSpawned]
    and a
    jr z, .cactus2

    ld a, [wCactusSmall1Type]
    cp a, CACTUS_SMALL_TYPE_1
    jr z, .cactus1Type1
    cp a, CACTUS_SMALL_TYPE_2
    jr z, .cactus1Type2

.cactus1Type3:
    ld hl, {CACTUS_SMALL_1_SPRITE_2} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a

.cactus1Type2:
    ld hl, {CACTUS_SMALL_1_SPRITE_1} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a

.cactus1Type1:
    ld hl, {CACTUS_SMALL_1_SPRITE_0} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a

.cactus2:
    ld a, [wCactusSmall2IsSpawned]
    and a
    jr z, .done

    ld a, [wCactusSmall2Type]
    cp a, CACTUS_SMALL_TYPE_1
    jr z, .cactus2Type1
    cp a, CACTUS_SMALL_TYPE_2
    jr z, .cactus2Type2

.cactus2Type3:
    ld hl, {CACTUS_SMALL_2_SPRITE_2} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a

.cactus2Type2:
    ld hl, {CACTUS_SMALL_2_SPRITE_1} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a

.cactus2Type1:
    ld hl, {CACTUS_SMALL_2_SPRITE_0} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a

.done:
    ld hl, {CACTUS_SMALL_1_SPRITE_2} + OAMA_X
    ld a, [hl]
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_2_X + 1
    call nc, _InitCactusSmall1
    
    ld hl, {CACTUS_SMALL_2_SPRITE_2} + OAMA_X
    ld a, [hl]
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_2_X + 1
    call nc, _InitCactusSmall2

    ret

ENDSECTION


SECTION "Cactus (Small) Variables", WRAM0

wCactusSmall1SpawnChance:
    DB

wCactusSmall2SpawnChance:
    DB

wCactusSmall1IsSpawned:
    DB

wCactusSmall2IsSpawned:
    DB

wCactusSmall1Type:
    DB

wCactusSmall2Type:
    DB

ENDSECTION
