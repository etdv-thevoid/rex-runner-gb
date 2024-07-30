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
    ld [wRexInputDelayFrameCounter], a
    ld [wRexJumpAccel], a
    ld [wRexJumpSpeed], a
    ld [wRexJumpSpeedFrameDifferential], a
    ld [wRexJumpVelocity], a
    ld [wRexJumpVelocity+1], a

    ld a, TRUE
    ld [wRexInitialJumpFlag], a
    
    call _RexStand
    ; fallthrough

; Randomizes the frame delay for blinking
_RexRandomBlinkDelay:
    call _GetRandom
    or a, REX_BLINK_DELAY_MASK
    ld [wRexBlinkAnimationRandomDelay], a
    ret

; Increments Rex's internal animation frame counter
_RexIncFrameCounter::
    ld a, [wRexAnimationFrameCounter]
    inc a
    ld [wRexAnimationFrameCounter], a

    ld a, [wRexAnimationState]
    cp a, REX_ANIM_JUMPING
    ret c

    cp a, REX_ANIM_FAST_FALLING
    ld d, GRAVITY_VALUE
    jr nz, .notFastFalling
    ld d, GRAVITY_VALUE_FAST

.notFastFalling:
    ld a, [wRexJumpAccel]
    bit 7, a
    jr z, .notFalling

    ld a, [wRexJumpAccel]
    sub a, d
    ld [wRexJumpAccel], a
    
    cp a, TERMINAL_VELOCITY
    jr nc, .complementAccel

    ld a, TERMINAL_VELOCITY
    ld [wRexJumpAccel], a
    jr .complementAccel

.notFalling:
    ld a, [wRexJumpAccel]
    sub a, d
    ld [wRexJumpAccel], a
    bit 7, a
    jr z, .calculateSpeed

.complementAccel:
    cpl

.calculateSpeed:
    ld e, a
    ld hl, wRexJumpVelocity
    ld a, [hl]
    add a, e
    ld [hl+], a
    ld a, [hl]
    adc a, 0
    ld [hl], a

    scf
    ccf

    ld a, [wRexJumpVelocity]
    ld b, a
    ld a, [wRexJumpVelocity+1]
    ld c, a

    ld a, [wRexJumpSpeed]
    ld d, a
REPT 4
    srl c
    rr b
ENDR
    ld a, b
    ld [wRexJumpSpeed], a
    sub a, d
    ld [wRexJumpSpeedFrameDifferential], a

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
    xor a
    ld [wRexAnimationFrameCounter], a
    ld [wRexJumpAccel], a
    ld [wRexJumpSpeed], a
    ld [wRexJumpSpeedFrameDifferential], a
    ld [wRexJumpVelocity], a
    ld [wRexJumpVelocity+1], a

    ld a, REX_ANIM_STANDING
    ld [wRexAnimationState], a

    jp _RexSetSpriteDefault

; Make Rex run
_RexRun::
    ld a, [wRexAnimationState]
    cp a, REX_ANIM_RUNNING
    ret z

    xor a
    ld [wRexAnimationFrameCounter], a
    ld [wRexJumpAccel], a
    ld [wRexJumpSpeed], a
    ld [wRexJumpSpeedFrameDifferential], a
    ld [wRexJumpVelocity], a
    ld [wRexJumpVelocity+1], a

    ld a, REX_ANIM_RUNNING
    ld [wRexAnimationState], a

    jp _RexSetSpriteRunning

; Make Rex jump
_RexJump::
    ld a, [wRexAnimationState]
    cp a, REX_ANIM_DUCKING
    ret nc
    
    xor a
    ld [wRexAnimationFrameCounter], a
    ld [wRexJumpAccel], a
    ld [wRexJumpSpeed], a
    ld [wRexJumpSpeedFrameDifferential], a
    ld [wRexJumpVelocity], a
    ld [wRexJumpVelocity+1], a

    ld a, [wRexInitialJumpFlag]
    and a
    ld a, MAX_JUMP_ACCEL
    ;jr nz, .initialJump

    ; ld a, [wRexInputDelayFrameCounter]
    ; inc a
    ; and a, REX_JUMP_FRAMES_MASK
    ; ld [wRexInputDelayFrameCounter], a
    ; ld a, MAX_JUMP_ACCEL
    ; ret nz

.initialJump:
    ld [wRexJumpAccel], a

    ld a, REX_ANIM_JUMPING
    ld [wRexAnimationState], a

    jp _RexSetSpriteDefault

; Toggles Rex ducking on
_RexDuckOn::
    ld a, [wRexAnimationState]
    cp a, REX_ANIM_RUNNING
    jr z, .running
    cp a, REX_ANIM_JUMPING
    jr z, .jumping
    ret 

.running:
    xor a
    ld [wRexAnimationFrameCounter], a
    ld [wRexJumpAccel], a
    ld [wRexJumpSpeed], a
    ld [wRexJumpSpeedFrameDifferential], a
    ld [wRexJumpVelocity], a
    ld [wRexJumpVelocity+1], a
    
    ld a, REX_ANIM_DUCKING
    ld [wRexAnimationState], a
    
    jp _RexSetSpriteDucking

