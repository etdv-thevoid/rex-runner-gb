INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Cactus Functions", ROM0

; Initializes all Cactus
_InitCactus::
    ld a, CACTUS_TYPE_1_INIT_SPAWN_CHANCE
    ld [wCactus1SpawnChance], a
    
    ld a, CACTUS_TYPE_2_INIT_SPAWN_CHANCE
    ld [wCactus2SpawnChance], a
    
    ld a, CACTUS_TYPE_3_INIT_SPAWN_CHANCE
    ld [wCactus3SpawnChance], a
    
    ld a, CACTUS_TYPE_4_INIT_SPAWN_CHANCE
    ld [wCactus4SpawnChance], a
    
    ld a, CACTUS_TYPE_5_INIT_SPAWN_CHANCE
    ld [wCactus5SpawnChance], a
    
    ld a, CACTUS_TYPE_6_INIT_SPAWN_CHANCE
    ld [wCactus6SpawnChance], a

    call _InitCactus6
    call _InitCactus5
    call _InitCactus4
    call _InitCactus3
    call _InitCactus2
    ; fallthrough

; Initializes Cactus 1
_InitCactus1:
    xor a
    ld [wCactus1IsSpawned], a

    ld hl, {CACTUS_TYPE_1_SPRITE_0}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, CACTUS_TYPE_1_SPRITE_0_TILE
    ld [hl], a

    ret

; Initializes Cactus 2
_InitCactus2:
    xor a
    ld [wCactus2IsSpawned], a

    ld hl, {CACTUS_TYPE_2_SPRITE_0}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, CACTUS_TYPE_2_SPRITE_0_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_2_SPRITE_1}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, CACTUS_TYPE_2_SPRITE_1_TILE
    ld [hl], a

    ret 

; Initializes Cactus 3
_InitCactus3:
    xor a
    ld [wCactus3IsSpawned], a

    ld hl, {CACTUS_TYPE_3_SPRITE_0}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, CACTUS_TYPE_3_SPRITE_0_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_3_SPRITE_1}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, CACTUS_TYPE_3_SPRITE_1_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_3_SPRITE_2}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_2_X
    ld [hl+], a
    ld a, CACTUS_TYPE_3_SPRITE_2_TILE
    ld [hl], a

    ret 

; Initializes Cactus 4
_InitCactus4:
    xor a
    ld [wCactus4IsSpawned], a

    ld hl, {CACTUS_TYPE_4_SPRITE_0}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, CACTUS_TYPE_4_SPRITE_0_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_4_SPRITE_1}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, CACTUS_TYPE_4_SPRITE_1_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_4_SPRITE_2}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, CACTUS_TYPE_4_SPRITE_2_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_4_SPRITE_3}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, CACTUS_TYPE_4_SPRITE_3_TILE
    ld [hl], a

    ret 

; Initializes Cactus 5
_InitCactus5:
    xor a
    ld [wCactus5IsSpawned], a

    ld hl, {CACTUS_TYPE_5_SPRITE_0}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, CACTUS_TYPE_5_SPRITE_0_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_1}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, CACTUS_TYPE_5_SPRITE_1_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_2}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_2_X
    ld [hl+], a
    ld a, CACTUS_TYPE_5_SPRITE_2_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_3}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, CACTUS_TYPE_5_SPRITE_3_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_4}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, CACTUS_TYPE_5_SPRITE_4_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_5}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_2_X
    ld [hl+], a
    ld a, CACTUS_TYPE_5_SPRITE_5_TILE
    ld [hl], a

    ret 

; Initializes Cactus 6
_InitCactus6:
    xor a
    ld [wCactus6IsSpawned], a

    ld hl, {CACTUS_TYPE_6_SPRITE_0}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, CACTUS_TYPE_6_SPRITE_0_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_1}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, CACTUS_TYPE_6_SPRITE_1_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_2}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_2_X
    ld [hl+], a
    ld a, CACTUS_TYPE_6_SPRITE_2_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_3}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_3_X
    ld [hl+], a
    ld a, CACTUS_TYPE_6_SPRITE_3_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_4}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_4_X
    ld [hl+], a
    ld a, CACTUS_TYPE_6_SPRITE_4_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_5}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, CACTUS_TYPE_6_SPRITE_5_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_6}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, CACTUS_TYPE_6_SPRITE_6_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_7}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_2_X
    ld [hl+], a
    ld a, CACTUS_TYPE_6_SPRITE_7_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_8}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_3_X
    ld [hl+], a
    ld a, CACTUS_TYPE_6_SPRITE_8_TILE
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_9}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_4_X
    ld [hl+], a
    ld a, CACTUS_TYPE_6_SPRITE_9_TILE
    ld [hl], a

    ret 



