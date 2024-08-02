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
