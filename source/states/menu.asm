INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Menu", ROM0

_Menu::
    call _LoadTilemapMenu

    ld a, WINDOW_OFF
    call _ScreenOn
    
.loop:
    ei

    call _WaitForVBLInterrupt

    call _RexAnimate
    
.checkKeys:
    ldh a, [hKeysPressed]
    and a, PADF_START
    jr z, :+
    ld a, $FF
    jp _SwitchStateToNew

:
    ldh a, [hKeysPressed]
    and a, PADF_SELECT
    jr z, :+
    ld a, STATE_CREDITS
    jp _SwitchStateToNew

:
    ldh a, [hKeysPressed]
    and a, PADF_A
    jr z, :+
    ld a, STATE_GAME
    jp _SwitchStateToNew

:
    jr .loop

ENDSECTION