/*******************************************************************************
**                                                                            **
**      CACTUS SPAWN FUNCTIONS                                                **
**                                                                            **
*******************************************************************************/

; Increments Cactus spawn chance variables
_CactusIncSpawnChance::
    ld a, [wCactus1SpawnChance]
    add a, SPAWN_CHANCE_INCREMENT
    ld [wCactus1SpawnChance], a
    jr nc, .cactus2
    ld a, $FF
    ld [wCactus1SpawnChance], a
    
.cactus2:
    ld a, [wCactus2SpawnChance]
    add a, SPAWN_CHANCE_INCREMENT
    ld [wCactus2SpawnChance], a
    jr nc, .cactus3
    ld a, $FF
    ld [wCactus2SpawnChance], a
    
.cactus3:
    ld a, [wCactus3SpawnChance]
    add a, SPAWN_CHANCE_INCREMENT
    ld [wCactus3SpawnChance], a
    jr nc, .cactus4
    ld a, $FF
    ld [wCactus3SpawnChance], a
    
.cactus4:
    ld a, [wCactus4SpawnChance]
    add a, SPAWN_CHANCE_INCREMENT
    ld [wCactus4SpawnChance], a
    jr nc, .cactus5
    ld a, $FF
    ld [wCactus4SpawnChance], a
    
.cactus5:
    ld a, [wCactus5SpawnChance]
    add a, SPAWN_CHANCE_INCREMENT
    ld [wCactus1SpawnChance], a
    jr nc, .cactus6
    ld a, $FF
    ld [wCactus5SpawnChance], a
    
.cactus6:
    ld a, [wCactus6SpawnChance]
    add a, SPAWN_CHANCE_INCREMENT
    ld [wCactus6SpawnChance], a
    jr nc, .done
    ld a, $FF
    ld [wCactus6SpawnChance], a

.done:
    ret

; Attempts to spawn a Cactus
_CactusTrySpawn::
    call _GetRandom
    and %00000111
    cp a, NUMBER_OF_CACTUS_TYPES
    jr c, .jump
    ld a, DEFAULT_CACTUS_TYPE
.jump:
    ld hl, _CactusSpawnJumpTable
    jp _JumpTable

_CactusSpawnJumpTable:
    DW _CactusType1Spawn
    DW _CactusType2Spawn
    DW _CactusType3Spawn
    DW _CactusType4Spawn
    DW _CactusType5Spawn
    DW _CactusType6Spawn
    DW _NULL

_CactusType1Spawn:
    call _GetRandom

    ld a, [wCactus1IsSpawned]
    and a
    ret nz

    ld a, [wCactus1SpawnChance]
    cp a, b
    ret nc
    cp a, c
    ret nc

    ld a, [wCactus1IsSpawned]
    ld a, TRUE
    ld [wCactus1IsSpawned], a
    
    ld hl, {CACTUS_TYPE_1_SPRITE_0} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS)
    ld [hl], a

    ret

_CactusType2Spawn:
    call _GetRandom

    ld a, [wCactus2IsSpawned]
    and a
    jp nz, _CactusType1Spawn

    ld a, [wCactus2SpawnChance]
    cp a, b
    jp nc, _CactusType1Spawn
    cp a, c
    jp nc, _CactusType1Spawn

    ld a, [wCactus2IsSpawned]
    ld a, TRUE
    ld [wCactus2IsSpawned], a
    
    ld hl, {CACTUS_TYPE_2_SPRITE_0} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_2_SPRITE_1} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS)
    ld [hl], a

    ret

_CactusType3Spawn:
    call _GetRandom

    ld a, [wCactus3IsSpawned]
    and a
    jp nz, _CactusType2Spawn

    ld a, [wCactus3SpawnChance]
    cp a, b
    jp nc, _CactusType2Spawn
    cp a, c
    jp nc, _CactusType2Spawn

    ld a, [wCactus3IsSpawned]
    ld a, TRUE
    ld [wCactus3IsSpawned], a
    
    ld hl, {CACTUS_TYPE_3_SPRITE_0} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_3_SPRITE_1} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_3_SPRITE_2} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS)
    ld [hl], a

    ret

_CactusType4Spawn:
    call _GetRandom

    ld a, [wCactus4IsSpawned]
    and a
    jp nz, _CactusType3Spawn

    ld a, [wCactus4SpawnChance]
    cp a, b
    jp nc, _CactusType3Spawn
    cp a, c
    jp nc, _CactusType3Spawn

    ld a, [wCactus4IsSpawned]
    ld a, TRUE
    ld [wCactus4IsSpawned], a
    
    ld hl, {CACTUS_TYPE_4_SPRITE_0} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_4_SPRITE_1} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_4_SPRITE_2} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_4_SPRITE_3} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a

    ret

