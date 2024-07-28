INCLUDE "libraries/hardware.inc/hardware.inc"
    rev_Check_hardware_inc 4.9.1

DEF FALSE   EQU 0
DEF TRUE    EQU 1

/*******************************************************************************
**                                                                            **
**      MAIN CONSTANTS                                                        **
**                                                                            **
*******************************************************************************/

RSRESET
DEF STATE_INIT          RB 1 ; $00
DEF STATE_MENU          RB 1 ; $01
DEF STATE_CREDITS       RB 1 ; $02
DEF STATE_GAME          RB 1 ; $03
DEF STATE_PAUSE         RB 1 ; $04
DEF STATE_DEAD          RB 1 ; $05

DEF NUMBER_OF_STATES    RB 0 ; $06


/*******************************************************************************
**                                                                            **
**      MAIN CONSTANTS                                                        **
**                                                                            **
*******************************************************************************/

DEF MENU_OPT_START_TILE EQUS "vSCRN0.y8x5"

RSRESET
DEF MENU_OPT_START      RB 1 ; $00
DEF MENU_OPT_CREDITS    RB 1 ; $01

DEF NUMBER_OF_MENU_OPTS RB 0 ; $02


/*******************************************************************************
**                                                                            **
**      ENGINE CONSTANTS                                                      **
**                                                                            **
*******************************************************************************/

DEF INITIAL_DIFFICULTY_SPEED    EQU 10

DEF COLLISION_PIXEL_OVERLAP     EQU 3

DEF SCORE_BYTES                 EQU 3
DEF SCORE_DIGITS                EQU SCORE_BYTES * 2
DEF SCORE_INCREMENT_MASK        EQU %00000011

DEF SPAWN_FRAME_MASK            EQU %01111111

DEF SPAWN_CHANCE_INCREMENT      EQU $10

DEF PTERO_1_INIT_SPAWN_CHANCE   EQU $40
DEF PTERO_2_INIT_SPAWN_CHANCE   EQU PTERO_1_INIT_SPAWN_CHANCE

DEF CACTUS_TYPE_1_INIT_SPAWN_CHANCE EQU $80
DEF CACTUS_TYPE_2_INIT_SPAWN_CHANCE EQU CACTUS_TYPE_1_INIT_SPAWN_CHANCE - SPAWN_CHANCE_INCREMENT
DEF CACTUS_TYPE_3_INIT_SPAWN_CHANCE EQU CACTUS_TYPE_2_INIT_SPAWN_CHANCE
DEF CACTUS_TYPE_4_INIT_SPAWN_CHANCE EQU CACTUS_TYPE_3_INIT_SPAWN_CHANCE - SPAWN_CHANCE_INCREMENT
DEF CACTUS_TYPE_5_INIT_SPAWN_CHANCE EQU CACTUS_TYPE_4_INIT_SPAWN_CHANCE
DEF CACTUS_TYPE_6_INIT_SPAWN_CHANCE EQU CACTUS_TYPE_5_INIT_SPAWN_CHANCE - SPAWN_CHANCE_INCREMENT

RSRESET
DEF OBJECT_CACTUS   RB 1 ; $00
DEF OBJECT_PTERO    RB 1 ; $01
;DEF OBJECT_METEOR   RB 1 ; $02

DEF NUMBER_OF_OBJECTS   RB 0 ; $03

/*******************************************************************************
**                                                                            **
**      BACKGROUND & WINDOW CONSTANTS                                         **
**                                                                            **
*******************************************************************************/

DEF PARALLAX_BIT_SHIFTS_INITIAL     EQU 3
DEF PARALLAX_BIT_SHIFTS_PER_SECTION EQU 2

DEF LYC_HUD_START_LINE              EQU 0
DEF LYC_PARALLAX_TOP_START_LINE     EQU 7
DEF LYC_PARALLAX_MIDDLE_START_LINE  EQU 39
DEF LYC_PARALLAX_BOTTOM_START_LINE  EQU 71
DEF LYC_PARALLAX_GROUND_START_LINE  EQU 103

DEF WINDOW_ON   EQU LCDCF_ON | LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_BLK21 | LCDCF_BG9800 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON
DEF WINDOW_OFF  EQU LCDCF_ON | LCDCF_WIN9C00 | LCDCF_WINOFF | LCDCF_BLK21 | LCDCF_BG9800 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON

