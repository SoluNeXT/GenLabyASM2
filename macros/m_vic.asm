#importonce

#import "../def/d_vic.asm"
#import "../libs/l_vic.asm"

* = * "M_VIC"

.macro SetBorderColor(color){
	.if(color < 0 || color > 15){
		.error("color must be from 0 to 15")
	}
		lda #color
		sta VIC.BORDER_COLOR
}

.function GetCharsetMemoryPosition(memBank, charsetPointer){
	.if(memBank < 0 || memBank > 3){
		.error("memBank must be from 0 to 3")
	}	
	.if(charsetPointer < 0 || charsetPointer > 7){
		.error("charsetPointer must be from 0 to 7")
	}
	.return memBank * 16384 + charsetPointer * 2048
}

.function GetScreenMemoryPosition(memBank, screenPointer){
	.if(memBank < 0 || memBank > 3){
		.error("memBank must be from 0 to 3")
	}	
	.if(screenPointer < 0 || screenPointer > 15){
		.error("screenPointer must be from 0 to 15")
	}
	.return memBank * 16384 + screenPointer * 1024
}


.macro SetScreenAndCharset(memBank, charsetPointer, screenPointer){
	.if(memBank < 0 || memBank > 3){
		.error("memBank must be from 0 to 3")
	}	
	.if(charsetPointer < 0 || charsetPointer > 7){
		.error("charsetPointer must be from 0 to 7")
	}
	.if(screenPointer < 0 || screenPointer > 15){
		.error("screenPointer must be from 0 to 15")
	}

	lda VIC.SCREENBANK_REGISTER
	and #%11111100
	ora #3-memBank
	sta VIC.SCREENBANK_REGISTER

	lda #screenPointer * 16 + charsetPointer * 2
	sta VIC.MEMORY_SETUP_REGISTER

}

.macro ClearScreen(char){
	lda #char
	jsr VIC.CLEARSCREEN
}