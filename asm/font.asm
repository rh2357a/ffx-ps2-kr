.ps2
.open "build/files/file_0.elf", 0xff000

.definelabel fun_0020b960, 0x20b960



; FUN_00205080: 용도 확인 필요
;.org 0x20515c
;	sltiu v0, v1, 0x24
;.org 0x20518c
;	addiu v0, v0, -0x23
;.org 0x205234
;	sltiu v0, v0, 0x24


; FUN_00205b40: placeholder?
;


; FUN_002053c0: 폰트폭 관련
.org 0x2053e0
	sltiu v0, a0, 0x30
	bne v0, zero, _under_0x30
	move s1, a1
	jal fun_0020b960
	move a0, a3
	lbu v1, 0x0(s0)
	addu v0, v1, v0
	move a0, v1
	b _ignore_legacy
	lb t0, -0x30(v0)
_under_0x30:
	sltiu v0, a0, 0x24
	bne v0, zero, _ignore_legacy
	nop
	jal fun_0020b960
	move a0, zero
	lbu a0, 0x0(s0)
	li a1, 0xd0
	lbu a2, 0x1(s0)
	addiu v1, a0, -0x23
	mult v1, v1, a1
	addiu v1, v1, -0x30
	addu v1, v1, a2
	addu v0, v0, v1
	b _ignore_legacy
	lb t0, 0x0(v0)
.org 0x2054f4
_ignore_legacy:


; FUN_00204d70: 폰트 그래픽
.org 0x204e68
	sltiu v0, v1, 0x24
.org 0x204ea0
	addiu v0, v0, -0x23


.close

; ==================================================

.ps2
.open "build/files/file_455.ftcx", 0xff000

.orga 0x5c
	; TODO: 추가...

.close
