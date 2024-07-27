INCLUDE "libraries/hardware.inc/hardware.inc"
    rev_Check_hardware_inc 4.9.1

DEF FALSE   EQU 0
DEF TRUE    EQU 1

/*******************************************************************************
**                                                                            **
**      GAME CONSTANTS                                                        **
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

RSRESET
DEF MENU_OPT_START      RB 1 ; $00
DEF MENU_OPT_CREDITS    RB 1 ; $01
DEF NUMBER_OF_MENU_OPTS RB 0 ; $02

DEF MENU_OPT_START_TILE EQUS "vSCRN0.y8x5"

DEF INITIAL_SPEED           EQU 10

DEF COLLISION_PIXEL_OVERLAP EQU 2

DEF SCORE_BYTES             EQU 3
DEF SCORE_DIGITS            EQU SCORE_BYTES * 2
DEF SCORE_INCREMENT_MASK    EQU %00000001

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
**      REX CONSTANTS                                                         **
**                                                                            **
*******************************************************************************/

DEF REX_INIT_Y_POS          EQU 120 + OAM_Y_OFS
DEF REX_INIT_X_POS          EQU 8 + OAM_X_OFS

DEF REX_MAX_JUMP_HEIGHT         EQU 54 + OAM_Y_OFS
DEF REX_MAX_SHORT_JUMP_HEIGHT   EQU 90 + OAM_Y_OFS

DEF REX_JUMP_VELOCITY           EQU 3
DEF REX_FAST_FALL_VELOCITY      EQU 6


/*******************************************************************************
**                                                                            **
**      REX ANIMATION CONSTANTS                                               **
**                                                                            **
*******************************************************************************/

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

DEF REX_BLINK_FRAMES_MASK       EQU %00000111
DEF REX_RUNNING_FRAMES_MASK     EQU %00000111
DEF REX_JUMP_FRAMES_MASK        EQU %00000011


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

DEF REX_SPRITE_ROW_0_Y      EQU 0
DEF REX_SPRITE_ROW_1_Y      EQU -8
DEF REX_SPRITE_ROW_2_Y      EQU -16

DEF REX_SPRITE_COL_0_X      EQU 0
DEF REX_SPRITE_COL_1_X      EQU 8
DEF REX_SPRITE_COL_2_X      EQU 16
DEF REX_SPRITE_COL_3_X      EQU 24

/* Default Sprite
        2   
        2   3
    0   1   3
    0   1
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
    0   1   2   3
*/
DEF REX_DUCKING_SPRITE_0    EQU $08
DEF REX_DUCKING_SPRITE_1    EQU $0A
DEF REX_DUCKING_SPRITE_2    EQU $0C
DEF REX_DUCKING_SPRITE_3    EQU $0E

DEF REX_DUCKING_SPRITE_0_L  EQU $18
DEF REX_DUCKING_SPRITE_1_R  EQU $1A


/*******************************************************************************
**                                                                            **
**      PTERO CONSTANTS                                                       **
**                                                                            **
*******************************************************************************/

DEF PTERO_1_INIT_Y_POS_0    EQU 54 + OAM_Y_OFS
DEF PTERO_1_INIT_Y_POS_1    EQU 86 + OAM_Y_OFS
DEF PTERO_2_INIT_Y_POS_0    EQU 70 + OAM_Y_OFS
DEF PTERO_2_INIT_Y_POS_1    EQU 102 + OAM_Y_OFS

DEF PTERO_INIT_X_POS        EQU 160 + OAM_X_OFS

DEF PTERO_1_INIT_SPAWN_CHANCE EQU 10
DEF PTERO_2_INIT_SPAWN_CHANCE EQU $FF - PTERO_1_INIT_SPAWN_CHANCE


/*******************************************************************************
**                                                                            **
**      PTERO ANIMATION CONSTANTS                                             **
**                                                                            **
*******************************************************************************/

RSRESET
DEF PTERO_ANIM_FRAME_1          RB 1 ; $00
DEF PTERO_ANIM_FRAME_2          RB 1 ; $01
DEF NUMBER_OF_PTERO_ANIMATIONS  RB 0 ; $02

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

DEF PTERO_SPRITE_ROW_0_Y      EQU 0

DEF PTERO_SPRITE_COL_0_X      EQU 0
DEF PTERO_SPRITE_COL_1_X      EQU 8
DEF PTERO_SPRITE_COL_2_X      EQU 16

/* Frame 1
    0   1   2
    0   1   2
*/
DEF PTERO_FRAME_1_SPRITE_0   EQU $60
DEF PTERO_FRAME_1_SPRITE_1   EQU $62
DEF PTERO_FRAME_1_SPRITE_2   EQU $64

/* Frame 2
    0   1   2
    0   1   2
*/
DEF PTERO_FRAME_2_SPRITE_0    EQU $70
DEF PTERO_FRAME_2_SPRITE_1    EQU $72
DEF PTERO_FRAME_2_SPRITE_2    EQU $74
