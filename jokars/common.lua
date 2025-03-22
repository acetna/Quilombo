--Cosmic Ray
SMODS.Joker {
    key= "cosmic-ray",
    atlas = "placeholder",
    pos = { x = 0, y = 0},
    rarity = 1,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    cost = 3,
    loc_txt = {
        name = "Cosmic Ray",
        text = {
            --"{C:green}#1# in #2#{} chance to upgrade level of",
            --"a random {C:attention}poker hand{} when playing", 
            --"any hand",
            "Every hand played has",
            "a {C:green}#1# in #2#{} chance to upgrade",
            "a random {C:attention}poker hand{}"
        }
    },
    config = { extra = { chance = 4 } },
    loc_vars = function(self, info_queue, card)
            return { vars = { (G.GAME.probabilities.normal or 1) , card.ability.extra.chance } }
        end,
    calculate = function(self, card, context)

        --i wrote this looking at Extra Credit Mod's Accretion Disk

        if context.before and pseudorandom("cosmicray") < G.GAME.probabilities.normal/card.ability.extra.chance then
            local rando = math.ceil(pseudorandom("cosmicray2") * #G.handlist)
            local _hand =  G.handlist[rando]
            while not G.GAME.hands[_hand].visible do
                rando = math.ceil(pseudorandom("cosmicray2") * #G.handlist)
                _hand =  G.handlist[rando]
            end
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_level_up_ex')})
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(_hand, 'poker_hands'),chips = G.GAME.hands[_hand].chips, mult = G.GAME.hands[_hand].mult, level=G.GAME.hands[_hand].level})
            level_up_hand(context.blueprint_card or card, _hand, nil, 1)
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {handname=localize(context.scoring_name, 'poker_hands'),chips = G.GAME.hands[context.scoring_name].chips, mult = G.GAME.hands[context.scoring_name].mult, level=G.GAME.hands[context.scoring_name].level})
        end



    end
}