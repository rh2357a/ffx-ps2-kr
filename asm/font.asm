.ps2
.open "build/files/file_0.elf", 0xff000

.definelabel fun_001bd3a0, 0x1bd3a0
.definelabel fun_0020a828, 0x20a828
.definelabel fun_0020b918, 0x20b918
.definelabel fun_0020b960, 0x20b960



; FUN_00205b40: placeholder?


; FUN_002053c0: 폰트폭 관련
;.org 0x2053e0
;	sltiu v0, a0, 0x30
;	bne v0, zero, _under_0x30
;	move s1, a1
;	jal fun_0020b960
;	move a0, a3
;	lbu v1, 0x0(s0)
;	addu v0, v1, v0
;	move a0, v1
;	b _ignore_legacy
;	lb t0, -0x30(v0)
;_under_0x30:
;	sltiu v0, a0, 0x24
;	bne v0, zero, _ignore_legacy
;	nop
;	jal fun_0020b960
;	move a0, zero
;	lbu a0, 0x0(s0)
;	li a1, 0xd0
;	lbu a2, 0x1(s0)
;	addiu v1, a0, -0x23
;	mult v1, v1, a1
;	addiu v1, v1, -0x30
;	addu v1, v1, a2
;	addu v0, v0, v1
;	b _ignore_legacy
;	lb t0, 0x0(v0)
;.org 0x2054f4
;_ignore_legacy:


; FUN_00204d70: 폰트 그래픽
.org 0x204d70
render_font:
.area 784, 0
	addiu sp, sp, -0x80
	sd s0, 0x10(sp)
	sd s1, 0x20(sp)
	sd s2, 0x30(sp)
	sd s3, 0x40(sp)
	sd a2, 0x50(sp)
	sd a3, 0x60(sp)
	sd ra, 0x70(sp)

	; *a0 < 0x24
	lbu v1, 0x0(a0)
	sltiu v0, v1, 0x24
	beq v0, zero, @@_valid
	nop

	; return
	ld s0, 0x10(sp)
	ld s1, 0x20(sp)
	ld s2, 0x30(sp)
	ld s3, 0x40(sp)
	ld a2, 0x50(sp)
	ld a3, 0x60(sp)
	ld ra, 0x70(sp)
	jr ra
	addiu sp, sp, 0x80

@@_valid:
	move s1, a0

	; *0x3257d0 != 1
	lui v0, 0x32
	lw v1, 0x57d0(v0)
	li v0, 0x1
	bne v1, v0, @@_is_korean
	nop

	; fun_001bd3a0() == 0
	jal fun_001bd3a0
	nop
	beq v0, zero, @@_is_korean
	nop

	li s0, 0x3d40
	sh s0, 0x0(a1)
	b @@_glyph_idx
	nop

@@_is_korean:
	li s0, 0x3c00
	sh s0, 0x0(a1)

@@_glyph_idx:
	jal fun_0020a828
	nop
	jal fun_0020b960
	move a0, v0

	move a2, v0
	move a0, s1
	li a3, 0

	; *a3 < 0x30
	lbu v0, 0x0(a0)
	sltiu v0, v0, 0x30
	beq v0, zero, @@_not_multibyte
	nop

	; a3 = (*a0 - 0x23) * 0xd0
	; a0++;
	lbu a3, 0x0(a0)
	addiu a3, a3, -0x2b ; TODO: -0x23
	li v1, 0xd0
	mult a3, a3, v1
	addiu a0, a0, 0x1

@@_not_multibyte:
	; a3 = a3 - 0x30 + *a3++
	lbu s1, 0x0(a0)
	addiu a3, a3, -0x30
	addu a3, a3, s1
	addiu a0, a0, 0x1

	lui s0, 0x7a
	addiu s0, s0, -0x8000 + 0x5c - 0x40 ; 0x798000 + 0x5c - 0x40
	jr s0
	nop
.endarea


