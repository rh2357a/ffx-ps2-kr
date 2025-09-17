; 폰트 확장 코드

.ps2
.open "build/files/file_00000.elf", 0xff000

; ==================================================

.definelabel    fun_001bd3a0, 0x1bd3a0 ; 언어 설정값 관련
.definelabel    fun_0020a828, 0x20a828 ; 폰트 index 관련
.definelabel    fun_0020b960, 0x20b960
.definelabel    fun_0020c528, 0x20c528 ; 텍스처 dma 적용?
.definelabel          memcpy, 0x2f0dd4
.definelabel     flush_cache, 0x2fa520
.definelabel font_buffer_ptr, 0x66d330
.definelabel     font_buffer, 0x67c3a0

MULTIBYTE_BASE      equ 0x24
TEXTURE_GLYPH_COUNT equ 998

; ==================================================

; 코드 주입 및 폰트 주소 설정
.org 0x20c3c0
.area 44, 0
	la a0, injection_begin
	lw a2, 0x24(s1)
	jal memcpy
	addu a1, s1, a1

	la s0, font_buffer
	sw s0, 0x0(s2)

	jal flush_cache
	li a0, 2
.endarea

; 폰트폭 주소 설정
.org 0x20c44c
.area 16, 0
	la v1, font_width_table
	sll a0, a1, 4
	addu v0, v0, a0
.endarea


; ==================================================

; FUN_00206fc0: placeholder 문자열 길이 관련
.org 0x20702c
	sltiu v0, v0, MULTIBYTE_BASE


; FUN_002053c0: 문자 너비 관련?
.org 0x2053c0
read_glyph_width:
.area 496, 0
	addiu sp, sp, -0x40
	sd s0, 0x0(sp)
	sd s1, 0x10(sp)
	sd s2, 0x20(sp)
	sd ra, 0x30(sp)

	move s2, a2
	move s0, a0
	lbu a0, 0x0(s0)

	sltiu v0, a0, 0x30
	bne v0, zero, @@_under_0x30
	move s1, a1

	jal fun_0020b960
	move a0, a3

	lbu v1, 0x0(s0)
	addu v0, v1, v0
	move a0, v1
	b @@_end_read_width
	lb t0, -0x30(v0)

@@_under_0x30:
	sltiu v0, a0, MULTIBYTE_BASE
	bne v0, zero, @@_end_read_width
	nop

	jal fun_0020b960
	move a0, zero

	lbu a0, 0x0(s0)
	li a1, 0xd0
	lbu a2, 0x1(s0)
	addiu v1, a0, -(MULTIBYTE_BASE - 1)
	mult v1, v1, a1
	addiu v1, v1, -0x30
	addu v1, v1, a2
	addu v0, v0, v1
	b @@_end_read_width
	lb t0, 0x0(v0)

@@_end_read_width:
	addiu v0, t0, 2
	li v1, 1
	beq s1, v1, @@_1
	movz t0, v0, s1

	li v0, 3
	bnel s1, v0, @@_2
	sw t0, 0x0(s2)

@@_1:
	addiu t0, t0, 4
	sw t0, 0x0(s2)

@@_2:
	lbu v0, 0x0(s0)
	sltiu v0, v0, 0x30
	bnel v0, zero, @@_3
	addiu s0, s0, 2
	addiu s0, s0, 1

@@_3:
	move v0, s0
	ld ra, 0x30(sp)
	ld s2, 0x20(sp)
	ld s1, 0x10(sp)
	ld s0, 0x0(sp)
	jr ra
	addiu sp, sp, 0x40
.endarea


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
	sltiu v0, v1, MULTIBYTE_BASE
	beq v0, zero, @@_valid
	nop

@@_return:
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
	la v0, 0x3257d0
	lw v1, 0x0(v0)
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

	la a2, is_korean
	sb v0, 0x0(a2)

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
	addiu a3, a3, -(MULTIBYTE_BASE - 1)
	li v1, 0xd0
	mult a3, a3, v1
	addiu a0, a0, 0x1

