// CPSC 359 Assignment 3 
// Marcello Di Benedetto (30031839)
// Christopher Rodriguez (30024811)
// March 11, 2018
// Alot of the code was based off the tutorial/ lecture slides

// used for assignment4 to read input from the snes controller and move the paddle accordingly.






			.data
mBase:		.rept	4
			.byte	0
			.endr
			
			.text
			.balign 4
			.global snesInit
			.global	checkButtonPress
			.global checkAnyButtonPressed
			
			
@Subroutine snesInit
@intiializes the gpio lines for the snes (clock, latch and data) to out, out , in 			
snesInit:		
			push	{r5-r11, lr}
			bl		getGpioPtr									//branch link to the getGpioPtr function in order to get the base gpio reg
			ldr 	r1,	=mBase									
			str 	r0, [r1]									//stores the address in the buffer mbase. 
			
			mov		r0,	#10										//Initializes the three gpio lines that we are using clock, latch and data
			mov		r1,	#0
			bl		init_GPIO
			
			mov		r0,	#9
			mov		r1,	#1
			bl		init_GPIO
			
			mov		r0,	#11
			mov		r1,	#1
			bl		init_GPIO
			
			pop		{r5-r11, lr}
			mov		pc,	lr

			


@Subroutine checkButtonPress
@reads input from the snes controller and returns a constant value representing which button (or groups of buttons) have been pressed.
@Returns: r0 = constant integer value regarding the buttons pressed.
checkButtonPress:
			push	{r5-r11, lr}
			
			bl		Read_SNES									//Wait for input is a loop that will run until the button pressed is the start button
			
			mov		r1,	#0xFFFE									//This will compare the input given with the hex value of each single button input and will print which one you pressed
			teq		r1,	r0
			moveq	r0,	#2										//B button
			beq		endCheck

			mov		r1,	#0xFFF7									//This is the start button hex value which will end the program
			teq		r1,	r0	
			moveq	r0,	#7										//Start button
			beq		endCheck
			
			mov		r1,	#0xFFEF
			teq		r1,	r0	
			moveq	r0, #3										//Up button
			beq		endCheck			
			
			mov		r1,	#0xFFDF
			teq		r1,	r0	
			moveq	r0, #4										//Down button
			beq		endCheck		
			
			mov		r1,	#0xFFBF
			teq		r1,	r0	
			moveq	r0, #5										//left button
			beq		endCheck		
			
			mov		r1,	#0xFF7F
			teq		r1,	r0	
			moveq	r0, #6										//right button
			beq		endCheck

			mov		r1,	#0xFEFF
			teq		r1,	r0	
			moveq	r0, #1										//A button
			beq		endCheck
			
			mov		r1,	#0xFEBF									//Left + A button
			teq		r1,	r0
			moveq	r0,	#8
			beq		endCheck
			
			mov		r1,	#0xFE7F									//Right + A button
			teq		r1,	r0
			moveq	r0,	#9
			beq		endCheck
						
			mov		r0,	#0										//Nothing relevant checked

endCheck:	
			
			pop		{r5-r11, lr}
			mov		pc,	lr


checkAnyButtonPressed:
			push	{r5-r11, lr}
			
			bl		Read_SNES									//Wait for input is a loop that will run until the button pressed is the anything
			
			mov		r1,	#0xFFFF									//Checks if any button is pressed
			teq		r1,	r0
			moveq	r0,	#0
			beq		endCheck2
			
			mov		r0,	#1
endCheck2:	
			
			pop		{r5-r11, lr}
			mov		pc,	lr



