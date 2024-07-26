INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Score Functions", ROM0

_InitScore::
    xor a
    ld [wScoreFrameCounter], a
    ld hl, wCurrentScore
REPT SCORE_BYTES
    ld [hl+], a
ENDR
    
    xor a
    ld hl, vSCRN1.y0x0
    ld b, 20
    ld d, " "
    jp _VideoMemSetFast

/**
Returns:
    - carry if high < current
    - no carry if high >= current
*/
_CompareScores:
    ld de, wCurrentScore.end
    ld hl, wHighScore.end
REPT SCORE_BYTES
    dec de
    dec hl
    ld a, [de]
    ld b, a             ; b = current score byte
    ld a, [hl]          ; a = high score byte
    cp a, b
    jr c, .lessThan     ; exit if high < current
    jr nz, .greaterThan ; exit if high > current
                        ; else compare next byte
ENDR

.greaterThan:           ; exit with no carry if high >= current
    scf
    ccf
    ret

.lessThan:              ; exit with carry if high < current
    scf
    ret

/**
Returns:
    - zero if no change of thousands digit
    - not zero if thousands digit changed
*/
_IncrementScore::
    ld a, [wScoreFrameCounter]
    inc a
    and SCORE_INCREMENT_MASK
    ld [wScoreFrameCounter], a
    ret nz

    ld hl, wCurrentScore + 1
    ld a, [hl]
    swap a
    and a, %00001111
    ld b, a

    scf
    ccf

    ld hl, wCurrentScore
    ld a, [hl]
    add a, 1
    daa
    ld [hl+], a
REPT SCORE_BYTES - 1
    ld a, [hl]
    adc a, 0
    daa
    ld [hl+], a
ENDR

    ld hl, wCurrentScore + 1
    ld a, [hl]
    swap a
    and a, %00001111
    ld c, a
    ld a, b
    cp a, c
    ret

_DrawCurrentScore::
    call _CompareScores
    jr nc, .skip

    xor a
    ld hl, wCurrentScore
    ld b, (wCurrentScore.end - wCurrentScore)
    ld c, $00
    ld de, vSCRN1.y0x3 + SCORE_DIGITS - 1
    call _DrawBCDNumber

.skip
    xor a
    ld hl, wCurrentScore
    ld b, (wCurrentScore.end - wCurrentScore)
    ld c, "0"
    ld de, vSCRN1.y0x14 + SCORE_DIGITS - 1
    jp _DrawBCDNumber

_DrawHighScore::
    xor a
    ld hl, wHighScore
    ld b, (wHighScore.end - wHighScore)
    ld c, $00
    ld de, vSCRN1.y0x3 + SCORE_DIGITS - 1
    jp _DrawBCDNumber

_DrawHighScoreString::
    xor a
    ld hl, _HighScoreString
    ld b, (_HighScoreString.end - _HighScoreString)
    ld de, vSCRN1.y0x0
    jp _VideoMemCopyFast

_HighScoreString:
    DB $10, $11, $12, $00, $00, $00, $00, $00, $00
.end:

_DrawBCDNumber:
    ldh [rVBK], a
.loop:
    call _WaitForScreenBlank
    ld a, [hl]          ; low nibble
    and a, %00001111
    add a, c
    ld [de], a
    dec de
    ld a, [hl+]         ; high nibble
    swap a
    and a, %00001111
    add a, c
    ld [de], a
    dec de
    dec b
    jr nz, .loop
    ret

ENDSECTION


SECTION "Score Variables", WRAM0

wScoreFrameCounter:
    DB

wCurrentScore:
    DS SCORE_BYTES
.end:

wHighScore:
    DS SCORE_BYTES
.end:

ENDSECTION


SECTION "Save Functions", ROM0

_LoadHighScore::
    ld hl, sHighScore
    ld bc, SCORE_BYTES ; (sHighScore.end - sHighScore)
    ld de, wHighScore
    jp _LoadFromSRAM

_SaveHighScore::
    call _CompareScores
    ret nc

    ld hl, wCurrentScore
    ld b, SCORE_BYTES ; (wCurrentScore.end - wCurrentScore)
    ld de, wHighScore
    call _MemCopyFast

    ld hl, wHighScore
    ld bc, SCORE_BYTES ; (wHighScore.end - wHighScore)
    ld de, sHighScore
    jp _SaveToSRAM

ENDSECTION


SECTION "Save Data", SRAM

sHighScore:
    DS SCORE_BYTES
.end:

ENDSECTION
