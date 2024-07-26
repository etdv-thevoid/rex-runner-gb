INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Difficulty Functions", ROM0

_InitDifficulty::
    
    ld a, INITIAL_SPEED
    ld [wDifficultySpeed], a

    ret

_GetDifficultySpeed::
    ld a, [wDifficultySpeed]
    ret

_DifficultyIncrementSpeed::
    ld a, [wDifficultySpeed]
    inc a
    ld [wDifficultySpeed], a
    ret

ENDSECTION


SECTION "Difficulty Variables", WRAM0

wDifficultySpeed:
    DB

ENDSECTION