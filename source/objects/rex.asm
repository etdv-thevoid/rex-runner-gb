INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Rex Functions", ROM0

; Initializes Rex object
_InitRex::
    xor a
    ld [wRexAnimationFrameCounter], a
    ld [wRexAnimationState], a
    ld [wRexBlinkAnimationRandomDelay], a
    ld [wRexJumpFrameCounter], a

    ld a, TRUE
    ld [wRexInitialJumpFlag], a
    
    call _RexStand
    ; fallthrough

; Randomizes the frame delay for blinking
_RexRandomBlinkDelay:
    call _GetRandomByte
    and a, REX_BLINK_FRAMES_MASK
    rla 
    swap a
    ld [wRexBlinkAnimationRandomDelay], a
    ret

; Increments Rex's internal animation frame counter
_RexIncFrameCounter::
    ld a, [wRexAnimationFrameCounter]
    inc a
    ld [wRexAnimationFrameCounter], a
    ret

; Get Rex's current animation state
_RexGetAnimationState::
    ld a, [wRexAnimationState]
    ret


/*******************************************************************************
**                                                                            **
**      REX ACTION FUNCTIONS                                                  **
**                                                                            **
*******************************************************************************/

; Make Rex stand
_RexStand::
    ld a, REX_ANIM_STANDING
    ld [wRexAnimationState], a
    xor a
    ld [wRexAnimationFrameCounter], a

    jp _RexSetSpriteStanding

; Make Rex blink
_RexBlink::
    ld a, [wRexAnimationState]
    and a
    ret nz

    ld a, REX_ANIM_BLINKING
    ld [wRexAnimationState], a
    xor a
    ld [wRexAnimationFrameCounter], a

    jp _RexSetSpriteBlinking

; Make Rex run
_RexRun::
    ld a, [wRexAnimationState]
    cp a, REX_ANIM_SHORT_JUMPING
    ret z
    cp a, REX_ANIM_JUMPING
    ret z
    cp a, REX_ANIM_RUNNING
    ret z

    ld a, REX_ANIM_RUNNING
    ld [wRexAnimationState], a
    xor a
    ld [wRexAnimationFrameCounter], a

    jp _RexSetSpriteRunning

; Make Rex full jump
_RexFullJump::
    ld a, [wRexAnimationState]
    cp a, REX_ANIM_FAST_FALLING
    ret z
    cp a, REX_ANIM_FALLING
    ret z
    cp a, REX_ANIM_SHORT_JUMPING
    ret z
    cp a, REX_ANIM_JUMPING
    ret z
    cp a, REX_ANIM_DUCKING
    ret z

    ld a, [wRexInitialJumpFlag]
    and a
    jr nz, .initialJump

    ld a, [wRexJumpFrameCounter]
    inc a
    and a, REX_JUMP_FRAMES_MASK
    ld [wRexJumpFrameCounter], a
    ret nz

.initialJump:
    ld a, REX_ANIM_JUMPING
    ld [wRexAnimationState], a
    xor a
    ld [wRexAnimationFrameCounter], a
    ld [wRexInitialJumpFlag], a

    jp _RexSetSpriteStanding

; Make Rex short jump
_RexShortJump::
    ld a, [wRexAnimationState]
    cp a, REX_ANIM_FAST_FALLING
    ret z
    cp a, REX_ANIM_FALLING
    ret z
    cp a, REX_ANIM_SHORT_JUMPING
    ret z
    cp a, REX_ANIM_JUMPING
    ret z
    cp a, REX_ANIM_DUCKING
    ret z

    ld a, REX_ANIM_SHORT_JUMPING
    ld [wRexAnimationState], a
    xor a
    ld [wRexAnimationFrameCounter], a
    ld [wRexJumpFrameCounter], a

    jp _RexSetSpriteStanding

