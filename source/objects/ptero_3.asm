INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION FRAGMENT "Ptero Functions", ROM0

_InitPtero3::
    xor a
    ld [wPtero3IsSpawned], a
    ld [wPtero3AnimationFrameCounter], a

    ld hl, {PTERO_3_SPRITE_0}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_0
    ld [hl], a
    
    ld hl, {PTERO_3_SPRITE_1}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_1
    ld [hl], a
    
    ld hl, {PTERO_3_SPRITE_2}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_2_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_2
    ld [hl], a

    ret

_SpawnPtero3::
    call _GetRandom

    ld a, [wPtero3IsSpawned]
    and a
    ret nz

    ld a, [wPteroSpawnChance]
    cp a, b
    ret c
    
    ld a, [wAirSpawnDistanceCounter]
    cp a, MINIMUM_SPAWN_DISTANCE
    ret c

    call _GetRandom
    and a, %00000011
    cp a, NUMBER_OF_PTERO_3_Y_POS
    jr c, .jump
    ld a, NUMBER_OF_PTERO_3_Y_POS
    
.jump:
    ld hl, .jumpTable
    jp _JumpTable

.jumpTable:
    DW .yPos0
    DW .yPos1
    DW .yPos2
    DW .yPos3
    DW _NULL

.yPos0:
    ld b, PTERO_3_INIT_Y_POS_0 + META_SPRITE_ROW_0_Y
    
    ld hl, {PTERO_3_SPRITE_0}
    ld a, b
    ld [hl], a

    ld hl, {PTERO_3_SPRITE_1}
    ld a, b
    ld [hl], a
    
    ld hl, {PTERO_3_SPRITE_2}
    ld a, b
    ld [hl], a

    ld a, TRUE
    ld [wPtero3IsSpawned], a

    xor a
    ld [wAirSpawnDistanceCounter], a

    ret

.yPos1:
    ld b, PTERO_3_INIT_Y_POS_1 + META_SPRITE_ROW_0_Y
    
    ld hl, {PTERO_3_SPRITE_0}
    ld a, b
    ld [hl], a

    ld hl, {PTERO_3_SPRITE_1}
    ld a, b
    ld [hl], a
    
    ld hl, {PTERO_3_SPRITE_2}
    ld a, b
    ld [hl], a

    ld a, TRUE
    ld [wPtero3IsSpawned], a

    xor a
    ld [wAirSpawnDistanceCounter], a

    ret

.yPos2:
    ld a, [wGroundSpawnDistanceCounter]
    cp a, MINIMUM_SPAWN_DISTANCE
    ret c

    ld b, PTERO_3_INIT_Y_POS_2 + META_SPRITE_ROW_0_Y
    
    ld hl, {PTERO_3_SPRITE_0}
    ld a, b
    ld [hl], a

    ld hl, {PTERO_3_SPRITE_1}
    ld a, b
    ld [hl], a
    
    ld hl, {PTERO_3_SPRITE_2}
    ld a, b
    ld [hl], a

    ld a, TRUE
    ld [wPtero3IsSpawned], a

    xor a
    ld [wAirSpawnDistanceCounter], a
    ld [wGroundSpawnDistanceCounter], a

    ret

.yPos3:
    ld a, [wGroundSpawnDistanceCounter]
    cp a, MINIMUM_SPAWN_DISTANCE
    ret c

    ld b, PTERO_3_INIT_Y_POS_3 + META_SPRITE_ROW_0_Y
    
    ld hl, {PTERO_3_SPRITE_0}
    ld a, b
    ld [hl], a

    ld hl, {PTERO_3_SPRITE_1}
    ld a, b
    ld [hl], a
    
    ld hl, {PTERO_3_SPRITE_2}
    ld a, b
    ld [hl], a
    
    ld a, TRUE
    ld [wPtero3IsSpawned], a

    xor a
    ld [wAirSpawnDistanceCounter], a
    ld [wGroundSpawnDistanceCounter], a

    ret

_Ptero3IncFrameCounter::
    ld a, [wPtero3AnimationFrameCounter]
    inc a
    ld [wPtero3AnimationFrameCounter], a

    ret

_AnimatePtero3::
    ld a, [wAirSpeedDifferential]
    ld b, a

    ld hl, {PTERO_3_SPRITE_0} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {PTERO_3_SPRITE_1} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {PTERO_3_SPRITE_2} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a

    ld a, [wPtero3AnimationFrameCounter]
    and a, PTERO_FRAMES_MASK
    ld [wPtero3AnimationFrameCounter], a
    jr nz, .reset

    ld hl, {PTERO_3_SPRITE_0} + OAMA_TILEID
    ld a, [hl]
    cp a, PTERO_FRAME_1_SPRITE_0
    jr z, .frame2
    
.frame1:
    ld a, PTERO_FRAME_1_SPRITE_0
    ld [hl], a
    
    ld hl, {PTERO_3_SPRITE_1} + OAMA_TILEID
    ld a, PTERO_FRAME_1_SPRITE_1
    ld [hl], a
    
    ld hl, {PTERO_3_SPRITE_2} + OAMA_TILEID
    ld a, PTERO_FRAME_1_SPRITE_2
    ld [hl], a

    jr .reset

.frame2:
    ld a, PTERO_FRAME_2_SPRITE_0
    ld [hl], a
    
    ld hl, {PTERO_3_SPRITE_1} + OAMA_TILEID
    ld a, PTERO_FRAME_2_SPRITE_1
    ld [hl], a
    
    ld hl, {PTERO_3_SPRITE_2} + OAMA_TILEID
    ld a, PTERO_FRAME_2_SPRITE_2
    ld [hl], a

.reset:
    ld hl, {PTERO_3_SPRITE_0} + OAMA_X
    ld a, [hl]
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X + 1
    ret c
    cp a, $FF - META_SPRITE_COL_2_X - 1
    jp c, _InitPtero3

    ret

ENDSECTION


SECTION FRAGMENT "Ptero Variables", WRAM0

wPtero3AnimationFrameCounter:
    DB

ENDSECTION
