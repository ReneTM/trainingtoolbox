	
//****************************************************************************************
//																						//
//									ttb_commentarydate.nut								//
//																						//
//****************************************************************************************	
	
// The player is actually free to start at any chapter of the campaign.
// Thats why we want to have one welcomming node in every "official" map.
// ----------------------------------------------------------------------------------------------------------------------------
	
customCommentaryData <-
{
	c1m1_hotel				= Vector(448,5459,2942)
	c1m2_streets			= Vector(2519,4975,542)
	c1m3_mall				= Vector(6760,-1502,118)
	c1m4_atrium				= Vector(-1910,-4738,630)
	c2m1_highway			= Vector(10385,7868,-433)
	c2m2_fairgrounds		= Vector(2005,2717,94)
	c2m3_coaster			= Vector(4064,2048,30)
	c2m4_barns				= Vector(2882,3488,-93)
	c2m5_concert			= Vector(-1031,2026,-161)
	c3m1_plankcountry		= Vector(-12207,10234,263)
	c3m2_swamp				= Vector(-8011,6971,62)
	c3m3_shantytown			= Vector(-5633,2251,230)
	c3m4_plantation			= Vector(-5181,-1609,-2)
	c4m1_milltown_a			= Vector(-6552,7362,190)
	c4m2_sugarmill_a		= Vector(3746,-1756,326)
	c4m3_sugarmill_b		= Vector(-1711,-13383,224)
	c4m4_milltown_b			= Vector(3844,-1667,326)
	c4m5_milltown_escape	= Vector(-3385,7941,213)
	c5m1_waterfront			= Vector(889,787,-405)
	c5m2_park				= Vector(-3815,-1234,-249)
	c5m3_cemetery			= Vector(6254,8256,94)
	c5m4_quarter			= Vector(-3210,4780,162)
	c5m5_bridge				= Vector(-11881,5942,606)
	c6m1_riverbank			= Vector(1121,3892,190)
	c6m2_bedlam				= Vector(2956,-1266,-201)
	c6m3_port				= Vector(-2252,-455,-161)
	c7m1_docks				= Vector(13592,1856,-4)
	c7m2_barge				= Vector(10838,2375,270)
	c7m3_port				= Vector(1310,3142,262)
	c8m1_apartment			= Vector(1584,1117,529)
	c8m2_subway				= Vector(3011,2855,110)
	c8m3_sewers				= Vector(11019,4672,110)
	c8m4_interior			= Vector(12374,12651,110)
	c8m5_rooftop			= Vector(5477,8520,5630)
	c9m1_alleys				= Vector(-9867,-8775,89)
	c9m2_lots				= Vector(638,-1358,-81)
	c10m1_caves				= Vector(-11833,-14256,-30)
	c10m2_drainage			= Vector(-11165,-8678,-369)
	c10m3_ranchhouse		= Vector(-8235,-5553,69)
	c10m4_mainstreet		= Vector(-2899,-252,414)
	c10m5_houseboat			= Vector(2160,4015,30)
	c11m1_greenhouse		= Vector(6587,-756,864)
	c11m2_offices			= Vector(5419,2822,142)
	c11m3_garage			= Vector(-5253,-3225,241)
	c11m4_terminal			= Vector(-488,3664,390)
	c11m5_runway			= Vector(-5577,11628,121)
	c12m1_hilltop			= Vector(-8256,-15190,411)
	c12m2_traintunnel		= Vector(-6492,-6944,442)
	c12m3_bridge			= Vector(-1056,-10302,30)
	c12m4_barn				= Vector(7832,-11435,548)
	c12m5_cornfield			= Vector(10585,114,30)
	c13m1_alpinecreek		= Vector(-2870,-120,186)
	c13m2_southpinestream	= Vector(8390,7046,590)
	c13m3_memorialbridge	= Vector(-4482,-5163,190)
	c13m4_cutthroatcreek	= Vector(-3592,-8918,454)
	c14m1_junkyard			= Vector(-4100,-10521,-191)
	c14m2_lighthouse		= Vector(2358,-1080,542)
	//
	c17m17					= Vector(561,1263,160)
}
	
	

// This is all needed data to spawn the chat command prop on all 14 campaigns
// ----------------------------------------------------------------------------------------------------------------------------
	
