#importonce

#import "../def/d_sid.asm"
#import "../def/d_vic.asm"

* = * "L_FN"

.namespace FN{


	RANDOM:{
		
		random:
			.byte $ff, $ff, $ff, $ff
		
		//.label random = VIC.SCREEN_RAM

		INIT:{
				lda #255
				sta SID.VOICE3+SID.FREQUENCELO
				sta SID.VOICE3+SID.FREQUENCEHI

				lda #SID.WAVEFORM_NOISE
				sta SID.VOICE3+SID.CONTROLREG

				ldx VIC.RASTER
			!:
				dex
				bne !-

				lda SID.VOICE3_WAVEFORM_OUTPUT
				sta random
				lda SID.VOICE3_WAVEFORM_OUTPUT
				sta random + 1
				lda SID.VOICE3_WAVEFORM_OUTPUT
				sta random + 2
				lda SID.VOICE3_WAVEFORM_OUTPUT
				sta random + 3

				rts
		}

		GET:{
			rnd:
			        asl random
			        rol random+1
			        rol random+2
			        rol random+3
			        bcc nofeedback
			        lda random
			        eor #$B7
			        sta random
			        lda random+1
			        eor #$1D
			        sta random+1
			        lda random+2
			        eor #$C1
			        sta random+2
			        lda random+3
			        eor #$04
			        sta random+3
			nofeedback:
					lda random+1

					rts
		}







	}




}