DEF DEFAULT_PALETTE  EQU %11100100


/*******************************************************************************
**                                                                            **
**      SPRITE POSITION CONSTANTS                                             **
**                                                                            **
*******************************************************************************/

DEF OFFSCREEN_SPRITE_Y_POS  EQU SCRN_Y + (OAM_Y_OFS * 2)
DEF OFFSCREEN_SPRITE_X_POS  EQU SCRN_X + (OAM_X_OFS * 2)

DEF META_SPRITE_ROW_0_Y     EQU 0
DEF META_SPRITE_ROW_1_Y     EQU -8
DEF META_SPRITE_ROW_2_Y     EQU -16

DEF META_SPRITE_COL_0_X     EQU 0
DEF META_SPRITE_COL_1_X     EQU 8
DEF META_SPRITE_COL_2_X     EQU 16
DEF META_SPRITE_COL_3_X     EQU 24
DEF META_SPRITE_COL_4_X     EQU 32

DEF GROUND_LEVEL_Y_POS      EQU 120 + OAM_Y_OFS
DEF GROUND_LEVEL_Y_POS_OFF  EQU 128 + OAM_Y_OFS

DEF REX_INIT_X_POS          EQU 8 + OAM_X_OFS

DEF REX_JUMP_HEIGHT         EQU 54 + OAM_Y_OFS
DEF REX_SHORT_JUMP_HEIGHT   EQU 90 + OAM_Y_OFS

DEF PTERO_1_INIT_Y_POS_0    EQU 54 + OAM_Y_OFS
DEF PTERO_1_INIT_Y_POS_1    EQU 86 + OAM_Y_OFS
DEF PTERO_2_INIT_Y_POS_0    EQU 70 + OAM_Y_OFS
DEF PTERO_2_INIT_Y_POS_1    EQU 102 + OAM_Y_OFS

/*******************************************************************************
**                                                                            **
**      REX ANIMATION CONSTANTS                                               **
**                                                                            **
*******************************************************************************/

DEF REX_JUMP_VELOCITY           EQU 2
DEF REX_FAST_FALL_VELOCITY      EQU 3

DEF REX_BLINK_FRAMES_MASK       EQU %00000111
DEF REX_RUNNING_FRAMES_MASK     EQU %00000111
DEF REX_JUMP_FRAMES_MASK        EQU %00000011

RSRESET
DEF REX_ANIM_STANDING           RB 1 ; $00
DEF REX_ANIM_BLINKING           RB 1 ; $01
DEF REX_ANIM_RUNNING            RB 1 ; $02
DEF REX_ANIM_DUCKING            RB 1 ; $03
DEF REX_ANIM_JUMPING            RB 1 ; $04
DEF REX_ANIM_SHORT_JUMPING      RB 1 ; $05
DEF REX_ANIM_FALLING            RB 1 ; $06
DEF REX_ANIM_FAST_FALLING       RB 1 ; $07
DEF REX_ANIM_DEAD               RB 1 ; $08

DEF NUMBER_OF_REX_ANIMATIONS    RB 0 ; $09


/*******************************************************************************
**                                                                            **
**      REX SPRITE CONSTANTS                                                  **
**                                                                            **
*******************************************************************************/

DEF NUMBER_OF_REX_SPRITES   EQU 4

DEF REX_SPRITE_0            EQUS "wShadowOAM.0"
DEF REX_SPRITE_1            EQUS "wShadowOAM.1"
DEF REX_SPRITE_2            EQUS "wShadowOAM.2"
DEF REX_SPRITE_3            EQUS "wShadowOAM.3"

/* Default Sprite
        2   
        2   3
    0   1   3
____0___1________
*/
DEF REX_DEFAULT_SPRITE_0    EQU $00
DEF REX_DEFAULT_SPRITE_1    EQU $02
DEF REX_DEFAULT_SPRITE_2    EQU $04
DEF REX_DEFAULT_SPRITE_3    EQU $06

DEF REX_BLINKING_SPRITE_2   EQU $14

DEF REX_RUNNING_SPRITE_0    EQU $10
DEF REX_RUNNING_SPRITE_1    EQU $12

