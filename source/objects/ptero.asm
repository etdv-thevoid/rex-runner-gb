INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Ptero Functions", ROM0

; Initializes Ptero 1
_InitPtero1::
    xor a
    ld [wPtero1IsSpawned], a
    ld [wPtero1AnimationFrameCounter], a

    ld hl, {PTERO_1_SPRITE_0}
    ld a, PTERO_INIT_Y_POS_1 + PTERO_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, PTERO_INIT_X_POS + PTERO_SPRITE_COL_0_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_0
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_1}
    ld a, PTERO_INIT_Y_POS_1 + PTERO_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, PTERO_INIT_X_POS + PTERO_SPRITE_COL_1_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_1
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_2}
    ld a, PTERO_INIT_Y_POS_1 + PTERO_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, PTERO_INIT_X_POS + PTERO_SPRITE_COL_2_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_2
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_3}
    ld a, PTERO_INIT_Y_POS_1 + PTERO_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, PTERO_INIT_X_POS + PTERO_SPRITE_COL_0_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_3
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_4}
    ld a, PTERO_INIT_Y_POS_1 + PTERO_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, PTERO_INIT_X_POS + PTERO_SPRITE_COL_1_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_4
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_5}
    ld a, PTERO_INIT_Y_POS_1 + PTERO_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, PTERO_INIT_X_POS + PTERO_SPRITE_COL_2_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_5
    ld [hl], a

    ret

; Initializes Ptero 2
_InitPtero2::
    xor a
    ld [wPtero2IsSpawned], a
    ld [wPtero2AnimationFrameCounter], a

    ld hl, {PTERO_2_SPRITE_0}
    ld a, PTERO_INIT_Y_POS_2 + PTERO_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, PTERO_INIT_X_POS + PTERO_SPRITE_COL_0_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_0
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_1}
    ld a, PTERO_INIT_Y_POS_2 + PTERO_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, PTERO_INIT_X_POS + PTERO_SPRITE_COL_1_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_1
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_2}
    ld a, PTERO_INIT_Y_POS_2 + PTERO_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, PTERO_INIT_X_POS + PTERO_SPRITE_COL_2_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_2
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_3}
    ld a, PTERO_INIT_Y_POS_2 + PTERO_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, PTERO_INIT_X_POS + PTERO_SPRITE_COL_0_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_3
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_4}
    ld a, PTERO_INIT_Y_POS_2 + PTERO_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, PTERO_INIT_X_POS + PTERO_SPRITE_COL_1_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_4
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_5}
    ld a, PTERO_INIT_Y_POS_2 + PTERO_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, PTERO_INIT_X_POS + PTERO_SPRITE_COL_2_X
    ld [hl+], a
    ld a, PTERO_FRAME_1_SPRITE_5
    ld [hl], a

    ret

/*******************************************************************************
**                                                                            **
**      PTERO FRAME COUNTER FUNCTION                                          **
**                                                                            **
*******************************************************************************/

; Increments both Ptero's internal animation frame counters
_PteroTrySpawn::
    call _GetRandomByte
    ld b, a

    ld a, [wPtero1IsSpawned]
    and a
    jr nz, .ptero2

    ld a, b
    and a, PTERO_1_SPAWN_MASK
    jr nz, .ptero2

    ld a, [wPtero1IsSpawned]
    ld a, TRUE
    ld [wPtero1IsSpawned], a

.ptero2:
    ld a, [wPtero2IsSpawned]
    and a
    jr nz, .done

    ld a, b
    and a, PTERO_2_SPAWN_MASK
    jr nz, .done

    ld a, [wPtero2IsSpawned]
    ld a, TRUE
    ld [wPtero2IsSpawned], a

.done:
    ret

/*******************************************************************************
**                                                                            **
**      PTERO FRAME COUNTER FUNCTION                                          **
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

/*******************************************************************************
**                                                                            **
**      PTERO ANIMATION FUNCTIONS                                             **
**                                                                            **
*******************************************************************************/

; Animate both Pteros
_PteroAnimate::
    call _GetDifficultySpeed

REPT PARALLAX_BIT_SHIFTS_INITIAL
    srl a
