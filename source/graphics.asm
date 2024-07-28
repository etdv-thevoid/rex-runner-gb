INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"


SECTION "Graphics", ROM0

/*******************************************************************************
**                                                                            **
**      LOAD GRAPHICS FUNCTION                                                **
**                                                                            **
*******************************************************************************/

_LoadGraphics::
    xor a
    ld hl, _SpriteTiles
    ld bc, (_SpriteTiles.end - _SpriteTiles)
    ld de, vBLK01.0
    call _VideoMemCopy

    xor a
    ld hl, _BackgroundTiles
    ld bc, (_BackgroundTiles.end - _BackgroundTiles)
    ld de, vBLK01.128
    call _VideoMemCopy

    xor a
    ld hl, _HUDTiles
    ld bc, (_HUDTiles.end - _HUDTiles)
    ld de, vBLK21.0
    call _VideoMemCopy

    xor a
    ld hl, _FontTiles
    ld bc, (_FontTiles.end - _FontTiles)
    ld de, vBLK21.32
    jp _VideoMemCopyMonochrome


/*******************************************************************************
**                                                                            **
**      LOAD TILEMAP FUNCTIONS                                                **
**                                                                            **
*******************************************************************************/

_LoadTilemapMenu::
    xor a
    ld hl, _MenuTilemap
    ld bc, (_MenuTilemap.end - _MenuTilemap)
    ld de, vSCRN0
    jp _VideoMemCopy

_LoadTilemapCredits::
    xor a
    ld hl, _CreditsTilemap
    ld bc, (_CreditsTilemap.end - _CreditsTilemap)
    ld de, vSCRN0
    jp _VideoMemCopy

_LoadTilemapBackground::
    xor a
    ld hl, _BackgroundTilemap
    ld bc, (_BackgroundTilemap.end - _BackgroundTilemap)
    ld de, vSCRN0
    jp _VideoMemCopy

_LoadTilemapBackgroundNight::
    xor a
    ld hl, _BackgroundNightTilemap
    ld bc, (_BackgroundNightTilemap.end - _BackgroundNightTilemap)
    ld de, vSCRN0
    jp _VideoMemCopy


/*******************************************************************************
**                                                                            **
**      TILE GRAPHICS                                                         **
**                                                                            **
*******************************************************************************/

_SpriteTiles:
    INCBIN "assets/sprites.2bpp"
.end:

_BackgroundTiles:
    INCBIN "assets/background.2bpp"
.end:

_HUDTiles:
    INCBIN "assets/hud.2bpp"
.end:

_FontTiles::
    INCBIN "assets/font.1bpp"
.end:: 


/*******************************************************************************
**                                                                            **
**      TILEMAPS                                                              **
**                                                                            **
*******************************************************************************/

_MenuTilemap:
    INCBIN "tilemaps/menu.tilemap"
.end:

_CreditsTilemap:
    INCBIN "tilemaps/credits.tilemap"
.end:

_BackgroundTilemap:
    INCBIN "tilemaps/background.tilemap"
.end:

_BackgroundNightTilemap:
    INCBIN "tilemaps/background_night.tilemap"
.end:

ENDSECTION