DEF REX_RUNNING_SPRITE_0_L  EQU $20
DEF REX_RUNNING_SPRITE_1_R  EQU $22

DEF REX_DEAD_SPRITE_2       EQU $24
DEF REX_DEAD_SPRITE_3       EQU $26

/* Ducking Sprite

    0   1   2   3
____0___1___2___3____
*/
DEF REX_DUCKING_SPRITE_0    EQU $08
DEF REX_DUCKING_SPRITE_1    EQU $0A
DEF REX_DUCKING_SPRITE_2    EQU $0C
DEF REX_DUCKING_SPRITE_3    EQU $0E

DEF REX_DUCKING_SPRITE_0_L  EQU $18
DEF REX_DUCKING_SPRITE_1_R  EQU $1A


/*******************************************************************************
**                                                                            **
**      PTERO ANIMATION CONSTANTS                                             **
**                                                                            **
*******************************************************************************/

DEF PTERO_FRAMES_MASK           EQU %00000111


/*******************************************************************************
**                                                                            **
**      PTERO SPRITE CONSTANTS                                                **
**                                                                            **
*******************************************************************************/

DEF PTERO_1_SPRITE_0            EQUS "wShadowOAM.4"
DEF PTERO_1_SPRITE_1            EQUS "wShadowOAM.5"
DEF PTERO_1_SPRITE_2            EQUS "wShadowOAM.6"

DEF PTERO_2_SPRITE_0            EQUS "wShadowOAM.7"
DEF PTERO_2_SPRITE_1            EQUS "wShadowOAM.8"
DEF PTERO_2_SPRITE_2            EQUS "wShadowOAM.9"

/* Frame 1
    0   1   2
    0   1   2
*/
DEF PTERO_FRAME_1_SPRITE_0   EQU $64
DEF PTERO_FRAME_1_SPRITE_1   EQU $66
DEF PTERO_FRAME_1_SPRITE_2   EQU $68

/* Frame 2
    0   1   2
    0   1   2
*/
DEF PTERO_FRAME_2_SPRITE_0    EQU $6A
DEF PTERO_FRAME_2_SPRITE_1    EQU $6C
DEF PTERO_FRAME_2_SPRITE_2    EQU $6E


/*******************************************************************************
**                                                                            **
**      CACTUS TYPE CONSTANTS                                                 **
**                                                                            **
*******************************************************************************/

RSRESET
DEF CACTUS_TYPE_1           RB 1 ; $00
DEF CACTUS_TYPE_2           RB 1 ; $01
DEF CACTUS_TYPE_3           RB 1 ; $02
DEF CACTUS_TYPE_4           RB 1 ; $03
DEF CACTUS_TYPE_5           RB 1 ; $04
DEF CACTUS_TYPE_6           RB 1 ; $05

DEF NUMBER_OF_CACTUS_TYPES  RB 0 ; $06

DEF DEFAULT_CACTUS_TYPE     EQU CACTUS_TYPE_2

/*******************************************************************************
**                                                                            **
**      CACTUS SPRITE CONSTANTS                                               **
**                                                                            **
*******************************************************************************/

DEF CACTUS_TYPE_1_SPRITE_0   EQUS "wShadowOAM.10"

DEF CACTUS_TYPE_2_SPRITE_0   EQUS "wShadowOAM.11"
DEF CACTUS_TYPE_2_SPRITE_1   EQUS "wShadowOAM.12"

DEF CACTUS_TYPE_3_SPRITE_0   EQUS "wShadowOAM.13"
DEF CACTUS_TYPE_3_SPRITE_1   EQUS "wShadowOAM.14"
DEF CACTUS_TYPE_3_SPRITE_2   EQUS "wShadowOAM.15"

DEF CACTUS_TYPE_4_SPRITE_0   EQUS "wShadowOAM.16"
DEF CACTUS_TYPE_4_SPRITE_1   EQUS "wShadowOAM.17"
DEF CACTUS_TYPE_4_SPRITE_2   EQUS "wShadowOAM.18"
DEF CACTUS_TYPE_4_SPRITE_3   EQUS "wShadowOAM.19"

