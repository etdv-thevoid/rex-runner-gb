/*******************************************************************************
**                                                                            **
**      PTERO SPRITE CONSTANTS                                                **
**                                                                            **
*******************************************************************************/

DEF PTERO_1_INIT_Y_POS_0        EQU 54 + OAM_Y_OFS
DEF PTERO_1_INIT_Y_POS_1        EQU 86 + OAM_Y_OFS
DEF PTERO_2_INIT_Y_POS_0        EQU 70 + OAM_Y_OFS
DEF PTERO_2_INIT_Y_POS_1        EQU 102 + OAM_Y_OFS

DEF PTERO_3_INIT_Y_POS_0        EQU PTERO_1_INIT_Y_POS_0
DEF PTERO_3_INIT_Y_POS_1        EQU PTERO_2_INIT_Y_POS_0
DEF PTERO_3_INIT_Y_POS_2        EQU PTERO_1_INIT_Y_POS_1
DEF PTERO_3_INIT_Y_POS_3        EQU PTERO_2_INIT_Y_POS_1
DEF NUMBER_OF_PTERO_3_Y_POS     EQU 4

DEF PTERO_FRAMES_MASK           EQU %00001111

DEF PTERO_1_SPRITE_0            EQUS "wShadowOAM.10"    ; collision ignored
DEF PTERO_1_SPRITE_1            EQUS "wShadowOAM.14"    ; sprites into the lower
DEF PTERO_1_SPRITE_2            EQUS "wShadowOAM.11"    ; slots

DEF PTERO_2_SPRITE_0            EQUS "wShadowOAM.12"
DEF PTERO_2_SPRITE_1            EQUS "wShadowOAM.15"
DEF PTERO_2_SPRITE_2            EQUS "wShadowOAM.13"

DEF PTERO_3_SPRITE_0            EQUS "wShadowOAM.12"
DEF PTERO_3_SPRITE_1            EQUS "wShadowOAM.15"
DEF PTERO_3_SPRITE_2            EQUS "wShadowOAM.13"

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