; Toggles Rex ducking on
_RexDuckOn::
    ld a, [wRexAnimationState]
    cp a, REX_ANIM_FAST_FALLING
    ret z
    cp a, REX_ANIM_DUCKING
    ret z

    xor a
    ld [wRexAnimationFrameCounter], a

    ld a, [wRexAnimationState]
    cp a, REX_ANIM_FALLING
    jr z, .fastFall
    cp a, REX_ANIM_SHORT_JUMPING
    jr z, .fastFall
    cp a, REX_ANIM_JUMPING
    jr z, .fastFall
    ld a, REX_ANIM_DUCKING
    ld [wRexAnimationState], a
    jp _RexSetSpriteDucking

.fastFall:
    ld a, REX_ANIM_FAST_FALLING
    ld [wRexAnimationState], a
    ret

; Toggles Rex ducking off
_RexDuckOff::
    ld a, [wRexAnimationState]
    cp a, REX_ANIM_FALLING
    ret z
    cp a, REX_ANIM_SHORT_JUMPING
    ret z
    cp a, REX_ANIM_JUMPING
    ret z
    cp a, REX_ANIM_RUNNING
    ret z

    xor a
    ld [wRexAnimationFrameCounter], a

    ld a, [wRexAnimationState]
    cp a, REX_ANIM_FAST_FALLING
    jr z, .fall
    ld a, REX_ANIM_RUNNING
    ld [wRexAnimationState], a
    jp _RexSetSpriteRunning

.fall:
    ld a, REX_ANIM_FALLING
    ld [wRexAnimationState], a
    ret

