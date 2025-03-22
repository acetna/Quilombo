-- Passe Partout
SMODS.Joker {
    key= "passe-partout",
    atlas = "uncommons",
    pos = { x = 0, y = 0},
    rarity = 2,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    cost = 6,
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

