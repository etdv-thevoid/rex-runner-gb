INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Game", ROM0

_Game::
    call _GetStatePrevious
    cp a, STATE_PAUSE
    jr nz, .skip

    call _DrawHUD
    jr _GameLoop

.skip:
    call _ScreenOff
    
    call _LoadTilemapBackground
    call _RexJump

    call _DrawHUD

    ld a, WINDOW_ON
    call _ScreenOn

    ; fallthrough

_GameLoop:
    ei
    
    call _WaitForVBLInterrupt

    call _EngineCheckCollision
    ld a, STATE_DEAD
    jp c, _SwitchStateToNew

    call _EngineAnimate

    call _EngineTrySpawn

    call _UpdateScore
    
    call _UpdateHUD

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
    and a, PADF_START
    jr z, :+
    ld a, STATE_PAUSE
    jp _SwitchStateToNew
:
    jr _GameLoop

ENDSECTION
