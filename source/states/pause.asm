INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Pause", ROM0

_Pause::
    call _DrawPauseScreenHUD

    ; fallthrough
    
_PauseLoop:
    ei
    
    call _WaitForVBLInterrupt

.checkKeys:
    ldh a, [hKeysPressed]
    and a, PADF_START
    jr z, _PauseLoop
    
    jp _SwitchStateToPrevious

ENDSECTION
