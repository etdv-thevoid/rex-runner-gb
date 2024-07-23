# Style Conventions

- All labels are `PascalCase`, with an appropriate prefix:
  - Prefix `_`: ROM0
  - Prefix `x`: ROMX
  - Prefix `v`: VRAM
  - Prefix `s`: SRAM
  - Prefix `w`: WRAM
  - Prefix `o`: OAM
  - Prefix `h`: HRAM
- All sublabels are `camelCase`

- Macros are in `snake_case`
- Constants are in `ALL_CAPS`

- Instructions are in `lowercase` (`ld`, `jp`, `call`, etc...)
- Directives are in `UPPERCASE` (`INCLUDE`, `SECTION`, `DB`, etc...)

- Hex addresses use the uppercase format (`$0123456789ABCDEF`)