@Subroutine init_GPIO
@This subroutine initializes a given Gpio line with a command function given by the other functions
init_GPIO:															
																	//This is a leaf subroutine therefore lr isnt being popped or pushed
			ldr		r4,	=mBase										//Grabs the base address and then calculates the offset according to the pin number
			ldr 	r2, [r4]
			
			mov		r7, #10
			mov		r8, #4
			sdiv 	r6, r0, r7
			mul		r6, r8
			add		r2, r6
			
			
			ldr		r3,	[r2]										//Gets the value at the address
			mov		r4,	#7
			mov		r5,	#3
			
			cmp		r0, #9											//gets the least significant digit in the pin number and if it is double digit keeps subtracting ten until it is single
			ble		singleDig							
			sub 	r0, #10								
			cmp		r0, #10
			subge	r0, #10
			
singleDig:			
			mul		r0,	r5											//Clears approriate bits according to the pin and then sets them to the given function code
			lsl		r4,	r0
			bic		r3,	r4
			
			lsl		r1,	r0
			orr		r1,	r3
			str		r1,	[r2]
			
ret:		
			mov		pc,	lr											//returns to calling code





@Subroutine write_latch
Write_Latch:
																	//This sets the given bit to the latch pin using GPSET0 and GPCLR0
			mov	r4,	r0
			
			mov		r0,	#9											//Pin 9
			ldr		r1,	=mBase
			ldr		r2,	[r1]
			mov		r3,	#1
			lsl		r3,	r0
			teq 	r4,	#0
			streq	r3,	[r2, #40]									//GPCLR0
			strne	r3,	[r2, #28]									//GPSET0
			
			
writeLatchRet:		
			mov 	pc, lr



@Subroutine write_clock
Write_Clock:
			
			mov		r4,	r0											//This also sets the given bit to the clock pin using GPSET0 and GPCLR0
			
			mov		r0,	#11											//Pin 11
			ldr		r1,	=mBase
			ldr		r2,	[r1]
			mov		r3,	#1
			lsl		r3,	r0
			teq		r4,	#0
			streq	r3,	[r2, #40]									//GPCLR0
			strne	r3,	[r2, #28]									//GPSET0
				
			
writeClockRet:
			mov 	pc, lr





@Subroutine read_data
Read_Data:															//This subroutine reads the data line in order to check what data is being sent from the controller at the current clock iteration	
			mov	r0,	#10
			ldr	r1,	=mBase
			ldr	r2,	[r1]
			ldr	r1,	[r2, #52]
			mov	r3,	#1
			lsl	r3, r0
			and r1,	r3												//Aligns the pin and then bit masks
			teq	r1,	#0
			moveq	r0,	#0
			movne	r0,	#1
						
readDataRet:
			mov		pc,	lr


	
Read_SNES:															//Read Snes is the main subroutine and involves setting the latch and clock to on and then reading the data on the falling edge of the clock
																	//and does it for 16 clock iterations and saves the data/status of each button which is then returned as a psuedo array 

			push	{lr}
			
			mov		r0,		#1										//writes a 1 to the clock 
			bl		Write_Clock
			
			mov		r0,		#1										//writes a 1 to the latch pin
			bl		Write_Latch
			
			mov		r10,	#0x0
			
			mov		r0,		#12
			bl		delayMicroseconds
			
			mov		r0,		#0										//writes a 0 to the latch
			bl		Write_Latch
			
			mov		r11,	#0
			b		pulseLoop
			
pulseLoop:
			mov		r0,		#6
			bl		delayMicroseconds
			
			mov		r0,		#0
			bl		Write_Clock
			
			mov		r0,		#100									//delays the program before the next loop iteration
			bl		delayMicroseconds
			
			bl		Read_Data
			
			lsl		r0,		r11
			orr		r10,	r0
			
			mov		r0,		#1
			bl		Write_Clock										//writes a 1 to the clock to prepare for the next iteration
					
			add		r11,	#1
			
pulseTest:
			cmp		r11,	#16
			blt		pulseLoop										//loops back to the pulseloop label
			
			mov		r0,		r10
			
			pop		{lr}										//restores the previous value of the lr regsiter
			mov		pc,		lr										//returns to calling code
