# README

Team: ArmWrestling  
Fiona Wright (FionaWright)  
Emma (b00rg)
Angelos (AngelosLeEpic)

## About

This was a project where we had to create a videogame on a small microcontroller device.  
The device had 1 button input and 8 LEDs in a ring shape, each with a fixed corresponding colour.  
We decided to make a game where you have to do a loop around the ring without getting hit by various obstacles.  
We had 10 levels in the game.  
We got full marks!

![WhatsApp Image 2024-04-22 at 14 29 52_a30745fe](https://github.com/user-attachments/assets/a17ecc1a-98c4-44f5-9be6-dc8cdb0ccba4)

## Hardware Info

We're using Port E  
Starting from North-West going clockwise the LED indices are:  
	LED4 (Blue, Pin 8, Bit 0)  
	LED3 (Red, Pin 9, Bit 1)  
	LED5 (Orange, Pin 10, Bit 2)  
	LED7 (Green, Pin 11, Bit 3)  
	LED9 (Blue, Pin 12, Bit 4)  
	LED10 (Red, Pin 13, Bit 5)  
	LED8 (Orange, Pin 14, Bit 6)  
	LED6 (Green, Pin 15, Bit 7)	  

## Game Structure

Every Render Frame:		  
    Clear all LEDs		 
    Foreach obstacle:  
        Turn on obstacle LEDs   
    Turn on player LED  
        If LED already on then player has collided and died  

When button interrupt happens:  
    Move player forward  
        Check for player winning  

When sys_tick happens:  
    Progress obstacles by 1 tick	  

Player wins:  
    Increase difficulty  
    Put player at point0
