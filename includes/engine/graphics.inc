/*******************************************************************************
**                                                                            **
**      GRAPHICS CONSTANTS                                                    **
**                                                                            **
*******************************************************************************/

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

DEF OFFSCREEN_SPRITE_Y_POS  EQU $FF
DEF OFFSCREEN_SPRITE_X_POS  EQU SCRN_X + OAM_X_OFS

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

DEF DESPAWN_LEFT_BOUNDARY   EQU OFFSCREEN_SPRITE_X_POS + 1
DEF DESPAWN_RIGHT_BOUNDARY  EQU $FF - META_SPRITE_COL_4_X - 1

DEF MINIMUM_SPAWN_DISTANCE  EQU (SCRN_X / 2) + META_SPRITE_COL_4_X + 1
