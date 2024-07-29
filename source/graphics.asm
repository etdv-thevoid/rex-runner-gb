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
    call _VideoMemCopyMonochrome

    call _IsGBColor
    ret z

    call _SetBackgroundPaletteBlack
    call _SetSpritePaletteWhite

    jp _LoadMonochromePalette


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
**      PALETTE FUNCTIONS                                                     **
**                                                                            **
*******************************************************************************/

_LoadMonochromePalette::
    xor a
    ld hl, _MonochromePalette
    call _SetBackgroundPalette

    xor a
    ld hl, _MonochromePalette
    jp _SetSpritePalette

_LoadMonochromePaletteInverted::
    xor a
    ld hl, _MonochromePaletteInverted
    call _SetBackgroundPalette

    xor a
    ld hl, _MonochromePaletteInverted
    jp _SetSpritePalette

/*******************************************************************************
**                                                                            **
**      TILE GRAPHICS                                                         **
**                                                                            **
*******************************************************************************/

_SpriteTiles:
    INCBIN "temp/sprites.2bpp"
.end:

_BackgroundTiles:
    INCBIN "temp/background.2bpp"
.end:

_HUDTiles:
    INCBIN "temp/hud.2bpp"
.end:

_FontTiles::
    INCBIN "temp/font.1bpp"
.end:: 


/*******************************************************************************
**                                                                            **
**      TILEMAPS                                                              **
**                                                                            **
*******************************************************************************/

_MenuTilemap:
    INCBIN "assets/menu.tilemap"
.end:

_CreditsTilemap:
    INCBIN "assets/credits.tilemap"
.end:

_BackgroundTilemap:
    INCBIN "assets/background.tilemap"
.end:

_BackgroundNightTilemap:
    INCBIN "assets/background_night.tilemap"
.end:


/*******************************************************************************
**                                                                            **
**      PALETTES                                                              **
**                                                                            **
*******************************************************************************/

_MonochromePalette:
    rgb_palette #FFF, #AAA, #555, #000
.end:

_MonochromePaletteInverted:
    rgb_palette #000, #555, #AAA, #FFF
.end:

ENDSECTION
