#importonce

* = * "D_SID"

.namespace SID{
	.label VOICE1 = $D400
	.label VOICE2 = $D407
	.label VOICE3 = $D40E

	.label FREQUENCELO = 0
	.label FREQUENCEHI = 1
	.label PULSEWIDTHLO = 2
	.label PULSEWIDTHHI = 3
	.label CONTROLREG = 4
	.label ATTACKDECAY = 5
	.label SUSTAINRELEASE = 6

	.label FILTERCUTOFFFREQUENCEYLO = $D415
	.label FILTERCUTOFFFREQUENCEYHI = $D416
	.label FILTERCONTROL			= $D417
	.label VOLUMEANDFILTERMODES		= $D418

	//Paddle !!! Gérés par le SID, retourne la valeur du paddle sélectionné en $DC00
	.label PADDLE_X = $D419
	.label PADDLE_Y = $D41A

	.label VOICE3_WAVEFORM_OUTPUT = $D41B
	.label VOICE3_ADSR_OUTPUT = $D41C


	.label WAVEFORM_TRIANGLE	= %00010000
	.label WAVEFORM_SAW			= %00100000
	.label WAVEFORM_RECTANGLE	= %01000000
	.label WAVEFORM_NOISE		= %10000000

	.label CTRL_DISABLEVOICE 	= %00000001

	.label LA4 = 440 // Hz
	.label SFC = 17.02841924063789 // PAL
	/*
		PAL 		: SFC = 16777216 / 985248	= 17,02841924063789

		NTSC (old)	: SFC = 16777216 / 1003766	= 16,71427005895796

		NTSC (new)	: SFC = 16777216 / 1022727	= 16,40439335228267
	*/
}