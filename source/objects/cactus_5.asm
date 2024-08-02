INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION FRAGMENT "Cactus Functions", ROM0

_InitCactus5::
    xor a
    ld [wCactus5IsSpawned], a

    ld hl, {CACTUS_TYPE_5_SPRITE_0}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, CACTUS_TYPE_5_SPRITE_0_TILE
    ld [hl], a
    
    ; ld hl, {CACTUS_TYPE_5_SPRITE_1}
    ; ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ; ld [hl+], a
    ; ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_1_X
    ; ld [hl+], a
    ; ld a, CACTUS_TYPE_5_SPRITE_1_TILE
    ; ld [hl], a
    
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

_SpawnCactus5::
    call _GetRandom

    ld a, [wCactus5IsSpawned]
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
    
    ld hl, {CACTUS_TYPE_5_SPRITE_0} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF
    ld [hl], a
    
    ; ld hl, {CACTUS_TYPE_5_SPRITE_1} + OAMA_Y
    ; ld a, GROUND_LEVEL_Y_POS_OFF
    ; ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_2} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_3} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF + META_SPRITE_ROW_2_Y
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_4} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF + META_SPRITE_ROW_2_Y
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_5_SPRITE_5} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF + META_SPRITE_ROW_2_Y
    ld [hl], a

    ld a, [wCactus5IsSpawned]
    ld a, TRUE
    ld [wCactus5IsSpawned], a
    
    xor a
    ld [wGroundSpawnDistanceCounter], a

    ret

_AnimateCactus5::
    ld a, [wCactus5IsSpawned]
    and a
    ret z
    
    ld a, [wGroundSpeedDifferential]
    ld b, a

    ld hl, {CACTUS_TYPE_5_SPRITE_0} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ; ld hl, {CACTUS_TYPE_5_SPRITE_1} + OAMA_X
    ; ld a, [hl]
    ; sub a, b
    ; ld [hl], a
    
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
    ret c
    cp a, $FF - META_SPRITE_COL_2_X - 1
    jp c, _InitCactus5

    ret

ENDSECTION


SECTION FRAGMENT "Cactus Variables", WRAM0

wCactus5IsSpawned::
    DB

ENDSECTION