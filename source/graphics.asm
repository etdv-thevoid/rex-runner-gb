INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Graphics Functions", ROM0

/*******************************************************************************
**                                                                            **
**      LOAD GRAPHICS                                                         **
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
**      INIT GRAPHICS                                                         **
**                                                                            **
*******************************************************************************/

_InitGraphics::
    xor a

    ldh [rSCY], a
    ldh [rSCX], a

    ldh [rWY], a
    add WX_OFS
    ldh [rWX], a

    xor a
    ld [wBackgroundScrollPosition], a
    ld [wBackgroundScrollPosition+1], a
    ld [wBackgroundParallaxTop], a
    ld [wBackgroundParallaxMiddle], a
    ld [wBackgroundParallaxBottom], a
    ld [wBackgroundParallaxGround], a

    ld a, DEFAULT_PALETTE
    ld [wBackgroundPalette], a
    call _SetDMGPalettes

    xor a
    ld hl, vSCRN0
    ld bc, (vSCRN0.end - vSCRN0)
    ld d, $FF
    call _VideoMemSet
    
    xor a
    ld hl, vSCRN1
    ld bc, (vSCRN1.end - vSCRN1)
    ld d, $FF
    call _VideoMemSet

    xor a
    ld hl, wShadowOAM
    ld bc, (wShadowOAM.end - wShadowOAM)
    ld d, $00
    call _MemSet

    jp _RefreshOAM


/*******************************************************************************
**                                                                            **
**      BACKGROUND                                                            **
**                                                                            **
*******************************************************************************/

_BackgroundIncScroll::
    call _GetDifficultySpeed
    ld b, a

    scf
    ccf

    ld hl, wBackgroundScrollPosition
    ld a, [hl]
    add a, b
    ld [hl+], a
    ld a, [hl]
    adc a, 0
    ld [hl], a

    scf
    ccf

    ld a, [wBackgroundScrollPosition]
    ld b, a
    ld a, [wBackgroundScrollPosition+1]
    ld c, a

REPT PARALLAX_BIT_SHIFTS_INITIAL
    srl c
    rr b
ENDR
    ld a, b
    ld [wBackgroundParallaxGround], a
    
REPT PARALLAX_BIT_SHIFTS_PER_SECTION
    srl c
    rr b
ENDR
    ld a, b
    ld [wBackgroundParallaxBottom], a
  
REPT PARALLAX_BIT_SHIFTS_PER_SECTION
    srl c
    rr b
ENDR
    ld a, b
    ld [wBackgroundParallaxMiddle], a

REPT PARALLAX_BIT_SHIFTS_PER_SECTION
    srl c
    rr b
ENDR
    ld a, b
    ld [wBackgroundParallaxTop], a

    ret

_BackgroundParallaxReset::
    xor a
    ldh [rSCX], a
    ret

_BackgroundParallaxTop::
    ld a, [wBackgroundParallaxTop]
    ldh [rSCX], a
    ret

_BackgroundParallaxMiddle::
    ld a, [wBackgroundParallaxMiddle]
    ldh [rSCX], a
    ret

_BackgroundParallaxBottom::
    ld a, [wBackgroundParallaxBottom]
    ldh [rSCX], a
    ret

_BackgroundParallaxGround::
    ld a, [wBackgroundParallaxGround]
    ldh [rSCX], a
    ret

_BackgroundInvertPalette::
    ld a, [wBackgroundPalette]
    cpl
    ld [wBackgroundPalette], a
    call _SetDMGPalettes
    cpl
    cp a, DEFAULT_PALETTE
    jp z, _LoadTilemapBackground
    jp _LoadTilemapBackgroundNight

/*******************************************************************************
**                                                                            **
**      WINDOW                                                                **
**                                                                            **
*******************************************************************************/


/*******************************************************************************
**                                                                            **
**      SPRITES                                                               **
**                                                                            **
*******************************************************************************/



ENDSECTION


SECTION "Graphics Assets", ROM0

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


SECTION "Graphics Variables", WRAM0

wBackgroundPalette:
    DB

wBackgroundScrollPosition:
    DW

wBackgroundParallaxTop:
    DB

wBackgroundParallaxMiddle:
    DB

wBackgroundParallaxBottom:
    DB

wBackgroundParallaxGround:
    DB

ENDSECTION
