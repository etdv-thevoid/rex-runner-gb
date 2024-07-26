INCLUDE "libraries/hardware.inc/hardware.inc"
    rev_Check_hardware_inc 4.9.1

DEF FALSE   EQU 0
DEF TRUE    EQU 1

/*******************************************************************************
**                                                                            **
**      STATE CONSTANTS                                                       **
**                                                                            **
*******************************************************************************/

RSRESET

DEF STATE_INIT          RB 1
DEF STATE_MENU          RB 1
DEF STATE_CREDITS       RB 1
DEF STATE_GAME          RB 1
DEF STATE_PAUSE         RB 1
DEF STATE_DEAD          RB 1

DEF NUMBER_OF_STATES    RB 0


/*******************************************************************************
**                                                                            **
**      BACKGROUND & WINDOW CONSTANTS                                         **
**                                                                            **
*******************************************************************************/

DEF INITIAL_SCROLL_SPEED    EQU 10

DEF PARALLAX_BIT_SHIFTS_INITIAL     EQU 3
DEF PARALLAX_BIT_SHIFTS_PER_SECTION EQU 2

DEF LYC_HUD_START_LINE              EQU 0
DEF LYC_PARALLAX_TOP_START_LINE     EQU 7
DEF LYC_PARALLAX_MIDDLE_START_LINE  EQU 39
DEF LYC_PARALLAX_BOTTOM_START_LINE  EQU 71
DEF LYC_PARALLAX_GROUND_START_LINE  EQU 103

DEF WINDOW_ON   EQU LCDCF_ON | LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_BLK21 | LCDCF_BG9800 | LCDCF_OBJ8 | LCDCF_OBJON | LCDCF_BGON
DEF WINDOW_OFF  EQU LCDCF_ON | LCDCF_WIN9C00 | LCDCF_WINOFF | LCDCF_BLK21 | LCDCF_BG9800 | LCDCF_OBJ8 | LCDCF_OBJON | LCDCF_BGON

DEF DEFAULT_PALETTE  EQU %11100100


/*******************************************************************************
**                                                                            **
**      HUD & SCORE CONSTANTS                                                 **
**                                                                            **
*******************************************************************************/

DEF SCORE_BYTES     EQU 3
DEF SCORE_DIGITS    EQU SCORE_BYTES * 2

DEF SCORE_INCREMENT_MASK    EQU %00000001


/*******************************************************************************
**                                                                            **
**      REX CONSTANTS                                                         **
**                                                                            **
*******************************************************************************/

DEF REX_INIT_Y_POS          EQU 120 + OAM_Y_OFS
DEF REX_INIT_X_POS          EQU 16 + OAM_X_OFS

DEF MAX_JUMP_HEIGHT         EQU 54 + OAM_Y_OFS
DEF MAX_SHORT_JUMP_HEIGHT   EQU 90 + OAM_Y_OFS

DEF JUMP_VELOCITY           EQU 3
DEF FAST_FALL_VELOCITY      EQU 6


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

DEF BLINK_FRAMES_MASK           EQU %00000111
DEF RUNNING_FRAMES_MASK         EQU %00000111
DEF LONG_JUMP_FRAMES_MASK       EQU %00000011


/*******************************************************************************
**                                                                            **
**      REX SPRITE CONSTANTS                                                  **
**                                                                            **
*******************************************************************************/

DEF REX_SPRITE_0            EQUS "wShadowOAM.0"
DEF REX_SPRITE_1            EQUS "wShadowOAM.1"
DEF REX_SPRITE_2            EQUS "wShadowOAM.2"
DEF REX_SPRITE_3            EQUS "wShadowOAM.3"
DEF REX_SPRITE_4            EQUS "wShadowOAM.4"
DEF REX_SPRITE_5            EQUS "wShadowOAM.5"
DEF REX_SPRITE_6            EQUS "wShadowOAM.6"
DEF REX_SPRITE_7            EQUS "wShadowOAM.7"

DEF REX_SPRITE_ROW_0_Y      EQU -8
DEF REX_SPRITE_ROW_1_Y      EQU 0
DEF REX_SPRITE_ROW_2_Y      EQU 8

DEF REX_SPRITE_COL_0_X      EQU -8
DEF REX_SPRITE_COL_1_X      EQU 0
DEF REX_SPRITE_COL_2_X      EQU 8
DEF REX_SPRITE_COL_3_X      EQU 16

/* Default Sprite
    0   1   2
    3   4   5
    6   7
*/
DEF REX_STANDING_SPRITE_0   EQU $00
DEF REX_STANDING_SPRITE_1   EQU $01
DEF REX_STANDING_SPRITE_2   EQU $02
DEF REX_STANDING_SPRITE_3   EQU $10
DEF REX_STANDING_SPRITE_4   EQU $11
DEF REX_STANDING_SPRITE_5   EQU $12
DEF REX_STANDING_SPRITE_6   EQU $20
DEF REX_STANDING_SPRITE_7   EQU $21

DEF REX_BLINKING_SPRITE_1   EQU $31

/* Running Sprite
    0   1   2
    3   4   5
    6   7
*/
DEF REX_RUNNING_SPRITE_0    EQU $03
DEF REX_RUNNING_SPRITE_1    EQU $04
DEF REX_RUNNING_SPRITE_2    EQU $05
DEF REX_RUNNING_SPRITE_3    EQU $13
DEF REX_RUNNING_SPRITE_4    EQU $14
DEF REX_RUNNING_SPRITE_5    EQU $15
DEF REX_RUNNING_SPRITE_6    EQU $23
DEF REX_RUNNING_SPRITE_7    EQU $24

DEF REX_RUNNING_SPRITE_6_L  EQU $33
DEF REX_RUNNING_SPRITE_7_R  EQU $34

/* Ducking Sprite

    3   4   1   2
    6   7   5   0
*/
DEF REX_DUCKING_SPRITE_0    EQU $29
DEF REX_DUCKING_SPRITE_1    EQU $18
DEF REX_DUCKING_SPRITE_2    EQU $19
DEF REX_DUCKING_SPRITE_3    EQU $16
DEF REX_DUCKING_SPRITE_4    EQU $17
DEF REX_DUCKING_SPRITE_5    EQU $28
DEF REX_DUCKING_SPRITE_6    EQU $26
DEF REX_DUCKING_SPRITE_7    EQU $27

DEF REX_DUCKING_SPRITE_6_L  EQU $36
DEF REX_DUCKING_SPRITE_7_R  EQU $37

/* Dead Sprite
    0   1   2
    3   4   5
    6   7
*/
DEF REX_DEAD_SPRITE_0       EQU $0A
DEF REX_DEAD_SPRITE_1       EQU $0B
DEF REX_DEAD_SPRITE_2       EQU $0C
DEF REX_DEAD_SPRITE_3       EQU $1A
DEF REX_DEAD_SPRITE_4       EQU $1B
DEF REX_DEAD_SPRITE_5       EQU $1C
DEF REX_DEAD_SPRITE_6       EQU $2A
DEF REX_DEAD_SPRITE_7       EQU $2B
