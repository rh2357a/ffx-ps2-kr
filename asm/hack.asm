.ps2
.open "build/files/file_455.ftcx", 0xff000

.orga 0x40
	lui s0, 0x68
	addiu s0, s0, -0x3c60 ; 0x67c3a0
	sw s0, 0x0(s2)

	lui t0, 0x21
	addiu t0, t0, -0x3c14 ; 0x20c3ec
	jr t0
	nop

.close

; =============================================

.ps2
.open "build/files/file_0.elf", 0xff000

.org 0x20c3c0
	lui s0, 0x7a
	addiu s0, s0, -0x8000 ; 0x798000

; ...

.org 0x20c3d8
	; 코드 메모리 동기화
	li v1, 0x64
	syscall 0x0

	; 폰트 데이터에 있는 코드로 이동
	jr s0
	nop

; ...

.org 0x20c450
	lui v1, 0x7c
	addu v0, v0, a0
	addiu v1, v1, 0 ; 0x7c0000

.close
