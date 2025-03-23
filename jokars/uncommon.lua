-- Passe Partout
SMODS.Joker {
    key= "passe_partout",
    atlas = "placeholder",
    pos = { x = 0, y = 0},
    rarity = 2,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    cost = 5,
    loc_txt = {
        name = "Passe Partout",
        text = {

            "{X:mult,C:white}X#1#{} if every unscoring card",
            "in a five card hand is", 
            "the same suit" 

        }
    },
    config = { extra = { Xmult = 3 , trigger = false} },
    loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.Xmult } }
        end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local unscoringCard = {}
            local suits = {
                ["H"] = 0,
                ["S"] = 0,
                ["D"] = 0,
                ["C"] = 0,
                ["WC"] = 0
            }
            if #G.play.cards == 5 and #context.scoring_hand ~= 5 then
                for i = 1, #G.play.cards do
                    if existsInTable(G.play.cards[i],context.scoring_hand) then
                    else
                        unscoringCard[#unscoringCard + 1] = G.play.cards[i]
                    end
                end

                for i = 1, #unscoringCard do
                    if unscoringCard[i].ability.name == "Wild Card" then
                        suits.WC = suits.WC + 1
                    elseif unscoringCard[i]:is_suit("Hearts", true) then
                        suits.H = suits.H + 1
                    elseif unscoringCard[i]:is_suit("Spades", true) then
                        suits.S = suits.S + 1
                    elseif unscoringCard[i]:is_suit("Diamonds", true) then
                        suits.D = suits.D + 1
                    elseif unscoringCard[i]:is_suit("Clubs", true) then
                        suits.C = suits.C + 1
                    end
                end

                if #unscoringCard ~= 0 and 
                    suits.H + suits.WC >= #unscoringCard or
                    suits.S + suits.WC >= #unscoringCard or
                    suits.D + suits.WC >= #unscoringCard or
                    suits.C + suits.WC >= #unscoringCard
                then
                    card.ability.extra.trigger = true
                end
            end
        end

        if context.joker_main and card.ability.extra.trigger then
            return {
                Xmult_mod = card.ability.extra.Xmult,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
              }
        end

        --this is just so blueprint plays nice with this card
        if context.final_scoring_step then
            card.ability.extra.trigger = false
        end





    end
}

function existsInTable(card, scored)
    for k, v in ipairs(scored) do
        if card == v then
            -- scoring
            return true
        end
    end
    return false
end

-- Golden Idol
SMODS.Joker {
    key= "golden_idol",
    atlas = "uncommons",
    pos = { x = 0, y = 0},
    rarity = 2,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    cost = 1,
    eternal_compat = false,
    rental_compat = false,
    loc_txt = {
        name = "Golden Idol",
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "Gains {C:money}$#2#{} of sell value at end",
            "of round"  
        }
    },
    config = { extra = { X = 0.25 , moolah = 25} },
    loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.X , card.ability.extra.moolah } }
        end,
    calculate = function(self, card, context)
       if context.joker_main then
        return {
            Xmult = card.ability.extra.X,
        }
        end
  
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
          card.ability.extra_value = card.ability.extra_value + card.ability.extra.moolah
          card:set_cost()
          return {
            message = localize('k_val_up'),
            colour = G.C.MONEY
        }
        end
  
  
  
    end
  }

  function existsInTable(card, scored)
    for k, v in ipairs(scored) do
        if card == v then
            -- scoring
            return true
        end
    end
    return false
end

-- World Cracker
SMODS.Joker {
    key= "world_cracker",
    atlas = "placeholder",
    pos = { x = 0, y = 0},
    rarity = 2,
    unlocked = true,
    discovered = true,
    cost = 7,
    loc_txt = {
        name = "World Cracker",
        text = {
            "Lower the level of the first",
            "played {C:attention}poker hand{} each round",
            "Lowering the level of a",
            "{C:attention}poker hand{} gives {C:money}$#1#{}" 
        }
    },
    config = { extra = { reward = 7 } },
    loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.reward } }
        end,
    calculate = function(self, card, context)
        if context.before and G.GAME.current_round.hands_played == 0 then
            if G.GAME.hands[context.scoring_name].level > 1 then
                level_up_hand(card, context.scoring_name, nil, -1)
            end
        end
  
  
  
    end
  }