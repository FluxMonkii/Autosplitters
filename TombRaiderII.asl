// Universal Tomb Raider II Autosplitter for Livesplit
// Author: FluxMonkii (derivative works of Supergamer57)
// Contributor: MidgeOnTwitch
// Support: https://discord.gg/UPawKth (Tomb Runner Discord Server)
// Version 1.3

// Adapts to all commonly used Tomb Raider II executables including; 
// Multipatch, Eidos Premier Collection, Eidos UK Box, German, Soul and Japanese releases


state("tomb2") {
	uint title : 0x11BD90;
	uint level : 0xD9EB0;
	uint levelTime : 0x11EE00;
	ushort creditsFlag : 0x11A1FC;
}
state("tomb2", "Eidos UK Box") {
	uint title : 0x11BDA0;
	uint level : 0xD9EC0;
	uint levelTime : 0x11EE00;
	ushort creditsFlag : 0x11A20C;
}
state("tomb2", "Soul") {
	uint title : 0x11BDB0;
	uint level : 0xD9ED0;
	uint levelTime : 0x11EE20;
	ushort creditsFlag : 0x11A21C;
}
state("tomb2", "Japanese") {
	uint title : 0x124730;
	uint level : 0xE2850;
	uint levelTime : 0x1276A0;
	ushort creditsFlag : 0x122B9C;
}

init {
	uint validity = 0;
    vars.game_ver = 0;  // 1 for Soul's, 2 for JP

	byte[] multipatch = new byte[] {0xE3, 0xA8, 0x8E};
	byte[] epc = new byte[] {0x03, 0xC4, 0x8F};
	byte[] ukbox = new byte[] {0x7F, 0x76, 0x6A};
	byte[] german = new byte[] {0x54, 0xC3, 0x8F};
	byte[] soul = new byte[] {0x70, 0x7C, 0x6A};
	byte[] jpn = new byte[] {0x6F, 0xB6, 0xA3};

	byte[] executable = memory.ReadBytes(modules.First().BaseAddress + 0x88, 3);
	
	for (int i = 0; i < executable.Length; i++) {
      if (executable[i] == multipatch[i]) validity++; 
    }
	if(validity == 3) {
		version = "Multipatch";
    }
    validity = 0;
	
	for (int i = 0; i < executable.Length; i++) {
      if (executable[i] == epc[i]) validity++; 
    }
	if(validity == 3) {
		version = "Eidos Premier Collection";
    }
    validity = 0;
	
	for (int i = 0; i < executable.Length; i++) {
      if (executable[i] == ukbox[i]) validity++; 
    }
    if(validity == 3) {
		version = "Eidos UK Box";
    }
    validity = 0;
	
	for (int i = 0; i < executable.Length; i++) {
      if (executable[i] == german[i]) validity++; 
    }
	if(validity == 3) {
		version = "German";
    }
	validity = 0;
	
	for (int i = 0; i < executable.Length; i++) {
		if (executable[i] == soul[i]) validity++; 
    }
	if(validity == 3) {
		vars.game_ver = 1;
        version = "Soul";
    }
	validity = 0;
	
	for (int i = 0; i < executable.Length; i++) {
		if (executable[i] == jpn[i]) validity++; 
    }
	if(validity == 3) {
        vars.game_ver = 2;
		version = "Japanese";
    }
	validity = 0;
}

start {
	return (current.title == 0) && (current.level == 1);
}

reset {
	return (current.title == 1);
}

isLoading {
	return true;
}

gameTime {
	var acc = 0;
	var lvl = 18;
	
	var levelStats = (IntPtr)(0x51E9F8);  // Correct for game_ver == 0
	
	if(vars.game_ver == 1) {
		levelStats = (IntPtr)(0x51EA18);  // Soul's check
	} else if (vars.game_ver == 2) {
        levelStats = (IntPtr)(0x527298);  // JP check
    }
	
	while(lvl > 0) {
		if(lvl != current.level)
			acc += memory.ReadValue<int>(levelStats + (lvl * 0x2C));
		lvl-=1;
	}

	return TimeSpan.FromSeconds(((acc + current.levelTime) / 30.0));
}

split {
	var curseg = timer.CurrentSplitIndex + 1;
	if(curseg != 18) {
		return (current.level == (curseg + 1));
	} else {
		return (current.creditsFlag == 1);
	}
}
