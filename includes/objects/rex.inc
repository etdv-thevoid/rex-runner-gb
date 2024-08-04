/*******************************************************************************
**                                                                            **
**      REX SPRITE CONSTANTS                                                  **
**                                                                            **
*******************************************************************************/

DEF REX_INIT_X_POS              EQU 8 + OAM_X_OFS

DEF REX_BLINK_FRAMES_MASK       EQU %00001111
DEF REX_BLINK_DELAY_MASK        EQU %01111111
DEF REX_RUNNING_FRAMES_MASK     EQU %00000111
DEF REX_DUCK_DELAY_MASK         EQU %00000111

RSRESET
DEF REX_ANIM_DEAD               RB 1 ; $00
DEF REX_ANIM_STANDING           RB 1 ; $01
DEF REX_ANIM_RUNNING            RB 1 ; $02
DEF REX_ANIM_DUCKING            RB 1 ; $03
DEF REX_ANIM_JUMPING            RB 1 ; $04
DEF REX_ANIM_FALLING            RB 1 ; $05
DEF REX_ANIM_FAST_FALLING       RB 1 ; $06
DEF NUMBER_OF_REX_ANIMATIONS    RB 0 ; $07

DEF REX_SPRITE_0                EQUS "wShadowOAM.0"
DEF REX_SPRITE_1                EQUS "wShadowOAM.1"
DEF REX_SPRITE_2                EQUS "wShadowOAM.2"
DEF REX_SPRITE_3                EQUS "wShadowOAM.3"
DEF NUMBER_OF_REX_SPRITES       EQU 4

DEF FIRST_NON_REX_SPRITE        EQUS "wShadowOAM.4"

/* Default Sprite
        2   
        2   3
    0   1   3
____0___1________
*/
DEF REX_DEFAULT_SPRITE_0        EQU $00
DEF REX_DEFAULT_SPRITE_1        EQU $02
DEF REX_DEFAULT_SPRITE_2        EQU $04
DEF REX_DEFAULT_SPRITE_3        EQU $06

DEF REX_BLINKING_SPRITE_2       EQU $14

DEF REX_RUNNING_SPRITE_0        EQU $10
DEF REX_RUNNING_SPRITE_1        EQU $12

DEF REX_RUNNING_SPRITE_0_L      EQU $20
DEF REX_RUNNING_SPRITE_1_R      EQU $22

DEF REX_DEAD_SPRITE_2           EQU $24
DEF REX_DEAD_SPRITE_3           EQU $26

/* Ducking Sprite

    0   1   2   3
____0___1___2___3____
*/
DEF REX_DUCKING_SPRITE_0        EQU $08
DEF REX_DUCKING_SPRITE_1        EQU $0A
DEF REX_DUCKING_SPRITE_2        EQU $0C
DEF REX_DUCKING_SPRITE_3        EQU $0E

DEF REX_DUCKING_SPRITE_0_L      EQU $18
DEF REX_DUCKING_SPRITE_1_R      EQU $1A
