INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Interrupts", ROM0

_InitInterrupts::
    ld bc, _VBlankHandler
    rst _SetVBLHandler

    ld bc, _LCDStatHandler
    rst _SetLCDHandler

    ld a, LYC_HUD_START_LINE
    ldh [rLYC], a

    ld a, STATF_LYC
    ldh [rSTAT], a

    ld a, IEF_VBLANK | IEF_LCDC
    ldh [rIE], a

    ret

_VBlankHandler:
    call _ScanKeys
    call _RefreshOAM

    call _GetStateCurrent
    cp a, STATE_PAUSE
    ret z
    cp a, STATE_DEAD
    ret z

    call _RexIncFrameCounter

    call _GetStateCurrent
    cp a, STATE_GAME
    ret nz

    call _PteroIncFrameCounter

    call _BackgroundIncScroll

    call _IncrementScore
    ret nc

    call _DifficultyIncrementSpeed
    call _PteroIncSpawnChance

    jp _BackgroundInvertPalette

_LCDStatHandler:
    ldh a, [rLYC]
    cp a, LYC_PARALLAX_TOP_START_LINE
    jr z, .top
    cp a, LYC_PARALLAX_MIDDLE_START_LINE
    jr z, .middle
    cp a, LYC_PARALLAX_BOTTOM_START_LINE
    jr z, .bottom
    cp a, LYC_PARALLAX_GROUND_START_LINE
    jr z, .ground

.default:
    ld a, LYC_PARALLAX_TOP_START_LINE
    ldh [rLYC], a
    ld a, WINDOW_ON
    call _ScreenOn
    jp _BackgroundParallaxReset

.top:
    ld a, LYC_PARALLAX_MIDDLE_START_LINE
    ldh [rLYC], a
    ld a, WINDOW_OFF
    call _ScreenOn
    jp _BackgroundParallaxTop

.middle:
    ld a, LYC_PARALLAX_BOTTOM_START_LINE
    ldh [rLYC], a
    jp _BackgroundParallaxMiddle

.bottom:
    ld a, LYC_PARALLAX_GROUND_START_LINE
    ldh [rLYC], a
    jp _BackgroundParallaxBottom

.ground:
    ld a, LYC_HUD_START_LINE
    ldh [rLYC], a
    jp _BackgroundParallaxGround

ENDSECTION
