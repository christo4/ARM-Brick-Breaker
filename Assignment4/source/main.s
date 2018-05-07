//CPSC 359 Assignment 4 - Arkanoid
// Christopher Rodriguez (30024811)
// Marcello Di Benedetto (30031839)

.section .data
.align  4 
.global frameBufferInfo
.global tileGrid
.global ballVariables
.global ballVelocity
.global paddleVariables
frameBufferInfo:
	.int	0		@ frame buffer pointer
	.int	0		@ screen width
	.int	0		@ screen height
	
tileGrid:

	.int 4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4 //top wall
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,2 //red row	
	.int 1,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,2 //yellow row
	.int 1,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,2 //green row
	.int 1,5,5,5,5,5,5,12,5,5,5,13,5,5,5,5,5,5,5,2 //green row
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2 //air
	.int 1,11,11,11,11,11,11,11,11,11,11,11,11,11, 11, 11, 11, 11, 11, 2

paddleVariables:
	.int 772, 804											 			//Paddle top left x, Paddle top left y
	.int 1, 2											 				//Paddle velocity, Paddle velocity modifier

ballVariables:
	.int 828, 788														//Top Left
	.int 844, 788														//Top right
	.int 828, 804														//Bottom left
	.int 844, 804														//Bottom right
	
ballVelocity:	
	.int 1, -1															//X vel, Y vel

ballModifier:
	.int 1

score:
	.int 0, 0, 0, 0
lives:
	.int 3, 10

valuePackFlag:
	.int 	0, 0

valuePackVariables:
	.int	0, 0														//ValuePackOne
	.int	0, 0														//ValuePackTwo

catchFlag:
	.int	0


@ Code section
.section .text

.global main
.global getTileFromPixel
.global drawTileRange
.global	getTileFromPixel
.global	getTileType
.global	drawEntity
.global valuePackVariables
.global paddleVariables
.global valuePackFlag
.global ballModifier
.global catchFlag

X_OFFSET =	200
Y_OFFSET =	100
MENU_X_OFF = 200
MENU_Y_OFF = 68
BUTTON1_X_OFF = 432
BUTTON2_X_OFF = 528
GRID_LENGTH = 20
GRID_HEIGHT = 25
GRID_ELEM_SIZE = 4
TILE_WIDTH = 64
TILE_HEIGHT   = 32
PADDLE_XOFF   = 772
PADDLE_YOFF   = 804
PADDLE_WIDTH  = 128
PADDLE_HEIGHT =	32
BALL_XOFF   = 828
BALL_YOFF   = 788
BALL_DIM  = 16
NO_INPUT  = 0
ABUT	= 1
BBUT	= 2
UP		= 3
DOWN	= 4
LEFT	= 5
RIGHT	= 6
START	= 7
LEFT_A	= 8
RIGHT_A	= 9




@Main function serves as the driver for the entire game. Handles the functionality for holding the ball on the paddle,
@reading input from the snes controller, menu prompts, pause menu.

main:
		@ ask for frame buffer information
		ldr 		r0, =frameBufferInfo 	@ frame buffer information structure
		bl		initFbInfo
	
		bl		snesInit
		
		mov		r11,	#0
		
startMenu:																//prints the start menu 
	
		mov		r0,		#200
		mov		r1,		#MENU_Y_OFF
		ldr		r2,		=menu
		mov		r3,		#1280
		mov		r4,		#800
	
		bl		drawEntity
	
		mov		r0,		#762
		mov		r1,		#BUTTON1_X_OFF
		ldr		r2,		=startClicked
		mov		r3,		#128
		mov		r4,		#64
		
		bl		drawEntity
		
		mov		r0,		#762
		mov		r1,		#BUTTON2_X_OFF
		ldr		r2,		=quitNotClicked
		mov		r3,		#128
		mov		r4,		#64
		
		bl		drawEntity
	
		mov		r5,		#1
		mov		r6,		#0
	
startMenuLoop:															//reads the putton presses within the start menu, changing the state of the
																		//menu whenever the user presses up or down on the d pad
		bl		checkButtonPress
		
		cmp		r5,		r0
		mov		r5,		r0
		beq		startMenuLoop
		
		teq		r5,		#3
		beq		clickedArrow											//changes state of menu
		
		teq		r5,		#4
		beq		clickedArrow											//changes state of menu
		
		teq		r5,		#1
		beq		clickedA												//branches to the handling of the user's selection in the menu
		
		b		startMenuLoop
		
clickedArrow:
		teq		r6,		#0
		addeq	r6,		#1
		beq		otherStartMenu
		
		teq		r6,		#1
		subeq	r6,		#1
		beq		standardStartMenu

clickedA:
		teq		r6,		#0
		bleq	resetGame												//resets the game if the menu is a pause menu rather than main menu
		
		cmp		r6,		#0
		beq		maininit
		
		b		endGame													//ends game
	
standardStartMenu:														//primary state of the main menu
		mov		r0,		#200
		mov		r1,		#MENU_Y_OFF
		ldr		r2,		=menu
		mov		r3,		#1280
		mov		r4,		#800
	
		bl		drawEntity
	
		mov		r0,		#762
		mov		r1,		#BUTTON1_X_OFF
		ldr		r2,		=startClicked
		mov		r3,		#128
		mov		r4,		#64
		
		bl		drawEntity
		
		mov		r0,		#762
		mov		r1,		#BUTTON2_X_OFF
		ldr		r2,		=quitNotClicked
		mov		r3,		#128
		mov		r4,		#64
		
		bl		drawEntity
		
		b		startMenuLoop

