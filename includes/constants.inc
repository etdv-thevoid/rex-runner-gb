INCLUDE "libraries/hardware.inc/hardware.inc"
    rev_Check_hardware_inc 4.9.1

DEF FALSE   EQU 0
DEF TRUE    EQU 1

RSRESET
DEF STATE_MENU              RB 1 ; $00
DEF STATE_SECRET            RB 1 ; $01
DEF STATE_CONTROLS          RB 1 ; $02
DEF STATE_SCORES            RB 1 ; $03
DEF STATE_ABOUT             RB 1 ; $04
DEF STATE_GAME              RB 1 ; $05
DEF STATE_PAUSE             RB 1 ; $06
DEF STATE_DEAD              RB 1 ; $07
DEF NUMBER_OF_STATES        RB 0 ; $08

RSRESET
DEF SOUND_CH_1              RB 1 ; $00
DEF SOUND_CH_2              RB 1 ; $01
DEF SOUND_CH_3              RB 1 ; $02
DEF SOUND_CH_4              RB 1 ; $03
DEF NUMBER_OF_CH            RB 0 ; $04

RSRESET
DEF SFX_MENU_A              RB 1 ; $00
DEF SFX_MENU_B              RB 1 ; $01
DEF SFX_JUMP                RB 1 ; $02
DEF SFX_DEAD                RB 1 ; $03
DEF SFX_SCORE               RB 1 ; $04
DEF SFX_SECRET              RB 1 ; $05
DEF NUMBER_OF_SFX           RB 0 ; $06

RSRESET
DEF MENU_OPT_START          RB 1 ; $00
DEF MENU_OPT_CONTROLS       RB 1 ; $01
DEF MENU_OPT_SCORES         RB 1 ; $02
DEF MENU_OPT_ABOUT          RB 1 ; $03
DEF NUMBER_OF_MENU_OPTS     RB 0 ; $04

DEF MENU_OPT_START_TILE     EQUS "vSCRN0.y5x4"
DEF MENU_CURSOR_TILE        EQU $0F
DEF MENU_BUTTON_DELAY_MASK  EQU %00001111

RSRESET
DEF OBJECT_CACTUS           RB 1 ; $00
DEF OBJECT_PTERO            RB 1 ; $01
;DEF OBJECT_METEOR          RB 1 ; $02
DEF NUMBER_OF_OBJECTS       RB 0 ; $03

DEF DEFAULT_OBJECT          EQU OBJECT_CACTUS

DEF NUMBER_OF_HIGH_SCORES   EQU 5
DEF SCORE_BYTES             EQU 3
DEF SCORE_DIGITS            EQU SCORE_BYTES * 2


/*******************************************************************************
**                                                                            **
**      ENGINE DIFFICULTY CONSTANTS                                           **
**                                                                            **
*******************************************************************************/

DEF INITIAL_DIFFICULTY_SPEED        EQU 10
DEF DIFFICULTY_SPEED_INCREASE       EQU 1
DEF MAX_DIFFICULTY_SPEED            EQU 25

DEF PALETTE_SWITCH_100_DIGIT        EQU 0

DEF GRAVITY_VALUE                   EQU 6
DEF GRAVITY_VALUE_FAST              EQU 12

DEF JUMP_VELOCITY_CHARGE            EQU $01
DEF MIN_JUMP_VELOCITY               EQU $18
DEF MAX_JUMP_VELOCITY               EQU $7F ; +127
DEF MIN_MAX_JUMP_DIFFERENCE         EQU MAX_JUMP_VELOCITY - MIN_JUMP_VELOCITY
DEF TERMINAL_VELOCITY               EQU $80 ; -128

DEF COLLISION_PIXEL_OVERLAP_OBJ     EQU 4

DEF COLLISION_PIXEL_OVERLAP_TOP     EQU 1
DEF COLLISION_PIXEL_OVERLAP_RIGHT   EQU 3
DEF COLLISION_PIXEL_OVERLAP_BOTTOM  EQU 3
DEF COLLISION_PIXEL_OVERLAP_LEFT    EQU 2

DEF PTERO_INIT_SPAWN_CHANCE         EQU $00
DEF PTERO_MAX_SPAWN_CHANCE          EQU $08
DEF PTERO_SPAWN_INCREMENT           EQU $02