DEF CACTUS_TYPE_5_SPRITE_0   EQUS "wShadowOAM.20"
DEF CACTUS_TYPE_5_SPRITE_1   EQUS "wShadowOAM.21"
DEF CACTUS_TYPE_5_SPRITE_2   EQUS "wShadowOAM.22"
DEF CACTUS_TYPE_5_SPRITE_3   EQUS "wShadowOAM.23"
DEF CACTUS_TYPE_5_SPRITE_4   EQUS "wShadowOAM.24"
DEF CACTUS_TYPE_5_SPRITE_5   EQUS "wShadowOAM.25"

DEF CACTUS_TYPE_6_SPRITE_0   EQUS "wShadowOAM.26"
DEF CACTUS_TYPE_6_SPRITE_1   EQUS "wShadowOAM.27"
DEF CACTUS_TYPE_6_SPRITE_2   EQUS "wShadowOAM.28"
DEF CACTUS_TYPE_6_SPRITE_3   EQUS "wShadowOAM.29"
DEF CACTUS_TYPE_6_SPRITE_4   EQUS "wShadowOAM.30"
DEF CACTUS_TYPE_6_SPRITE_5   EQUS "wShadowOAM.31"
DEF CACTUS_TYPE_6_SPRITE_6   EQUS "wShadowOAM.32"
DEF CACTUS_TYPE_6_SPRITE_7   EQUS "wShadowOAM.33"
DEF CACTUS_TYPE_6_SPRITE_8   EQUS "wShadowOAM.34"
DEF CACTUS_TYPE_6_SPRITE_9   EQUS "wShadowOAM.35"

/* Version 1
    0
____0____
*/
DEF CACTUS_TYPE_1_SPRITE_0_TILE     EQU $30

/* Version 2
    0   1
____0___1____
*/
DEF CACTUS_TYPE_2_SPRITE_0_TILE     EQU $32
DEF CACTUS_TYPE_2_SPRITE_1_TILE     EQU $34

/* Version 3
    0   1   2
____0___1___2____
*/
DEF CACTUS_TYPE_3_SPRITE_0_TILE     EQU $36
DEF CACTUS_TYPE_3_SPRITE_1_TILE     EQU $38
DEF CACTUS_TYPE_3_SPRITE_2_TILE     EQU $3A

/* Version 4
    2   3
    2   3
____0___1____
    0   1
*/
DEF CACTUS_TYPE_4_SPRITE_0_TILE     EQU $3E
DEF CACTUS_TYPE_4_SPRITE_1_TILE     EQU $42
DEF CACTUS_TYPE_4_SPRITE_2_TILE     EQU $3C
DEF CACTUS_TYPE_4_SPRITE_3_TILE     EQU $40

/* Version 5
    3   4   5
    3   4   5
____0___1___2____
    0   1   2
*/
DEF CACTUS_TYPE_5_SPRITE_0_TILE     EQU $46
DEF CACTUS_TYPE_5_SPRITE_1_TILE     EQU $4A
DEF CACTUS_TYPE_5_SPRITE_2_TILE     EQU $4E
DEF CACTUS_TYPE_5_SPRITE_3_TILE     EQU $44
DEF CACTUS_TYPE_5_SPRITE_4_TILE     EQU $48
DEF CACTUS_TYPE_5_SPRITE_5_TILE     EQU $4C


/* Version 6
    5   6   7   8   9
    5   6   7   8   9
____0___1___2___3___4____
    0   1   2   3   4
*/
DEF CACTUS_TYPE_6_SPRITE_0_TILE     EQU $52
DEF CACTUS_TYPE_6_SPRITE_1_TILE     EQU $56
DEF CACTUS_TYPE_6_SPRITE_2_TILE     EQU $5A
DEF CACTUS_TYPE_6_SPRITE_3_TILE     EQU $5E
DEF CACTUS_TYPE_6_SPRITE_4_TILE     EQU $62
DEF CACTUS_TYPE_6_SPRITE_5_TILE     EQU $50
DEF CACTUS_TYPE_6_SPRITE_6_TILE     EQU $54
DEF CACTUS_TYPE_6_SPRITE_7_TILE     EQU $58
DEF CACTUS_TYPE_6_SPRITE_8_TILE     EQU $5C
DEF CACTUS_TYPE_6_SPRITE_9_TILE     EQU $60