otherStartMenu:															//prints the secondary state of the main menu
		mov		r0,		#200
		mov		r1,		#MENU_Y_OFF
		ldr		r2,		=menu
		mov		r3,		#1280
		mov		r4,		#800
	
		bl		drawEntity
	
		mov		r0,		#762
		mov		r1,		#BUTTON1_X_OFF
		ldr		r2,		=startNotClicked
		mov		r3,		#128
		mov		r4,		#64
		
		bl		drawEntity
		
		mov		r0,		#762
		mov		r1,		#BUTTON2_X_OFF
		ldr		r2,		=quitClicked
		mov		r3,		#128
		mov		r4,		#64
		
		bl		drawEntity
		
		b		startMenuLoop

pauseGame:																//prints the pauseGame menu
		mov		r0,		#200
		mov		r1,		#MENU_Y_OFF
		ldr		r2,		=menu
		mov		r3,		#1280
		mov		r4,		#800
	
		bl		drawEntity
	
		mov		r0,		#762
		mov		r1,		#BUTTON1_X_OFF
		ldr		r2,		=resumeClicked
		mov		r3,		#128
		mov		r4,		#64
		
		bl		drawEntity
		
		mov		r0,		#762
		mov		r1,		#BUTTON2_X_OFF
		ldr		r2,		=quitNotClicked
		mov		r3,		#128
		mov		r4,		#64
		
		bl		drawEntity
	
		mov		r5,		#7
		mov		r6,		#0
	
pauseMenuLoop:															//reads user input within the pause menu and branches around the main function accordingly
																		//in order to accurately alter the flow of the game
		bl		checkButtonPress
		
		cmp		r5,		r0
		mov		r5,		r0
		beq		pauseMenuLoop
		
		teq		r5,		#3
		beq		clickedArrowPauseMenu
		
		teq		r5,		#4
		beq		clickedArrowPauseMenu
		
		teq		r5,		#1
		beq		clickedAPauseMenu
		
		teq		r5,		#7
		beq		maininit
		
		b		pauseMenuLoop
		
clickedArrowPauseMenu:
		teq		r6,		#0
		addeq	r6,		#1
		beq		otherPauseMenu
		
		teq		r6,		#1
		subeq	r6,		#1
		beq		standardPauseMenu

clickedAPauseMenu:
		teq		r6,		#0
		bleq	resetGame
		teq		r6,		#0
		beq		maininit
		
		b		startMenu
	
standardPauseMenu:														//primary pause menu state printing 
		mov		r0,		#200
		mov		r1,		#MENU_Y_OFF
		ldr		r2,		=menu
		mov		r3,		#1280
		mov		r4,		#800
	
		bl		drawEntity
	
		mov		r0,		#762
		mov		r1,		#BUTTON1_X_OFF
		ldr		r2,		=resumeClicked
		mov		r3,		#128
		mov		r4,		#64
		
		bl		drawEntity
		
		mov		r0,		#762
		mov		r1,		#BUTTON2_X_OFF
		ldr		r2,		=quitNotClicked
		mov		r3,		#128
		mov		r4,		#64
		
		bl		drawEntity
		
		b		pauseMenuLoop

otherPauseMenu:															//prints the secondary pause menu state
		mov		r0,		#200
		mov		r1,		#MENU_Y_OFF
		ldr		r2,		=menu
		mov		r3,		#1280
		mov		r4,		#800
	
		bl		drawEntity
	
		mov		r0,		#762
		mov		r1,		#BUTTON1_X_OFF
		ldr		r2,		=resumeNotClicked
		mov		r3,		#128
		mov		r4,		#64
		
		bl		drawEntity
		
		mov		r0,		#762
		mov		r1,		#BUTTON2_X_OFF
		ldr		r2,		=quitClicked
		mov		r3,		#128
		mov		r4,		#64
		
		bl		drawEntity
		
		b		pauseMenuLoop

gameWon:																//prints the game won screen upon destroying all bricks
		mov		r0,		#200
		mov		r1,		#MENU_Y_OFF
		ldr		r2,		=win
		mov		r3,		#1280
		mov		r4,		#800
		
		bl		drawEntity
gameWonLoop:															//takes the user back to the main menu after a win should any button be pressed
		bl		checkAnyButtonPressed
		teq		r0,		#0
		beq		gameWonLoop
		
		b		startMenu												//branch back to start menu
		
		
gameLost:																//prints the game lost screen upon losing all lives
		mov		r0,		#200
		mov		r1,		#MENU_Y_OFF
		ldr		r2,		=lose
		mov		r3,		#1280
		mov		r4,		#800
		
		bl		drawEntity
gameLostLoop:															//takes the user back to the main menu after a loss should any button be pressed
		bl		checkAnyButtonPressed												
		teq		r0,		#0
		beq		gameLostLoop
		
		b		startMenu												//back to start menu

endGame:
		mov		r0,		#200
		mov		r1,		#MENU_Y_OFF
		ldr		r2,		=blackScreen									//prints over the window with a black screen to end the game
		mov		r3,		#1280
		mov		r4,		#800
	
		bl		drawEntity
	
		b		haltloop												//branch to haltloop

maininit:	
		bl		scoreAndLivesInit										//init score and lives along with the gameboard
		bl 		initGameBoard
	
