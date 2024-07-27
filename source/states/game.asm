INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Game", ROM0

_Game::
    call _LoadTilemapBackground

    call _DrawHighScoreString
    call _DrawHighScore

    call _RexFullJump

    ld a, WINDOW_OFF
    call _ScreenOn

    ; fallthrough

_GameLoop:
    ei
    
    call _WaitForVBLInterrupt

    call _RexAnimate
    call _PteroAnimate

    call _PteroTrySpawn
    
    call _DrawCurrentScore

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
    call _RexFullJump
:
    ldh a, [hKeysReleased]
    and a, PADF_A
    jr z, :+
    call _RexShortJump
:
    ldh a, [hKeysPressed]
    and a, PADF_B
    jr z, :+
    call _PteroTrySpawn
:
    ldh a, [hKeysPressed]
    and a, PADF_SELECT
    jr z, :+
    ld a, STATE_DEAD
    jp _SwitchStateToNew
:
    ldh a, [hKeysPressed]
    and a, PADF_START
    jr z, :+
    ld a, STATE_PAUSE
    jp _SwitchStateToNew
:
    jr _GameLoop

ENDSECTION
