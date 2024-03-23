  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

  .include "./src/definitions.s"

  .section .text

@ Move player 1 space forward (v_player_position)
@ If position is 8 (final one) then PlayerWin()
PlayerMove:
 BX LR

@ Set player LED (ORR, v_led_states)
@ If LED is already lit up then PlayerDead()
PlayerFrame:
 BX LR

@ Player died. Restart game or something
PlayerDead:
 BX LR

@ Player won level. Increase v_level and StartLevel()
PlayerWin:
 BX LR

  .end