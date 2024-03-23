# PASTE LINK TO TEAM VIDEO BELOW
#

  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global Main
  .global SysTick_Handler
  .global EXTI0_IRQHandler
  .global v_blink_countdown
  .global v_button_count

  .include "./src/definitions.s"

  .equ    BLINK_PERIOD, 250

  .section .text

Main:
  BL Setup

.LMain_IdleLoop:
  NOP
  B .LMain_IdleLoop

End_Main:
  BX LR

  .type  SysTick_Handler, %function
SysTick_Handler:
  PUSH  {R4, R5, LR}

  LDR   R4, =v_blink_countdown        @ if (countdown == 0):
  LDR   R5, [R4]                      @   CountdownFinished();
  CMP   R5, #0                      
  BEQ   .L_SysTick_Handler_CountdownFinished                  

  SUB   R5, R5, #1                    @ countdown--;
  STR   R5, [R4]                    

  B     .LendIfDelay                

@ (!) This label is entered when the SysTick timer has completed
.L_SysTick_Handler_CountdownFinished:

  LDR     R4, =GPIOE_ODR              @   Invert LD3
  LDR     R5, [R4]                  
  EOR     R5, #(0b1<<(LD3_PIN))       @   GPIOE_ODR ^= (1<<LD3_PIN);
  STR     R5, [R4]                  

  LDR     R4, =v_blink_countdown      @   countdown = BLINK_PERIOD;
  LDR     R5, =BLINK_PERIOD         
  STR     R5, [R4]                  

.LendIfDelay:                       
  LDR     R4, =SCB_ICSR               @ Clear (acknowledge) the interrupt
  LDR     R5, =SCB_ICSR_PENDSTCLR   
  STR     R5, [R4]                  
  POP  {R4, R5, PC}

@ External interrupt line 0 interrupt handler
@   (count button presses)
  .type  EXTI0_IRQHandler, %function
EXTI0_IRQHandler:
  PUSH  {R4,R5,LR}

  LDR   R4, =v_button_count           @ buttonCount++;
  LDR   R5, [R4]                    
  ADD   R5, R5, #1                  
  STR   R5, [R4]                    

  LDR   R4, =EXTI_PR                  @ Clear (acknowledge) the interrupt
  MOV   R5, #(1<<0)                 
  STR   R5, [R4]                    
  POP  {R4,R5,PC}

  .section .data
v_button_count:
  .space  4
v_blink_countdown:
  .space  4

  .end