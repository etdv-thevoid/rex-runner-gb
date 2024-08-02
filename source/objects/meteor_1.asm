INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION FRAGMENT "Meteor Functions", ROM0

_InitMeteor1::
    xor a
    ld [wMeteor1IsSpawned], a

    ld hl, {METEOR_1_SPRITE_0}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, METEOR_SPRITE_0_TILE
    ld [hl], a
    
    ld hl, {METEOR_1_SPRITE_1}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, METEOR_SPRITE_1_TILE
    ld [hl], a
    
    ld hl, {METEOR_1_SPRITE_2}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_2_X
    ld [hl+], a
    ld a, METEOR_SPRITE_2_TILE
    ld [hl], a

    ret 

_SpawnMeteor1::
    call _GetRandom

    ld a, [wMeteor1IsSpawned]
    and a
    ret nz

    ld a, [wMeteorSpawnChance]
    cp a, b
    ret c
    
    ld a, [wAirSpawnDistanceCounter]
    cp a, MINIMUM_SPAWN_DISTANCE
    ret c

    call _GetRandom
    and a, METEOR_RANDOM_X_MASK
    ld b, a

    ld hl, {METEOR_1_SPRITE_0} + OAMA_X
    ld a, [hl]
    add a, b
    ld [hl], a

    ld hl, {METEOR_1_SPRITE_1} + OAMA_X
    ld a, [hl]
    add a, b
    ld [hl], a
    
    ld hl, {METEOR_1_SPRITE_2} + OAMA_X
    ld a, [hl]
    add a, b
    ld [hl], a

    ld a, [wMeteor1IsSpawned]
    ld a, TRUE
    ld [wMeteor1IsSpawned], a
    
    xor a
    ld [wAirSpawnDistanceCounter], a

    ret

_AnimateMeteor1::
    ld a, [wMeteor1IsSpawned]
    and a
    ret z
    
    ld a, [wGroundSpeedDifferential]
    ld b, a
    ld a, [wAirSpeedDifferential]
    ld c, a

    ld hl, {METEOR_1_SPRITE_0} + OAMA_Y
    ld a, [hl]
    add a, b
    ld [hl+], a
    ld a, [hl]
    sub a, c
    ld [hl], a
    
    ld hl, {METEOR_1_SPRITE_1} + OAMA_Y
    ld a, [hl]
    add a, b
    ld [hl+], a
    ld a, [hl]
    sub a, c
    ld [hl], a
    
    ld hl, {METEOR_1_SPRITE_2} + OAMA_Y
    ld a, [hl]
    add a, b
    ld [hl+], a
    ld a, [hl]
    sub a, c
    ld [hl], a
    
    ld hl, {METEOR_1_SPRITE_0} + OAMA_X
    ld a, [hl]
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X + METEOR_RANDOM_X_MASK + 1
    ret c
    cp a, $FF - META_SPRITE_COL_2_X - 1
    jp c, _InitMeteor1

    ret


ENDSECTION


SECTION FRAGMENT "Meteor Variables", WRAM0

wMeteor1IsSpawned::
    DB

ENDSECTION
