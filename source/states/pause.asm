INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Pause", ROM0

_Pause::


    ld a, WINDOW_OFF
    call _ScreenOn
    
.loop:
    ei
    
    call _WaitForVBLInterrupt

.checkKeys:
    ldh a, [hKeysPressed]
    and a, PADF_START
    jr z, .loop
    jp _SwitchStateToPrevious

ENDSECTION