signData <-
{
	c1m1_hotel = { origin = Vector(280.674957, 5955.968750, 2814.031250), angles = "0 -90 0" },
	c1m2_streets = { origin = Vector(2655.96875, 5046.410645, 510.031250), angles = "0 180 0" },
	c1m3_mall = { origin = Vector(7023.968750, -1453.0693, 86.031250), angles = "0 180 0" },
	c1m4_atrium = { origin = Vector(-2022.12463, -4911.968, 598.03), angles = "0 90 0" },
	c2m1_highway = { origin = Vector(9653.000000, 7750.799805, -417.000000), angles = "0 0 0" },
	c2m2_fairgrounds = { origin = Vector(1740.968750, 2625.716309, 66.031250), angles = "0 180 0" },
	c2m3_coaster = { origin = Vector(4150.586914, 2175.968750, 33.951237), angles = "0 -90 0" },
	c2m4_barns = { origin = Vector(3052.006348, 3241.031250, -124.000000), angles = "0 90 0" },
	c2m5_concert = { origin = Vector(-1317.913940, 2271.968750, -179.718750), angles = "0 -90 0" },
	c3m1_plankcountry = { origin = Vector(-11682.000000, 10369.000000, 227.000000), angles = "0 180 0 " },
	c3m2_swamp = { origin = Vector(-8300.000000, 6920.000000, 60.000000), angles = "0 0 0" },
	c3m3_shantytown = { origin = Vector(-5577.031250, 2051.308594, 198.031250), angles = "0 180 0" },
	c3m4_plantation = { origin = Vector(-4881.000000, -1599.000000, -34.000000), angles = "0 180 0" },
	c4m1_milltown_a = { origin = Vector(-6348.031250, 7637.079102, 191.873169), angles = "0 180 0" },
	c4m2_sugarmill_a = { origin = Vector(3890.409424, -1855.968750, 294.531250), angles = "0 90 0" },
	c4m3_sugarmill_b = { origin = Vector(-1838.115967, -13584.031250, 192.031250), angles = "0 -90 0" },
	c4m4_milltown_b = { origin = Vector(3744.031250, -1512.566650, 294.281250), angles = "0 0 0" },
	c4m5_milltown_escape = { origin = Vector(-3209.534668, 7975.968750, 182.031250), angles = "0 -90 0" },
	c5m1_waterfront = { origin = Vector(675.000000, 634.000000, -419.000000), angles = "0 0 0" },
	c5m2_park = { origin = Vector(-3834.000000, -1423.000000, -275.000000), angles = "0 90 0" },
	c5m3_cemetery = { origin = Vector(6224.031250, 8526.358398, 62.031250), angles = "0 0 0" },
	c5m4_quarter = { origin = Vector(-3387.355957, 4752.031250, 135.000000), angles = "0 90 0" },
	c5m5_bridge = { origin = Vector(-12170.000000, 5916.000000, 580.000000), angles = "0 0 0" },
	c6m1_riverbank = { origin = Vector(1145.000000, 3761.000000, 160.000000), angles = "0 180 0" },
	c6m2_bedlam = { origin = Vector(2942.000000, -830.000000, -220.000000), angles = "0 -90 0" },
	c6m3_port = { origin = Vector(-2312.526123, -272.031250, -193.968750), angles = "0 -90 0" },
	c7m1_docks = { origin = Vector(13564.033203, 2252.376953, -30.000000), angles = "0 0 0" },
	c7m2_barge = { origin = Vector(10616.493164, 1680.031250, 238.031250), angles = "0 90 0" },
	c7m3_port = { origin = Vector(1073.585938, 2725.000000, 225.000000), angles = "0 90 0" },
	c8m1_apartment = { origin = Vector(1697.793213, 776.031250, 551.911194), angles = "0 90 0" },
	c8m2_subway = { origin = Vector(3315.000000, 2874.100098, 85.000000), angles = "0 180 0" },
	c8m3_sewers = { origin = Vector(11251.000000, 4810.000000, 90.000000), angles = "0 180 0" },
	c8m4_interior = { origin = Vector(12140.000000, 12581.000000, 87.000000), angles = "0 0 0" },
	c8m5_rooftop = { origin = Vector(5397.702637, 8256.031250, 5598.031250), angles = "0 90 0" },
	c9m1_alleys = { origin = Vector(-10303.968750, -8639.518555, 64.000000), angles = "0 0 0" },
	c9m2_lots = { origin = Vector(250.719788, -1471.968750, -113.968750), angles = "0 90 0" },
	c10m1_caves = { origin = Vector(-11900.000000, -14747.000000, -120.000000), angles = "0 0 0" },
	c10m2_drainage = { origin = Vector(-11312.961914, -8832.031250, -401.968750), angles = "0 -90 0" },
	c10m3_ranchhouse = { origin = Vector(-8960.866211, -5742.671875, 22.931229), angles = "0 90 0" },
	c10m4_mainstreet = { origin = Vector(-3227.731445, -210.101700, 390.000000), angles = "0 0 0" },
	c10m5_houseboat = { origin = Vector(1824.031250, 4601.995117, -1.968750), angles = "0 0 0" },
	c11m1_greenhouse = { origin = Vector(6460.477539, -552.535645, 830.031250), angles = "0 0 0" },
	c11m2_offices = { origin = Vector(5660.000000, 2780.000000, 115.000000), angles = "0 180 0" },
	c11m3_garage = { origin = Vector(-5208.031250, -3156.167480, 78.031250), angles = "0 180 0" },
	c11m4_terminal = { origin = Vector(-104.000000, 3525.000000, 390.000000), angles = "0 180 0" },
	c11m5_runway = { origin = Vector(-5408.391113, 11734.271484, 113.790543), angles = "0 180 0" },
	c12m1_hilltop = { origin = Vector(-8152.117676, -15008.749023, 354.376160), angles = "0 0 0" },
	c12m2_traintunnel = { origin = Vector(-6336.031250, -6899.174805, 410.031250), angles = "0 180 0" },
	c12m3_bridge = { origin = Vector(-963.020020, -10503.869141, -1.96875), angles = "0 90 0" },
	c12m4_barn = { origin = Vector(7648.059082, -11252.031250, 539.846680), angles = "0 -90 0 " },
	c12m5_cornfield = { origin = Vector(10321.087891, -21.073280, 34.086933), angles = "0 0 0" },
	c13m1_alpinecreek = { origin = Vector(-3167.501953, -533.988464, 163.846802), angles = "0 0 0" },
	c13m2_southpinestream = { origin = Vector(8448.031250, 7295.685059, 563.916138), angles = "0 0 0" },
	c13m3_memorialbridge = { origin = Vector(-4312.006836, -5295.968750, 158.031250), angles = "0 90 0" },
	c13m4_cutthroatcreek = { origin = Vector(-3308.445313, -8894.029297, 422.031250), angles = "0 -90 0" },
	c14m1_junkyard = { origin = Vector(-4017.427490, -10554.319336, -236.121246), angles = "0 225 0" },
	c14m2_lighthouse = { origin = Vector(2160.500000, -1207.000000, 554.000000), angles = "0 90 0" },
	//
	c17m17 = { origin = Vector(481,1096,168), angles = "0 0 0"}
}




