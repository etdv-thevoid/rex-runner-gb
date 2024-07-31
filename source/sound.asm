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
    ld hl, xTriangleWaveform
    ld de, _AUD3WAVERAM
    ld b, $10
    call _MemCopyFast

    ld a, AUDENA_ON
    ldh [rNR52], a
    
    ld a, $55
    ldh [rNR51], a
            
    ld a, $77
    ldh [rNR50], a
    
    xor a
    ldh [hSoundType], a
    ldh [hSoundCh1Type], a
    ldh [hSoundCh1Length], a
    ldh [hSoundCh1Count], a
    ldh [hSoundCh1Duration], a
    ldh [hSoundCh3Type], a
    ldh [hSoundCh3Length], a
    ldh [hSoundCh3Count], a
    ldh [hSoundCh3Duration], a

    ld bc, _UpdateSound
    rst _SetTIMHandler

    ld a, (-64)
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
**      PLAY SOUND FUNCTIONS                                                  **
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
    jp z, _InitCh1

    cp SOUND_CH_3
    jp z, _InitCh3

    ret

_InitCh1:
    ldh a, [hSoundType]
    ldh [hSoundCh1Type], a
    
    ld a, [hl+]
    ldh [hSoundCh1Length], a

    xor a
    ldh [hSoundCh1Count], a
    ldh [hSoundCh1Duration], a
    
    ret

_InitCh3:
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
**      UPDATE SOUND FUNCTION                                                 **
**                                                                            **
*******************************************************************************/

_UpdateSound::
    call _UpdateCh1
    jp _UpdateCh3

_UpdateCh1:
    ldh a, [hSoundCh1Duration]
    or a
    jr z, .continue
    dec a
    ldh [hSoundCh1Duration], a
    jr .end

.continue:
    ldh a, [hSoundCh1Length]
    or a
    jr z, .end
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

.end:
    ret

_UpdateCh3:
    ldh a, [hSoundCh3Duration]
    or a
    jr z, .continue
    dec a
    ldh [hSoundCh3Duration], a
    jr .end
    
.continue:
    ldh a, [hSoundCh3Length]
    or a
    jr z, .end
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

.end:
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
    
xSoundLookupTable:
    DW xJumpSFX
    DW xScoreSFX
    DW xDeadSFX
    DW _NULL

xJumpSFX:
    DB SOUND_CH_3, 2
    DB  3, $80, $F8, $20, $84, $C7, $00, $00
    DB  1, $00, $00, $00, $00, $00, $00, $00

xScoreSFX:
    DB SOUND_CH_1, 3
    DB  5, $00, $AA, $F0, $07, $87, $00, $00
    DB 14, $00, $84, $F0, $59, $87, $00, $00
    DB  1, $00, $00, $00, $00, $00, $00, $00

xDeadSFX:
    DB SOUND_CH_1, 4
    DB  3, $00, $B3, $F0, $1F, $80, $00, $00
    DB  2, $00, $B7, $00, $1F, $80, $00, $00
    DB  5, $00, $AA, $F0, $1F, $80, $00, $00
    DB  1, $00, $00, $00, $00, $00, $00, $00

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
