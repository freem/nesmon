; hey you!
; yes, you.
; don't try and be "smart" and include multiple character sets in a single
; nesmon binary. That wastes space that could be used for other things.
; (In other words, only define one CHARSET variable.)

chr_charset:
.ifdef CHARSET0
	.incbin "charsets_1bpp/charset0.chr"
.endif

.ifdef CHARSET1
	.incbin "charsets_1bpp/charset1.chr"
.endif

.ifdef CHARSET2
	.incbin "charsets_1bpp/charset2.chr"
.endif

.ifdef CHARSET3
	.incbin "charsets_1bpp/charset3.chr"
.endif

.ifdef CHARSET4
	.incbin "charsets_1bpp/charset4.chr"
.endif

.ifdef CHARSET5
	.incbin "charsets_1bpp/charset5.chr"
.endif

.ifdef CHARSET6
	.incbin "charsets_1bpp/charset6.chr"
.endif

; GIANT IFNDEF SWITCH OF DOOM
; You MUST edit this if you add a new character set.

.ifndef CHARSET0
	.ifndef CHARSET1
	.ifndef CHARSET2
	.ifndef CHARSET3
	.ifndef CHARSET4
	.ifndef CHARSET5
	.ifndef CHARSET6
		.error "No valid CHARSET defined, or src/charsets_1bpp/charset.asm needs to be edited"
	.endif ;charset6
	.endif ;charset5
	.endif ;charset4
	.endif ;charset3
	.endif ;charset2
	.endif ;charset1
.endif ; charset0
