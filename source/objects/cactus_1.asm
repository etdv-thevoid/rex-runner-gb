INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION FRAGMENT "Cactus Functions", ROM0

_InitCactus1::
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

_SpawnCactus1::
    call _GetRandom

    ld a, [wCactus1IsSpawned]
    and a
    ret nz

    ld a, [wCactusSpawnChance]
    cp a, b
    ret c
    
    ld a, [wGroundSpawnDistanceCounter]
    cp a, MINIMUM_SPAWN_DISTANCE
    ret c
    
    ld hl, {CACTUS_TYPE_1_SPRITE_0} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS
    ld [hl], a

    ld a, [wCactus1IsSpawned]
    ld a, TRUE
    ld [wCactus1IsSpawned], a

    xor a
    ld [wGroundSpawnDistanceCounter], a

    ret

_AnimateCactus1::
    ld a, [wCactus1IsSpawned]
    and a
    ret z
    
    ld a, [wGroundSpeedDifferential]
    ld b, a

    ld hl, {CACTUS_TYPE_1_SPRITE_0} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_1_SPRITE_0} + OAMA_X
    ld a, [hl]
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X + 1
    ret c
    cp a, $FF - META_SPRITE_COL_0_X - 1
    jp c, _InitCactus1

    ret

ENDSECTION
