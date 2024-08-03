INCLUDE "libraries/hardware.inc/hardware.inc"
    rev_Check_hardware_inc 4.9.1

DEF FALSE   EQU 0
DEF TRUE    EQU 1

RSRESET
DEF STATE_MENU              RB 1 ; $00
DEF STATE_SECRET            RB 1 ; $01
DEF STATE_CONTROLS          RB 1 ; $02
DEF STATE_SCOREBOARD        RB 1 ; $03
DEF STATE_ABOUT             RB 1 ; $04
DEF STATE_GAME              RB 1 ; $05
DEF NUMBER_OF_STATES        RB 0 ; $06


/*******************************************************************************
**                                                                            **
**      ENGINE CONSTANTS                                                      **
**                                                                            **
*******************************************************************************/

INCLUDE "includes/engine/graphics.inc"
INCLUDE "includes/engine/score.inc"
INCLUDE "includes/engine/sound.inc"


/*******************************************************************************
**                                                                            **
**      STATE CONSTANTS                                                       **
**                                                                            **
*******************************************************************************/

INCLUDE "includes/states/menu.inc"
INCLUDE "includes/states/game.inc"


/*******************************************************************************
**                                                                            **
**      OBJECT CONSTANTS                                                      **
**                                                                            **
*******************************************************************************/

RSRESET
DEF OBJECT_CACTUS_1         RB 1 ; $00
DEF OBJECT_CACTUS_2         RB 1 ; $01
DEF OBJECT_CACTUS_3         RB 1 ; $02
DEF OBJECT_CACTUS_4         RB 1 ; $03
DEF OBJECT_CACTUS_5         RB 1 ; $04
DEF OBJECT_CACTUS_6         RB 1 ; $05
DEF OBJECT_PTERO_1          RB 1 ; $06
DEF OBJECT_PTERO_2          RB 1 ; $07
DEF NUMBER_OF_OBJECTS       RB 0 ; $08

DEF OBJECT_METEOR_1     EQU OBJECT_CACTUS_1
DEF OBJECT_METEOR_2     EQU OBJECT_PTERO_1
DEF OBJECT_PTERO_3      EQU OBJECT_PTERO_2


INCLUDE "includes/objects/cactus.inc"
INCLUDE "includes/objects/ptero.inc"
INCLUDE "includes/objects/meteor.inc"
INCLUDE "includes/objects/rex.inc"

INCLUDE "includes/objects/game_over.inc"
