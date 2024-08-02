/*******************************************************************************
**                                                                            **
**      MENU STATE CONSTANTS                                                  **
**                                                                            **
*******************************************************************************/

RSRESET
DEF MENU_OPT_START          RB 1 ; $00
DEF MENU_OPT_CONTROLS       RB 1 ; $01
DEF MENU_OPT_SCORES         RB 1 ; $02
DEF MENU_OPT_ABOUT          RB 1 ; $03
DEF NUMBER_OF_MENU_OPTS     RB 0 ; $04

DEF MENU_OPT_START_TILE     EQUS "vSCRN0.y5x4"
DEF MENU_CURSOR_TILE        EQU $0F
DEF MENU_BUTTON_DELAY_MASK  EQU %00001111