DEF CACTUS_INIT_SPAWN_CHANCE        EQU $28
DEF CACTUS_MAX_SPAWN_CHANCE         EQU $40
DEF CACTUS_SPAWN_INCREMENT          EQU $01

DEF CACTUS_TYPE_6_SPEED_MINIMUM     EQU 2

/*******************************************************************************
**                                                                            **
**      BACKGROUND & WINDOW CONSTANTS                                         **
**                                                                            **
*******************************************************************************/

DEF PARALLAX_BIT_SHIFTS_BOTTOM      EQU 3
DEF PARALLAX_BIT_SHIFTS_MIDDLE      EQU 5 - PARALLAX_BIT_SHIFTS_BOTTOM
DEF PARALLAX_BIT_SHIFTS_TOP         EQU 7 - PARALLAX_BIT_SHIFTS_BOTTOM - PARALLAX_BIT_SHIFTS_MIDDLE

DEF LYC_HUD_STOP_LINE               EQU 7
DEF LYC_PARALLAX_TOP_START_LINE     EQU 31
DEF LYC_PARALLAX_MIDDLE_START_LINE  EQU 55
DEF LYC_PARALLAX_BOTTOM_START_LINE  EQU 87

DEF WINDOW_ON   EQU LCDCF_ON | LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_BLK21 | \
                    LCDCF_BG9800 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON

DEF WINDOW_OFF  EQU LCDCF_ON | LCDCF_WIN9C00 | LCDCF_WINOFF | LCDCF_BLK21 | \
                    LCDCF_BG9800 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON

DEF DMG_COLOR_3     EQU (%11 & $FF)
DEF DMG_COLOR_2     EQU (%10 & $FF)
DEF DMG_COLOR_1     EQU (%01 & $FF)
DEF DMG_COLOR_0     EQU (%00 & $FF)

DEF DEFAULT_BG_PALETTE      EQU ((DMG_COLOR_3) << 6) + ((DMG_COLOR_2) << 4) + \
                                ((DMG_COLOR_1) << 2) + ((DMG_COLOR_0) << 0)

DEF INVERTED_BG_PALETTE     EQU (~DEFAULT_BG_PALETTE & $FF)

DEF DEFAULT_OBJ_PALETTE     EQU ((DMG_COLOR_3) << 6) + ((DMG_COLOR_1) << 4) + \
                                ((DMG_COLOR_0) << 2) + ((DMG_COLOR_0) << 0)

DEF INVERTED_OBJ_PALETTE    EQU (~DEFAULT_OBJ_PALETTE & $FF)


/*******************************************************************************
**                                                                            **
**      SPRITE POSITION CONSTANTS                                             **
**                                                                            **
*******************************************************************************/

DEF OFFSCREEN_SPRITE_Y_POS      EQU $FF
DEF OFFSCREEN_SPRITE_X_POS      EQU SCRN_X + OAM_X_OFS

DEF META_SPRITE_ROW_0_Y         EQU 0
DEF META_SPRITE_ROW_1_Y         EQU -8
DEF META_SPRITE_ROW_2_Y         EQU -16

DEF META_SPRITE_COL_0_X         EQU 0
DEF META_SPRITE_COL_1_X         EQU 8
DEF META_SPRITE_COL_2_X         EQU 16
DEF META_SPRITE_COL_3_X         EQU 24
DEF META_SPRITE_COL_4_X         EQU 32

DEF GROUND_LEVEL_Y_POS          EQU 120 + OAM_Y_OFS
DEF GROUND_LEVEL_Y_POS_OFF      EQU 128 + OAM_Y_OFS

DEF DESPAWN_LEFT_BOUNDARY       EQU OFFSCREEN_SPRITE_X_POS + 1
DEF DESPAWN_RIGHT_BOUNDARY      EQU $FF - META_SPRITE_COL_4_X - 1

DEF MINIMUM_SPAWN_DISTANCE      EQU (SCRN_X / 2) + META_SPRITE_COL_4_X + 1


/*******************************************************************************
**                                                                            **
**      GAME OVER SPRITE CONSTANTS                                            **
**                                                                            **
*******************************************************************************/

DEF GAME_OVER_Y_POS_0           EQU (SCRN_Y / 2)
DEF GAME_OVER_X_POS_0           EQU (SCRN_X / 2)
DEF GAME_OVER_X_POS_1           EQU (SCRN_X / 2) + META_SPRITE_COL_1_X

