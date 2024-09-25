#importonce

* = * "M_BASIC"

.macro MyBasicUpstart(line, start, phrase, del, startLen){
	* = $0801 "MyBasicUpstart"
	.if(startLen>4){
		.eval startLen=5
	}
	.if(startLen<1){
		.eval startLen=1
	}
	.var l = 8 + startLen + ceil(log10(line+1))
	.byte <next,>next  			// Next line
	.byte <line,>line			// line number
	.byte 158					// SYS
.print l
	.var tmp = start
	.for(var i=startLen-1;i>=0;i--){
		.var p=pow(10,i)
		.var v = floor(tmp/p)
		.eval tmp = tmp - p * v
		.byte 48 + v
	}

	.byte 58,143				//:REM
	.if(del>0){
		.for(var i=0;i<l;i++){
			.byte 20
		}
	}
	.encoding "petscii_upper"
	.text phrase				// le texte

 	next:
	.byte 0,0,0
}
