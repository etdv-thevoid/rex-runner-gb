INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Game Over Functions", ROM0

_InitGameOver::
    ld hl, {GAME_OVER_SPRITE_0}
    ld a, OFFSCREEN_SPRITE_Y_POS
    ld [hl+], a
    ld a, GAME_OVER_X_POS_0
    ld [hl+], a
    ld a, GAME_OVER_SPRITE_0_TILE
    ld [hl], a

    ld hl, {GAME_OVER_SPRITE_1}
    ld a, OFFSCREEN_SPRITE_Y_POS
    ld [hl+], a
    ld a, GAME_OVER_X_POS_1
    ld [hl+], a
    ld a, GAME_OVER_SPRITE_1_TILE
    ld [hl], a

    ret

_SpawnGameOver::
    ld hl, {GAME_OVER_SPRITE_0}
    ld a, GAME_OVER_Y_POS_0
    ld [hl], a

    ld hl, {GAME_OVER_SPRITE_1}
    ld a, GAME_OVER_Y_POS_0
    ld [hl], a

    ret

ENDSECTION
