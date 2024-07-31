INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"


SECTION "Graphics Functions", ROM0

/*******************************************************************************
**                                                                            **
**      INIT GRAPHICS FUNCTION                                                **
**                                                                            **
*******************************************************************************/

_InitGraphics::
    call _ScreenOff
    
    xor a
    ld hl, xSpriteTiles
    ld bc, (xSpriteTiles.end - xSpriteTiles)
    ld de, vBLK01.0
    call _VideoMemCopy

    xor a
    ld hl, xBackgroundTiles
    ld bc, (xBackgroundTiles.end - xBackgroundTiles)
    ld de, vBLK01.128
    call _VideoMemCopy

    xor a
    ld hl, xHUDTiles
    ld bc, (xHUDTiles.end - xHUDTiles)
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
    ld hl, xMonochromeBGPalette
    call _SetBackgroundPalette
    
    xor a
    ld hl, xMonochromeOBJPalette
    jp _SetSpritePalette

_LoadMonochromeColorPaletteInverted::
    ld a, DEFAULT_PALETTE_INVERTED
    call _SetDMGPalettes

    call _IsGBColor
    ret z

    xor a
    ld hl, xMonochromeBGPaletteInverted
    call _SetBackgroundPalette
    
    xor a
    ld hl, xMonochromeOBJPaletteInverted
    jp _SetSpritePalette

/*******************************************************************************
**                                                                            **
**      LOAD TILEMAP FUNCTIONS                                                **
**                                                                            **
*******************************************************************************/

_LoadTilemapMenu::
    xor a
    ld hl, xMenuTilemap
    ld bc, (xMenuTilemap.end - xMenuTilemap)
    ld de, vSCRN0
    jp _VideoMemCopy

_LoadTilemapSecret::
    xor a
    ld hl, xSecretTilemap
    ld bc, (xSecretTilemap.end - xSecretTilemap)
    ld de, vSCRN0
    jp _VideoMemCopy

_LoadTilemapControls::
    xor a
    ld hl, xControlsTilemap
    ld bc, (xControlsTilemap.end - xControlsTilemap)
    ld de, vSCRN0
    jp _VideoMemCopy

_LoadTilemapAbout::
    xor a
    ld hl, xAboutTilemap
    ld bc, (xAboutTilemap.end - xAboutTilemap)
    ld de, vSCRN0
    jp _VideoMemCopy

_LoadTilemapBackground::
    xor a
    ld hl, xBackgroundTilemap
    ld bc, (xBackgroundTilemap.end - xBackgroundTilemap)
    ld de, vSCRN0.y11x0
    jp _VideoMemCopy

_LoadTilemapBackgroundDay::
    xor a
    ld hl, xBackgroundDayTilemap
    ld bc, (xBackgroundDayTilemap.end - xBackgroundDayTilemap)
    ld de, vSCRN0.y1x0
    jp _VideoMemCopy

_LoadTilemapBackgroundNight::
    xor a
    ld hl, xBackgroundNightTilemap
    ld bc, (xBackgroundNightTilemap.end - xBackgroundNightTilemap)
    ld de, vSCRN0.y1x0
    jp _VideoMemCopy

ENDSECTION


SECTION "Font Data", ROM0

_FontTiles::
    INCBIN "temp/font.1bpp"
.end:: 

ENDSECTION


SECTION "Graphics Data", ROMX

/*******************************************************************************
**                                                                            **
**      TILE GRAPHICS                                                         **
**                                                                            **
*******************************************************************************/

xSpriteTiles:
    INCBIN "temp/sprites.2bpp"
.end:

xBackgroundTiles:
    INCBIN "temp/background.2bpp"
.end:

xHUDTiles:
    INCBIN "temp/hud.2bpp"
.end:


/*******************************************************************************
**                                                                            **
**      GBC PALETTES                                                          **
**                                                                            **
*******************************************************************************/

xMonochromeBGPalette:
    rgb_palette #DEF, #ABC, #345, #012
.end:

xMonochromeBGPaletteInverted:
    rgb_palette #012, #345, #ABC, #DEF
.end:

xMonochromeOBJPalette:
    rgb_palette #DEF, #ABC, #345, #012
.end:

xMonochromeOBJPaletteInverted:
    rgb_palette #012, #345, #ABC, #DEF
.end:

/*******************************************************************************
**                                                                            **
**      TILEMAPS                                                              **
**                                                                            **
*******************************************************************************/

xMenuTilemap:
    INCBIN "assets/menu.tilemap"
.end:

xSecretTilemap:
    INCBIN "assets/menu_secret.tilemap"
.end:

xControlsTilemap:
    INCBIN "assets/controls.tilemap"
.end:

xAboutTilemap:
    INCBIN "assets/about.tilemap"
.end:

xBackgroundTilemap:
    INCBIN "assets/background.tilemap"
.end:

xBackgroundDayTilemap:
    INCBIN "assets/background_day.tilemap"
.end:

xBackgroundNightTilemap:
    INCBIN "assets/background_night.tilemap"
.end:

ENDSECTION