DEF GAME_OVER_SPRITE_0          EQUS "wShadowOAM.38"
DEF GAME_OVER_SPRITE_1          EQUS "wShadowOAM.39"

DEF GAME_OVER_SPRITE_0_TILE     EQU $7C
DEF GAME_OVER_SPRITE_1_TILE     EQU $7E


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
DEF REX_ANIM_FAST_FALLING       RB 1 ; $05
DEF NUMBER_OF_REX_ANIMATIONS    RB 0 ; $06

DEF REX_SPRITE_0                EQUS "wShadowOAM.0"
DEF REX_SPRITE_1                EQUS "wShadowOAM.1"
DEF REX_SPRITE_2                EQUS "wShadowOAM.2"
DEF REX_SPRITE_3                EQUS "wShadowOAM.3"
DEF NUMBER_OF_REX_SPRITES       EQU 4

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


/*******************************************************************************
**                                                                            **
**      PTERO SPRITE CONSTANTS                                                **
**                                                                            **
*******************************************************************************/

DEF PTERO_1_INIT_Y_POS_0        EQU 54 + OAM_Y_OFS
DEF PTERO_1_INIT_Y_POS_1        EQU 86 + OAM_Y_OFS
DEF PTERO_2_INIT_Y_POS_0        EQU 70 + OAM_Y_OFS
DEF PTERO_2_INIT_Y_POS_1        EQU 102 + OAM_Y_OFS

DEF PTERO_FRAMES_MASK           EQU %00001111

DEF PTERO_1_SPRITE_0            EQUS "wShadowOAM.4"
DEF PTERO_1_SPRITE_1            EQUS "wShadowOAM.6"
DEF PTERO_1_SPRITE_2            EQUS "wShadowOAM.8"

DEF PTERO_2_SPRITE_0            EQUS "wShadowOAM.5"
DEF PTERO_2_SPRITE_1            EQUS "wShadowOAM.7"
DEF PTERO_2_SPRITE_2            EQUS "wShadowOAM.9"

DEF NUMBER_OF_IGNORED_PTERO_SPRITES EQU 2 ; Don't calc collision with heads

/* Frame 1
    0   1   2
    0   1   2
*/
DEF PTERO_FRAME_1_SPRITE_0      EQU $64
DEF PTERO_FRAME_1_SPRITE_1      EQU $66
DEF PTERO_FRAME_1_SPRITE_2      EQU $68

/* Frame 2
    0   1   2
    0   1   2
*/
DEF PTERO_FRAME_2_SPRITE_0      EQU $6A
DEF PTERO_FRAME_2_SPRITE_1      EQU $6C
DEF PTERO_FRAME_2_SPRITE_2      EQU $6E


/*******************************************************************************
**                                                                            **
**      CACTUS SPRITE CONSTANTS                                               **
**                                                                            **
*******************************************************************************/

RSRESET
DEF CACTUS_TYPE_1               RB 1 ; $00
DEF CACTUS_TYPE_2               RB 1 ; $01
DEF CACTUS_TYPE_3               RB 1 ; $02
DEF CACTUS_TYPE_4               RB 1 ; $03
DEF CACTUS_TYPE_5               RB 1 ; $04
DEF CACTUS_TYPE_6               RB 1 ; $05
DEF NUMBER_OF_CACTUS_TYPES      RB 0 ; $06

DEF DEFAULT_CACTUS_TYPE         EQU CACTUS_TYPE_6

DEF CACTUS_TYPE_1_SPRITE_0      EQUS "wShadowOAM.10"

DEF CACTUS_TYPE_2_SPRITE_0      EQUS "wShadowOAM.11"
DEF CACTUS_TYPE_2_SPRITE_1      EQUS "wShadowOAM.12"

DEF CACTUS_TYPE_3_SPRITE_0      EQUS "wShadowOAM.13"
DEF CACTUS_TYPE_3_SPRITE_1      EQUS "wShadowOAM.14"
DEF CACTUS_TYPE_3_SPRITE_2      EQUS "wShadowOAM.15"

DEF CACTUS_TYPE_4_SPRITE_0      EQUS "wShadowOAM.16"
DEF CACTUS_TYPE_4_SPRITE_1      EQUS "wShadowOAM.17"
DEF CACTUS_TYPE_4_SPRITE_2      EQUS "wShadowOAM.18"
DEF CACTUS_TYPE_4_SPRITE_3      EQUS "wShadowOAM.19"