@@_not_multibyte:
	; a3 = a3 - 0x30 + *a3++
	lbu s1, 0x0(a0)
	addiu a3, a3, -0x30
	addu a3, a3, s1
	addiu a0, a0, 0x1

	la s0, render_font_impl
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
	sltiu v0, v1, MULTIBYTE_BASE
	beq v0, zero, @@_valid
	nop

@@_return:
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
	la a2, is_korean
	sb a0, 0x0(a2)

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
	addiu a3, a3, -(MULTIBYTE_BASE - 1)
	li v1, 0xd0
	mult a3, a3, v1
	addiu a0, a0, 0x1

@@_not_multibyte:
	; a3 = a3 - 0x30 + *a3++
	lbu s1, 0x0(a0)
	addiu a3, a3, -0x30
	addu a3, a3, s1
	addiu a0, a0, 0x1

	la s0, render_font_impl
	jr s0
	nop
.endarea


.close

; ==================================================

.ps2
.open "build/files/file_00455.ftcx", 0x798000 - 0x40

.orga 0x40
.area 0x1000, 0

injection_begin:
	; no-op


; a0 - uint8_t *str
; a1 - uint16_t *font_attr
; a2 - uint8_t *font_widths
; a3 - uint16_t glyph_idx
render_font_impl:
	; 음수값 예외처리
	bltz a3, @@_return
	nop

	la s0, is_korean
	lbu s1, 0x0(s0)
	beq s1, zero, @@_is_korean
	nop

	; font_attr[7] = 0
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
	b @@_return
	nop

@@_is_korean:
	jal find_glyph_index
	nop

	li s0, -1
	bne v0, s0, @@_found
	nop

	jal trim_glyph_checker_table
	nop
	jal find_glyph_index
	nop

@@_found:
	move s0, v0
	andi s0, s0, 0x8000
	bne s0, zero, @@_ignore_copy
	nop

	andi v0, v0, 0x7fff
	move s0, v0
	jal copy_font
	move s2, a3
	jal apply_font_gfx
	nop

@@_ignore_copy:
	; *(glyph_checker_table + (v0 * 2)) = a3
	la s0, glyph_checker_table
	li s2, 2
	andi v0, v0, 0x7fff
	mult s1, v0, s2
	add s0, s0, s1
	sh a3, 0x0(s0)

	; 소문자 정렬
	addiu s0, a3, -0x76a
	sltiu s0, s0, 0x1a
	beq s0, zero, @@_is_lower_case
	nop

	li s0, 2
	b @@_done_set_case
	sh s0, 0xe(a1)
	
@@_is_lower_case:
	sh zero, 0xe(a1)

@@_done_set_case:
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

	; font_attr[2] = v0 & 1
	andi t0, v0, 0x1
	sh t0, 0x4(a1)

	; s0 = (v0 / 0x12) * 0x12
	; font_attr[4] = s0
	li t0, 0x12
	div v0, t0
	mflo t2
	mfhi v0
	mult s0, t0, t2
	sh s0, 0x8(a1)

	; s1 = ((v0 % 0x12) / 2) * 0xe
	; font_attr[3] = s1
	srl t2, v0, 0x1f
	addu v0, v0, t2
	sra v0, v0, 0x1
	li t1, 0xe
	mult s1, v0, t1
	sh s1, 0x6(a1)

	; font_attr[5] = *(a2 + v0) + s1
	addu s3, s2, s1
	sh s3, 0xa(a1)

	; font_attr[6] = s0 + 0x12
	addiu s0, s0, 0x12
	sh s0, 0xc(a1)

@@_return:
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


