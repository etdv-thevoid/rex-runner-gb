INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"


SECTION "Graphics", ROM0

/*******************************************************************************
**                                                                            **
**      INIT GRAPHICS FUNCTION                                                **
**                                                                            **
*******************************************************************************/

_InitGraphics::
    call _ScreenOff
    
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

    xor a
    ld hl, vSCRN0
    ld bc, (vSCRN0.end - vSCRN0)
    ld d, " "
    call _VideoMemSet
    
    xor a
    ld hl, vSCRN1
    ld bc, (vSCRN1.end - vSCRN1)
    ld d, " "
    call _VideoMemSet

    call _IsGBColor
    ret z

    ld a, 1
    ld hl, vSCRN0
    ld bc, (vSCRN0.end - vSCRN0)
    ld d, $00
    call _VideoMemSet
    
    ld a, 1
    ld hl, vSCRN1
    ld bc, (vSCRN1.end - vSCRN1)
    ld d, $00
    call _VideoMemSet

    call _SetBackgroundPaletteBlack
    call _SetSpritePaletteWhite

    ; fallthrough


/*******************************************************************************
**                                                                            **
**      LOAD PALETTE FUNCTIONS                                                **
**                                                                            **
*******************************************************************************/

_LoadMonochromeColorPalette::
    ld a, DEFAULT_PALETTE
    call _SetDMGPalettes

    call _IsGBColor
    ret z

    xor a
    ld hl, _MonochromeBGPalette
    call _SetBackgroundPalette
    
    xor a
    ld hl, _MonochromeOBJPalette
    jp _SetSpritePalette

_LoadMonochromeColorPaletteInverted::
    ld a, DEFAULT_PALETTE_INVERTED
    call _SetDMGPalettes

    call _IsGBColor
    ret z

    xor a
    ld hl, _MonochromeBGPaletteInverted
    call _SetBackgroundPalette
    
    xor a
    ld hl, _MonochromeOBJPaletteInverted
    jp _SetSpritePalette

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
    ld de, vSCRN0.y11x0
    jp _VideoMemCopy

_LoadTilemapBackgroundDay::
    xor a
    ld hl, _BackgroundDayTilemap
    ld bc, (_BackgroundDayTilemap.end - _BackgroundDayTilemap)
    ld de, vSCRN0.y1x0
    jp _VideoMemCopy

_LoadTilemapBackgroundNight::
    xor a
    ld hl, _BackgroundNightTilemap
    ld bc, (_BackgroundNightTilemap.end - _BackgroundNightTilemap)
    ld de, vSCRN0.y1x0
    jp _VideoMemCopy


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
**      GBC PALETTES                                                          **
**                                                                            **
*******************************************************************************/

_MonochromeBGPalette:
    rgb_palette #DEF, #9AB, #456, #012
.end:

_MonochromeBGPaletteInverted:
    rgb_palette #012, #456, #9AB, #DEF
.end:

_MonochromeOBJPalette:
    rgb_palette #DEF, #9AB, #456, #012
.end:

_MonochromeOBJPaletteInverted:
    rgb_palette #012, #456, #9AB, #DEF
.end:

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

_BackgroundDayTilemap:
    INCBIN "assets/background_day.tilemap"
.end:

_BackgroundNightTilemap:
    INCBIN "assets/background_night.tilemap"
.end:

ENDSECTION
