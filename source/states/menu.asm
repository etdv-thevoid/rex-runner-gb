INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Menu", ROM0

_Menu::
    call _ScreenOff

    call _LoadTilemapMenu
    call _MenuDrawCursor

    ld a, WINDOW_OFF
    call _ScreenOn

    ; fallthrough
    
_MenuLoop:
    ei
    call _WaitForVBLInterrupt
    
    call _MenuDrawCursor
    call _RexAnimate
    
.checkKeys:
    ldh a, [hKeysPressed]
    and a, PADF_UP
    jr z, :+
    call _MainMoveCursorUp
:
    ldh a, [hKeysPressed]
    and a, PADF_DOWN
    jr z, :+
    call _MainMoveCursorDown
:
    ldh a, [hKeysPressed]
    and a, PADF_A
    jr z, :+
    jr _MainSelectOption
:
    jr _MenuLoop


/*******************************************************************************
**                                                                            **
**      MAIN MOVE CURSOR FUNCTIONS                                            **
**                                                                            **
*******************************************************************************/

_MainMoveCursorUp:
    ld a, [wMainCursorSelection]
    and a
    ret z
    dec a
    ld [wMainCursorSelection], a
    ret

_MainMoveCursorDown:
    ld a, [wMainCursorSelection]
    cp a, NUMBER_OF_MENU_OPTS - 1
    ret nc
    inc a
    ld [wMainCursorSelection], a
    ret


/*******************************************************************************
**                                                                            **
**      MAIN DRAW CURSOR FUNCTIONS                                            **
**                                                                            **
*******************************************************************************/

_MenuDrawCursor:
    ld c, 0
    ld e, SCRN_VX_B
.loop1:
    ld hl, {MENU_OPT_START_TILE}
    ld a, c
    and a
    jr z, .draw
    ld d, $00
.loop2:
    add hl, de
    add hl, de
    dec a
    jr nz, .loop2
.draw:
    ld a, [wMainCursorSelection]
    ld d, " "
    cp a, c
    jr nz, .clear
    ld d, ">"
.clear:
    xor a
    ld b, 1
    call _VideoMemSetFast
    inc c
    ld a, c
    cp a, NUMBER_OF_MENU_OPTS
    jr c, .loop1
    ret


/*******************************************************************************
**                                                                            **
**      MAIN SELECT OPTION FUNCTIONS                                          **
**                                                                            **
*******************************************************************************/

_MainSelectOption:
    ld hl, _MenuSelectOptionJumpTable
    ld a, [wMainCursorSelection]
    cp a, NUMBER_OF_MENU_OPTS
    jr c, .jump
    ld a, NUMBER_OF_MENU_OPTS
.jump:
    jp _JumpTable

_MenuSelectOptionJumpTable:
    DW _MenuSelectGame
    DW _MenuSelectCredits
    DW _NULL

_MenuSelectGame:
    ld a, STATE_GAME
    jp _SwitchStateToNew

_MenuSelectCredits:
    ld a, STATE_CREDITS
    jp _SwitchStateToNew

ENDSECTION


SECTION "Menu Variables", WRAM0

wMainCursorSelection:
    DB

ENDSECTION
