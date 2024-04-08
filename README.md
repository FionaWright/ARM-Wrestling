# README

Team: ArmWrestling  
Finn Wright (CloudyUnity)  
Emma (b00rg)
Angelos [FILL IN HERE]  

## HARDWARE

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
        (Maybe they should flash?)  
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