DEF CACTUS_TYPE_5_SPRITE_0      EQUS "wShadowOAM.20"
DEF CACTUS_TYPE_5_SPRITE_1      EQUS "wShadowOAM.21"
DEF CACTUS_TYPE_5_SPRITE_2      EQUS "wShadowOAM.22"
DEF CACTUS_TYPE_5_SPRITE_3      EQUS "wShadowOAM.23"
DEF CACTUS_TYPE_5_SPRITE_4      EQUS "wShadowOAM.24"
DEF CACTUS_TYPE_5_SPRITE_5      EQUS "wShadowOAM.25"

DEF CACTUS_TYPE_6_SPRITE_0      EQUS "wShadowOAM.26"
DEF CACTUS_TYPE_6_SPRITE_1      EQUS "wShadowOAM.27"
DEF CACTUS_TYPE_6_SPRITE_2      EQUS "wShadowOAM.28"
DEF CACTUS_TYPE_6_SPRITE_3      EQUS "wShadowOAM.29"
DEF CACTUS_TYPE_6_SPRITE_4      EQUS "wShadowOAM.30"
DEF CACTUS_TYPE_6_SPRITE_5      EQUS "wShadowOAM.31"
DEF CACTUS_TYPE_6_SPRITE_6      EQUS "wShadowOAM.32"
DEF CACTUS_TYPE_6_SPRITE_7      EQUS "wShadowOAM.33"
DEF CACTUS_TYPE_6_SPRITE_8      EQUS "wShadowOAM.34"
DEF CACTUS_TYPE_6_SPRITE_9      EQUS "wShadowOAM.35"

/* Version 1
    0
____0____
*/
DEF CACTUS_TYPE_1_SPRITE_0_TILE EQU $30

/* Version 2
    0   1
____0___1____
*/
DEF CACTUS_TYPE_2_SPRITE_0_TILE EQU $32
DEF CACTUS_TYPE_2_SPRITE_1_TILE EQU $34

/* Version 3
    0   1   2
____0___1___2____
*/
DEF CACTUS_TYPE_3_SPRITE_0_TILE EQU $36
DEF CACTUS_TYPE_3_SPRITE_1_TILE EQU $38
DEF CACTUS_TYPE_3_SPRITE_2_TILE EQU $3A

/* Version 4
    2   3
    2   3
____0___1____
    0   1
*/
DEF CACTUS_TYPE_4_SPRITE_0_TILE EQU $3E
DEF CACTUS_TYPE_4_SPRITE_1_TILE EQU $42
DEF CACTUS_TYPE_4_SPRITE_2_TILE EQU $3C
DEF CACTUS_TYPE_4_SPRITE_3_TILE EQU $40

/* Version 5
    3   4   5
    3   4   5
____0___1___2____
    0   1   2
*/
DEF CACTUS_TYPE_5_SPRITE_0_TILE EQU $46
DEF CACTUS_TYPE_5_SPRITE_1_TILE EQU $4A
DEF CACTUS_TYPE_5_SPRITE_2_TILE EQU $4E
DEF CACTUS_TYPE_5_SPRITE_3_TILE EQU $44
DEF CACTUS_TYPE_5_SPRITE_4_TILE EQU $48
DEF CACTUS_TYPE_5_SPRITE_5_TILE EQU $4C


/* Version 6
    5   6   7   8   9
    5   6   7   8   9
____0___1___2___3___4____
    0   1   2   3   4
*/
DEF CACTUS_TYPE_6_SPRITE_0_TILE EQU $52
DEF CACTUS_TYPE_6_SPRITE_1_TILE EQU $56
DEF CACTUS_TYPE_6_SPRITE_2_TILE EQU $5A
DEF CACTUS_TYPE_6_SPRITE_3_TILE EQU $5E
DEF CACTUS_TYPE_6_SPRITE_4_TILE EQU $62
DEF CACTUS_TYPE_6_SPRITE_5_TILE EQU $50
DEF CACTUS_TYPE_6_SPRITE_6_TILE EQU $54
DEF CACTUS_TYPE_6_SPRITE_7_TILE EQU $58
DEF CACTUS_TYPE_6_SPRITE_8_TILE EQU $5C
DEF CACTUS_TYPE_6_SPRITE_9_TILE EQU $60
