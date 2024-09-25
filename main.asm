#importonce
MyBasicUpstart(1971,main,@"\$0D\$0E\$12\$1E                                        \$05mAZEgENERATOR (c)2024 rETROpROGRAMMATION\$1E                                        \$05\$0D",1,4)

//Display screen
.label memBank			=	0 		// $0000-$7FFF
.label screenPointer 	=	1 		// $0400-$07FF
//Charset
.label charsetPointer	=	4 		// $2000-$27FF


#import "./macros/m_basic.asm"
#import "./libs/l_vic.asm"
#import "./libs/l_fonctions.asm"
#import "./libs/l_laby.asm"

*=* "MAIN"
main:

	SetBorderColor(6)

	ClearScreen(15)
	SetScreenAndCharset(memBank, charsetPointer, screenPointer)

	jsr FN.RANDOM.INIT
	jsr	LABY.INIT

	jsr LABY.GENERATE

	jsr	LABY.DISPLAY

	SetBorderColor(14)

	jmp *

* = GetCharsetMemoryPosition(memBank, charsetPointer) "CHARSET"
.import binary "./assets/Chars3.bin"

* = 49152 "LABYDATAS"
LabyDatasLocation:

