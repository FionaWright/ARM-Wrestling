# PASTE LINK TO TEAM VIDEO BELOW
#

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

  @ Code goes here    
  @ Move obstacles forward by 1 tick        
  @ Reset tick rate counter 

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

  .end