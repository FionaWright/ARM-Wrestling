# PASTE LINK TO TEAM VIDEO BELOW
# test

  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global Main
  .global SysTick_Handler
  .global EXTI0_IRQHandler

  .global v_player_position
  .global v_led_states
  .global v_level

  .include "./src/definitions.s"

  .section .text

Main:
  LDR R4, =v_tick_rate_counter        @ tickRateCounter = 80ms
  MOV R5, #10                         @ 8ms * 10 = 80ms
  STR R5, [R4]                        @ This needs testing I'm not sure if this is actually 80ms

  BL Setup

@ Main Rendering loop
@ Clear all LEDs
@ Loop over all obstacles and turn on correct LEDs
@ PlayerRender() to draw Player and check for death
.LRenderFrameLoop:
  LDR R4, =v_led_states               @ clear(ledStates);
  MOV R5, #0  
  STR R5, [R4]  

  @ Draw obstacles

  BL PlayerFrame

  BL SetLEDs

  B .LRenderFrameLoop

  .type  SysTick_Handler, %function
SysTick_Handler:
  PUSH  {R4, R5, LR}

  LDR   R4, =v_tick_rate_counter      @ if (tickRateCounter == 0):
  LDR   R5, [R4]                      @   CountdownFinished();
  CMP   R5, #0                      
  BEQ   .L_SysTick_Handler_CountdownFinished                  

  SUB   R5, R5, #1                    @ tickRateCounter--;
  STR   R5, [R4]                    

  B     .LendIfDelay                

@ (!) This label is entered when the SysTick timer has completed
@ Cause 1 tick to occur on every obstacle
.L_SysTick_Handler_CountdownFinished:               
  PUSH {R0 - R6, LR}

  LDR R4, =v_patternIndex @ Load the index of the patter
  STR R4, [R4]
  MOV R4, R4, LSL #3    @ We shift the pattern index to account for the size of levels

  LDR R5, =v_levels     // R6 = current frame obstacle patter
  LDRB R6, [R5, R4]

  CMP R5, #0xffffffff       @check if we reached the end
    BEQ .LrepeatLevelFrame
.LsetObstacles:
  LDR R7, =v_led_states
  STR R6, [R7]    

  LDR R4, =v_tick_rate_counter
  MOV R5, #6000
  LDR R5, [R4]

  POP {R0 - R6, PC}

.LrepeatLevelFrame:

  LDR R4, =v_patternIndex @ Load the index of the patter and set it to 0
  MOV R6, #0
  STR R6, [R4]
  LDRB R6, [R5, R4]

  B .LsetObstacles
.LendIfDelay:                       
  LDR     R4, =SCB_ICSR               @ Clear (acknowledge) the interrupt
  LDR     R5, =SCB_ICSR_PENDSTCLR   
  STR     R5, [R4]                  
  POP  {R4, R5, PC}

@ (!) Entered when button1 is pressed
@ PlayerMove()
  .type  EXTI0_IRQHandler, %function
EXTI0_IRQHandler:
  PUSH  {R4,R5,LR}

  BL PlayerMove                       @ PlayerMove();       

  LDR   R4, =EXTI_PR                  @ Clear (acknowledge) the interrupt
  MOV   R5, #(1<<0)                 
  STR   R5, [R4]                    
  POP  {R4,R5,PC}

@ Set LEDs based on v_led_states
SetLEDs:
  PUSH {R4-R8, LR}

  LDR R4, =GPIOE_ODR                  @ int currentVal = GPIOE_ODR;
  LDR R5, [R4]

  LDR R6, =v_led_states               @ ledStates <<= 8;
  LDR R7, [R6]
  LSL R7, R7, #8

  MOV R8, #0b11111111                 @ int mask = 0xFF << 8
  LSL R8, R8, #8

  BIC R5, R5, R8                      @ clearBits(currentVal, mask);
  ORR R5, R5, R7                      @ setBits(currentVal, ledStates)

  STR R5, [R4]                        @ GPIOE_ODR = currentVal;

  POP {R4-R8, PC}

  .section .data
v_tick_rate_counter:
  .space 4
v_led_states:
  .space 4
v_player_position:
  .space 4
v_level:
  .space 4
v_patternIndex:
  .space 4
v_levels:
  .byte 0b00001000, 0b00000000, 0b00000000, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0               @ level 1
  .byte 0b00010100, 0b00000000, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0                        @ level 2
  .byte 0b01000000, 0b00100000, 0b00010000, 0b00010000, 0b00001000, 0b00000100, 0b00000010,      @ level 3
    0b00000001, -1, 0, 0, 0, 0, 0, 0, 0 
  .byte 0b00011100, 0b00000000, 0b00000000, 0b00000000, 0b00000000, -1, 0, 0, 0, 0, 0, 0, 0, 0,  @ level 4
    0, 0
  .byte 0b00111110, 0b00000000, 0b00000000, 0b00000000, 0b00000000, -1, 0, 0, 0, 0, 0, 0, 0, 0, @ level 5
    0, 0
  .byte 0b00100100, 0b00010010, 0b01001001, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0               @ level 6
  .byte 0b00111111, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000,      @ level 7
    -1, 0, 0, 0, 0, 0, 0, 0, 0   
  .byte 0b00100010, 0b00001000, 0b00010100, 0b00000000, 0b01000001, -1, 0, 0, 0, 0, 0, 0, 0, 0,  @ level 8
    0, 0
  .byte 0b01010101, 0b00000000, 0b00101010, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0               @ level 9
  .byte 0b01000000, 0b00000000, 0b00000001, 0b01000001, 0b01000011, 0b01000101, 0b01010101,      @ level 10 
    0b01001111, 0b01100101, 0b01000101, 0b01110011, 0b01111001, 0b01111101, 0b01111100, 0b01111110


  .end
