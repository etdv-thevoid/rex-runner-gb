INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Controls State", ROM0

_Controls::
    call _ScreenOff
    
    call _LoadTilemapControls

    call _RexStand
    
    xor a
    ld [wControlsDelayFrameCounter], a
    ld [wControlsButtonsEnabled], a

    ld a, SFX_JUMP
    call _PlaySound

    ld a, WINDOW_OFF
    call _ScreenOn

    ; fallthrough
    
_ControlsLoop:
    ei
    call _WaitForVBLInterrupt

    call _RexAnimate
    
    ld a, [wControlsButtonsEnabled]
    and a
    jr nz, .checkKeys

    ld a, [wControlsDelayFrameCounter]
    inc a
    ld [wControlsDelayFrameCounter], a
    and a, BUTTON_DELAY_FRAMES_MASK
    jr nz, _ControlsLoop

    ld a, TRUE
    ld [wControlsButtonsEnabled], a

    jr _ControlsLoop

.checkKeys:
    ldh a, [hKeysHeld]
    and a, PADF_DOWN
    jr z, :+
    call _RexDuckOn
:
    ldh a, [hKeysReleased]
    and a, PADF_DOWN
    jr z, :+
    call _RexDuckOff
:
    ldh a, [hKeysHeld]
    and a, PADF_A
    jr z, :+
    call _RexChargeJump
:
    ldh a, [hKeysReleased]
    and a, PADF_A
    jr z, :+
    call _RexJump
:
    ldh a, [hKeysPressed]
    and a, PADF_B
    jr z, :+
    
    ld a, SFX_JUMP
    call _PlaySound
    jp _SwitchStateToPrevious
:
    jr _ControlsLoop

ENDSECTION


SECTION "Controls State Variables", WRAM0

wControlsDelayFrameCounter:
    DB

wControlsButtonsEnabled:
    DB

ENDSECTION
