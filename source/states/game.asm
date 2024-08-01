INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Game State", ROM0

_Game::
    call _GetStatePrevious
    cp a, STATE_PAUSE
    jr nz, .notFromPause

    call _DrawGameHUD
    jr _GameLoop

.notFromPause:
    call _ScreenOff
    
    call _GetStatePrevious
    cp a, STATE_DEAD
    jr nz, .notFromDead

    call _InitEngine

.notFromDead:
    call _LoadTilemapBackground
    call _LoadTilemapBackgroundDay
    
    call _RexJumpFull

    call _DrawGameHUD

    ld a, WINDOW_ON
    call _ScreenOn

    ; fallthrough

_GameLoop:
    ei
    call _WaitForVBLInterrupt

    call _UpdateScore
    
    call _UpdateGameHUD
    
    call _EngineCheckCollision
    ld a, STATE_DEAD
    jp c, _SwitchStateToNew

    call _EngineTrySpawn

    call _EngineAnimate

    ; no check_keys_start since we don't want input delays

    check_keys_add hKeysHeld, PADF_DOWN
    call _RexDuckOn

    check_keys_add hKeysReleased, PADF_DOWN
    call _RexDuckOff

    check_keys_add hKeysHeld, PADF_A
    call _RexChargeJump

    check_keys_add hKeysReleased, PADF_A
    call _RexJump

    check_keys_add hKeysPressed, PADF_START
    ld a, SFX_MENU_A
    call _PlaySound
    ld a, STATE_PAUSE
    jp _SwitchStateToNew

    check_keys_end _GameLoop


ENDSECTION