; Makes Rex dead :(
_RexDead::
    ld a, REX_ANIM_DEAD
    ld [wRexAnimationState], a
    xor a
    ld [wRexAnimationFrameCounter], a

    jp _RexSetSpriteDead


/*******************************************************************************
**                                                                            **
**      REX SPRITE FUNCTIONS                                                  **
**                                                                            **
*******************************************************************************/

; Set Sprites to standing (also jumping)
_RexSetSpriteStanding:
    ld hl, {REX_SPRITE_0} ; {REX_SPRITE_0} ; wShadowOAM.0
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_0_X
    ld [hl+], a
    ld a, REX_STANDING_SPRITE_0
    ld [hl], a

    ld hl, {REX_SPRITE_1} ; {REX_SPRITE_1} ; wShadowOAM.1
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_STANDING_SPRITE_1
    ld [hl], a

    ld hl, {REX_SPRITE_2} ; {REX_SPRITE_2} ; wShadowOAM.2
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_2_X
    ld [hl+], a
    ld a, REX_STANDING_SPRITE_2
    ld [hl], a
    
    ld hl, {REX_SPRITE_3} ; {REX_SPRITE_3} ; wShadowOAM.3
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_0_X
    ld [hl+], a
    ld a, REX_STANDING_SPRITE_3
    ld [hl], a
    
    ld hl, {REX_SPRITE_4} ; {REX_SPRITE_4} ; wShadowOAM.4
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_STANDING_SPRITE_4
    ld [hl], a

    ld hl, {REX_SPRITE_5} ; {REX_SPRITE_5} ; wShadowOAM.5
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_2_X
    ld [hl+], a
    ld a, REX_STANDING_SPRITE_5
    ld [hl], a

    ld hl, {REX_SPRITE_6} ; {REX_SPRITE_6} ; wShadowOAM.6
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_0_X
    ld [hl+], a
    ld a, REX_STANDING_SPRITE_6
    ld [hl], a
    
    ld hl, {REX_SPRITE_7} ; {REX_SPRITE_7} ; wShadowOAM.7
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_STANDING_SPRITE_7
    ld [hl], a

    ret

; Set Sprites to blinking
_RexSetSpriteBlinking:
    ld hl, {REX_SPRITE_0} ; wShadowOAM.0
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_0_X
    ld [hl+], a
    ld a, REX_STANDING_SPRITE_0
    ld [hl], a

    ld hl, {REX_SPRITE_1} ; wShadowOAM.1
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_BLINKING_SPRITE_1
    ld [hl], a

    ld hl, {REX_SPRITE_2} ; wShadowOAM.2
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_2_X
    ld [hl+], a
    ld a, REX_STANDING_SPRITE_2
    ld [hl], a
    
    ld hl, {REX_SPRITE_3} ; wShadowOAM.3
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_0_X
    ld [hl+], a
    ld a, REX_STANDING_SPRITE_3
    ld [hl], a
    
    ld hl, {REX_SPRITE_4} ; wShadowOAM.4
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_STANDING_SPRITE_4
    ld [hl], a

    ld hl, {REX_SPRITE_5} ; wShadowOAM.5
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_2_X
    ld [hl+], a
    ld a, REX_STANDING_SPRITE_5
    ld [hl], a

    ld hl, {REX_SPRITE_6} ; wShadowOAM.6
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_0_X
    ld [hl+], a
    ld a, REX_STANDING_SPRITE_6
    ld [hl], a
    
    ld hl, {REX_SPRITE_7} ; wShadowOAM.7
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_STANDING_SPRITE_7
    ld [hl], a

    ret

; Set Sprites to running
_RexSetSpriteRunning:
    ld hl, {REX_SPRITE_0} ; wShadowOAM.0
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_0_X
    ld [hl+], a
    ld a, REX_RUNNING_SPRITE_0
    ld [hl], a

    ld hl, {REX_SPRITE_1} ; wShadowOAM.1
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_RUNNING_SPRITE_1
    ld [hl], a

    ld hl, {REX_SPRITE_2} ; wShadowOAM.2
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_2_X
    ld [hl+], a
    ld a, REX_RUNNING_SPRITE_2
    ld [hl], a
    
    ld hl, {REX_SPRITE_3} ; wShadowOAM.3
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_0_X
    ld [hl+], a
    ld a, REX_RUNNING_SPRITE_3
    ld [hl], a
    
    ld hl, {REX_SPRITE_4} ; wShadowOAM.4
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_RUNNING_SPRITE_4
    ld [hl], a

    ld hl, {REX_SPRITE_5} ; wShadowOAM.5
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_2_X
    ld [hl+], a
    ld a, REX_RUNNING_SPRITE_5
    ld [hl], a

    ld hl, {REX_SPRITE_6} ; wShadowOAM.6
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_0_X
    ld [hl+], a
    ld a, REX_RUNNING_SPRITE_6
    ld [hl], a
    
    ld hl, {REX_SPRITE_7} ; wShadowOAM.7
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_RUNNING_SPRITE_7
    ld [hl], a

    ret

; Set Sprites to ducking
_RexSetSpriteDucking:
    ld hl, {REX_SPRITE_0} ; wShadowOAM.0
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_3_X
    ld [hl+], a
    ld a, REX_DUCKING_SPRITE_0
    ld [hl], a

    ld hl, {REX_SPRITE_1} ; wShadowOAM.1
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_2_X
    ld [hl+], a
    ld a, REX_DUCKING_SPRITE_1
    ld [hl], a

    ld hl, {REX_SPRITE_2} ; wShadowOAM.2
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_3_X
    ld [hl+], a
    ld a, REX_DUCKING_SPRITE_2
    ld [hl], a
    
    ld hl, {REX_SPRITE_3} ; wShadowOAM.3
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_0_X
    ld [hl+], a
    ld a, REX_DUCKING_SPRITE_3
    ld [hl], a
    
    ld hl, {REX_SPRITE_4} ; wShadowOAM.4
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_DUCKING_SPRITE_4
    ld [hl], a

    ld hl, {REX_SPRITE_5} ; wShadowOAM.5
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_2_X
    ld [hl+], a
    ld a, REX_DUCKING_SPRITE_5
    ld [hl], a

    ld hl, {REX_SPRITE_6} ; wShadowOAM.6
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_0_X
    ld [hl+], a
    ld a, REX_DUCKING_SPRITE_6
    ld [hl], a
    
    ld hl, {REX_SPRITE_7} ; wShadowOAM.7
    ld a, REX_INIT_Y_POS + REX_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + REX_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_DUCKING_SPRITE_7
    ld [hl], a

    ret

; Set Sprites to dead
_RexSetSpriteDead:
    ld hl, {REX_SPRITE_4} ; wShadowOAM.4
    ld a, [hl+]
    ld b, a     ; b = current y center
    ld a, [hl]
    ld c, a     ; c = current x center

    ld hl, {REX_SPRITE_0} ; wShadowOAM.0
    ld a, b
    add a, REX_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, c
    add a, REX_SPRITE_COL_0_X
    ld [hl+], a
    ld a, REX_DEAD_SPRITE_0
    ld [hl], a

    ld hl, {REX_SPRITE_1} ; wShadowOAM.1
    ld a, b
    add a, REX_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, c
    add a, REX_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_DEAD_SPRITE_1
    ld [hl], a

    ld hl, {REX_SPRITE_2} ; wShadowOAM.2
    ld a, b
    add a, REX_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, c
    add a, REX_SPRITE_COL_2_X
    ld [hl+], a
    ld a, REX_DEAD_SPRITE_2
    ld [hl], a
    
    ld hl, {REX_SPRITE_3} ; wShadowOAM.3
    ld a, b
    add a, REX_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, c
    add a, REX_SPRITE_COL_0_X
    ld [hl+], a
    ld a, REX_DEAD_SPRITE_3
    ld [hl], a
    
    ld hl, {REX_SPRITE_4} ; wShadowOAM.4
    ld a, b
    add a, REX_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, c
    add a, REX_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_DEAD_SPRITE_4
    ld [hl], a

    ld hl, {REX_SPRITE_5} ; wShadowOAM.5
    ld a, b
    add a, REX_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, c
    add a, REX_SPRITE_COL_2_X
    ld [hl+], a
    ld a, REX_DEAD_SPRITE_5
    ld [hl], a

    ld hl, {REX_SPRITE_6} ; wShadowOAM.6
    ld a, b
    add a, REX_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, c
    add a, REX_SPRITE_COL_0_X
    ld [hl+], a
    ld a, REX_DEAD_SPRITE_6
    ld [hl], a
    
    ld hl, {REX_SPRITE_7} ; wShadowOAM.7
    ld a, b
    add a, REX_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, c
    add a, REX_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_DEAD_SPRITE_7
    ld [hl], a

    ret
    

/*******************************************************************************
**                                                                            **
**      REX ANIMATION FUNCTIONS                                               **
**                                                                            **
*******************************************************************************/

; Call once per frame to animate Rex
_RexAnimate::
    ld hl, _RexAnimationJumpTable
    ld a, [wRexAnimationState]
    cp a, NUMBER_OF_REX_ANIMATIONS
    jr c, .jump
    ld a, NUMBER_OF_REX_ANIMATIONS
.jump:
    jp _JumpTable

_RexAnimationJumpTable:
    DW _RexAnimateStanding
    DW _RexAnimateBlinking
    DW _RexAnimateRunning
    DW _RexAnimateDucking
    DW _RexAnimateJumping
    DW _RexAnimateShortJumping
    DW _RexAnimateFalling
    DW _RexAnimateFastFalling
    DW _RexAnimateDead
    DW _NULL
    
; Animate standing Rex
_RexAnimateStanding:
    ld a, [wRexBlinkAnimationRandomDelay]
    ld b, a
    ld a, [wRexAnimationFrameCounter]
    xor a, b
    ld [wRexAnimationFrameCounter], a
    ret nz

    call _RexRandomBlinkDelay
    jp _RexBlink

; Animate blinking Rex
_RexAnimateBlinking:
    ld a, [wRexAnimationFrameCounter]
    and a, REX_BLINK_FRAMES_MASK
    ld [wRexAnimationFrameCounter], a
    ret nz

    jp _RexStand

; Animate runing Rex
_RexAnimateRunning:
    ld a, [wRexAnimationFrameCounter]
    and a, REX_RUNNING_FRAMES_MASK
    ld [wRexAnimationFrameCounter], a
    ret nz

    ld hl, {REX_SPRITE_6} + OAMA_TILEID ; wShadowOAM.6 + OAMA_TILEID
    ld a, [hl]
    cp a, REX_RUNNING_SPRITE_6
    ld a, REX_RUNNING_SPRITE_6_L
    jr z, .swapL
    ld a, REX_RUNNING_SPRITE_6
.swapL
    ld [hl], a

    ld hl, {REX_SPRITE_7} + OAMA_TILEID ; wShadowOAM.7 + OAMA_TILEID
    ld a, [hl]
    cp a, REX_RUNNING_SPRITE_7
    ld a, REX_RUNNING_SPRITE_7_R
    jr z, .swapR
    ld a, REX_RUNNING_SPRITE_7
.swapR
    ld [hl], a
    ret

; Animate ducking Rex
_RexAnimateDucking:
    ld a, [wRexAnimationFrameCounter]
    and a, REX_RUNNING_FRAMES_MASK
    ld [wRexAnimationFrameCounter], a
    ret nz

    ld hl, {REX_SPRITE_6} + OAMA_TILEID ; wShadowOAM.6 + OAMA_TILEID
    ld a, [hl]
    cp a, REX_DUCKING_SPRITE_6
    ld a, REX_DUCKING_SPRITE_6_L
    jr z, .swapL
    ld a, REX_DUCKING_SPRITE_6
.swapL
    ld [hl], a

    ld hl, {REX_SPRITE_7} + OAMA_TILEID ; wShadowOAM.7 + OAMA_TILEID
    ld a, [hl]
    cp a, REX_DUCKING_SPRITE_7
    ld a, REX_DUCKING_SPRITE_7_R
    jr z, .swapR
    ld a, REX_DUCKING_SPRITE_7
.swapR
    ld [hl], a
    ret

; Animate jumping Rex
_RexAnimateJumping:
    ld hl, {REX_SPRITE_0} ; wShadowOAM.0
    ld a, [hl]
    sub a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_1} ; wShadowOAM.1
    ld a, [hl]
    sub a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_2} ; wShadowOAM.2
    ld a, [hl]
    sub a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_3} ; wShadowOAM.3
    ld a, [hl]
    sub a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_4} ; wShadowOAM.4
    ld a, [hl]
    sub a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_5} ; wShadowOAM.5
    ld a, [hl]
    sub a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_6} ; wShadowOAM.6
    ld a, [hl]
    sub a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_7} ; wShadowOAM.7
    ld a, [hl]
    sub a, REX_JUMP_VELOCITY
    ld [hl], a

    ld hl, {REX_SPRITE_4} ; wShadowOAM.4
    ld a, [hl]
    cp a, REX_MAX_JUMP_HEIGHT
    ret nc

    ld a, REX_ANIM_FALLING
    ld [wRexAnimationState], a
    xor a
    ld [wRexAnimationFrameCounter], a
    ret

