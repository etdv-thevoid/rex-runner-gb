INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Menu State", ROM0

_Menu::
    call _ScreenOff

    call _LoadTilemapMenu
    call _LoadMonochromeColorPalette

    call _RexStand
    
    ld a, SFX_JUMP
    call _PlaySound

    jr _MenuCommon

_Secret::
    call _ScreenOff
    
    call _LoadTilemapSecret
    call _LoadMonochromeColorPaletteInverted

    call _RexDead
    
    ld a, SFX_SCORE
    call _PlaySound

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

    ld a, [wMenuButtonsEnabled]
    and a
    jr nz, .checkKeys

    ld a, [wMenuDelayFrameCounter]
    inc a
    ld [wMenuDelayFrameCounter], a
    and a, BUTTON_DELAY_FRAMES_MASK
    jr nz, _MenuLoop

    ld a, TRUE
    ld [wMenuButtonsEnabled], a

    jr _MenuLoop
    
.checkKeys:
    ldh a, [hKeysPressed]
    and a, PADF_SELECT
    jr z, :+
    jp _MenuSwitch
:
    ldh a, [hKeysPressed]
    and a, PADF_UP
    jr z, :+
    call _MenuMoveCursorUp
:
    ldh a, [hKeysPressed]
    and a, PADF_DOWN
    jr z, :+
    call _MenuMoveCursorDown
:
    ldh a, [hKeysPressed]
    and a, PADF_A
    jr z, :+
    jr _MenuSelectOption
:
    jr _MenuLoop


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

    ld a, STATE_MENU
    jp _SwitchStateToNew

.secret:
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
    DW _MenuSelectAbout
    DW _NULL

_MenuSelectGame:
    ld a, STATE_GAME
    jp _SwitchStateToNew

_MenuSelectControls:
    ld a, STATE_CONTROLS
    jp _SwitchStateToNew

_MenuSelectAbout:
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
