INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Menu State", ROM0

_Menu::
    call _ScreenOff

    call _LoadTilemapMenu
    call _LoadMonochromeColorPalette

    call _RexStand

    jr _MenuCommon

_Secret::
    call _ScreenOff
    
    call _LoadTilemapSecret
    call _LoadMonochromeColorPaletteInverted

    call _RexDead

_MenuCommon:
    call _GetStatePrevious
    cp a, STATE_GAME
    jr c, .skipInit

    call _InitEngine

.skipInit:
    ld hl, STARTOF("Menu State Variables")
    ld b, SIZEOF("Menu State Variables")
    xor a
    call _MemSetFast

    call _ClearHUD

    ld a, WINDOW_OFF
    call _ScreenOn

    ; fallthrough
    
_MenuLoop:
    ei
    call _WaitForVBLInterrupt
    
    call _MenuDrawCursor

    call _RexAnimate

    check_keys_start wMenuButtonsEnabled, \
                     wMenuDelayFrameCounter, \
                     _MenuLoop

    check_keys_add hKeysPressed, PADF_SELECT
    jp _MenuSwitch

    check_keys_add hKeysPressed, PADF_UP
    call _MenuMoveCursorUp

    check_keys_add hKeysPressed, PADF_DOWN
    call _MenuMoveCursorDown

    check_keys_add hKeysPressed, PADF_A
    jr _MenuSelectOption

    check_keys_end _MenuLoop


/*******************************************************************************
**                                                                            **
**      MENU MOVE CURSOR FUNCTIONS                                            **
**                                                                            **
*******************************************************************************/

_MenuMoveCursorUp:
    ld a, [wMenuCursorSelection]
    and a
    ret z
    dec a
    ld [wMenuCursorSelection], a
    ret

_MenuMoveCursorDown:
    ld a, [wMenuCursorSelection]
    cp a, NUMBER_OF_MENU_OPTS - 1
    ret nc
    inc a
    ld [wMenuCursorSelection], a
    ret


/*******************************************************************************
**                                                                            **
**      MENU DRAW CURSOR FUNCTIONS                                            **
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
    ld a, [wMenuCursorSelection]
    ld d, " "
    cp a, c
    jr nz, .clear
    ld d, MENU_CURSOR_TILE
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
**      MENU SELECT OPTION FUNCTIONS                                          **
**                                                                            **
*******************************************************************************/

_MenuSwitch:
    call _GetStateCurrent
    cp a, STATE_SECRET
    jr nz, .secret

    ld a, SFX_SCORE
    call _PlaySound

    ld a, STATE_MENU
    jp _SwitchStateToNew

.secret:
    ld a, SFX_SECRET
    call _PlaySound

    ld a, STATE_SECRET
    jp _SwitchStateToNew

_MenuSelectOption:
    ld hl, _MenuSelectOptionJumpTable
    ld a, [wMenuCursorSelection]
    cp a, NUMBER_OF_MENU_OPTS
    jr c, .jump
    ld a, NUMBER_OF_MENU_OPTS
.jump:
    jp _JumpTable

_MenuSelectOptionJumpTable:
    DW _MenuSelectGame
    DW _MenuSelectControls
    ;DW _MenuSelectScores
    DW _MenuSelectAbout
    DW _NULL

_MenuSelectGame:
    ld a, STATE_GAME
    jp _SwitchStateToNew

_MenuSelectControls:
    ld a, SFX_MENU_A
    call _PlaySound
    ld a, STATE_CONTROLS
    jp _SwitchStateToNew

_MenuSelectScores:
    ld a, SFX_MENU_A
    call _PlaySound
    ld a, STATE_SCORES
    jp _SwitchStateToNew

_MenuSelectAbout:
    ld a, SFX_MENU_A
    call _PlaySound
    ld a, STATE_ABOUT
    jp _SwitchStateToNew

ENDSECTION


SECTION "Menu State Variables", WRAM0

wMenuCursorSelection:
    DB

wMenuDelayFrameCounter:
    DB

wMenuButtonsEnabled:
    DB

ENDSECTION
