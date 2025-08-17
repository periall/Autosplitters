state("Nosferatu")
{
	byte inCutscene			: 0x145D08, 0x504; 
	byte isPaused				: 0x14BF68, 0x1568;
	float timer						: 0x14BF70;
	string32 eventString	: 0x14D0A0; 
	string32 eventString2	: 0x14CC7C;
}

start 
{ 
	if ( old.inCutscene == 1 && current.inCutscene == 0 && current.timer <= 1 )
	{
		return true;
	}
} 

isLoading 
{												
	if ( current.timer == old.timer && current.eventString2 != "Inventory_Pause" && current.isPaused == 0 && current.inCutscene == 0 ) 
		return true;
	else
		return false;
}
	
reset
{	
	if ( current.eventString2.Contains("UI_System_Deactivate") && current.timer < 0 )
	{
		return true;
	}	
} 

split 
{		
	if ( current.eventString == "outro_happy" ) {
		return true;
	}
}
