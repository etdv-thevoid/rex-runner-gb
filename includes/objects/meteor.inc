/*******************************************************************************
**                                                                            **
**      METEOR SPRITE CONSTANTS                                               **
**                                                                            **
*******************************************************************************/

DEF METEOR_RANDOM_X_MASK        EQU %00011111

DEF METEOR_1_SPRITE_0           EQUS "wShadowOAM.16"   ; collision ignored
DEF METEOR_1_SPRITE_1           EQUS "wShadowOAM.10"   ; sprites into the lower
DEF METEOR_1_SPRITE_2           EQUS "wShadowOAM.11"   ; slots

DEF METEOR_2_SPRITE_0           EQUS "wShadowOAM.14"
DEF METEOR_2_SPRITE_1           EQUS "wShadowOAM.8"
DEF METEOR_2_SPRITE_2           EQUS "wShadowOAM.9"

/* Sprite
            2
        1   2
    0   1
    0
*/
DEF METEOR_SPRITE_0_TILE        EQU $70
DEF METEOR_SPRITE_1_TILE        EQU $72
DEF METEOR_SPRITE_2_TILE        EQU $74
