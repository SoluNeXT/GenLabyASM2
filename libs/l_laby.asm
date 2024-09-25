#importonce

#import "../macros/m_laby.asm"
#import "../def/d_laby.asm"

* = * "L_LABY"

.namespace LABY{

	.label	LABYDATAS		=	LabyDatasLocation
	.label	NextStartNumber	=	LABYDATAS + SizeX*SizeY
	.label	NextStartsX		=	NextStartNumber + 1
	.label	NextStartsY		=	NextStartsX + MaxSearchWays


	.label	DIRECTIONS		=	$08	// $08 = NOMBRE de directions possibles
									// $09 = Ouest
									// $0A = Est
									// $0B = Nord
									// $0C = Sud
	
	.label	Temp1			=	$02
	.label	Temp2			=	$03
	.label	PosX			=	$04
	.label	PosY			=	$05
	.label	Temp16bits		=	$06 // 06 07

	.label	ScreenPos		=	VIC.SCREEN_RAM



	INIT:{
			lda #<LABYDATAS
			sta	LabyPtr
			lda #>LABYDATAS
			sta LabyPtr+1

			ldy #0
			lda #0

		nextYloop:
			ldx #0

		nextXloop:
			sta LabyPtr: $C0C0
			inc LabyPtr
			bne !+
			inc LabyPtr+1
		!:
			inx
			cpx #SizeX
			bne nextXloop

			iny
			cpy #SizeY
			bne nextYloop

			//Point de départ X/Y aléatoire 
			lda #SizeX
			jsr ChooseNumber
			sta PosX

			lda #SizeY
			jsr ChooseNumber
			sta PosY

			rts
	}

	ChooseNumber:{ // 0 <= n < A
			sta Temp1  
			jsr FN.RANDOM.GET    
			cmp Temp1
			bcc ok

		loop:
			sec  				 
			sbc Temp1   		   
			cmp Temp1   
			bcs loop

		ok:
			rts	
	}

	GENERATE:{

		GenerateNextCell:{
				jsr SearchDirections

			ChooseDirection:{
					lda DIRECTIONS
					beq chooseNewStart
					jsr ChooseNumber
					tax
					lda DIRECTIONS+1,x
					sta Temp1
			}
				jsr ChangePositionValue
				jsr SetNewPosition
				jsr DISPLAY
				jmp GenerateNextCell
		}

		chooseNewStart:{
				jsr DISPLAY

				jsr SearchWaysWithEmptyNeightboor

				lda NextStartNumber
				beq finish

				jsr ChooseNumber
				tax
				lda NextStartsX,x
				sta PosX
				lda NextStartsY,x
				sta PosY

				jmp GenerateNextCell


			finish:
				lda #SizeY
				jsr	ChooseNumber
				tay
				ldx #0
				jsr GetPosVal
				ora #1
				jsr SetPosVal

				lda #SizeY
				jsr	ChooseNumber
				tay
				ldx #SizeX-1
				jsr GetPosVal
				ora #2
				jsr SetPosVal

				jmp DISPLAY
		}		

		SearchWaysWithEmptyNeightboor:{
				lda #0
				sta NextStartNumber

				sta PosX
				sta PosY

			loop:
				ldx PosX
				ldy PosY
				jsr GetPosVal

				cmp #0
				beq caseVide

			caseOccupee:
				jsr SearchDirections
				lda DIRECTIONS
				cmp #0
				beq pasDeVoisines

			caseAvecVoisines:
				ldx NextStartNumber
				lda PosX
				sta NextStartsX,x
				lda PosY
				sta NextStartsY,x

				inx
				stx NextStartNumber
				cpx #MaxSearchWays
				beq overLimit


			caseVide:
			pasDeVoisines:
				inc PosX
				ldx PosX
				cpx #SizeX
				bne loop
				ldx #0
				stx PosX

				inc PosY
				ldy PosY
				cpy #SizeY
				bne loop

			overLimit:
				rts
		}

		SetNewPosition:{
				lda Temp1
			Ouest:
				cmp #1
				bne Est
				dec PosX
				lda #2
				sta Temp1
				jmp ChangePositionValue

			Est:
				cmp #2
				bne Nord
				inc PosX
				lda #1
				sta Temp1
				jmp ChangePositionValue

			Nord:
				cmp #4
				bne Sud
				dec PosY
				lda #8
				sta Temp1
				jmp ChangePositionValue


			Sud:
				inc PosY
				lda #4
				sta Temp1
				jmp ChangePositionValue

		}

		ChangePositionValue:{
				ldx PosX
				ldy PosY
				jsr GetPosVal
				ora Temp1
				jsr SetPosVal
				rts
		}





		SearchDirections:{
			lda #0
			sta DIRECTIONS

		TestOuest:
			ldx PosX
			beq TestEst

			dex
			ldy PosY
			jsr GetPosVal
			cmp #0
			bne TestEst
			inc DIRECTIONS
			ldx DIRECTIONS
			lda #1
			sta DIRECTIONS,x

		TestEst:
			ldx PosX
			cpx #SizeX-1
			beq TestNord

			inx
			ldy PosY
			jsr GetPosVal
			cmp #0
			bne TestNord
			inc DIRECTIONS
			ldx DIRECTIONS
			lda #2
			sta DIRECTIONS,x

		TestNord:
			ldy PosY
			beq TestSud

			dey
			ldx PosX
			jsr GetPosVal
			cmp #0
			bne TestSud
			inc DIRECTIONS
			ldx DIRECTIONS
			lda #4
			sta DIRECTIONS,x

		TestSud:
			ldy PosY
			cpy #SizeY-1
			beq EndTests

			iny
			ldx PosX
			jsr GetPosVal
			cmp #0
			bne EndTests
			inc DIRECTIONS
			ldx DIRECTIONS
			lda #8
			sta DIRECTIONS,x



		EndTests:
			rts

		}

		GetXY:{	// X et Y >> X + Y * Size Y dans Temp16Bits
			lda #0
			sta Temp16bits
			sta Temp16bits+1

			cpy #0
			beq addX

			clc
		loop:
			lda Temp16bits
			adc #SizeX
			sta Temp16bits
			lda Temp16bits+1
			adc #0
			sta Temp16bits+1

			dey 
			bne loop

		addX:
			clc
			txa
			adc Temp16bits
			sta Temp16bits
			lda Temp16bits+1
			adc #0
			sta Temp16bits+1

			rts


		}

		GetPosVal:{
			jsr GetXY

			clc
			lda #<LABYDATAS
			adc Temp16bits
			sta PosMemXY
			sta SetPosVal.PosMemXY
			lda #>LABYDATAS
			adc Temp16bits+1
			sta PosMemXY+1
			sta SetPosVal.PosMemXY+1

			lda PosMemXY: $C0C0
			rts
		}

		SetPosVal:{
			sta PosMemXY: $C0C0
			rts
		}

	}


	DISPLAY:{
			lda #<LABYDATAS
			sta	LabyPtr
			lda #>LABYDATAS
			sta LabyPtr+1

			lda #<ScreenPos
			sta	ScreenPtr
			lda #>ScreenPos
			sta ScreenPtr+1			

			ldy #SizeY

		NextLine:
			ldx #0


		!:
			lda LabyPtr: $C0C0,x
			sta ScreenPtr: $C0C0,x

			inx
			cpx #SizeX
			bne !-

			clc
			lda LabyPtr
			adc #SizeX
			sta LabyPtr
			lda LabyPtr+1
			adc #0
			sta LabyPtr+1

			//clc
			lda ScreenPtr
			adc #40
			sta ScreenPtr
			lda ScreenPtr+1
			adc #0
			sta ScreenPtr+1

			dey
			bne NextLine

			rts
	}

}
