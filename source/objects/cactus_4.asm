INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION FRAGMENT "Cactus Functions", ROM0

_InitCactus4::
    xor a
    ld [wCactus4IsSpawned], a

    ld hl, {CACTUS_TYPE_4_SPRITE_0}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, CACTUS_TYPE_4_SPRITE_0_TILE
    ld [hl], a
    
    ; ld hl, {CACTUS_TYPE_4_SPRITE_1}
    ; ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ; ld [hl+], a
    ; ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_1_X
    ; ld [hl+], a
    ; ld a, CACTUS_TYPE_4_SPRITE_1_TILE
    ; ld [hl], a
    
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

_SpawnCactus4::
    call _GetRandom

    ld a, [wCactus4IsSpawned]
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
    
    ld hl, {CACTUS_TYPE_4_SPRITE_0} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF
    ld [hl], a
    
    ; ld hl, {CACTUS_TYPE_4_SPRITE_1} + OAMA_Y
    ; ld a, GROUND_LEVEL_Y_POS_OFF
    ; ld [hl], a
    
    ld hl, {CACTUS_TYPE_4_SPRITE_2} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF + META_SPRITE_ROW_2_Y
    ld [hl], a
    
    ld hl, {CACTUS_TYPE_4_SPRITE_3} + OAMA_Y
    ld a, GROUND_LEVEL_Y_POS_OFF + META_SPRITE_ROW_2_Y
    ld [hl], a

    ld a, [wCactus4IsSpawned]
    ld a, TRUE
    ld [wCactus4IsSpawned], a
    
    xor a
    ld [wGroundSpawnDistanceCounter], a

    ret

_AnimateCactus4::
    ld a, [wCactus4IsSpawned]
    and a
    ret z
    
    ld a, [wGroundSpeedDifferential]
    ld b, a

    ld hl, {CACTUS_TYPE_4_SPRITE_0} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ; ld hl, {CACTUS_TYPE_4_SPRITE_1} + OAMA_X
    ; ld a, [hl]
    ; sub a, b
    ; ld [hl], a
    
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
    ret c
    cp a, $FF - META_SPRITE_COL_1_X - 1
    jp c, _InitCactus4

    ret

ENDSECTION


SECTION FRAGMENT "Cactus Variables", WRAM0

wCactus4IsSpawned::
    DB

ENDSECTION