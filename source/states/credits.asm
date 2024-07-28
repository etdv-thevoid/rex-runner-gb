INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Credits", ROM0

_Credits::
    call _LoadTilemapCredits

    ld a, WINDOW_OFF
    call _ScreenOn
    
_CreditsLoop:
    ei
    
    call _WaitForVBLInterrupt

    call _RexAnimate

.checkKeys:
    ldh a, [hKeysPressed]
    and a, PADF_B | PADF_A
    jr z, _CreditsLoop
    jp _SwitchStateToPrevious

ENDSECTION
