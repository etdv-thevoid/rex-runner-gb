INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Controls State", ROM0

_Controls::
    call _ResetScreen
    
    call _LoadTilemapControls

    call _RexStand
    
    ld hl, STARTOF("Controls State Variables")
    ld b, SIZEOF("Controls State Variables")
    xor a
    call _MemSetFast

    ld bc, _ControlsVBlankHandler
    rst _SetVBLHandler

    ld a, IEF_VBLANK | IEF_TIMER
    ldh [rIE], a

    ld a, WINDOW_OFF
    call _ScreenOn

    ; fallthrough
    
_ControlsLoop:
    ei
    call _WaitForVBLInterrupt

    call _RexAnimate

    check_keys_start wControlsButtonsEnabled, \
                     wControlsDelayFrameCounter, \
                     _ControlsLoop

    check_keys_add hKeysHeld, PADF_DOWN
    call _RexDuckOn

    check_keys_add hKeysReleased, PADF_DOWN
    call _RexDuckOff

    check_keys_add hKeysHeld, PADF_A
    call _RexChargeJump

    check_keys_add hKeysReleased, PADF_A
    call _RexJump

    check_keys_add hKeysPressed, PADF_B
    ld a, SFX_MENU_B
    call _PlaySound
    jp _SwitchStateToPrevious

    check_keys_end _ControlsLoop

_ControlsVBlankHandler:
    call _ScanKeys
    call _RefreshOAM
    
    call _RexIncFrameCounter

    ret

ENDSECTION


SECTION "Controls State Variables", WRAM0

wControlsDelayFrameCounter:
    DB

wControlsButtonsEnabled:
    DB

ENDSECTION