// Just in case we need them later, these are all needed properties of the vanilla commentary nodes.
// ----------------------------------------------------------------------------------------------------------------------------
	
/*	
	local c5m1CommentaryData =
	[
		{ targetname = "WELCOME TO LEFT 4 DEAD 2", origin = Vector(775,525,-420), file = "#commentary/com-welcome.wav", speaker = "Gabe Newell"},
		{ targetname = "UNIQUE CAMPAIGNS", origin = Vector(605,-40,-335), file = "#commentary/com-uniquecampaigns.wav", speaker = "Scott Dalton"},
		{ targetname = "WOUNDS",origin = Vector(-50,255,-335), file = "#commentary/com-wounds.wav", speaker = "Gray Horsfield"},
		{ targetname = "BODY PILES", origin = Vector(-905,350,-335), file = "#commentary/com-bodypiles.wav", speaker = "Marc Nagel"},
		{ targetname = "SOUND DESIGN PRINCIPLES", origin = Vector(-1140,-940,-175), file = "#commentary/com-sounddesign.wav", speaker = "Mike Morasky"},
		{ targetname = "INFECTED VARIATION", origin = Vector(-990,-1250,-335), file = "#commentary/com-infectedvariation.wav", speaker = "Ricardo Ariza"},
		{ targetname = "LOCAL MUSIC", origin = Vector(-1490,-1770,-335), file = "#commentary/com-localmusic.wav", speaker = "Erik Wolpaw"},
		{ targetname = "SECRET INGREDIENTS", origin = Vector(2340,-915,-335), file = "#commentary/com-secretingredients.wav", speaker = "Bronwen Grimes"},
		{ targetname = "GLOWING EYES", origin = Vector(-2250,-85,-335), file = "#commentary/com-glowingeyes.wav", speaker = "Thorsten Scheuermann"},
		{ targetname = "FURNITURE", origin = Vector(-2660,-190,-325), file = "#commentary/com-furniture.wav", speaker = "Sergiy Migdalsky"},
		{ targetname = "PIPE BOMBS", origin = Vector(-2660,-190,-325), file = "#commentary/com-pipebombs.wav", speaker = "Torsten Zabka"}
	]
	
	local c5m2CommentaryData =
	[
		{ targetname = "STORY", origin = Vector(-4085,-1275,-300), file = "#commentary/com-story.wav", speaker = "Chet Faliszek"},
		{ targetname = "THE NEW SPECIAL INFECTED", origin = Vector(-3475,-1575,-335), file = "#commentary/com-newspecialinfected.wav", speaker = "Tom Leonard"},
		{ targetname = "PARK PATHS", origin = Vector(-4445,-2200,-215), file = "#commentary/com-parkpaths.wav", speaker = "Dario Casali"},
		{ targetname = "AMMO PILES AND WEAPON SCAVENGING", origin = Vector(-6560,-2190,-190), file = "#commentary/com-ammopiles.wav", speaker = "Matt Boone"},
		{ targetname = "SPECIAL MOVES", origin = Vector(-7985,-2170,-190), file = "#commentary/com-specialmoves.wav", speaker = "Karen Prell"},
		{ targetname = "DEADLY HALLWAYS", origin = Vector(-8785,-3270,-215), file = "#commentary/com-deadlyhallways.wav", speaker = "Chris Carollo"},
		{ targetname = "OVERPASSES", origin = Vector(-9520,-3520,-215), file = "#commentary/com-overpasses.wav", speaker = "Randy Lundeen"},
		{ targetname = "BUS STATION", origin = Vector(-9590,-5940,-170), file = "#commentary/com-busstation.wav", speaker = "Aaron Barber"},
		{ targetname = "GUNPLAY", origin = Vector(-6855,-5495,-215), file = "#commentary/com-gunplay.wav", speaker = "Tristan Reidford"},
		{ targetname = "DAYTIME CUES", origin = Vector(-8960,-6145,-215), file = "#commentary/com-daytimecues.wav", speaker = "Brandon Idol"},
		{ targetname = "ADRENALINE", origin = Vector(-8175,-5825,0), file = "#commentary/com-adrenaline.wav", speaker = "John Guthrie"},
		{ targetname = "SPECIALS AND SONIC SILHOUETTES", origin = Vector(-7570,-7140,-205), file = "#commentary/com-sonicsilhouettes.wav", speaker = "Bill Van Buren"},
		{ targetname = "GIDDY UP! COMPOSITING THE JOCKEY AND SURVIVOR", origin = Vector(-8625,-8385,-205), file = "#commentary/com-giddyup.wav", speaker = "John Morello"}
	]
	local c5m3CommentaryData =
	[
		{ targetname = "PLAYTEST OBSERVATION", origin = Vector(5870,8180,65), file = "#commentary/com-playtestobservation.wav", speaker = "Charlie Burgin"},
		{ targetname = "BUS RETURN", origin = Vector(4160,5305,170), file = "#commentary/com-busreturn.wav", speaker = "Alireza Razmpoosh"},
		{ targetname = "UPGRADE PACKS", origin = Vector(4620,4235,40), file = "#commentary/com-upgradepacks.wav", speaker = "Eric Strand"},
		{ targetname = "SPITTER EFFECTS", origin = Vector(2610,2510,175), file = "#commentary/com-spittereffects.wav", speaker = "Peter Konig"},
		{ targetname = "LOBBY BROWSER", origin = Vector(2920,495,40), file = "#commentary/com-lobbybrowser.wav", speaker = "Zoid Kirsch"},
		{ targetname = "LASER-SIGHTS", origin = Vector(3625,190,75), file = "#commentary/com-lasersights.wav", speaker = "Jay Pinkerton"},
		{ targetname = "SNEAK OR FIGHT", origin = Vector(5940,150,40), file = "#commentary/com-sneakorfight.wav", speaker = "David Sawyer"},
		{ targetname = "DEFIBRILLATOR", origin = Vector(6215,-2840,475), file = "#commentary/com-defibrillator.wav", speaker = "Lars Jensvold"},
		{ targetname = "DYNAMIC PATHS", origin = Vector(6730,-4625,150), file = "#commentary/com-dynamicpaths.wav", speaker = "Kim Swift"},
		{ targetname = "NEW SURVIVORS", origin = Vector(9170,-6595,255), file = "#commentary/com-newsurvivors.wav", speaker = "Jeremy Bennett"}
	]
	local c5m4CommentaryData =
	[
		{ targetname = "RIVERBOAT GAMBLER", origin = Vector(-3360,4545,105), file = "#commentary/com-riverboatgambler.wav", speaker = "Andrea Wicklund"},
		{ targetname = "BALCONY", origin = Vector(-3075,2895,265), file = "#commentary/com-balcony.wav", speaker = "Jess Cliffe"},
		{ targetname = "ITEM PLACEMENT", origin = Vector(-1485,2915,105), file = "#commentary/com-itemplacement.wav", speaker = "Ryan Thorlakson"},
		{ targetname = "JAZZ CLUB", origin = Vector(-645,1975,105), file = "#commentary/com-jazzclub.wav", speaker = "Paul Graham"},
		{ targetname = "THE AX", origin = Vector(-700,2360,265), file = "#commentary/com-ax.wav", speaker = "Gary McTaggart"},
		{ targetname = "TEMPORARY SOUNDS", origin = Vector(-1235,1540,110), file = "#commentary/com-tempsounds.wav", speaker = "Kelly Thornton"},
		{ targetname = "SEPARATION ANXIETY", origin = Vector(-630,805,460), file = "#commentary/com-separationanxiety.wav", speaker = "Phil Co"},
		{ targetname = "TRADITIONAL CRESCENDO", origin = Vector(-1215,745,350), file = "#commentary/com-traditionalcrescendo.wav", speaker = "Kerry Davis"},
		{ targetname = "PARADE FLOAT", origin = Vector(-1565,125,200), file = "#commentary/com-paradefloat.wav", speaker = "Danika Wright"},
		{ targetname = "THIRD PARTY ADDON CAMPAIGNS", origin = Vector(-2370,835,115), file = "#commentary/com-thirdpartyaddon.wav", speaker = "Mike Durand"},
		{ targetname = "MOCAP BASICS", origin = Vector(-2680,-845,115), file = "#commentary/com-mocapbasics.wav", speaker = "Nick Maggiore"},
		{ targetname = "UNCOMMON COMMONS", origin = Vector(-915,-1735,105), file = "#commentary/com-uncommons.wav", speaker = "Ted Backman"},
		{ targetname = "DYNAMIC ALARMS", origin = Vector(1460,-2140,105), file = "#commentary/com-dynamicalarms.wav", speaker = "Jason Mitchell"}

	]
	local c5m5CommentaryData =
	[
		{ targetname = "STRAIGHTFORWARD FINALE", origin = Vector(-11725,6325,500), file = "#commentary/com-straightforward.wav", speaker = "Ido Magal"},
		{ targetname = "ASSETS", origin = Vector(-11410,6330,500), file = "#commentary/com-assets.wav", speaker = "Matt Wright"},
		{ targetname = "LEFT 4 DICTIONARY", origin = Vector(-7975,6165,500), file = "#commentary/com-L4dictionary.wav", speaker = "Steve Bond"},
		{ targetname = "ELEVATION", origin = Vector(-3845,6330,490), file = "#commentary/com-elevation.wav", speaker = "Chris Chin"},
		{ targetname = "WEATHER EFFECTS", origin = Vector(-1760,6185,830), file = "#commentary/com-weatherfx.wav", speaker = "Tim Larkin"},
		{ targetname = "GRENADE LAUNCHER", origin = Vector(3005,6260,535), file = "#commentary/com-grenadelauncher.wav", speaker = "Noel McGinn"},
		{ targetname = "FLOWING WATER", origin = Vector(4940,6330,605), file = "#commentary/com-flowingwater.wav", speaker = "Alex Vlachos"},
		{ targetname = "FROM_SERVER_BROWSING_TO_MATCHMAKING", origin = Vector(7015,6215,625), file = "#commentary/com-serverbrowsing.wav", speaker = "Vitaliy Genkin"},
		{ targetname = "ENGINE OPTIMIZATIONS", origin = Vector(9345,3405,490), file = "#commentary/com-engineoptimizations.wav", speaker = "Brian Jacobson"},
		{ targetname = "HYBRID ENVIRONMENT AUTHORING", origin = Vector(), file = "#commentary/com-hybridenviron.wav", speaker = "Yasser Malaika"}
	]
	
*/
	
	
	
	
	
	