; Animate short jumping Rex
_RexAnimateShortJumping:
    ld hl, {REX_SPRITE_0} ; wShadowOAM.0
    ld a, [hl]
    sub a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_1} ; wShadowOAM.1
    ld a, [hl]
    sub a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_2} ; wShadowOAM.2
    ld a, [hl]
    sub a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_3} ; wShadowOAM.3
    ld a, [hl]
    sub a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_4} ; wShadowOAM.4
    ld a, [hl]
    sub a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_5} ; wShadowOAM.5
    ld a, [hl]
    sub a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_6} ; wShadowOAM.6
    ld a, [hl]
    sub a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_7} ; wShadowOAM.7
    ld a, [hl]
    sub a, REX_JUMP_VELOCITY
    ld [hl], a

    ld hl, {REX_SPRITE_4} ; wShadowOAM.4
    ld a, [hl]
    cp a, REX_MAX_SHORT_JUMP_HEIGHT
    ret nc

    ld a, REX_ANIM_FALLING
    ld [wRexAnimationState], a
    xor a
    ld [wRexAnimationFrameCounter], a
    ret

; Animate falling Rex
_RexAnimateFalling:
    ld hl, {REX_SPRITE_0} ; wShadowOAM.0
    ld a, [hl]
    add a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_1} ; wShadowOAM.1
    ld a, [hl]
    add a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_2} ; wShadowOAM.2
    ld a, [hl]
    add a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_3} ; wShadowOAM.3
    ld a, [hl]
    add a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_4} ; wShadowOAM.4
    ld a, [hl]
    add a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_5} ; wShadowOAM.5
    ld a, [hl]
    add a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_6} ; wShadowOAM.6
    ld a, [hl]
    add a, REX_JUMP_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_7} ; wShadowOAM.7
    ld a, [hl]
    add a, REX_JUMP_VELOCITY
    ld [hl], a

    ld hl, {REX_SPRITE_4} ; wShadowOAM.4
    ld a, [hl]
    cp a, REX_INIT_Y_POS
    ret c
    ret z

    jp _RexRun

