INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Credits", ROM0

_Credits::
    call _LoadTilemapCredits

    ld a, WINDOW_OFF
    call _ScreenOn
    
.loop:
    ei
    
    call _WaitForVBLInterrupt

    call _RexAnimate

.checkKeys:
    ldh a, [hKeysPressed]
    and a, PADF_START | PADF_SELECT | PADF_B | PADF_A
    jr z, .loop
    jp _SwitchStateToPrevious

ENDSECTION