; 폰트 그래픽 반영
apply_font_gfx:
	addiu sp, sp, -0xc0
	sd t3, 0x0(sp)
	sd t4, 0x10(sp)
	sd t5, 0x20(sp)
	sd t6, 0x30(sp)
	sd t7, 0x40(sp)
	sd v0, 0x50(sp)
	sd v1, 0x60(sp)
	sd a0, 0x70(sp)
	sd a1, 0x80(sp)
	sd a2, 0x90(sp)
	sd a3, 0xa0(sp)
	sd ra, 0xb0(sp)

	la v0, font_buffer_ptr
	lw a0, 0x0(v0)
	li a1, 0x3c00
	li a2, 0x14
	move a3, zero
	move t0, zero
	lh t1, 0xc(v0)
	jal fun_0020c528
	lh t2, 0xe(v0)

	ld t3, 0x0(sp)
	ld t4, 0x10(sp)
	ld t5, 0x20(sp)
	ld t6, 0x30(sp)
	ld t7, 0x40(sp)
	ld v0, 0x50(sp)
	ld v1, 0x60(sp)
	ld a0, 0x70(sp)
	ld a1, 0x80(sp)
	ld a2, 0x90(sp)
	ld a3, 0xa0(sp)
	ld ra, 0xb0(sp)
	jr ra
	addiu sp, sp, 0xc0

; 폰트 그래픽 복사
; s0: dst 인덱스
; s2: src 인덱스
copy_font:
	addiu sp, sp, -0x100
	sd v0, 0x10(sp)
	sd a1, 0x20(sp)
	sd a2, 0x30(sp)
	sd a3, 0x40(sp)
	sd s0, 0x50(sp)
	sd s1, 0x60(sp)
	sd s2, 0x70(sp)
	sd s3, 0x80(sp)
	sd t0, 0x90(sp)
	sd t1, 0xa0(sp)
	sd t2, 0xb0(sp)
	sd t3, 0xc0(sp)
	sd v1, 0xd0(sp)
	sd a0, 0xe0(sp)
	sd ra, 0xf0(sp)

	; s0 = calc_tile_offset(s0).addr
	; s1 = calc_tile_offset(s0).is_odd
	jal calc_tile_offset
	move a0, s0
	move s0, v0
	move s1, v1

	; s2 = calc_tile_offset(s2).addr
	; s3 = calc_tile_offset(s2).is_odd
	jal calc_tile_offset
	move a0, s2
	move s2, v0
	move s3, v1

	; s2 = font_buffer + s0
	la t0, font_buffer
	addu s0, t0, s0

	; s2 = font_data + s2
	la t0, font_data
	addu s2, t0, s2

	; s1 != 0
	bne s1, zero, @@_s1_odd
	nop

	li t0, 0xcc
	beq s3, zero, @@_s1_even_s3_even
	nop

	li t1, 0xcc
	b @@_start_copy
	li s3, 2

@@_s1_even_s3_even:
	li t1, 0x33
	b @@_start_copy
	li s3, 0

@@_s1_odd:
	li t0, 0x33
	bne s3, zero, @@_s1_odd_s3_even
	nop

	li t1, 0x33
	b @@_start_copy
	li s3, 2

@@_s1_odd_s3_even:
	li t1, 0xcc
	li s3, 0

@@_start_copy:
	li a1, 0
@@_for_0x12_loop:
	li a2, 0
	li t2, 0x12
	beq a1, t2, @@_end_for_0x12
	nop
@@_for_7_loop:
	li t2, 7
	beq a2, t2, @@_end_for_7
	nop

	lbu t2, 0x0(s0)
	and t2, t2, t0

	lbu t3, 0x0(s2)
	and t3, t3, t1

	beq s1, zero, @@_s1_is_even
	nop

	sllv t3, t3, s3
	b @@_store_t2
	or t2, t2, t3

@@_s1_is_even:
	srlv t3, t3, s3
	or t2, t2, t3

@@_store_t2:
	sb t2, 0x0(s0)

	addi s0, s0, 1
	addi s2, s2, 1
	b @@_for_7_loop
	addi a2, a2, 1