.jumping:
    ld a, REX_ANIM_FAST_FALLING
    ld [wRexAnimationState], a

    ret

; Toggles Rex ducking off
_RexDuckOff::
    ld a, [wRexAnimationState]
    cp a, REX_ANIM_DUCKING
    ret nz

    xor a
    ld [wRexAnimationFrameCounter], a
    ld [wRexJumpAccel], a
    ld [wRexJumpSpeed], a
    ld [wRexJumpSpeedFrameDifferential], a
    ld [wRexJumpVelocity], a
    ld [wRexJumpVelocity+1], a

    ld a, REX_ANIM_RUNNING
    ld [wRexAnimationState], a

    jp _RexSetSpriteRunning

; Makes Rex dead :(
_RexDead::
    xor a
    ld [wRexAnimationFrameCounter], a
    ld [wRexJumpAccel], a
    ld [wRexJumpSpeed], a
    ld [wRexJumpSpeedFrameDifferential], a
    ld [wRexJumpVelocity], a
    ld [wRexJumpVelocity+1], a
    
    ld a, REX_ANIM_DEAD
    ld [wRexAnimationState], a

    jp _RexSetSpriteDead


/*******************************************************************************
**                                                                            **
**      REX SPRITE FUNCTIONS                                                  **
**                                                                            **
*******************************************************************************/

; Set Sprites to standing (also jumping)
_RexSetSpriteDefault:
    ld hl, {REX_SPRITE_0} ; wShadowOAM.0
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, REX_DEFAULT_SPRITE_0
    ld [hl], a

    ld hl, {REX_SPRITE_1} ; wShadowOAM.1
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_DEFAULT_SPRITE_1
    ld [hl], a

    ld hl, {REX_SPRITE_2} ; wShadowOAM.2
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_DEFAULT_SPRITE_2
    ld [hl], a
    
    ld hl, {REX_SPRITE_3} ; wShadowOAM.3
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + META_SPRITE_COL_2_X
    ld [hl+], a
    ld a, REX_DEFAULT_SPRITE_3
    ld [hl], a

    ret

; Set Sprites to running
_RexSetSpriteRunning:
    ld hl, {REX_SPRITE_0} ; wShadowOAM.0
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, REX_RUNNING_SPRITE_0
    ld [hl], a

    ld hl, {REX_SPRITE_1} ; wShadowOAM.1
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_RUNNING_SPRITE_1
    ld [hl], a

    ld hl, {REX_SPRITE_2} ; wShadowOAM.2
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_DEFAULT_SPRITE_2
    ld [hl], a
    
    ld hl, {REX_SPRITE_3} ; wShadowOAM.3
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + META_SPRITE_COL_2_X
    ld [hl+], a
    ld a, REX_DEFAULT_SPRITE_3
    ld [hl], a

    ret

; Set Sprites to ducking
_RexSetSpriteDucking:
    ld hl, {REX_SPRITE_0} ; wShadowOAM.0
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + META_SPRITE_COL_0_X
    ld [hl+], a
    ld a, REX_DUCKING_SPRITE_0
    ld [hl], a

    ld hl, {REX_SPRITE_1} ; wShadowOAM.1
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_DUCKING_SPRITE_1
    ld [hl], a

    ld hl, {REX_SPRITE_2} ; wShadowOAM.2
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + META_SPRITE_COL_2_X
    ld [hl+], a
    ld a, REX_DUCKING_SPRITE_2
    ld [hl], a
    
    ld hl, {REX_SPRITE_3} ; wShadowOAM.3
    ld a, GROUND_LEVEL_Y_POS + META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, REX_INIT_X_POS + META_SPRITE_COL_3_X
    ld [hl+], a
    ld a, REX_DUCKING_SPRITE_3
    ld [hl], a
    
    ret

; Set Sprites to dead
_RexSetSpriteDead:
    ld hl, {REX_SPRITE_0} ; wShadowOAM.0
    ld a, [hl+]
    ld b, a     ; b = current y base
    ld a, [hl+]
    ld c, a     ; c = current x base
    ld a, REX_DEFAULT_SPRITE_0
    ld [hl], a

    ld hl, {REX_SPRITE_1} ; wShadowOAM.1
    ld a, b
    add a, META_SPRITE_ROW_0_Y
    ld [hl+], a
    ld a, c
    add a, META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_DEFAULT_SPRITE_1
    ld [hl], a

    ld hl, {REX_SPRITE_2} ; wShadowOAM.2
    ld a, b
    add a, META_SPRITE_ROW_2_Y
    ld [hl+], a
    ld a, c
    add a, META_SPRITE_COL_1_X
    ld [hl+], a
    ld a, REX_DEAD_SPRITE_2
    ld [hl], a
    
    ld hl, {REX_SPRITE_3} ; wShadowOAM.3
    ld a, b
    add a, META_SPRITE_ROW_1_Y
    ld [hl+], a
    ld a, c
    add a, META_SPRITE_COL_2_X
    ld [hl+], a
    ld a, REX_DEAD_SPRITE_3
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
    DW _RexAnimateRunning
    DW _RexAnimateDucking
    DW _RexAnimateJumping
    DW _RexAnimateJumping
    DW _RexAnimateDead
    DW _NULL
    
; Animate standing Rex
_RexAnimateStanding:
    ld hl, {REX_SPRITE_2} + OAMA_TILEID
    ld a, [hl]
    cp a, REX_BLINKING_SPRITE_2
    jr z, .blinking

    ld a, [wRexBlinkAnimationRandomDelay]
    ld b, a
    ld a, [wRexAnimationFrameCounter]
    and a, b
    ld [wRexAnimationFrameCounter], a
    ret nz

    ld a, REX_BLINKING_SPRITE_2
    ld [hl], a

    ret

.blinking:
    ld a, [wRexAnimationFrameCounter]
    and a, REX_BLINK_FRAMES_MASK
    ld [wRexAnimationFrameCounter], a
    ret nz

    ld a, REX_DEFAULT_SPRITE_2
    ld [hl], a

    jp _RexRandomBlinkDelay

; Animate runing Rex
_RexAnimateRunning:
    ld a, [wRexAnimationFrameCounter]
    and a, REX_RUNNING_FRAMES_MASK
    ld [wRexAnimationFrameCounter], a
    ret nz

    ld hl, {REX_SPRITE_0} + OAMA_TILEID
    ld a, [hl]
    cp a, REX_RUNNING_SPRITE_0
    ld a, REX_RUNNING_SPRITE_0_L
    jr z, .swapL
    ld a, REX_RUNNING_SPRITE_0
.swapL
    ld [hl], a

    ld hl, {REX_SPRITE_1} + OAMA_TILEID
    ld a, [hl]
    cp a, REX_RUNNING_SPRITE_1
    ld a, REX_RUNNING_SPRITE_1_R
    jr z, .swapR
    ld a, REX_RUNNING_SPRITE_1
.swapR
    ld [hl], a

    ret

; Animate ducking Rex
_RexAnimateDucking:
    ld a, [wRexAnimationFrameCounter]
    and a, REX_RUNNING_FRAMES_MASK
    ld [wRexAnimationFrameCounter], a
    ret nz

    ld hl, {REX_SPRITE_0} + OAMA_TILEID
    ld a, [hl]
    cp a, REX_DUCKING_SPRITE_0
    ld a, REX_DUCKING_SPRITE_0_L
    jr z, .swapL
    ld a, REX_DUCKING_SPRITE_0
.swapL
    ld [hl], a

    ld hl, {REX_SPRITE_1} + OAMA_TILEID
    ld a, [hl]
    cp a, REX_DUCKING_SPRITE_1
    ld a, REX_DUCKING_SPRITE_1_R
    jr z, .swapR
    ld a, REX_DUCKING_SPRITE_1
.swapR
    ld [hl], a

    ret

; Animate jumping Rex
_RexAnimateJumping:
    ld a, [wRexJumpSpeedFrameDifferential]
    ld b, a

    ld a, [wRexJumpAccel]
    bit 7, a
    jr nz, .falling

    ld hl, {REX_SPRITE_0} ; wShadowOAM.0
    ld a, [hl]
    sub a, b
    ld [hl], a
    ld hl, {REX_SPRITE_1} ; wShadowOAM.1
    ld a, [hl]
    sub a, b
    ld [hl], a
    ld hl, {REX_SPRITE_2} ; wShadowOAM.2
    ld a, [hl]
    sub a, b
    ld [hl], a
    ld hl, {REX_SPRITE_3} ; wShadowOAM.3
    ld a, [hl]
    sub a, b
    ld [hl], a

    ret

.falling:
    ld hl, {REX_SPRITE_0} ; wShadowOAM.0
    ld a, [hl]
    add a, b
    ld [hl], a
    ld hl, {REX_SPRITE_1} ; wShadowOAM.1
    ld a, [hl]
    add a, b
    ld [hl], a
    ld hl, {REX_SPRITE_2} ; wShadowOAM.2
    ld a, [hl]
    add a, b
    ld [hl], a
    ld hl, {REX_SPRITE_3} ; wShadowOAM.3
    ld a, [hl]
    add a, b
    ld [hl], a

    ld hl, {REX_SPRITE_0} ; wShadowOAM.0
    ld a, [hl]
    cp a, GROUND_LEVEL_Y_POS
    ret c

    jp _RexRun

; Animate dead Rex
_RexAnimateDead:
    rst _Crash

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
wRexInputDelayFrameCounter:
    DB

; Flag for determining if initial jump
wRexInitialJumpFlag:
    DB
; Floating point position
wRexJumpVelocity:
    DW
; Jump Accel (increases with input time and decreases with gravity)
wRexJumpAccel:
    DB

wRexJumpSpeed:
    DB

wRexJumpSpeedFrameDifferential:
    DB

ENDSECTION
