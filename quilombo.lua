SMODS.Atlas {
	key = "rares",
	path = "rarejokars.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "uncommons",
	path = "uncommonjokars.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "placeholder",
	path = "placeholder.png",
	px = 71,
	py = 95
}

-- maybe one day i'll change this so i don't have to write them all out
assert(SMODS.load_file("jokars/rare.lua"))()
assert(SMODS.load_file("jokars/uncommon.lua"))()
assert(SMODS.load_file("jokars/common.lua"))()
