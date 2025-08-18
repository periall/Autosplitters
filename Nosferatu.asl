state("Nosferatu")
{
	byte inCutscene         : 0x145D08, 0x504; 
	byte isPaused           : 0x14BF68, 0x1568;
	float timer             : 0x14BF70;
	string32 eventString	: 0x14D0A0; 
	string32 eventString2	: 0x14CC7C;
}

startup 
{
	vars.doneSplits = new List <string>();		
	
	settings.Add("split_keys", false, "Keys");

	var tB = (Func<string, string, string, bool, int, Tuple<string, string, string, bool, int>>)((elmt1, elmt2, elmt3, elmt4, elmt5) => {
		return Tuple.Create(elmt1, elmt2, elmt3, elmt4, elmt5); 
	});
	
	vars.sB = new List < Tuple < string, string, string, bool, int >> 
	{
		tB("eastwing", "East Wing Entry Key", "split_keys", false, 0x1A14),
		tB("towereast", "East Tower Key", "split_keys", false, 0x1A34),
		tB("desmodaui", "Desmodaui Vampire Key", "split_keys", false, 0x1AF4),
		tB("garrison", "Garrison Key", "split_keys", false, 0x1A54),
		tB("scroll", "Heavenly Scroll", "split_keys", false, 0x1A74),
		tB("crypt", "Crypt Key", "split_keys", false, 0x1AD4),
		tB("westwing", "West Wing Entry Key", "split_keys", false, 0x1A94),
		tB("foulbeast", "Foul Beast Vampire Key", "split_keys", false, 0x1B54),
		tB("2ndlvlwest", "2nd Level West Wing Key", "split_keys", false, 0x1B14),
		tB("4thlvlwest", "4th Level West Wing Key", "split_keys", false, 0x1B34),
		tB("5thlvlwest", "5th Level West Wing Key", "split_keys", false, 0x1BF4),
		tB("castle", "Castle Entry Key", "split_keys", false, 0x1AB4),
		tB("2ndlvlcastle", "2nd Level Castle Key", "split_keys", false, 0x1B74),
		tB("3rdlvlcastle", "3rd Level Castle Key", "split_keys", false, 0x1B94),
		tB("4thlvlcastle", "4th Level Castle Key", "split_keys", false, 0x1BB4),
		tB("5thlvlcastle", "5th Level Castle Key", "split_keys", false, 0x1BD4),
		tB("moraie", "Moraie Succubus Key", "split_keys", false, 0x1C14),
		tB("draija", "Draija Succubus Key", "split_keys", false, 0x1C34),
		tB("busterscage", "Buster's Cage Key", "split_keys", false, 0x1C54),	
	};

	foreach(var s in vars.sB) {
		settings.Add(s.Item1, s.Item4, s.Item2, s.Item3);
	}
}

update 
{
	if ( timer.CurrentPhase == TimerPhase.NotRunning && vars.doneSplits.Count > 0 ) {
		vars.doneSplits.Clear();
	}
}

start
{ 
	if ( old.inCutscene == 1 && current.inCutscene == 0 && current.timer <= 1 )
		return true;
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
		return true;
} 

split 
{
	var ItemCheck = (Func<string, int, byte>)(( itemname, offset ) => {	
		IntPtr itembaseaddr = IntPtr.Zero;
		new DeepPointer(0x141A40, 0x4, offset, -1).DerefOffsets(game, out itembaseaddr);		
	
	if ( !vars.doneSplits.Contains(itemname) && settings[itemname] == true )
	{			
		if (game.ReadValue<byte>(itembaseaddr) == 1) {			
			vars.doneSplits.Add(itemname);
			return 1;
		}
		else return 0;
	}
	else return 0;		
	});

	foreach(var s in vars.sB) {
		if ( s.Item3 != "split_keys" ) continue;

		if ( ItemCheck(s.Item1, s.Item5) == 1 )
			return true;
	}
		
	if ( current.eventString == "outro_happy")
		return true;
}
