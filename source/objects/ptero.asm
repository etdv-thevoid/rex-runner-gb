INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Ptero Functions", ROM0

; Initializes both Pteros
_InitPtero::
    ld a, PTERO_INIT_SPAWN_CHANCE
    ld [wPteroSpawnChance], a

    call _InitPtero1
    jp _InitPtero2

; Initializes Ptero 1
_InitPtero1:
    xor a
    ld [wPtero1IsSpawned], a
    ld [wPtero1AnimationFrameCounter], a

    ld hl, {PTERO_1_SPRITE_0}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_0
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_1}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_1
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_2}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_2_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_2
    ld [hl], a

    ret

; Initializes Ptero 2
_InitPtero2:
    xor a
    ld [wPtero2IsSpawned], a
    ld [wPtero2AnimationFrameCounter], a

    ld hl, {PTERO_2_SPRITE_0}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, PTERO_FRAME_2_SPRITE_0
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_1}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, PTERO_FRAME_2_SPRITE_1
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_2}
    ld a, OFFSCREEN_SPRITE_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_2_X
    ld [hl+], a
    ld a, PTERO_FRAME_2_SPRITE_2
    ld [hl], a

    ret

/*******************************************************************************
**                                                                            **
**      PTERO SPAWN FUNCTIONS                                                  **
**                                                                            **
*******************************************************************************/

; Increments Ptero spawn chance variables
_PteroIncSpawnChance::
    ld a, [wPteroSpawnChance]
    add a, PTERO_SPAWN_INCREMENT
    ld [wPteroSpawnChance], a
    cp a, PTERO_MAX_SPAWN_CHANCE
    ret c
    ld a, PTERO_MAX_SPAWN_CHANCE
    ld [wPteroSpawnChance], a
    ret

; Attempts to spawn a Ptero 
_PteroTrySpawn::
    call _GetRandom
    and a, %00000001
    jr nz, _Ptero2Spawn

    ; fallthrough

_Ptero1Spawn:
    call _GetRandom

    ld a, [wPtero1IsSpawned]
    and a
    ret nz

    ld a, [wPteroSpawnChance]
    cp a, b
    ret c
    
    call _GetAirSpawnDistanceCounter
    cp a, MINIMUM_SPAWN_DISTANCE
    ret c

    call _GetRandom
    and a, %00000001
    jr z, .yPos1

.yPos0:
    ld b, PTERO_1_INIT_Y_POS_0 + META_SPRITE_ROW_0_Y
    
    ld hl, {PTERO_1_SPRITE_0}
    ld a, b
    ld [hl], a

    ld hl, {PTERO_1_SPRITE_1}
    ld a, b
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_2}
    ld a, b
    ld [hl], a

    ld a, [wPtero1IsSpawned]
    ld a, TRUE
    ld [wPtero1IsSpawned], a

    jp _ResetAirSpawnDistanceCounter

.yPos1:
    call _GetGroundSpawnDistanceCounter
    cp a, MINIMUM_SPAWN_DISTANCE
    ret c

    ld b, PTERO_1_INIT_Y_POS_1 + META_SPRITE_ROW_0_Y
    
    ld hl, {PTERO_1_SPRITE_0}
    ld a, b
    ld [hl], a

    ld hl, {PTERO_1_SPRITE_1}
    ld a, b
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_2}
    ld a, b
    ld [hl], a
    
    ld a, [wPtero1IsSpawned]
    ld a, TRUE
    ld [wPtero1IsSpawned], a

    call _ResetAirSpawnDistanceCounter
    jp _ResetGroundSpawnDistanceCounter

_Ptero2Spawn:
    call _GetRandom

    ld a, [wPtero2IsSpawned]
    and a
    ret nz

    ld a, [wPteroSpawnChance]
    cp a, b
    ret c
    
    call _GetAirSpawnDistanceCounter
    cp a, MINIMUM_SPAWN_DISTANCE
    ret c

    call _GetRandom
    and a, %00000001
    jr z, .yPos1

.yPos0:
    ld b, PTERO_2_INIT_Y_POS_0 + META_SPRITE_ROW_0_Y
    
    ld hl, {PTERO_2_SPRITE_0}
    ld a, b
    ld [hl], a

    ld hl, {PTERO_2_SPRITE_1}
    ld a, b
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_2}
    ld a, b
    ld [hl], a

    ld a, [wPtero2IsSpawned]
    ld a, TRUE
    ld [wPtero2IsSpawned], a

    jp _ResetAirSpawnDistanceCounter