; Animate fast falling Rex
_RexAnimateFastFalling:
    ld hl, {REX_SPRITE_0} ; wShadowOAM.0
    ld a, [hl]
    add a, REX_FAST_FALL_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_1} ; wShadowOAM.1
    ld a, [hl]
    add a, REX_FAST_FALL_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_2} ; wShadowOAM.2
    ld a, [hl]
    add a, REX_FAST_FALL_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_3} ; wShadowOAM.3
    ld a, [hl]
    add a, REX_FAST_FALL_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_4} ; wShadowOAM.4
    ld a, [hl]
    add a, REX_FAST_FALL_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_5} ; wShadowOAM.5
    ld a, [hl]
    add a, REX_FAST_FALL_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_6} ; wShadowOAM.6
    ld a, [hl]
    add a, REX_FAST_FALL_VELOCITY
    ld [hl], a
    ld hl, {REX_SPRITE_7} ; wShadowOAM.7
    ld a, [hl]
    add a, REX_FAST_FALL_VELOCITY
    ld [hl], a

    ld hl, {REX_SPRITE_4} ; wShadowOAM.4
    ld a, [hl]
    cp a, REX_INIT_Y_POS
    ret c
    ret z

    jp _RexRun

; Animate dead Rex
_RexAnimateDead:
    rst _Crash

