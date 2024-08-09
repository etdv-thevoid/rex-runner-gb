INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"


SECTION "Sound Data", ROM0

/*
SOUND BYTES:
    - `channel`     = channel # | $C0
    - `length`      = total number of sounds

    - `duration`    = cycles to play following sound values
    - `rNRx0`       = byte value for channel register
    - `rNRx1`       = byte value for channel register
    - `rNRx2`       = byte value for channel register
    - `rNRx3`       = byte value for channel register
    - `rNRx4`       = byte value for channel register

    - `buffer`      = $00, $00 buffer for bit shifts

FORMAT:
    DB `channel`, `length`
    DB `duration`, `rNRx0`, `rNRx1`, `rNRx2`, `rNRx3`, `rNRx4`, `buffer`

*/
_SoundDataTable::
    DW _SfxMenuA
    DW _SfxMenuB
    DW _SfxJump
    DW _SfxDead
    DW _SfxScore
    DW _SfxSecret
    DW _NULL

_SfxMenuA:
    DB  $C1, 3
    DB  3, AUD1SWEEP_UP, $00, $70, $16, $84
    DB  0, 0
    DB  5, AUD1SWEEP_UP, $40, $70, $63, $85
    DB  0, 0
    DB  1, AUD1SWEEP_UP, $00, $00, $00, $00
    DB  0, 0

_SfxMenuB:
    DB  $C1, 3
    DB  3, AUD1SWEEP_UP, $00, $70, $16, $84
    DB  0, 0
    DB  5, AUD1SWEEP_UP, $40, $70, $56, $83
    DB  0, 0
    DB  1, AUD1SWEEP_UP, $00, $00, $00, $00
    DB  0, 0

_SfxJump:
    DB  $C3, 2
    DB  3, AUD3ENA_ON,  $00, AUD3LEVEL_100,  $84, $C7
    DB  0, 0
    DB  1, AUD3ENA_OFF, $00, AUD3LEVEL_MUTE, $00, $00
    DB  0, 0

_SfxDead:
    DB  $C1, 4
    DB  3, AUD1SWEEP_UP, $B3, $F0, $1F, $80
    DB  0, 0
    DB  2, AUD1SWEEP_UP, $B7, $00, $1F, $80
    DB  0, 0
    DB  5, AUD1SWEEP_UP, $AA, $F0, $1F, $80
    DB  0, 0
    DB  1, AUD1SWEEP_UP, $00, $00, $00, $00
    DB  0, 0

_SfxScore:
    DB  $C1, 3
    DB  5, AUD1SWEEP_UP, $AA, $F0, $07, $87
    DB  0, 0
    DB 15, AUD1SWEEP_UP, $84, $F0, $59, $87
    DB  0, 0
    DB  1, AUD1SWEEP_UP, $00, $00, $00, $00
    DB  0, 0

_SfxSecret:
    DB  $C1, 3
    DB  5, AUD1SWEEP_UP, $84, $F0, $59, $87
    DB  0, 0
    DB 15, AUD1SWEEP_UP, $AA, $F0, $07, $87
    DB  0, 0
    DB  1, AUD1SWEEP_UP, $00, $00, $00, $00
    DB  0, 0

ENDSECTION
