INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION FRAGMENT "Cactus Functions", ROM0

_InitCactus2::
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

_SpawnCactus2::
    call _GetRandom

    ld a, [wCactus2IsSpawned]
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
    
    ld hl, {CACTUS_TYPE_2_SPRITE_0} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_2_SPRITE_1} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS
    ld [hl], a

    ld a, [wCactus2IsSpawned]
    ld a, TRUE
    ld [wCactus2IsSpawned], a
    
    xor a
    ld [wGroundSpawnDistanceCounter], a

    ret

_AnimateCactus2::
    ld a, [wCactus2IsSpawned]
    and a
    ret z
    
    ld a, [wGroundSpeedDifferential]
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
    ret c
    cp a, $FF - META_SPRITE_COL_1_X - 1
    jp c, _InitCactus2

    ret

ENDSECTION
