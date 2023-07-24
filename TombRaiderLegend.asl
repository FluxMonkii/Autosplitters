// Tomb Raider: Legend Autosplitter for Livesplit
// Special thanks to: SmoothOperative and Cadarev
// Author: FluxMonkii
// Contributor: BryNu
// Version 1.1.2 <3

state("trl")
{
	bool loading: 0xCC0A54;
	string12 level: 0xD59318;
	float bosshealth: 0xB14A40;
}
state("tr7")
{
	bool loading: 0xCC80D4;
	string12 level: 0xD60C18;
	float bosshealth: 0xB1C0B0;
}

init
{
	refreshRate = 60;
}

start
{
	if(current.level == "bolivia1" && old.level == "bolivia12")
	return true;
}

split
{
	if(current.loading)
	{
		if(current.level == "mansion99" && old.level == "bolivia10" && settings["bolivia"] == true)
			return true;
		else if(current.level == "vehonehub1" && old.level == "flashback1" && settings["perustreets"] == true)
			return true;
		else if(current.level == "flashback3" && old.level == "vehoneend1" && settings["perumotorcyclechase"] == true)
			return true;
		else if(current.level == "flashback2" && old.level == "flashback7" && settings["peruflashback"] == true)
			return true;
		else if(current.level == "tokyo1" && old.level == "flashback2" && settings["peru"] == true)
			return true;
		else if(current.level == "amahlin2" && old.level == "tokyo66" && settings["japan"] == true)
			return true;
		else if(current.level == "russia11" && old.level == "Amahlin17" && settings["ghana"] == true)
			return true;
		else if(current.level == "vtrainhub1" && old.level == "russia11" && settings["kazakhstancompound"] == true)
			return true;
		else if(current.level == "russia1" && old.level == "vtrainend1" && settings["kazakhstanmotorcyclechase"] == true)
			return true;
		else if(current.level == "grave31" && old.level == "russia10" && settings["kazakhstan"] == true)
			return true;
		else if(current.level == "mansion99" && old.level == "grave3" && settings["england"] == true)
			return true;
		else if(current.level == "boliviaredux" && old.level == "himalayas6" && settings["nepal"] == true)
			return true;
	}
	else
	{
		if(current.level == "boliviaredux" && current.bosshealth == 0 && old.bosshealth != 0 && settings["boliviaredux"] == true)
		return true;
	}
}

isLoading
{
	return current.loading;
}

startup
{
	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{        
  		var timingMessage = MessageBox.Show(
  		"This game uses Game Time (without loads) as the main timing method. " +
  		"LiveSplit is currently set to display and compare against Real Time (including loads).\n\n" +
  		"Would you like the timing method to be set to Game Time?",
  		"Tomb Raider Legend | LiveSplit",
  		MessageBoxButtons.YesNo,MessageBoxIcon.Question
  		);
  		if (timingMessage == DialogResult.Yes)
    		timer.CurrentTimingMethod = TimingMethod.GameTime;
	}
	settings.Add("split", true, "Split at the end of:");
	settings.Add("bolivia", true, "Bolivia", "split");
	settings.Add("peru", true, "Peru", "split");
	settings.Add("perustreets", false, "Streets", "peru");
	settings.Add("perumotorcyclechase", false, "Motorcycle Chase", "peru");
	settings.Add("peruflashback", false, "Flashback", "peru");
	settings.Add("japan", true, "Japan", "split");
	settings.Add("ghana", true, "Ghana", "split");
	settings.Add("kazakhstan", true, "Kazakhstan", "split");
	settings.Add("kazakhstancompound", false, "Compound", "kazakhstan");
	settings.Add("kazakhstanmotorcyclechase", false, "Motorcycle Chase", "kazakhstan");
	settings.Add("england", true, "England", "split");
	settings.Add("nepal", true, "Nepal", "split");
	settings.Add("boliviaredux", true, "Bolivia Redux", "split");
}
