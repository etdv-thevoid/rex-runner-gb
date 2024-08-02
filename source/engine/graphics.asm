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
    ldh [rVBK], a

    ld hl, xSpriteTiles
    ld bc, (xSpriteTiles.end - xSpriteTiles)
    ld de, vBLK01.0
    call _MemCopy

    ld hl, xBackgroundTiles
    ld bc, (xBackgroundTiles.end - xBackgroundTiles)
    ld de, vBLK01.128
    call _MemCopy

    ld hl, xHUDTiles
    ld bc, (xHUDTiles.end - xHUDTiles)
    ld de, vBLK21.0
    call _MemCopy

    ld hl, _FontTiles
    ld bc, (_FontTiles.end - _FontTiles)
    ld de, vBLK21.32
    call _MemCopyMonochrome

    ld hl, vSCRN0
    ld bc, (vSCRN0.end - vSCRN0)
    ld d, " "
    call _MemSet
    
    ld hl, vSCRN1
    ld bc, (vSCRN1.end - vSCRN1)
    ld d, " "
    call _MemSet

    call _IsGBColor
    ret z

    ld a, 1
    ldh [rVBK], a

    ld hl, vSCRN0
    ld bc, (vSCRN0.end - vSCRN0)
    ld d, $00
    call _MemSet
    
    ld hl, vSCRN1
    ld bc, (vSCRN1.end - vSCRN1)
    ld d, $00
    call _MemSet

    xor a
    ldh [rVBK], a

    call _SetBackgroundPaletteBlack
    call _SetSpritePaletteWhite

    ; fallthrough


/*******************************************************************************
**                                                                            **
**      LOAD PALETTE FUNCTIONS                                                **
**                                                                            **
*******************************************************************************/

_LoadMonochromeColorPalette::
    ld a, DEFAULT_BG_PALETTE
	ldh [rBGP], a
    ld [wCurrentPalette], a
    
    ld a, DEFAULT_OBJ_PALETTE
    ldh [rOBP0], a
    cpl
    ldh [rOBP1], a

    call _IsGBColor
    ret z

    xor a
    ld hl, xMonochromeBGPalette
    call _SetBackgroundPalette
    
    xor a
    ld hl, xMonochromeOBJPalette
    jp _SetSpritePalette

_LoadMonochromeColorPaletteInverted::
    ld a, INVERTED_BG_PALETTE
	ldh [rBGP], a
    ld [wCurrentPalette], a

    ld a, INVERTED_OBJ_PALETTE
    ldh [rOBP0], a
    cpl
    ldh [rOBP1], a

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
**      RESET FUNCTION                                                        **
**                                                                            **
*******************************************************************************/

_ResetScreen::
    call _ScreenOff

    xor a
    ldh [rSCY], a
    ldh [rSCX], a
    ldh [rWY], a
    add WX_OFS
    ldh [rWX], a
    
    ld hl, wShadowOAM
    ld b, (wShadowOAM.end - wShadowOAM)
    ld a, $00
    call _MemSetFast

    jp _RefreshOAM

/*******************************************************************************
**                                                                            **
**      LOAD TILEMAP FUNCTIONS                                                **
**                                                                            **
*******************************************************************************/

_LoadTilemapMenu::
    ld hl, xMenuTilemap
    ld bc, (xMenuTilemap.end - xMenuTilemap)
    ld de, vSCRN0
    jp _MemCopy

_LoadTilemapSecret::
    ld hl, xSecretTilemap
    ld bc, (xSecretTilemap.end - xSecretTilemap)
    ld de, vSCRN0
    jp _MemCopy

_LoadTilemapControls::
    ld hl, xControlsTilemap
    ld bc, (xControlsTilemap.end - xControlsTilemap)
    ld de, vSCRN0
    jp _MemCopy

_LoadTilemapScoreboard::
    ld hl, xScoreboardTilemap
    ld bc, (xScoreboardTilemap.end - xScoreboardTilemap)
    ld de, vSCRN0
    jp _MemCopy

_LoadTilemapAbout::
    ld hl, xAboutTilemap
    ld bc, (xAboutTilemap.end - xAboutTilemap)
    ld de, vSCRN0
    jp _MemCopy

_LoadTilemapBackground::
    ld hl, xBackgroundTilemap
    ld bc, (xBackgroundTilemap.end - xBackgroundTilemap)
    ld de, vSCRN0
    jp _MemCopy

_LoadTilemapBackgroundDay::
    xor a
    ld hl, xBackgroundDayTilemap
    ld b, (xBackgroundDayTilemap.end - xBackgroundDayTilemap)
    ld de, vSCRN0.y4x0
    jp _VideoMemCopyFast

_LoadTilemapBackgroundNight::
    xor a
    ld hl, xBackgroundNightTilemap
    ld b, (xBackgroundNightTilemap.end - xBackgroundNightTilemap)
    ld de, vSCRN0.y4x0
    jp _VideoMemCopyFast

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
    rgb_palette #DFDFDF, #9F9F9F, #606060, #202020
.end:

xMonochromeBGPaletteInverted:
    rgb_palette #202020, #606060, #9F9F9F, #DFDFDF
.end:

xMonochromeOBJPalette:
    rgb_palette #DFDFDF, #DFDFDF, #606060, #202020
.end:

xMonochromeOBJPaletteInverted:
    rgb_palette #202020, #202020, #9F9F9F, #DFDFDF
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

xScoreboardTilemap:
    INCBIN "assets/scoreboard.tilemap"
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


SECTION "Graphics Variables", WRAM0

wCurrentPalette::
    DB

ENDSECTION
