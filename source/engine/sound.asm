INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"


SECTION "Sound Functions", ROM0

/*******************************************************************************
**                                                                            **
**      INIT SOUND FUNCTION                                                   **
**                                                                            **
*******************************************************************************/

_InitSound::
    ld hl, STARTOF("Sound Variables")
    ld b, SIZEOF("Sound Variables")
    xor a
    call _MemSetFast

    ld hl, xTriangleWaveform
    ld de, _AUD3WAVERAM
    ld b, $10
    call _MemCopyFast

    ld a, AUDENA_ON
    ldh [rNR52], a
    
    ld a, AUDTERM_3_LEFT | AUDTERM_1_LEFT | AUDTERM_3_RIGHT | AUDTERM_1_RIGHT
    ldh [rNR51], a
            
    ld a, $77 
    ldh [rNR50], a

    ld bc, _UpdateSound
    rst _SetTIMHandler

    ld a, $C4 ; 60 Hz
    ldh [rTMA], a
    ld a, TACF_START|TACF_4KHZ
    ldh [rTAC], a
    xor a
    ldh [rTIMA], a
    
    ldh a, [rIE]
    or a, IEF_TIMER
    ldh [rIE], a

    ret 


/*******************************************************************************
**                                                                            **
**      PLAY SOUND FUNCTION                                                   **
**                                                                            **
*******************************************************************************/

_PlaySound::
    ldh [hSoundType], a
    
    ld hl, xSoundLookupTable
    sla a
    add l
    ld l, a
    ld a, h
    adc 0
    ld h, a
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [hl+]

    cp SOUND_CH_1
    jp z, .ch1

    cp SOUND_CH_3
    jp z, .ch3

    ret

.ch1:
    ldh a, [hSoundType]
    ldh [hSoundCh1Type], a
    
    ld a, [hl+]
    ldh [hSoundCh1Length], a

    xor a
    ldh [hSoundCh1Count], a
    ldh [hSoundCh1Duration], a
    
    ret

.ch3:
    ldh a, [hSoundType]
    ldh [hSoundCh3Type], a
    
    ld a, [hl+]
    ldh [hSoundCh3Length], a
    
    xor a
    ldh [hSoundCh3Count], a
    ldh [hSoundCh3Duration], a
    
    ret

/*******************************************************************************
**                                                                            **
**      INTERRUPT FUNCTION                                                    **
**                                                                            **
*******************************************************************************/

_UpdateSound:
    ldh a, [hSoundCh1Duration]
    or a
    jr z, .ch1

    dec a
    ldh [hSoundCh1Duration], a
    jr .next

.ch1:
    ldh a, [hSoundCh1Length]
    or a
    jr z, .next

    ld hl, xSoundLookupTable
    ldh a, [hSoundCh1Type]
    sla a
    ld c, a
    ld b, 0
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a

    inc hl
    inc hl

    ldh a, [hSoundCh1Count]
    sla a
    sla a
    sla a
    ld c, a
    ld b, 0
    add hl, bc

    ld a, [hl+]
    ldh [hSoundCh1Duration], a

    ld bc, rNR10
    ld a, [hl+]
    ld [bc], a
    inc bc
    ld a, [hl+]
    ld [bc], a
    inc bc
    ld a, [hl+]
    ld [bc], a
    inc bc
    ld a, [hl+]
    ld [bc], a
    inc bc
    ld a, [hl+]
    ld [bc], a
    inc bc

    ld hl,hSoundCh1Count
    inc [hl]
    ld hl,hSoundCh1Length
    dec [hl]

.next:
    ldh a, [hSoundCh3Duration]
    or a
    jr z, .ch3

    dec a
    ldh [hSoundCh3Duration], a
    jr .done
    
.ch3:
    ldh a, [hSoundCh3Length]
    or a
    jr z, .done
    
    ld hl, xSoundLookupTable
    ldh a, [hSoundCh3Type]
    sla a
    ld c, a
    ld b, 0
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a

    inc hl
    inc hl

    ldh a, [hSoundCh3Count]
    sla a
    sla a
    sla a
    ld c, a
    ld b, 0
    add hl, bc

    ld a, [hl+]
    ldh [hSoundCh3Duration], a

    ld bc, rNR30
    ld a, [hl+]
    ld [bc], a
    inc bc
    ld a, [hl+]
    ld [bc], a
    inc bc
    ld a, [hl+]
    ld [bc], a
    inc bc
    ld a, [hl+]
    ld [bc], a
    inc bc
    ld a, [hl+]
    ld [bc], a
    inc bc

    ld hl, hSoundCh3Count
    inc [hl]
    ld hl, hSoundCh3Length
    dec [hl]

