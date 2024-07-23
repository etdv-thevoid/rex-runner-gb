INCLUDE "includes/constants.inc"
INCLUDE "includes/macros.inc"
INCLUDE "includes/charmap.inc"

SECTION "Program Main Example", ROM0

; The main program loop.
;
; `gbc-engine-core` hands off code execution to a function labeled `_Main` when done with initial setup.
;
;The function can assume the following:
; - All ram areas are cleared
; - LCD is off
; - Interrupts are disabled
_Main::
    ; Your code goes here!


    ; returning out of _Main will cause a crash!
    ret

ENDSECTION
