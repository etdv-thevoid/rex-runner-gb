INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION FRAGMENT "Cactus Functions", ROM0

_InitCactus6::
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

_SpawnCactus6::
    call _GetRandom

    ld a, [wGroundSpeedDifferential]
    cp a, CACTUS_TYPE_6_SPEED_MINIMUM
    ret c
    ret z

    ld a, [wCactus6IsSpawned]
    and a
    ret nz
    
    ld a, [wCactus5IsSpawned]
    and a
    ret nz
    
    ld a, [wCactus4IsSpawned]
    and a
    ret nz
    
    ld a, [wCactus3IsSpawned]
    and a
    ret nz
    
    ld a, [wCactus2IsSpawned]
    and a
    ret nz

    ld a, [wCactusSpawnChance]
    cp a, b
    ret c
    
    ld a, [wGroundSpawnDistanceCounter]
    cp a, MINIMUM_SPAWN_DISTANCE
    ret c
    
    ld hl, {CACTUS_TYPE_6_SPRITE_0} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_1} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_2} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_3} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_4} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_5} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF + META_SPRITE_ROW_2_Y
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_6} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF + META_SPRITE_ROW_2_Y
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_7} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF + META_SPRITE_ROW_2_Y
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_8} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF + META_SPRITE_ROW_2_Y
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_6_SPRITE_9} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF + META_SPRITE_ROW_2_Y
    ld [hl], a

    ld a, [wCactus6IsSpawned]
    ld a, TRUE
    ld [wCactus6IsSpawned], a
    
    xor a
    ld [wGroundSpawnDistanceCounter], a

    ret

_AnimateCactus6::
    ld a, [wCactus6IsSpawned]
    and a
    ret z
    
    ld a, [wGroundSpeedDifferential]
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
    ret c
    cp a, $FF - META_SPRITE_COL_4_X - 1
    jp c, _InitCactus6

    ret

ENDSECTION