.done:
    ret

ENDSECTION


SECTION "Sound Data", ROMX

/*******************************************************************************
**                                                                            **
**      SOUND DATA                                                            **
**                                                                            **
*******************************************************************************/

xTriangleWaveform:
    DB $01, $23, $45, $67, $89, $AB, $CD, $EF
    DB $FE, $DC, $BA, $98, $76, $54, $32, $10

/*
SOUND BYTES:
    - `SOUND_CH_X`  = channel
    - `length`      = total number of sounds

    - `duration`    = cycles to play following sound values
    - `rNRx0`       = byte value for channel register
    - `rNRx1`       = byte value for channel register
    - `rNRx2`       = byte value for channel register
    - `rNRx3`       = byte value for channel register
    - `rNRx4`       = byte value for channel register

    - `buffer`      = $00, $00 buffer for bit shifts

FORMAT:
    DB `SOUND_CH_X`, `length`
    DB `duration`, `rNRx0`, `rNRx1`, `rNRx2`, `rNRx3`, `rNRx4`, `buffer`

*/
xSoundLookupTable:
    DW xSfxMenuA
    DW xSfxMenuB
    DW xSfxJump
    DW xSfxDead
    DW xSfxScore
    DW xSfxSecret
    DW _NULL

xSfxMenuA:
    DB  SOUND_CH_1, 3
    DB  3, AUD1SWEEP_UP, $00, $70, $16, $84
    DB  0, 0
    DB  5, AUD1SWEEP_UP, $40, $70, $63, $85
    DB  0, 0
    DB  1, AUD1SWEEP_UP, $00, $00, $00, $00
    DB  0, 0

xSfxMenuB:
    DB  SOUND_CH_1, 3
    DB  3, AUD1SWEEP_UP, $00, $70, $16, $84
    DB  0, 0
    DB  5, AUD1SWEEP_UP, $40, $70, $56, $83
    DB  0, 0
    DB  1, AUD1SWEEP_UP, $00, $00, $00, $00
    DB  0, 0

xSfxJump:
    DB  SOUND_CH_3, 2
    DB  3, AUD3ENA_ON,  $00, AUD3LEVEL_100,  $84, $C7
    DB  0, 0
    DB  1, AUD3ENA_OFF, $00, AUD3LEVEL_MUTE, $00, $00
    DB  0, 0

xSfxDead:
    DB  SOUND_CH_1, 4
    DB  3, AUD1SWEEP_UP, $B3, $F0, $1F, $80
    DB  0, 0
    DB  2, AUD1SWEEP_UP, $B7, $00, $1F, $80
    DB  0, 0
    DB  5, AUD1SWEEP_UP, $AA, $F0, $1F, $80
    DB  0, 0
    DB  1, AUD1SWEEP_UP, $00, $00, $00, $00
    DB  0, 0

xSfxScore:
    DB  SOUND_CH_1, 3
    DB  5, AUD1SWEEP_UP, $AA, $F0, $07, $87
    DB  0, 0
    DB 15, AUD1SWEEP_UP, $84, $F0, $59, $87
    DB  0, 0
    DB  1, AUD1SWEEP_UP, $00, $00, $00, $00
    DB  0, 0

xSfxSecret:
    DB  SOUND_CH_1, 3
    DB  5, AUD1SWEEP_UP, $84, $F0, $59, $87
    DB  0, 0
    DB 15, AUD1SWEEP_UP, $AA, $F0, $07, $87
    DB  0, 0
    DB  1, AUD1SWEEP_UP, $00, $00, $00, $00
    DB  0, 0

ENDSECTION


SECTION "Sound Variables", HRAM

hSoundType:
    DB

hSoundCh1Type:
    DB

hSoundCh1Length:
    DB

hSoundCh1Count:
    DB

hSoundCh1Duration:
    DB

hSoundCh3Type:
    DB

hSoundCh3Length:
    DB

hSoundCh3Count:
    DB

hSoundCh3Duration:
    DB

ENDSECTION
