.ps2
.open "build/files/file_00000.elf", 0xff000

.definelabel log, 0x2f10f8
.definelabel fun_002f21e4, 0x2f21e4
.definelabel fun_002f25e4, 0x2f25e4


; 게임의 원본 구성 설정값
.org 0x569d70
	db 0x00, 0x00, 0x00, 0x00
	; db 0x00, 0x00, 0x00, 0x02


; HDD 설정 비활성화
.org 0x2db190
.area 80, 0
	addiu sp, sp, -0x20
	sd ra, 0x10(sp)

	lui a0, 0x58
	li a1, 0x0
	jal log
	addiu a0, a0, -0x7e18

	lui v1, 0x57
	sw zero, -0x7f54(v1) ; 0x5680ac

	ld ra, 0x10(sp)
	jr ra
	addiu sp, sp, 0x20
.endarea


; 국내판 메모리 카드 설정
.org 0x241528
.area 288, 0
	addiu sp, sp, -0x20
	sd ra, 0x10(sp)

	lui a0, 0x33
	lui a1, 0x33
	addiu a1, a1, -0x72b0 ; 0x328d50 = "BKSLPM-67513"
	jal fun_002f25e4
	addiu a0, a0, -0x7228 ; 0x328dd8

	lui a0, 0x33
	lui a1, 0x33
	addiu a1, a1, -0x72a0 ; 0x329d60 = "FF0906%02d"
	jal fun_002f21e4
	addiu a0, a0, -0x7228 ; 0x328dd8

	lui v1, 0x33
	sw zero, -0x7da0(v1) ; 0x328260

	ld ra, 0x10(sp)
	jr ra
	addiu sp, sp, 0x20
.endarea


.close