/*******************************************************************************
**                                                                            **
**      REX COLLISION FUNCTIONS                                               **
**                                                                            **
*******************************************************************************/

; Checks for collisions with any other oam objects.
; Uses Rex sprite 2, which is always in the top right,
; and sprite 6, which is always in the bottom left.
; Regardless of Rex's current animation.
;
; b = top y
; c = right x
; d = bottom y
; e = left y
;
; Returns:
; - carry = collision
; - no carry = no collision
_RexCheckCollision::
    ld hl, {REX_SPRITE_2}
    ld a, [hl+]
    sub a, COLLISION_PIXEL_OVERLAP
    ld b, a

    ld a, [hl+]
    sub a, COLLISION_PIXEL_OVERLAP
    ld c, a

    ld hl, {REX_SPRITE_6}
    ld a, [hl+]
    add a, COLLISION_PIXEL_OVERLAP
    ld d, a
    ld a, [hl+]
    add a, COLLISION_PIXEL_OVERLAP
    ld e, a

    ld hl, {REX_SPRITE_7} + sizeof_OAM_ATTRS
REPT (OAM_COUNT - NUMBER_OF_REX_SPRITES)
    ld a, [hl+]
    cp a, b
    jr c, :+
    cp a, d
    jr nc, :+

    ld a, [hl+]
    cp a, e
    jr c, :+
    cp a, c
    jr nc, :+

    jp .collsion
:
    inc hl
    inc hl
ENDR

    scf
    ccf
    ret

.collsion:
    scf
    ret

ENDSECTION


SECTION "Rex Variables", WRAM0

; Frame counter for animating Rex
wRexAnimationFrameCounter:
    DB

; Current Rex animation state
wRexAnimationState:
    DB

; Random delay to animate Rex blinking
wRexBlinkAnimationRandomDelay:
    DB

; Input delay for making Rex long jump or short jump
wRexJumpFrameCounter:
    DB

; Flag for determining if initial jump
wRexInitialJumpFlag:
    DB

ENDSECTION