@@_end_for_7:
	addi s0, s0, 0x40 - 7
	addi s2, s2, 0x40 - 7
	b @@_for_0x12_loop
	addi a1, a1, 1

@@_end_for_0x12:
	ld v0, 0x10(sp)
	ld a1, 0x20(sp)
	ld a2, 0x30(sp)
	ld a3, 0x40(sp)
	ld s0, 0x50(sp)
	ld s1, 0x60(sp)
	ld s2, 0x70(sp)
	ld s3, 0x80(sp)
	ld t0, 0x90(sp)
	ld t1, 0xa0(sp)
	ld t2, 0xb0(sp)
	ld t3, 0xc0(sp)
	ld v1, 0xd0(sp)
	ld a0, 0xe0(sp)
	ld ra, 0xf0(sp)
	jr ra
	addiu sp, sp, 0x100


; 복사 오프셋 계산
; from a0: index
; to v0: 변환 오프셋
;    v1: 홀수 유무
calc_tile_offset:
	addiu sp, sp, -0x50
	sd s0, 0x10(sp)
	sd s1, 0x20(sp)
	sd s2, 0x30(sp)
	sd s3, 0x40(sp)

	; s0 = a0 / 0x12
	; s1 = (a0 % 0x12) / 2
	li t0, 0x12
	div a0, t0
	mflo s0
	mfhi s1
	sra s1, s1, 1

	; v0 = (s0 * 0x480) + (s1 * 7)
	li t0, 0x480
	mult s2, s0, t0
	li t0, 7
	mult s3, s1, t0
	addu v0, s2, s3

	; v1 = a0 & 1
	andi v1, a0, 1

	ld s0, 0x10(sp)
	ld s1, 0x20(sp)
	ld s2, 0x30(sp)
	ld s3, 0x40(sp)
	jr ra
	addiu sp, sp, 0x50


; 검사 테이블 정리
trim_glyph_checker_table:
	la s0, glyph_checker_table
	li s1, 0
	li v0, 0xffff

@@_loop:
	bge s1, TEXTURE_GLYPH_COUNT, @@_end_loop
	nop

	sh v0, 0x0(s0)
	addiu s0, s0, 2
	j @@_loop
	addiu s1, s1, 1

@@_end_loop:
	la a0, font_buffer
	li a1, 0

@@_loop_fill_zero:
	bge a1, 4032, @@_end_loop_fill_zero
	nop

	sq zero, 0(a0)
	addiu a0, a0, 16
	b @@_loop_fill_zero
	addiu a1, a1, 1

@@_end_loop_fill_zero:
	jr ra
	nop


; 폰트 인덱스 찾기
; v0
;   -2: 인덱스 테이블 비워야함.
;   정수값: 인덱스
find_glyph_index:
	la s0, glyph_checker_table
	li s1, 0
	li v0, 0xffff

@@_loop:
	bge s1, TEXTURE_GLYPH_COUNT, @@_failure
	nop

	; *s0 == a3
	lhu s2, 0x0(s0)
	beq s2, a3, @@_found_ignore_copy
	nop

	; *s0 == 0xffff
	beq s2, v0, @@_found
	nop

@@_continue:
	addiu s0, s0, 2
	addiu s1, s1, 1
	j @@_loop
	nop

@@_found_ignore_copy:
	ori s1, s1, 0x8000
	jr ra
	move v0, s1

@@_found:
	jr ra
	move v0, s1

@@_failure:
	jr ra
	li v0, -1


is_korean:
	.fill 4, 0

glyph_checker_table:
	.fill TEXTURE_GLYPH_COUNT * 2, 0xff

.endarea

.orga 0x40 + 0x1000
font_data:
	; .fill 0x2a780, 0

.orga 0x40 + 0x1000 + 0x2a780
font_width_table:
	; .fill 2704, 0

.close