.yPos1:
    call _GetGroundSpawnDistanceCounter
    cp a, MINIMUM_SPAWN_DISTANCE
    ret c

    ld b, PTERO_2_INIT_Y_POS_1 + META_SPRITE_ROW_0_Y
    
    ld hl, {PTERO_2_SPRITE_0}
    ld a, b
    ld [hl], a

    ld hl, {PTERO_2_SPRITE_1}
    ld a, b
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_2}
    ld a, b
    ld [hl], a
    
    ld a, [wPtero2IsSpawned]
    ld a, TRUE
    ld [wPtero2IsSpawned], a

    call _ResetAirSpawnDistanceCounter
    jp _ResetGroundSpawnDistanceCounter

/*******************************************************************************
**                                                                            **
**      PTERO ANIMATION FUNCTIONS                                             **
**                                                                            **
*******************************************************************************/

; Increments both Ptero's internal animation frame counters
_PteroIncFrameCounter::
    ld a, [wPtero1IsSpawned]
    and a
    jr z, .ptero2

    ld a, [wPtero1AnimationFrameCounter]
    inc a
    ld [wPtero1AnimationFrameCounter], a

.ptero2:
    ld a, [wPtero2IsSpawned]
    and a
    jr z, .done
    
    ld a, [wPtero2AnimationFrameCounter]
    inc a
    ld [wPtero2AnimationFrameCounter], a

.done:
    ret

; Animate both Pteros
_PteroAnimate::
    ld a, [wPtero1IsSpawned]
    and a
    jr z, .ptero2

    call _GetAirSpeedDifferential
    ld b, a

    ld hl, {PTERO_1_SPRITE_0} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_1} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_2} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a

    ld a, [wPtero1AnimationFrameCounter]
    and a, PTERO_FRAMES_MASK
    ld [wPtero1AnimationFrameCounter], a
    jr nz, .ptero1Reset

    ld hl, {PTERO_1_SPRITE_0} + OAMA_TILEID
    ld a, [hl]
    cp a, PTERO_FRAME_1_SPRITE_0
    jr z, .ptero1Frame2
    
.ptero1Frame1:
    ld a, PTERO_FRAME_1_SPRITE_0
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_1} + OAMA_TILEID
    ld a, PTERO_FRAME_1_SPRITE_1
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_2} + OAMA_TILEID
    ld a, PTERO_FRAME_1_SPRITE_2
    ld [hl], a

    jr .ptero1Reset

.ptero1Frame2:
    ld a, PTERO_FRAME_2_SPRITE_0
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_1} + OAMA_TILEID
    ld a, PTERO_FRAME_2_SPRITE_1
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_2} + OAMA_TILEID
    ld a, PTERO_FRAME_2_SPRITE_2
    ld [hl], a

.ptero1Reset:
    ld hl, {PTERO_1_SPRITE_0} + OAMA_X
    ld a, [hl]
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X + 1
    jr c, .ptero2
    cp a, $FF - META_SPRITE_COL_2_X - 1
    call c, _InitPtero1

.ptero2:
    ld a, [wPtero2IsSpawned]
    and a
    jr z, .done

    call _GetAirSpeedDifferential
    ld b, a

    ld hl, {PTERO_2_SPRITE_0} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_1} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_2} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a

    ld a, [wPtero2AnimationFrameCounter]
    and a, PTERO_FRAMES_MASK
    ld [wPtero2AnimationFrameCounter], a
    jr nz, .ptero2Reset

    ld hl, {PTERO_2_SPRITE_0} + OAMA_TILEID
    ld a, [hl]
    cp a, PTERO_FRAME_1_SPRITE_0
    jr z, .ptero2Frame2
    
.ptero2Frame1:
    ld a, PTERO_FRAME_1_SPRITE_0
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_1} + OAMA_TILEID
    ld a, PTERO_FRAME_1_SPRITE_1
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_2} + OAMA_TILEID
    ld a, PTERO_FRAME_1_SPRITE_2
    ld [hl], a

    jr .ptero2Reset

.ptero2Frame2:
    ld a, PTERO_FRAME_2_SPRITE_0
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_1} + OAMA_TILEID
    ld a, PTERO_FRAME_2_SPRITE_1
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_2} + OAMA_TILEID
    ld a, PTERO_FRAME_2_SPRITE_2
    ld [hl], a

.ptero2Reset:
    ld hl, {PTERO_2_SPRITE_0} + OAMA_X
    ld a, [hl]
    cp a, OFFSCREEN_SPRITE_X_POS + META_SPRITE_COL_0_X + 1
    jr c, .done
    cp a, $FF - META_SPRITE_COL_2_X - 1
    call c, _InitPtero2

.done:
    ret

ENDSECTION


SECTION "Ptero Variables", WRAM0

wPteroSpawnChance:
    DB

wPtero1IsSpawned:
    DB

wPtero1AnimationFrameCounter:
    DB

wPtero2IsSpawned:
    DB

wPtero2AnimationFrameCounter:
    DB

ENDSECTION