_CactusType5Spawn:
    call _GetRandom

    ld a, [wCactus5IsSpawned]
    and a
    jp nz, _CactusType4Spawn

    ld a, [wCactus5SpawnChance]
    cp a, b
    jp nc, _CactusType4Spawn
    cp a, c
    jp nc, _CactusType4Spawn

    ld a, [wCactus5IsSpawned]
    ld a, TRUE
    ld [wCactus5IsSpawned], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_0} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_1} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_2} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_3} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_4} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_5} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a

    ret

_CactusType6Spawn:
    call _GetRandom

    ld a, [wCactus6IsSpawned]
    and a
    jp nz, _CactusType5Spawn

    ld a, [wCactus6SpawnChance]
    cp a, b
    jp nc, _CactusType5Spawn
    cp a, c
    jp nc, _CactusType5Spawn

    ld a, [wCactus6IsSpawned]
    ld a, TRUE
    ld [wCactus6IsSpawned], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_0} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_1} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_2} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_3} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_4} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_5} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_6} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_7} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_8} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_9} + OAMA_Y
    ld a, [hl]
    sub a, (OFFSCREEN_SPRITE_Y_POS - GROUND_LEVEL_Y_POS_OFF)
    ld [hl], a

    ret

/*******************************************************************************
**                                                                            **
**      CACTUS ANIMATION FUNCTIONS                                             **
**                                                                            **
*******************************************************************************/

; Animate all Cactus
_CactusAnimate::
    ld a, [wCactus1IsSpawned]
    and a
    jr z, .cactus2
    
    call _GetGroundSpeedDifferential
    ld b, a

    ld hl, {CACTUS_TYPE_1_SPRITE_0} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_1_SPRITE_0} + OAMA_X
    ld a, [hl]
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X + 1
    jr c, .cactus2
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_4_X + 1
    call c, _InitCactus1

.cactus2:
    ld a, [wCactus2IsSpawned]
    and a
    jr z, .cactus3
    
    call _GetGroundSpeedDifferential
    ld b, a

    ld hl, {CACTUS_TYPE_2_SPRITE_0} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_2_SPRITE_1} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_2_SPRITE_0} + OAMA_X
    ld a, [hl]
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X + 1
    jr c, .cactus3
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_4_X + 1
    call c, _InitCactus2

.cactus3:
    ld a, [wCactus3IsSpawned]
    and a
    jr z, .cactus4
    
    call _GetGroundSpeedDifferential
    ld b, a

    ld hl, {CACTUS_TYPE_3_SPRITE_0} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_3_SPRITE_1} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_3_SPRITE_2} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_3_SPRITE_0} + OAMA_X
    ld a, [hl]
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X + 1
    jr c, .cactus4
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_4_X + 1
    call c, _InitCactus3

.cactus4:
    ld a, [wCactus4IsSpawned]
    and a
    jr z, .cactus5
    
    call _GetGroundSpeedDifferential
    ld b, a

    ld hl, {CACTUS_TYPE_4_SPRITE_0} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_4_SPRITE_1} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_4_SPRITE_2} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_4_SPRITE_3} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_4_SPRITE_0} + OAMA_X
    ld a, [hl]
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X + 1
    jr c, .cactus5
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_4_X + 1
    call c, _InitCactus4

.cactus5:
    ld a, [wCactus5IsSpawned]
    and a
    jr z, .cactus6
    
    call _GetGroundSpeedDifferential
    ld b, a

    ld hl, {CACTUS_TYPE_5_SPRITE_0} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_1} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_2} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_3} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_4} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_5} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_0} + OAMA_X
    ld a, [hl]
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X + 1
    jr c, .cactus6
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_4_X + 1
    call c, _InitCactus5

.cactus6:
    ld a, [wCactus6IsSpawned]
    and a
    jr z, .done
    
    call _GetGroundSpeedDifferential
    ld b, a

    ld hl, {CACTUS_TYPE_6_SPRITE_0} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_1} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_2} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_3} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_4} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_5} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_6} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_7} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_8} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_9} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_0} + OAMA_X
    ld a, [hl]
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X + 1
    jr c, .done
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_4_X + 1
    call c, _InitCactus6

.done:
    ret

ENDSECTION


SECTION "Cactus Variables", WRAM0

wCactus1SpawnChance:
    DB

wCactus1IsSpawned:
    DB

wCactus2SpawnChance:
    DB

wCactus2IsSpawned:
    DB

wCactus3SpawnChance:
    DB

wCactus3IsSpawned:
    DB
    
wCactus4SpawnChance:
    DB

wCactus4IsSpawned:
    DB

wCactus5SpawnChance:
    DB

wCactus5IsSpawned:
    DB

wCactus6SpawnChance:
    DB

wCactus6IsSpawned:
    DB

ENDSECTION
