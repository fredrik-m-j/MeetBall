# Game
Ball & bat type of game written in assembly for Amiga.

# Requirements
Amiga with at least:
* 68000 CPU **
* 512 KB Chip + 512 KB slow RAM
* Kick 1.3 (I think)
* For 3 or 4 players using joystick - a parallel port adapter, but keyboard can also be used.

** Not tested with 040 or higher. For real hardware tests I have been limited to an A1200 with a ACA 1233n 030 card + 4-player adapter like this one: https://amigastore.eu/en/41-4-players-adapter-for-amiga.html.

# VS Code Extensions used
* Amiga Assembly for build, run and debug: https://marketplace.visualstudio.com/items?itemName=prb28.amiga-assembly
* Launch Configs for starting WinUAE Debug/Run with keyboard shortcuts (exposes items in launch.json): https://marketplace.visualstudio.com/items?itemName=ArturoDent.launch-config
* 68k Counter for optimizing: https://marketplace.visualstudio.com/items?itemName=gigabates.68kcounter
* GitHub Pull Requests and Issues
* gitignore
* Hex Editor

## Credits

* Source structure, asset system and PTPLAYER-wrapper is largely based on Amiga Game Dev series: 
        Graeme Cowie (Mcgeezer)
	https://mcgeezer.itch.io
	https://www.amigagamedev.com
* Keyboard interrupt: 
	? - posted by Graeme Cowie (Mcgeezer)
	https://eab.abime.net/showpost.php?p=1411387&postcount=8
* Vertical blank interrupt: 
	? - posted by Daniel Allsop
	https://eab.abime.net/showpost.php?p=1538796&postcount=8
* PRINCE-PHAZE101 & RANDY-RAMJAM: 
        STREAMS AND TUTORIALS FROM THE BOOK BY RANDY.
* Some system routines + JOY0 & JOY1 reading is based on RamJam assembly course by Prince of Phaze101: 
	https://princephaze101.wordpress.com
	https://www.youtube.com/playlist?list=PL-i3KPjyWoghwa9ZNAfiKQ-1HGToHn9EJ
        Fabio Ciucci
	http://corsodiassembler.ramjam.it/index_en.htm
* PHOTON-SCOOPEX: 
        (RNDW), exec_lib.i with CALLEXEC macro, ASMSKOOL + AMIGA HARDWARE PROGRAMMING SERIES.
        https://eab.abime.net/showpost.php?p=679652&postcount=6
        http://coppershade.org
        http://coppershade.org/file/CBM-includes-1991.zip
* FRANK WILLE: 
        MUSIC PLAYER (PTPLAYER).
* HIGHPUFF & LUDIS LANGENS: 
        NUMBER CONVERSION (BINARY2DECIMAL).
        https://www.ikod.se/binary2decimal/
* TOM HANDLEY & TOM KROENER: 
        (PARIO) & (CHECKPRT) FOR PARALLEL PORT TESTING.
        PARIO v1.5
        Author:	Tom Handley (thandley at nesbbx.rain.com)
        http://aminet.net/package/docs/hard/pario15
        CheckPrt v1.1
        Author:	kroener at cs.uni-sb.de (Tom Kroener)
        http://aminet.net/package/text/print/CheckPrt
* Parallel port reading: 
        Original source used as a base is from Amiga Mail Volume II
        http://amigadev.elowar.com/read/ADCD_2.1/AmigaMail_Vol2_guide/node01FF.html
        http://amigadev.elowar.com/read/ADCD_2.1/Hardware_Manual_guide/node012E.html#line34
* XYEZAWR & DRPETTER: 
        GFX: (EFFECTS PACK) ANIMATED ORB. SFX: (SFXR).
* CHUCKY: 
        RECAPPING MY A1200.
* X shifts + cookie-cut minterm: 
        djh0ffman - Knightmare
        https://github.com/djh0ffman/KnightmareAmiga
* Collision checking using bounding boxes: 
        John Girvin (nivrig)
        https://nivrig.com
	https://gist.github.com/johngirvin/75da8854aa91052e08956e9e558f2dca
* Guy C-J Sandvik: 
        Shopkeep gfx based on ICAnder.

* OTHERS: 
        ALL PEOPLE SPREADING KNOWLEDGE ABOUT AMIGA HW & SW.
