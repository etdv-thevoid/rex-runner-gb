INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"


SECTION "Save Data Functions", ROM0

_LoadHighScores::
    ld hl, STARTOF("Save Data")
    ld bc, SIZEOF("Save Data")
    ld de, STARTOF("Save Data Copy")
    jp _LoadFromSRAM

_SaveHighScores::
    call _SortScores
    ret nc

    ld hl, STARTOF("Save Data Copy")
    ld bc, SIZEOF("Save Data Copy")
    ld de, STARTOF("Save Data")
    jp _SaveToSRAM

_SaveHighScoresHard::
    call _SortScoresHard
    ret nc

    ld hl, STARTOF("Save Data Copy")
    ld bc, SIZEOF("Save Data Copy")
    ld de, STARTOF("Save Data")
    jp _SaveToSRAM

_DrawBCDNumber::
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
  
/**
Returns:
    - carry if high < current
    - no carry if high >= current
*/
_SortScores:
    ; Compare with 4
    ld hl, wHighScore4 + SCORE_BYTES
    ld de, wCurrentScore + SCORE_BYTES
    call _CompareScores
    ret nc

    ld hl, wCurrentScore
    ld b, SCORE_BYTES
    ld de, wHighScore4
    call _MemCopyFast

    ; Compare with 3
    ld hl, wHighScore3 + SCORE_BYTES
    ld de, wCurrentScore + SCORE_BYTES
    call _CompareScores
    jr nc, .done

    ld hl, wHighScore3
    ld b, SCORE_BYTES
    ld de, wHighScore4
    call _MemCopyFast
    
    ld hl, wCurrentScore
    ld b, SCORE_BYTES
    ld de, wHighScore3
    call _MemCopyFast

    ; Compare with 2
    ld hl, wHighScore2 + SCORE_BYTES
    ld de, wCurrentScore + SCORE_BYTES
    call _CompareScores
    jr nc, .done

    ld hl, wHighScore2
    ld b, SCORE_BYTES
    ld de, wHighScore3
    call _MemCopyFast
    
    ld hl, wCurrentScore
    ld b, SCORE_BYTES
    ld de, wHighScore2
    call _MemCopyFast

    ; Compare with 1
    ld hl, wHighScore1 + SCORE_BYTES
    ld de, wCurrentScore + SCORE_BYTES
    call _CompareScores
    jr nc, .done

    ld hl, wHighScore1
    ld b, SCORE_BYTES
    ld de, wHighScore2
    call _MemCopyFast
    
    ld hl, wCurrentScore
    ld b, SCORE_BYTES
    ld de, wHighScore1
    call _MemCopyFast
    
    ; Compare with 0
    ld hl, wHighScore0 + SCORE_BYTES
    ld de, wCurrentScore + SCORE_BYTES
    call _CompareScores
    jr nc, .done

    ld hl, wHighScore0
    ld b, SCORE_BYTES
    ld de, wHighScore1
    call _MemCopyFast
    
    ld hl, wCurrentScore
    ld b, SCORE_BYTES
    ld de, wHighScore0
    call _MemCopyFast

.done:
    scf
    ret

/**
Returns:
    - carry if high < current
    - no carry if high >= current
*/
_SortScoresHard:
    ; Compare with 4
    ld hl, wHighScore4Hard + SCORE_BYTES
    ld de, wCurrentScore + SCORE_BYTES
    call _CompareScores
    ret nc

    ld hl, wCurrentScore
    ld b, SCORE_BYTES
    ld de, wHighScore4Hard
    call _MemCopyFast

    ; Compare with 3
    ld hl, wHighScore3Hard + SCORE_BYTES
    ld de, wCurrentScore + SCORE_BYTES
    call _CompareScores
    jr nc, .done

    ld hl, wHighScore3Hard
    ld b, SCORE_BYTES
    ld de, wHighScore4Hard
    call _MemCopyFast
    
    ld hl, wCurrentScore
    ld b, SCORE_BYTES
    ld de, wHighScore3Hard
    call _MemCopyFast

    ; Compare with 2
    ld hl, wHighScore2Hard + SCORE_BYTES
    ld de, wCurrentScore + SCORE_BYTES
    call _CompareScores
    jr nc, .done

    ld hl, wHighScore2Hard
    ld b, SCORE_BYTES
    ld de, wHighScore3Hard
    call _MemCopyFast
    
    ld hl, wCurrentScore
    ld b, SCORE_BYTES
    ld de, wHighScore2Hard
    call _MemCopyFast

    ; Compare with 1
    ld hl, wHighScore1Hard + SCORE_BYTES
    ld de, wCurrentScore + SCORE_BYTES
    call _CompareScores
    jr nc, .done

    ld hl, wHighScore1Hard
    ld b, SCORE_BYTES
    ld de, wHighScore2Hard
    call _MemCopyFast
    
    ld hl, wCurrentScore
    ld b, SCORE_BYTES
    ld de, wHighScore1Hard
    call _MemCopyFast
    
    ; Compare with 0
    ld hl, wHighScore0Hard + SCORE_BYTES
    ld de, wCurrentScore + SCORE_BYTES
    call _CompareScores
    jr nc, .done

    ld hl, wHighScore0Hard
    ld b, SCORE_BYTES
    ld de, wHighScore1Hard
    call _MemCopyFast
    
    ld hl, wCurrentScore
    ld b, SCORE_BYTES
    ld de, wHighScore0Hard
    call _MemCopyFast

.done:
    scf
    ret


/**
Inputs:
    - hl = high score
    - de = current score

Returns:
    - carry if high < current
    - no carry if high >= current
*/
_CompareScores:
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
.lessThan:              ; exit with carry if high < current
    ret

ENDSECTION


SECTION "Save Data Copy", WRAM0

wHighScore0::
    DS SCORE_BYTES

wHighScore1::
    DS SCORE_BYTES

wHighScore2::
    DS SCORE_BYTES

wHighScore3::
    DS SCORE_BYTES

wHighScore4::
    DS SCORE_BYTES

wHighScore0Hard::
    DS SCORE_BYTES

wHighScore1Hard::
    DS SCORE_BYTES

wHighScore2Hard::
    DS SCORE_BYTES

wHighScore3Hard::
    DS SCORE_BYTES

wHighScore4Hard::
    DS SCORE_BYTES

ENDSECTION


SECTION "Save Data", SRAM

sHighScore0:
    DS SCORE_BYTES

sHighScore1:
    DS SCORE_BYTES

sHighScore2:
    DS SCORE_BYTES

sHighScore3:
    DS SCORE_BYTES

sHighScore4:
    DS SCORE_BYTES

sHighScore0Hard:
    DS SCORE_BYTES

sHighScore1Hard:
    DS SCORE_BYTES

sHighScore2Hard:
    DS SCORE_BYTES

sHighScore3Hard:
    DS SCORE_BYTES

sHighScore4Hard:
    DS SCORE_BYTES

ENDSECTION