init_Paddle:															//initializes the paddle and the ball
		ldr		r0,	=paddleVariables
		ldr		r1,	[r0, #4]
		ldr		r0,	[r0]
		ldr		r2, =paddle
		mov 	r3,	#PADDLE_WIDTH
		mov 	r4, #PADDLE_HEIGHT
	
		bl		drawEntity
		
init_Ball:
		ldr		r0,	=ballVariables
		ldr		r1,	[r0, #4]
		ldr		r0,	[r0]
		ldr		r2, =ball
		mov 	r3,	#BALL_DIM
		mov 	r4, #BALL_DIM
	
		bl		drawEntity		
		
		cmp		r11,	#1
		beq		mainLoop

waitForBButton:															//waits for the b button press to release the ball at the start of a round
	bl		checkButtonPress
	
	mov		r5,	r0
	
	ldr		r0,	=paddleVariables
	ldr		r1,	[r0, #8]
	ldr		r2,	[r0, #12]
	
	teq		r5,	#LEFT
	mvneq	r6,	r1
	beq		movingPaddleWithBall
	
	teq		r5,	#RIGHT
	moveq	r6,	r1
	beq		movingPaddleWithBall
	
	teq		r5,	#LEFT_A
	mvneq	r6,	r1
	muleq	r6,	r2
	beq		movingPaddleWithBall
	
	teq		r5,	#RIGHT_A
	moveq	r6,	r1
	muleq	r6,	r2
	beq		movingPaddleWithBall
	
	teq		r5,	#START
	mov		r11,	#0
	beq		pauseGame
	
	teq		r5,	#BBUT
	beq		afterMovePaddle
	
	b		afterMovingPaddleWithBall
	
movingPaddleWithBall:													//handles the moving of the paddle with a ball 
	
	mov		r0,	r6
	bl		checkPaddleMove
	cmp		r0,	#0
	beq		afterMovingPaddleWithBall
	
	bl		updateTilesPaddle
	mov		r0,	r6
	bl		movePaddle
	
	bl		updateTilesBall
	mov		r0,	r6
	bl		translateBall
	
	bl		drawPaddle
	bl		drawBall
	
afterMovingPaddleWithBall:												

	b		waitForBButton

mainLoop: 																//mainloop handles the flow of the game when actually playing
	bl		checkButtonPress
	
	mov		r5,	r0
	
	ldr		r0,	=paddleVariables
	ldr		r1,	[r0, #8]
	ldr		r2,	[r0, #12]
	
	teq		r5,	#LEFT
	mvneq	r6,	r1
	beq		movingPaddle
	
	teq		r5,	#RIGHT
	moveq	r6,	r1
	beq		movingPaddle
	
	teq		r5,	#LEFT_A
	mvneq	r6,	r1
	muleq	r6,	r2
	beq		movingPaddle
	
	teq		r5,	#RIGHT_A
	moveq	r6,	r1
	muleq	r6,	r2
	beq		movingPaddle
	
	teq		r5,	#START
	moveq	r11,	#1
	beq		pauseGame
	
	b		afterMovePaddle
	
movingPaddle:
	
	mov		r0,	r6
	bl		checkPaddleMove
	cmp		r0,	#0
	beq		afterMovePaddle
	
	bl		updateTilesPaddle
	mov		r0,	r6
checkMovingPaddle:
	bl		movePaddle

afterMovePaddle:
	
	bl		ballMovement
	teq		r0,	#1
	beq		checkLivesLeft
	
	bl		updateTilesBall
	bl		moveBall
	
checkValuePackFlags:
	//ldr		r0,	=valuePackFlag
	//ldr		r1,	[r0, #4]
//	ldr		r0,	[r0]
	
//	teq		r0,	#1
//	beq		valuePackOne
	
//	teq		r1,	#1
//	beq		valuePackTwo
	
afterValuePackCheck:	
	bl		drawPaddle
	bl		drawBall
	

	bl		updateLives
	bl		updateScore

	
	
checkGameWon:
	bl		checkWin
	teq		r0,		#1
	beq		gameWon
	
branchToMainLoop:
	b	mainLoop


checkLivesLeft:
	ldr		r0,	=lives
	ldr		r0,	[r0]
	teq		r0,	#0
	beq		gameLost
	
	bl		updateTilesBall
	bl		updateTilesPaddle
	bl		resetBallAndPaddle
	
	mov		r11,	#0
	b		maininit

haltloop:
		b haltloop		


	
	

@Subroutine translateBall
@takes the amount to move the ball on the x axis and changes the instance variables corresponding to the ball accordingly
@used primarily to move the ball with the paddle wen waiting for b button input
translateBall:
		push	{r5,lr}
		
		ldr		r1,	=ballVariables
		
		ldr		r2,	[r1]
		add		r2,	r0
		str		r2,	[r1]
		
		ldr		r3,	[r1, #8]
		add		r3,	r0
		str		r3,	[r1, #8]
		
		ldr		r4,	[r1, #16]
		add		r4,	r0
		str		r3,	[r1, #16]
		
		ldr		r5,	[r1, #24]
		add		r5,	r0
		str		r5,	[r1, #24]		
		
		pop		{r5,lr}
		mov		pc,	lr



@Subroutine resetGame 
@ resets the game grid array to the default layout and re initilizes the ball paddle and score variables
@ in the gamestate, this is called when the user specifies that they would like to restart the game within the pause menu
@ calls various reset subroutines in order to re initialize the entire gamestate

resetGame:
		push	{r5-r10, lr}

	
		mov 	r5, #0

resetBoardLoop:		

		ldr 	r7, =baseTileGrid
		ldr		r8, [r7, r5, lsl #2] 						//gets the current tile type in the base array
		
		ldr		r9, =tileGrid
		str		r8, [r9, r5, lsl #2]		
	
	
		add 	r5, #1
		
resetBoardTest:
		
		mov		r10,	#479
		cmp		r5, r10									// Grid area -1 
		ble		resetBoardLoop
		
		
		bl		resetScoreAndLives
		bl		resetBallAndPaddle
		
		pop		{r5-r10, lr}
		mov		pc, lr


@Subroutine resetScoreAndLives
@subroutine resets the values within the score and lieves array to 0000 and 3 respectively
@called within the resetGame subroutine to reinitialize the gamestate upon a restart
resetScoreAndLives:
		push	{r5,r6, lr}
				
		mov 	r6, #0										//resets the score to 0000
		ldr		r5, =score
		str 	r6, [r5]
		str 	r6, [r5, #4]
		str 	r6, [r5, #8]
		str 	r6, [r5, #12]
		
		
		mov 	r6, #3										//resets the lives to 3
		ldr 	r5, =lives
		str		r6, [r5]
		
		pop		{r5,r6,lr}
		mov		pc, lr





@Subroutine scoreAndLivesInit
@Initializes score and lives in the gamestate to properly display the correct letters for each of these values in the Gui
@the subroutine reads the values for score and lives in the gamestate within the data and prints accordingly.
scoreAndLivesInit:
		
		push	{r5-r8, lr} 


		array_index	.req r5
		curr_x		.req r6
		constant_y 	.req r8
		
		mov 	constant_y, #MENU_Y_OFF
		mov 	curr_x, #MENU_X_OFF
		mov 	array_index, #0

scoreInitLoop:		
		
		
		ldr		r4, =scoreArray
		ldr 	r4, [r4, array_index, lsl #2]
		
		mov		r0, curr_x
		mov 	r1, constant_y
		mov 	r2, r4
		mov 	r3, #TILE_WIDTH
		mov 	r4, #TILE_HEIGHT
		
		bl		drawEntity
		
		add 	array_index, #1
		add		curr_x, #64
		
scoreInitTest:
		
		cmp		array_index, #7
		blt		scoreInitLoop
		
		bl 		updateScore
		
		mov 	curr_x, #904
		mov 	array_index, #0
		
livesInitLoop:		
		
		
		ldr		r4, =livesArray
		ldr 	r4, [r4, array_index, lsl #2]
		
		mov		r0, curr_x
		mov 	r1, constant_y
		mov 	r2, r4
		mov 	r3, #TILE_WIDTH
		mov 	r4, #TILE_HEIGHT
		
		bl		drawEntity
		
		add 	array_index, #1
		add		curr_x, #64
		
livesInitTest:
		
		cmp		array_index, #7
		blt		livesInitLoop
		
		bl		updateLives
		
scoreLivesInitRet:	
		pop		{r5-r8, lr}
		mov 	pc, lr

		





@Subroutine UpdateScore
@This subroutine reads the score from the gamestate and prints the score onto the game Gui accordingly
@this is called within the initScoreAndLives subroutine in order to print the "Score" and "lives" words on the gui in cojunction with the appropriate values
@updates the score display in the games GUI

updateScore:
		
		push 	{r5-r9, lr}


		ldr		r5, =score
		mov 	r6, #0
		mov 	r7, #648
		
		
updateScoreLoop:
			
		
		mov 	r0, r7
		mov 	r1, #MENU_Y_OFF
		ldr 	r2, [r5, r6, lsl #2]
		ldr 	r8, =numberArray
		ldr		r2, [r8, r2, lsl #2]
		mov 	r3, #TILE_WIDTH
		mov 	r4, #TILE_HEIGHT
		
		bl 		drawEntity
	
	
		add		r7, #64
		add 	r6, #1
		
updateScoreTest:

		cmp		r6, #4
		blt		updateScoreLoop

		pop 	{r5-r9, lr}
		mov 	pc, lr


@Subroutine UpdateLives
@reads the current value of lives in the gamestate in data and prints to the game's gui the proper value
@used in conjunction with the previous subroutine in order to constantly update the top row of the game display
@updates the score display in the games GUI

updateLives:
		
		push 	{r5-r9, lr}


		ldr		r5, =lives
		mov 	r6, #0
		mov 	r7, #1352
		
		
updateLivesLoop:
			
		
		mov 	r0, r7
		mov 	r1, #MENU_Y_OFF
		ldr 	r2, [r5, r6, lsl #2]
		ldr 	r8, =numberArray
		ldr		r2, [r8, r2, lsl #2]
		mov 	r3, #TILE_WIDTH
		mov 	r4, #TILE_HEIGHT
		
		bl 		drawEntity
	
	
		add		r7, #64
		add 	r6, #1
		
updateLivesTest:

		cmp		r6, #2
		blt		updateLivesLoop

		pop 	{r5-r9, lr}
		mov 	pc, lr



@Subroutine ballMovement
@Subroutine which handles everything when it comes to the ball, including collision checking for the ball with
@various objects within the game including the bricks and the paddle. This subroutine also takes care of the updating of the tiles in contact
@with the ball and the updating of bricktypes when the bricks are damaged.
@increments the player's score when the ball comes in contact with a brick
@decrements the player's lives when the ball goes out of bounds
@Handles the ball movement and collision checking for the ball
ballMovement:
	push	{r5-r12,lr}
	
	xvel	.req	r5
	yvel	.req	r6
	
	ldr		r0,		=ballVelocity	
	ldr		xvel,	[r0]
	ldr		yvel,	[r0, #4]
	
	ldr		r2,		=ballVariables
	
	cmp		xvel,	#0
	bgt		positiveX

negativeX:																//checks the direction the ball is moving and sets the relevant corner values accordingly
		cmp		yvel,	#0
		bgt		negativeXpositiveY

negativeXY:
		ldr		r7,		[r2]
		ldr		r8,		[r2, #4]
		add		r0,		r7,		xvel
		mov		r1,		r8
		mov		r12,	#0
		b		checkBallCornerX
	
positiveX:
		cmp		yvel,	#0
		bgt		positiveXY
	
positiveXNegativeY:
		ldr		r7,		[r2, #8]
		ldr		r8,		[r2, #12]
		add		r0,		r7,		xvel
		mov		r1,		r8
		mov		r12,	#1
		b		checkBallCornerX
		
positiveXY:
		ldr		r7,		[r2, #24]
		ldr		r8,		[r2, #28]
		add		r0,		r7,		xvel
		mov		r1,		r8
		mov		r12,	#2
		b		checkBallCornerX
	
negativeXpositiveY:
		ldr		r7,		[r2, #16]
		ldr		r8,		[r2, #20]
		add		r0,		r7,		xvel
		mov		r1,		r8
		mov		r12,	#3
		b		checkBallCornerX
	
checkBallCornerX:
		bl		getTileFromPixel
		bl		getTileType
		
		mov		r9,		#0
		mov		r10,	r0
		mov		r11,	r1
		
		teq		r2,	#0
		bne		invalidBallMove
		

checkBallCornerY:
		mov		r0,		r7
		add		r1,		r8,		yvel
		
		bl		getTileFromPixel
		bl		getTileType
		
		mov		r9,		#1
		mov		r10,	r0
		mov		r11,	r1
		
		teq		r2,	#0
		beq		checkPaddleCollision

		
invalidBallMove:
		teq		r2,	#1
		beq		leftWallCollision
		
		teq		r2,	#2
		beq		rightWallCollision
		
		teq		r2,	#3
		beq		topWallCollision
		
		teq		r2,	#5
		beq		checkGreenBlockCollision
		
		teq		r2,	#6
		beq		checkYellowBlockCollision
		
		teq		r2,	#7
		beq		checkRedBlockCollision
		
		teq		r2,	#8
		beq		checkBreakingYellowCollision
		
		teq		r2,	#9
		beq		checkBreakingRedCollision
		
		teq		r2,	#10
		beq		checkBrokenRedCollision
		
		teq		r2,	#11
		beq		checkLoseLife
		
		teq		r2,	#12
		moveq	r12,#1
		beq		checkGreenBlockCollision
		
		teq		r2,	#13
		moveq	r12,#2
		beq		checkGreenBlockCollision

leftWallCollision:
		neg		r0,	xvel
		mov		r1,	yvel
		b		storeVelocitiesWall

rightWallCollision:
		neg		r0,	xvel
		mov		r1,	yvel
		b		storeVelocitiesWall

topWallCollision:
		mov		r0,	xvel
		neg		r1,	yvel
		b		storeVelocitiesWall

checkGreenBlockCollision:
		teq		r12,#1
		ldreq	r0,	=valuePackFlag
		moveq	r1,	#1
		streq	r1,	[r0]

		teq		r12,#2
		ldreq	r0,	=valuePackFlag
		moveq	r1,	#1
		streq	r1,	[r0, #4]


		mov		r0,	r10
		mov		r1,	r11
		mov		r2,	#0
		bl		updateTile
		
		teq		r9,	#0
		negeq	r0,	xvel
		moveq	r1,	yvel
		
		movne	r0,	xvel
		negne	r1,	yvel
		
		
		b		storeVelocitiesBlock

checkYellowBlockCollision:
		mov		r0,	r10
		mov		r1,	r11
		mov		r2,	#8
		bl		updateTile
		
		teq		r9,	#0
		negeq	r0,	xvel
		moveq	r1,	yvel
		
		movne	r0,	xvel
		negne	r1,	yvel
		
		b		storeVelocitiesBlock

checkRedBlockCollision:
		mov		r0,	r10
		mov		r1,	r11
		mov		r2,	#9
		bl		updateTile
		
		teq		r9,	#0
		negeq	r0,	xvel
		moveq	r1,	yvel
		
		movne	r0,	xvel
		negne	r1,	yvel
		
		b		storeVelocitiesBlock
		
checkBreakingYellowCollision:
		mov		r0,	r10
		mov		r1,	r11
		mov		r2,	#0
		bl		updateTile
		
		teq		r9,	#0
		negeq	r0,	xvel
		moveq	r1,	yvel
		
		movne	r0,	xvel
		negne	r1,	yvel
		
		b		storeVelocitiesBlock
		
checkBreakingRedCollision:
		mov		r0,	r10
		mov		r1,	r11
		mov		r2,	#10
		bl		updateTile
		
		teq		r9,	#0
		negeq	r0,	xvel
		moveq	r1,	yvel
		
		movne	r0,	xvel
		negne	r1,	yvel
		
		b		storeVelocitiesBlock
			
checkBrokenRedCollision:
		mov		r0,	r10
		mov		r1,	r11
		mov		r2,	#0
		bl		updateTile
		
		teq		r9,	#0
		negeq	r0,	xvel
		moveq	r1,	yvel
		
		movne	r0,	xvel
		negne	r1,	yvel
		
		b		storeVelocitiesBlock	
		
checkPaddleCollision:
		
		cmp		r12,	#2												//Checks if the ball is moving up
		blt		ballMovementReturn

		ldr		r0,		=ballVariables
		ldr		r1,		=paddleVariables

		ldr		r0,		[r0, #20]										//getBall bottom y
		ldr		r1,		[r1, #4]										//getPaddle top y

		ldr		r2,		=ballVelocity
		ldr		r2,		[r2, #4]										//get Ball y vel
		
		add		r0,		r2												//Get ball new position
		cmp		r0,		r1												//Check if the ball crosses the paddles y position
		blt		ballMovementReturn
		
		ldr		r0,		=ballVelocity
		ldr		r1,		=paddleVariables
		
		ldr		r7,		[r0]											//Get ball x vel
		
		ldr		r0,		=ballVariables
		
		ldr		r1,		[r1]											//paddle top left x
		
		ldr		r2,		[r0, #16]										//bottom left of ball x
		ldr		r3,		[r0, #24]										//bottom right of ball x
		
		add		r2,		r7												//Get next position of the ball
		add		r3,		r7
		
		add		r4,		r1,		#128
		
		cmp		r2,		r1												//Checks bottom left of the ball
		blt		checkSecondCorner
		
		cmp		r2,		r4
		bgt		checkSecondCorner
		
		b		checkWhereBallHits

checkSecondCorner:
		cmp		r3,		r1												//Checks bottom right of the ball for collision
		blt		ballMovementReturn
		
		cmp		r3,		r4
		bgt		ballMovementReturn

checkWhereBallHits:														//Depending on the direction that the ball is coming in we check different parts of the ball
		teq		r12,	#2
		beq		checkBottomRightOfBall                                                                                                                                                                                                                          

checkBottomLeftOfBall:
		add		r1,		#43
		cmp		r2,		r1												//r2	=	bottom left of ball
		blt		bounceBall45											//r1	=	top left of paddle
																		//r4	=	top right of paddle
		add		r1,		#42
		cmp		r2,		r1
		blt		bounceBall60
		
		b		bounceBall45

checkBottomRightOfBall:
		//r3 = bottom right of ball
		//r1 = top left of paddle
		//r4 = top right of paddle


		add		r1,		#43
		cmp		r3,		r1					
		blt		bounceBall45											
																		
		add		r1,		#42
		cmp		r3,		r1
		blt		bounceBall60
		
		b		bounceBall45

bounceBall45:															//45 degree bounce from the outer edges of the paddle
		mov		r0,		xvel
		mov		r1,		#-1
		
		b		storeVelocitiesWall

bounceBall60:															//60 degree bounce from the inner part of the paddle
		mov		r0,		xvel
		mov		r1,		#-2

		
		b		storeVelocitiesWall

storeVelocitiesWall:
		ldr		r3,		=ballModifier
		ldr		r3,		[r3]
		
		mul		r1,		r3

		ldr		r2,		=ballVelocity
		str		r0,	[r2]
		str		r1,	[r2, #4]
		b		ballMovementReturn
		
storeVelocitiesBlock:
		ldr		r2,		=ballVelocity
		str		r0,	[r2]
		str		r1,	[r2, #4]
		
		mov		r3,		#3
		ldr		r0,		=score

scoringLoop:															//increments the players score after being in contact with a block
		ldr		r1,		[r0, r3, lsl #2]
		add		r2,		r1,		#1
		cmp		r2,		#9
		
		movgt	r2,		#0
		strgt	r2,		[r0, r3, lsl #2]
		
		strle	r2,		[r0, r3, lsl #2]
		
		subgt	r3,		#1
		bgt		scoringLoop
		
		b		ballMovementReturn
				
		
checkLoseLife:															//checks if the ball is out of bounds and if so, decrements the players lives
		mov		r0,	#1
		ldr		r1,	=lives
		ldr		r2,	[r1]
		sub		r2,	#1
		str		r2,	[r1]
		b		realBallMovementReturn
		
ballMovementReturn:
		mov		r0,	#0
		
realBallMovementReturn:		
		pop		{r5-r12, lr}
		mov		pc, lr													//return




@Subroutine drawBall
@fetches the top left corner of the ball from the gamestate variables and calls the drawEntity function to draw the ball
@draws ball
drawBall:
		push	{lr}
		
		ldr		r2,	=ballVariables
		ldr		r0,	[r2]
		ldr		r1,	[r2, #4]
		ldr		r2,	=ball
		mov		r3,	#BALL_DIM
		mov		r4,	#BALL_DIM
		
		bl		drawEntity
		
		pop		{lr}
		mov		pc,	lr
		
	
@Subroutine moveBall
@moves the ball by changing the ball's location values in the gamestate depending on the current velocity component values
moveBall:
		push	{r5-r11, lr}
		
		ldr		r10,	=ballVariables
		ldr		r0,		[r10]											//top left x
		ldr		r1,		[r10, #4]										//top left y
		ldr		r2,		[r10, #8]										//top right x
		ldr		r3,		[r10, #12]										//top right y
		ldr		r4,		[r10, #16]										//bottom left x
		ldr		r5,		[r10, #20]										//bottom left y
		ldr		r6,		[r10, #24]										//bottom right x
		ldr		r7,		[r10, #28]										//bottom right y

		ldr		r11,	=ballVelocity
		ldr		r8,		[r11]											
		ldr		r9,		[r11, #4]

		add		r0,		r8
		add		r1,		r9
		add		r2,		r8
		add		r3,		r9
		add		r4,		r8
		add		r5,		r9
		add		r6,		r8
		add		r7,		r9

		stmia	r10,	{r0-r7}
		
		pop		{r5-r11, lr}
		mov		pc, 	lr




@Subroutine updateTilesBall
@gets endpoints of the ball in order to find which tiles the ball is in contact with and thus, which tiles should be updated
@uses the drawTileRange subroutine in order to refresh only the necessary tiles around the ball's trajectory
updateTilesBall:
		push	{r5-r8, lr}
		
		ldr		r2,		=ballVariables
		ldr		r0,		[r2]											//ball top left x
		ldr		r1,		[r2, #4]										//ball top left y
		
		bl		getTileFromPixel
				
		mov		r5,		r0												//First tile col
		mov		r6,		r1												//First tile row
		
		ldr		r2,		=ballVariables
		ldr		r0,		[r2, #24]										//ball bottom right x
		ldr		r1,		[r2, #28]										//ball bottom right y
				
		bl		getTileFromPixel
		
		mov		r2,		r0												//Second tile col
		mov		r3,		r1												//Second tile row
		
		mov		r0,		r5												//First tile col
		mov		r1,		r6												//First tile row
		
		bl		drawTileRange
		
		pop		{r5-r8, lr}
		mov		pc, lr





@Subroutine checkPaddleMove
@Parameters: r0 = how much to move
@checks if the desired paddle translation is valid or not, if the paddle is going to move into a wall, the function returns
@0 in r0 and if the paddle is going to move into an empty space, the subroutine returns 1 in r0
@Returns: r0 = validity of the desired paddle move. 
checkPaddleMove:
		push	{r5-r8,lr}
		
		ldr		r1,	=paddleVariables
		ldr		r5,	[r1]												//Paddle top left x		
		ldr		r6,	[r1, #4]											//Paddle top y
		add		r7,	r5,	#PADDLE_WIDTH									//Paddle top right x
		
		mov		r8,	r0
		
		cmp		r8,	#0
		bgt		checkPaddleMoveRight
		
checkPaddleMoveLeft:
		add		r0,	r5,	r8													//Position that its gonna move to
		mov		r1,	r6														//y
		b		checkPaddleMovement
		
checkPaddleMoveRight:
		add		r0,	r7,	r8
		mov		r1,	r6
		
checkPaddleMovement:		
		
		bl		getTileFromPixel

		mov 	r3, #GRID_LENGTH
		mul		r3, r1
		add 	r3, r0
		mov 	r4, #GRID_ELEM_SIZE
		mul 	r3, r4

		ldr 	r4, =tileGrid
		ldr 	r4, [r4, r3]
		
		teq		r4,	#1
		beq		invalidPaddleMove
		
		teq		r4,	#2
		beq		invalidPaddleMove				
		
		b		validPaddleMove
		
invalidPaddleMove:
		mov		r0, #0
		b		checkPaddleMoveReturn
		
validPaddleMove:
		mov		r0,	#1

checkPaddleMoveReturn:
		pop		{r5-r8, lr}
		mov		pc,	lr






@Subroutine updateTilesPaddle
@gets the endpoint of the tile in order to determine which tiles the paddle is in contact with in order to update these tiles later
@makes use of the drawTileRange subroutine to update the relevant tiles the paddle has touched
updateTilesPaddle:
		push	{r5-r8, lr}
		
		ldr		r2,		=paddleVariables
		ldr		r0,		[r2]											//Paddle top left x
		ldr		r1,		[r2, #4]										//Paddle top y

		add		r7,		r0,		#PADDLE_WIDTH							//Paddle top right x
		mov		r8,		r1												//Paddle top y
		
		bl		getTileFromPixel
		
		mov		r5,		r0												//First tile col
		mov		r6,		r1												//First tile row
		
		mov		r0,		r7
		mov		r1,		r8
		
		bl		getTileFromPixel
		
		mov		r2,		r0												//Second tile col
		mov		r3,		r1												//Second tile row
		
		mov		r0,		r5												//First tile col
		mov		r1,		r6												//First tile row
		
		bl		drawTileRange
		
		pop		{r5-r8, lr}
		mov		pc, lr
		


@Subroutine drawTileRange
@r0 = first tile col
@r1 = first tile row
@r2 = second tile col
@r3 = second tile row
@ redraws all of the tiles between the two specified endpoints according to theit tiletypes stored within the array in gamestate.
drawTileRange:
		push	{r5-r10, lr}
		
		mov		r5,		r0													//First Tile col
		mov		r6,		r1													//First Tile row
		mov		r7,		r2													//Second Tile col
		mov		r8, 	r3													//Second Tile row
		mov		r10,	r5													//Original first tile col	
				
drawTileRangeLoop:
		
		mov		r0,	r5
		mov		r1,	r6
		bl		getTileType	
		
		mov		r0,	r5
		mov		r1,	r6
		bl		updateTile

		add		r5,	#1
		
drawTileRangeColTest:
		cmp		r5,	r7
		ble		drawTileRangeLoop
		
		add		r6,	#1
		mov		r5,	r10
		

drawTileRangeRowTest:
		cmp		r6,	r8
		ble		drawTileRangeLoop
				
		pop		{r5-r10, lr}
		mov		pc, lr
		
		
		
@Subroutine getTypeType
@Takes col, row
@Returns r0 = col, r1 = row, r2 = tile type
getTileType:
		push	{lr}

		mov 	r3, #GRID_LENGTH
		mul		r3, r1
		add 	r3, r0
		mov 	r4, #GRID_ELEM_SIZE
		mul 	r3, r4

		ldr 	r4, =tileGrid
		ldr 	r2, [r4, r3]

		pop		{lr}
		mov		pc, lr

@Subroutine drawPaddle
@according to the current top left corner of the paddle stored in data, the subroutine redraws the paddle in it's correct location
drawPaddle:
		push	{lr}
		
		ldr		r0,	=paddleVariables
		ldr		r1,	[r0, #4]
		ldr		r0,	[r0]
		ldr		r2,	=paddle
		mov		r3,	#PADDLE_WIDTH
		mov		r4,	#PADDLE_HEIGHT
		
		bl		drawEntity
		
		pop		{lr}
		mov		pc,	lr

@Subroutine initGameBoard
@initializes the board for when the game starts.
@intiializes all brick, the paddle location and ball location as specified in the data section
initGameBoard:
		
		push	{r5-r8, lr} 


		i_r		.req r5
		j_r		.req r6
		
		
		
		mov 	r7, #X_OFFSET
		mov 	r8, #Y_OFFSET
		mov 	i_r, #0
		mov		j_r, #0

GameBoardLoop:		

		mov 	r2, #GRID_LENGTH
		mul		r2, i_r
		add 	r2, j_r
		mov 	r4, #GRID_ELEM_SIZE
		mul 	r2, r4

		ldr 	r4, =tileGrid
		ldr 	r4, [r4, r2]				
		
		
		ldr 	r2, =tileArray											//indexes into the external arry of pointers within entities.s
		ldr		r2,	[r2, r4, lsl #2]									//in order th retried the ascii value for the given tile type
		
		add  	r0, r7, j_r, lsl #6
		add		r1, r8, i_r, lsl #5
		mov		r3, #TILE_WIDTH
		mov 	r4, #TILE_HEIGHT
		
		bl 		drawEntity
		
		add 	j_r, #1
				
colLoopTest:
		cmp		j_r, #19
		ble		GameBoardLoop
		
		mov		j_r, #0			
		
		add 	i_r, #1
		
		
rowLoopTest:
		
		cmp		i_r, #23
		ble		GameBoardLoop		
	
gameBoardRet:
		
		pop		{r5-r8, lr}
		mov 	pc, lr
		

@Subroutine updateTile updates the tile, takes three arguments tile col, tile row, tile transform
@Parameters: r0 = col, r1 = row,  r2= tileType
@updates the tile, takes three arguments tile col, tile row, tile transform
updateTile:																
		push	{r5-r10, lr}	
		
		
		mov		r4,	r0
		mov		r5,	r1
		mov		r6,	r2
		mov		r7,	#X_OFFSET
		mov		r8,	#Y_OFFSET		
		
		mov 	r9, #GRID_LENGTH
		mul		r9, r5
		add 	r9, r4
		mov 	r10, #GRID_ELEM_SIZE
		mul 	r9, r10

		ldr 	r10, =tileGrid
		str 	r6, [r10, r9]
		
		ldr		r2,	=tileArray
		ldr		r2,	[r2, r6, lsl #2]
		
		add		r0,	r7,	r4,	lsl	#6
		add		r1,	r8,	r5,	lsl	#5
		mov		r3,	#TILE_WIDTH
		mov		r4,	#TILE_HEIGHT
		
		bl		drawEntity

updateTileReturn:
		pop		{r5-r10, lr}
		mov		pc,	lr



//TODO: FIX ARGUMENTS
@Subroutine drawEntity
@Parameters: Takes the x, y value where to draw in r0 and r1
@Takes the address of the ascii image data of the image
@Also takes the dimensions of the image to be drawn
@draws an image specified from a memory location to the screen at a specified location at a specified dimension

drawEntity:	
	push	{r0-r8, lr}	
	
	xPos	.req	r0			//xPos = r0
	yPos	.req	r1			//yPos = r1
	imgAdd	.req	r2			//imgAdd = r2
	xDim 	.req	r3			//xDim = r3
	yDim 	.req	r4			//yDim = r4	
	xDrawn	.req	r7
	yDrawn	.req	r8

		mov r6, imgAdd
		mov xDrawn, #0
		mov yDrawn, #0

drawEntityLoopOut:				
		
drawEntityLoopIn:
		
		mov	r0, xPos
		mov r1, yPos
		ldmia r6!, {r2}              	//TODO maybe post increment
	
		bl	DrawPixel
		
		add		xPos, #1
		add 	xDrawn, #1
	
drawLoopTestIn:

		cmp 	xDrawn, xDim
		blt		drawEntityLoopIn
		
		add		yPos, #1				//increments the yPos
		add 	yDrawn, #1				//increments nubmer of lines drawn in y
		
		sub 	xPos, xDrawn			//resets x coordinate for next line
		mov 	xDrawn, #0				//resets the xDrawn for next line		
		
drawLoopTestOut:

		cmp		yDrawn, yDim 
		blt		drawEntityLoopOut

		
		pop		{r0-r8, lr}
		mov		pc, lr
		


@DrawPixel subroutine
@From the tutorial exercises, takes the coordinates of the pixel to draw along with the pixel color
@r0 - x coor

DrawPixel:
	push		{r0-r5, lr}

	offset		.req	r4

	ldr		r5, =frameBufferInfo	
	
	ldr		r3, [r5, #4]		@ r3 = width
	mul		r1, r3
	add		offset,	r0, r1

	lsl		offset, #2

	ldr		r0, [r5]		@ r0 = frame buffer pointer
	str		r2, [r0, offset]

	pop		{r0-r5, lr}
	bx		lr
	
	
	
	
	
@Subroutine resetBallAndPaddle
@resets the ball and paddle to the ir original locations at the middle of the screen
@used for when the player loses a life.
resetBallAndPaddle:
		push	{r5,r6,lr}

		ldr 	r5, =ballVariables							//resets the ball variables and velocities
		mov		r6, #828																	
		str		r6, [r5]														
		mov		r6, #788																	
		str		r6, [r5, #4]															
		mov		r6, #844													
		str		r6, [r5, #8]														
		mov		r6, #788															
		str		r6, [r5, #12]	
		mov		r6, #828															
		str		r6, [r5, #16]															
		mov		r6, #804													
		str		r6, [r5, #20]																
		mov		r6, #844													
		str		r6, [r5, #24]															
		mov		r6, #804																	
		str		r6, [r5, #28]

		ldr		r5, =ballVelocity							
		mov		r6, #1
		str 	r6, [r5]
		mov		r6, #-1
		str 	r6, [r5,#4]

		
		ldr	r5, =paddleVariables							//resets the paddle variables
		mov	r6, #772
		str r6, [r5]
		mov	r6, #804
		str r6, [r5, #4]
		mov	r6, #1
		str r6, [r5, #8]
		mov	r6, #2
		str r6, [r5, #12]
	
	
	
		pop		{r5,r6,lr}
		mov 	pc, lr

	
	
	
	
@Subroutine checkWin
@this subroutine scans the array in the gamestate for blocks that are not background blocks 
@if at least one non background brick is found the subroutine returns a 0 in r1 signifying that the player has not won
@Returns: r0 = boolean value signifying that the game is over or not.
checkWin:
		push	{lr}
		mov		r0,	#1
		mov		r1,	#0
		ldr		r2,	=tileGrid
		
checkWinLoop:
		ldr		r3,	[r2, r1, lsl#2]
		cmp		r3,	#4
		movgt	r0,	#0
		
checkWinTest:		
		add		r1,	#1	
		cmp		r1,	#120
		blt		checkWinLoop
		
		pop		{lr}
		bx		lr


@Subroutine movePaddle
@moves the paddle according to its current velocity value in gamestate
movePaddle:
		push	{lr}
		
		ldr		r1,	=paddleVariables
		ldr		r2,	[r1]
		
		add		r2,	r0
		
		str		r2,	[r1]
		
		pop		{lr}
		bx		lr


@Takes pixel x and pixel y
@r0 = x
@r1 = y
@returns r0 = col, r1 = row
getTileFromPixel:
		push	{lr}
		
		sub		r0,	#X_OFFSET
		sub		r1,	#Y_OFFSET
		
		lsr		r0,	#6
		lsr		r1,	#5
		
		pop		{pc}
