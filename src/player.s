  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

  .global PlayerMove
  .global PlayerFrame

  .include "./src/definitions.s"

  .section .text

  BL Setup                                            @tst
PlayerMove:                                           @ void PlayerMove() {    
  PUSH {R4-R7, LR}

  LDR R4, =v_isGameCompleted                          @   if (isGameComplete)
  LDR R5, [R4]                                        @      return;
  CMP R5, #1
  BEQ .LEndPlayerMove      

  LDR R4, =v_player_position                          @   playerPos = playerPosition;
  LDR R5, [R4]

  ADD R5, R5, #1                                      @   playerPos++;
  STR R5, [R4]

  CMP R5, #8                                          @   if (playerPos == 8)
  BGE .LPlayerWin                                     @     PlayerWin();
.LEndPlayerMove:
  POP {R4-R7, PC}                                     @ }

.LPlayerWin:                                          @ void PlayerWin() {
  LDR R6, =v_levelIndex                               @   levelIndex++;
  LDR R7, [R6]
  ADD R7, R7, #1
  STR R7, [R6]

  CMP R7, #8                                          @   if (levelIndex == 8)
  BGE .LPlayerCompletedGame                           @     PlayerCompletedGame();

  MOV R5, #0                                          @   else
  STR R5, [R4]                                        @     playerPosition = 0;

  POP {R4-R7, PC}                                     @ }

.LPlayerCompletedGame:                                @ void PlayerCompletedGame() {
  LDR R4, =v_isGameCompleted                          @   isGameCompleted = true;
  MOV R5, #1
  STR R5, [R4]
  POP {R4-R7, PC}                                     @ }

PlayerFrame:                                          @ void PlayerFrame() {
  PUSH {R4-R7, LR}

  LDR R4, =v_isGameCompleted                          @   if (isGameCompleted)
  LDR R5, [R4]                                        @     return;
  CMP R5, #1
  BEQ .LEndPlayerFrame                  

  LDR R4, =v_player_position                          @   playerBit = 1 << playerPosition;
  LDR R4, [R4]  
  MOV R5, #1
  LSL R4, R5, R4

  LDR R5, =v_led_states                               @   obstacleState = ledStates;
  LDR R6, [R5]
 
  AND R7, R4, R6
  CMP R7, #0                                          @   if (overlap(playerBit, obstacleState))
  BNE .LPlayerDead                                    @     PlayerDead();
 
  ORR R4, R4, R6                                      @   else
  STR R4, [R5]                                        @     obstacleState |= playerBit;
 
.LEndPlayerFrame:
  POP {R4-R7, PC}                                     @ }

.LPlayerDead:                                         @ void PlayerDead() {
  LDR R4, =v_player_position                          @   playerPosition = 0;
  MOV R6, #0                            
  STR R6, [R4]

  LDR R6, [R5]                                        @   ledStates |= 0b1;
  ORR R6, R6, #0b1
  STR R6, [R5]

  POP {R4-R7, PC}                                     @ }

  .end
