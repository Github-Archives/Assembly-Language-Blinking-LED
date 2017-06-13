; uncomment following two lines if using 16f627 or 16f628. config uses internal oscillator
	LIST	p=16F628		;tell assembler what chip we are using
	include "P16F628.inc"		;include the defaults for the chip
	__config 0x3D18			;sets the configuration settings (oscillator type etc.)

; The following is very important:
; Recall: there is user RAM available starting at location 0x20 upto 0x77 in each bank
; Instead of referring to these locations by NUMBER, why not refer to them by NAME
; In the example below, count1 ia an alias for location 0x20, counta is an alias for
; location 0x21, countb is an alias for location 0x22. HIGHLY RECOMMENDED

	cblock 	0x20 			; start of general purpose registers
		count1 			; used in delay routine
		counta 			; used in delay routine 
		countb 			; used in delay routine
		countc
	endc

; We will turn on an LED on pin B8 (or any PORTB pin)
; (un-comment the following two lines if using 16f627 or 16f628)	
	movlw	0x07			; 1st digit = 4 bits 2nd digit = 4 bits
	movwf	CMCON			; turn comparators off (make it like a 16F84)
	
; set b port for output, a port for input

	bsf	STATUS,RP0		; select bank 1
	movlw	0x00			; this means setting it to output
	movwf	TRISB			; portb is output
	movlw	0xff			; 11111111 = set all port a to inputs
	movwf	TRISA			; porta is input
	bcf	STATUS,RP0		; return to bank 0

top_o_loop

; start with led off
	movlw	0x00
	movwf	PORTB
	call	delay_1000_milli
; turn led on
	movlw	0xff
	movwf	PORTB
	call	delay_1000_milli

; loop again
	goto top_o_loop
	

delay_1000_milli
	movlw	0x0a		; 0x0a == 10
	movwf	countc		; don't use counta here
delay_1000_loop
	call delay_100_milli
	decfsz	countc
	goto delay_1000_loop
	return
delay_100_milli
	movlw	0x64
	movwf	countb		; don't use counta here
delay_100_loop
	call delay_1_milli
	decfsz	countb
	goto delay_100_loop
	return

delay_1_milli
	movlw 	0xf9
	movwf	counta
delay_1_loop
	nop
	decfsz	counta
	goto	delay_1_loop
	return

	end
