INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Dead", ROM0

_Dead::
    call _RexDead

    ld a, WINDOW_OFF
    call _ScreenOn
    
.loop:
    ei
    
    call _WaitForVBLInterrupt

.checkKeys:
    ldh a, [hKeysPressed]
    and a, PADF_START | PADF_SELECT | PADF_B | PADF_A
    jr z, .loop
    call _SaveHighScore
    ld a, STATE_INIT
    jp _SwitchStateToNew

ENDSECTION
