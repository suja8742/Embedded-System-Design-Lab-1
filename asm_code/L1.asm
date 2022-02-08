	ORG $0000
	;Load initial values
	MOV A,#06h
	MOV B,#0Ch

	; Initialization
	MOV 20h,#00h
	MOV 21h,#00h
	MOV 22h,#00h
	MOV 23h,#00h
	MOV 24h,#00h
	MOV 30h,#00h

	;Move value of X from A to 20h
	MOV 20h,A
	;If numerator is input as 0, jump.
	JZ INPUTISZERO

	;B register has Y value
	;Transfer B value to 22h
	MOV 22h,B
	;Check if denominator is 0
	XCH A,B
	JZ DENOMINATORINVALID
	XCH A,B

	;Left shift 3 times gives X*8
	RLC A
	;If higher than 8bit value, jump.
	JC OVERRUN
	RLC A
	JC OVERRUN
	RLC A
	JC OVERRUN
	MOV 21h,A


	;R1 stores the remainder
	MOV R1,#00h
	;If no carry, ITERATESTORE
	;performs repeated subtraction
	;to store quotient.
ITERATESTORE: MOV R2,A
	;Subtract repeatedly.
	SUBB A,B
	;If Carry
	JC SUCCESSFULDIV
	;Remainder
	INC R1
	;Repeat Subtraction.
	JNC ITERATESTORE

	;This stores Remainder value.
SUCCESSFULDIV: MOV 23h,R1
	MOV 24h,R2
	SJMP ENDLOOP

INPUTISZERO: MOV 23h,#00h
	MOV 24h,#00h
	SJMP ENDLOOP

DENOMINATORINVALID: MOV 30h,#01h
	MOV 20h,#00h
	MOV 22h,#00h
	SJMP ENDLOOP

OVERRUN: MOV 23h,A
	MOV 30h,#02h

	; Infinite loop
ENDLOOP: SJMP ENDLOOP
