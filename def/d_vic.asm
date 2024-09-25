#importonce

* = * "D_VIC"

.namespace VIC{
	.label SCREEN_RAM = GetScreenMemoryPosition(memBank, screenPointer)
	.label COLOR_RAM = $d800

	.label BORDER_COLOR = $d020
	.label BACKGROUND_COLOR = $d021
	
	.label RASTER = $d012
	.label RASTER_MSB = $d011

	.label MEMORY_SETUP_REGISTER = $d018

	.label SCREENBANK_REGISTER = $dd00
}