; FUN_00205080: 폰트 그래픽 (언어 설정 강제)
.org 0x205080
render_font_2:
.area 624, 0
	addiu sp, sp, -0x80
	sd s0, 0x10(sp)
	sd s1, 0x20(sp)
	sd s2, 0x30(sp)
	sd s3, 0x40(sp)
	sd a2, 0x50(sp)
	sd a3, 0x60(sp)
	sd ra, 0x70(sp)

	; *a0 < 0x24
	lbu v1, 0x0(a0)
	sltiu v0, v1, 0x24
	beq v0, zero, @@_valid
	nop

	; return
	ld s0, 0x10(sp)
	ld s1, 0x20(sp)
	ld s2, 0x30(sp)
	ld s3, 0x40(sp)
	ld a2, 0x50(sp)
	ld a3, 0x60(sp)
	ld ra, 0x70(sp)
	jr ra
	addiu sp, sp, 0x80

@@_valid:
	move s1, a0

	; a2 == 0
	beq a2, zero, @@_is_korean
	nop

	li a0, 0x4
	li s0, 0x3d40
	sh s0, 0x0(a1)
	b @@_glyph_idx
	nop

@@_is_korean:
	li a0, 0x0
	li s0, 0x3c00
	sh s0, 0x0(a1)

@@_glyph_idx:
	jal fun_0020b960
	nop

	move a2, v0
	move a0, s1
	li a3, 0

	; *a3 < 0x30
	lbu v0, 0x0(a0)
	sltiu v0, v0, 0x30
	beq v0, zero, @@_not_multibyte
	nop

	; a3 = (*a0 - 0x23) * 0xd0
	; a0++;
	lbu a3, 0x0(a0)
	addiu a3, a3, -0x2b ; TODO: -0x23
	li v1, 0xd0
	mult a3, a3, v1
	addiu a0, a0, 0x1

@@_not_multibyte:
	; a3 = a3 - 0x30 + *a3++
	lbu s1, 0x0(a0)
	addiu a3, a3, -0x30
	addu a3, a3, s1
	addiu a0, a0, 0x1

	lui s0, 0x7a
	addiu s0, s0, -0x8000 + 0x5c - 0x40 ; 0x798000 + 0x5c - 0x40
	jr s0
	nop
.endarea


.close

; ==================================================

.ps2
.open "build/files/file_455.ftcx", 0xff000

; a0 - uint8_t *str
; a1 - uint16_t *font_attr
; a2 - uint8_t *font_widths
; a3 - uint16_t glyph_idx
.orga 0x5c
	; TODO: 한글 분기문 추가..

	; font_attr[7] = 0
	; NOTE: 한글 폰트에서 알파벳 유무 체크?
	sh zero, 0xe(a1)

	; font_attr[1] = 0x14
	li s0, 0x14
	sh s0, 0x2(a1)

	; font_attr[9] = 0x12
	li s0, 0x12
	sh s0, 0x12(a1)

	; font_attr[8] = *(a2 + a3)
	addu s0, a2, a3
	lbu s2, 0x0(s0)
	sh s2, 0x10(a1)

	; font_attr[2] = a3 & 1
	andi t0, a3, 0x1
	sh t0, 0x4(a1)

	; s0 = (a3 / 0x12) * 0x12
	; font_attr[4] = s0
	li t0, 0x12
	div a3, t0
	mflo t2
	mfhi v0
	mult s0, t0, t2
	sh s0, 0x8(a1)

	; s1 = ((a3 % 0x12) / 2) * 0xe
	; font_attr[3] = s1
	srl t2, v0, 0x1f
	addu v0, v0, t2
	sra v0, v0, 0x1
	li t1, 0xe
	mult s1, v0, t1
	sh s1, 0x6(a1)

	; font_attr[5] = *(a2 + a3) + s1
	addu s3, s2, s1
	sh s3, 0xa(a1)

	; font_attr[6] = s0 + 0x12
	addiu s0, s0, 0x12
	sh s0, 0xc(a1)

	; return a0
	move v0, a0
	ld s0, 0x10(sp)
	ld s1, 0x20(sp)
	ld s2, 0x30(sp)
	ld s3, 0x40(sp)
	ld a2, 0x50(sp)
	ld a3, 0x60(sp)
	ld ra, 0x70(sp)
	jr ra
	addiu sp, sp, 0x80

.close
