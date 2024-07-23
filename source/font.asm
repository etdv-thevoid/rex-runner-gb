INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Font Tiles Example", ROM0

; gbc-engine-core requires a .1bpp set of font tiles in ASCII format for the crash screen.
;
; Format:
;
;```
; !"#$%&'()*+,-./
;0123456789:;<=>?
;@ABCDEFGHIJKLMNO
;PQRSTUVWXYZ[\]^_
;`abcdefghijklmno
;pqrstuvwxyz{|}~
;```
_FontTiles::
    INCBIN "assets/font.1bpp"
.end::

ENDSECTION