ENDR
    ld b, a

    ld a, [wPtero1IsSpawned]
    and a
    jr z, .ptero2

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
    
    ld hl, {PTERO_1_SPRITE_3} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_4} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_5} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a

    ld a, [wPtero1AnimationFrameCounter]
    and a, PTERO_FRAMES_MASK
    ld [wPtero1AnimationFrameCounter], a
    jr nz, .ptero2

    ld hl, {PTERO_1_SPRITE_0} + OAMA_TILEID
    ld a, [hl]
    cp a, PTERO_FRAME_1_SPRITE_0
    jr z, .loadPtero1Frame2
    
    ld a, PTERO_FRAME_1_SPRITE_0
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_1} + OAMA_TILEID
    ld a, PTERO_FRAME_1_SPRITE_1
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_2} + OAMA_TILEID
    ld a, PTERO_FRAME_1_SPRITE_2
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_3} + OAMA_TILEID
    ld a, PTERO_FRAME_1_SPRITE_3
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_4} + OAMA_TILEID
    ld a, PTERO_FRAME_1_SPRITE_4
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_5} + OAMA_TILEID
    ld a, PTERO_FRAME_1_SPRITE_5
    ld [hl], a

    jr .ptero2

.loadPtero1Frame2:
    ld a, PTERO_FRAME_2_SPRITE_0
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_1} + OAMA_TILEID
    ld a, PTERO_FRAME_2_SPRITE_1
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_2} + OAMA_TILEID
    ld a, PTERO_FRAME_2_SPRITE_2
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_3} + OAMA_TILEID
    ld a, PTERO_FRAME_2_SPRITE_3
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_4} + OAMA_TILEID
    ld a, PTERO_FRAME_2_SPRITE_4
    ld [hl], a
    
    ld hl, {PTERO_1_SPRITE_5} + OAMA_TILEID
    ld a, PTERO_FRAME_2_SPRITE_5
    ld [hl], a

.ptero2:
    ld a, [wPtero2IsSpawned]
    and a
    jr z, .done

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
    
    ld hl, {PTERO_2_SPRITE_3} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_4} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_5} + OAMA_X
    ld a, [hl]
    sub a, b
    ld [hl], a

    ld a, [wPtero2AnimationFrameCounter]
    and a, PTERO_FRAMES_MASK
    ld [wPtero2AnimationFrameCounter], a
    jr nz, .done

    ld hl, {PTERO_2_SPRITE_0} + OAMA_TILEID
    ld a, [hl]
    cp a, PTERO_FRAME_1_SPRITE_0
    jr z, .loadPtero2Frame2
    
    ld a, PTERO_FRAME_1_SPRITE_0
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_1} + OAMA_TILEID
    ld a, PTERO_FRAME_1_SPRITE_1
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_2} + OAMA_TILEID
    ld a, PTERO_FRAME_1_SPRITE_2
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_3} + OAMA_TILEID
    ld a, PTERO_FRAME_1_SPRITE_3
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_4} + OAMA_TILEID
    ld a, PTERO_FRAME_1_SPRITE_4
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_5} + OAMA_TILEID
    ld a, PTERO_FRAME_1_SPRITE_5
    ld [hl], a

    jr .done

.loadPtero2Frame2:
    ld a, PTERO_FRAME_2_SPRITE_0
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_1} + OAMA_TILEID
    ld a, PTERO_FRAME_2_SPRITE_1
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_2} + OAMA_TILEID
    ld a, PTERO_FRAME_2_SPRITE_2
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_3} + OAMA_TILEID
    ld a, PTERO_FRAME_2_SPRITE_3
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_4} + OAMA_TILEID
    ld a, PTERO_FRAME_2_SPRITE_4
    ld [hl], a
    
    ld hl, {PTERO_2_SPRITE_5} + OAMA_TILEID
    ld a, PTERO_FRAME_2_SPRITE_5
    ld [hl], a

.done:
    ret

ENDSECTION


SECTION "Ptero Variables", WRAM0

wPtero1IsSpawned:
    DB

wPtero2IsSpawned:
    DB

wPtero1AnimationFrameCounter:
    DB

wPtero2AnimationFrameCounter:
    DB

ENDSECTION
