INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION FRAGMENT "Cactus Functions", ROM0

_InitCactus3::
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

_SpawnCactus3::
    call _GetRandom

    ld a, [wCactus3IsSpawned]
    and a
    ret nz
    
    ld a, [wCactus6IsSpawned]
    and a
    ret nz

    ld a, [wCactusSpawnChance]
    cp a, b
    ret c
    
    ld a, [wGroundSpawnDistanceCounter]
    cp a, MINIMUM_SPAWN_DISTANCE
    ret c
    
    ld hl, {CACTUS_TYPE_3_SPRITE_0} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_3_SPRITE_1} + OAMA_Y
    ld a, [hl]
    ld a, GROUND_LEVEL_Y_POS
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_3_SPRITE_2} + OAMA_Y
    ld a, [hl]
    ld a, GROUND_LEVEL_Y_POS
    ld [hl], a

    ld a, [wCactus3IsSpawned]
    ld a, TRUE
    ld [wCactus3IsSpawned], a
    
    xor a
    ld [wGroundSpawnDistanceCounter], a

    ret

_AnimateCactus3::
    ld a, [wCactus3IsSpawned]
    and a
    ret z
    
    ld a, [wGroundSpeedDifferential]
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
    ret c
    cp a, $FF - META_SPRITE_COL_2_X - 1
    jp c, _InitCactus3

    ret

ENDSECTION
