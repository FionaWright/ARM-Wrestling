# README

Team: ArmWrestling  
Finn Wright (CloudyUnity)  
Emma (b00rg)
Angelos [FILL IN HERE]  

## HARDWARE

We're using Port E  
Starting from North going clockwise the LED indices are:  
	LED3 (Red, Pin 9)  
	LED5 (Orange, Pin 10)  
	LED7 (Green, Pin 11)  
	LED9 (Blue, Pin 12)  
	LED10 (Red, Pin 13)  
	LED8 (Orange, Pin 14)  
	LED6 (Green, Pin 15)  
	LED4 (Blue, Pin 8)  

## Game Structure
 
Start Level:  
    Spawn obstacles according to current level difficulty  
    Place player at starting position  

Every Render Frame:		  
    Clear all LEDs		 
    Foreach obstacle:  
        Turn on obstacle LEDs   
        (Maybe they should flash?)  
    Turn on player LED  
        If LED already on then player has collided and died  

When button interrupt happens:  
    Move player forward  
        Check for player winning  

When sys_tick happens:  
    Move all obstacles accordingly		  

Player wins:  
    Increase difficulty  
    Start level  

## Thoughts

There should be a 32-bit variable where we use the least significant 8 bits to represent the state of the LEDs. So we can modify the variable and then write it into the GPIO all at once  

Obstacles should be rendered before the player to simplify player collision checking, if v_led_states is already set where player is then player has died  
