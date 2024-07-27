INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Menu", ROM0

_Menu::
    call _LoadTilemapMenu

    ld a, WINDOW_OFF
    call _ScreenOn

    jr _MainDrawCursor
    
_MenuLoop:
    ei

    call _WaitForVBLInterrupt

    call _RexAnimate
    
.checkKeys:
    ldh a, [hKeysPressed]
    and a, PADF_SELECT
    jr z, :+
    ld a, $FF
    jp _SwitchStateToNew
:
    ldh a, [hKeysPressed]
    and a, PADF_UP
    jr z, :+
    jr _MainMoveCursorUp
:
    ldh a, [hKeysPressed]
    and a, PADF_DOWN
    jr z, :+
    jr _MainMoveCursorDown
:
    ldh a, [hKeysPressed]
    and a, PADF_A
    jr z, :+
    jr _MainSelectOption
:
    jr _MenuLoop

_MainMoveCursorUp:
    ld a, [wMainCursorSelection]
    and a
    jr z, _MainDrawCursor
    dec a
    ld [wMainCursorSelection], a
    jr nz, _MainDrawCursor
    xor a
    ld [wMainCursorSelection], a
    jr _MainDrawCursor

_MainMoveCursorDown:
    ld a, [wMainCursorSelection]
    inc a
    cp a, NUMBER_OF_MENU_OPTS
    ld [wMainCursorSelection], a
    jr c, _MainDrawCursor
    ld a, NUMBER_OF_MENU_OPTS - 1
    ld [wMainCursorSelection], a
    jr _MainDrawCursor

_MainDrawCursor:
FOR MENU_OPT, NUMBER_OF_MENU_OPTS
    ld a, [wMainCursorSelection]
    cp a, MENU_OPT
    ld d, ">"
    jr z, :+
    ld d, " "
:
    ld hl, {MENU_OPT_START_TILE} + (MENU_OPT * 2 * 32)
    ld b, 1
    xor a
    call _VideoMemSetFast
ENDR
    jr _MenuLoop

_MainSelectOption:
    ld a, [wMainCursorSelection]
    cp a, MENU_OPT_START
    jr z, .game
    cp a, MENU_OPT_CREDITS
    jr z, .credits
    ld a, STATE_INIT
    jp _SwitchStateToNew
.game:
    ld a, STATE_GAME
    jp _SwitchStateToNew
.credits:
    ld a, STATE_CREDITS
    jp _SwitchStateToNew

ENDSECTION


SECTION "Menu Variables", WRAM0

wMainCursorSelection:
    DB

ENDSECTION
