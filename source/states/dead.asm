INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Dead", ROM0

_Dead::
    call _RexDead

    call _DrawGameOverHUD

    ld a, SFX_DEAD
    call _PlaySound
    
    ; fallthrough
    
_DeadLoop:
    ei
    
    call _WaitForVBLInterrupt

.checkKeys:
    ldh a, [hKeysPressed]
    and a, PADF_A
    jr z, _DeadLoop
    
    call _SaveHighScore
    ld a, STATE_INIT
    jp _SwitchStateToNew

ENDSECTION
