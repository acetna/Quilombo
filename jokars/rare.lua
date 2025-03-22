-- Faustian Bargain
SMODS.Joker {
	key = 'faustian-bargain',
	loc_txt = {
		name = 'Faustian Bargain',
		text = {
			--"Each {C:attention}6{} in your {C:attention}full deck{}", 
      --"gives {X:mult,C:white}X#1#{} Mult.",
      "This joker's {X:mult,C:white}X{} Mult is multiplied",
      "by {X:mult,C:white}X#1#{} for every {C:attention}6{} in your {C:attention}full deck{}",
      "If your hand ever contains exactly",
      "three {C:attention}6s{} {S:1.5,C:red,E:2}YOU LOSE.{}",
      "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"

		}
	},
	config = { extra = { Xmult = 1.5, doomed = false, handSixes = {} } },
	loc_vars = function(self, info_queue, card)
    local sixTally = G.playing_cards and sixCount() or 0
		return { vars = { card.ability.extra.Xmult, math.ceil(card.ability.extra.Xmult^sixTally)} }
	end,
	rarity = 3,
	atlas = 'rares',
	pos = { x = 0, y = 0 },
  soul_pos = { x = 1, y = 0},
	cost = 8,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
	calculate = function(self, card, context)
		if context.joker_main and not card.ability.extra.doomed then
      local sixTally = G.playing_cards and sixCount() or 0
      local totalXmult = math.ceil(card.ability.extra.Xmult^sixTally)
        return {
          Xmult_mod = totalXmult,
          message = localize { type = 'variable', key = 'a_xmult', vars = { totalXmult } }
        }
		end
    if not context.blueprint then
      if context.final_scoring_step and card.ability.extra.doomed then
        return {
          Xmult_mod = 0,
          message = "Nice try"}
      end
      
      if context.hand_drawn or context.before or context.discard then
          for i = 1, #G.hand.cards do
            if G.hand.cards[i]:get_id() == 6 then 
              card.ability.extra.handSixes[#card.ability.extra.handSixes + 1] = G.hand.cards[i]
            end
          end
          
          if #card.ability.extra.handSixes == 3 then
            card.ability.extra.doomed = true
            claimSoul(card)
          else
            card.ability.extra.handSixes = {}
          end
        end
        
        if context.using_consumeable then
          G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.01,
            func = function()
              for i = 1, #G.hand.cards do
                if G.hand.cards[i]:get_id() == 6 then 
                  card.ability.extra.handSixes[#card.ability.extra.handSixes + 1] = G.hand.cards[i]
                end
              end
              if #card.ability.extra.handSixes == 3 then
                claimSoul(card)
              else
                card.ability.extra.handSixes = {}
              end 
              return true
              end
            })) 
        end

        if context.open_booster then
          G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 10,
            blocking = false,
            blockable = false,
            func = function()
              sendInfoMessage("NOW","faust")
              for i = 1, #G.hand.cards do
                if G.hand.cards[i]:get_id() == 6 then 
                  card.ability.extra.handSixes[#card.ability.extra.handSixes + 1] = G.hand.cards[i]
                end
              end
              if #card.ability.extra.handSixes >= 1 then
                claimSoul(card)
              else
                card.ability.extra.handSixes = {}
              end 
              return true
              end
            })) 
        end
    end
    
    
  end
}

function sixCount()
  local count = 0
  for _,v in ipairs(G.playing_cards) do
    if v:get_id() == 6 then count = count + 1 end
  end
  return count
end


function claimSoul(card)
  for i,v in pairs(card.ability.extra.handSixes) do
    v:set_ability(G.P_CENTERS.m_gold, true)
    v:set_edition({polychrome = true}, true)
    G.E_MANAGER:add_event(Event({
                      func = function()
                        v:juice_up()
                        return true
                        end
                      })) 
  end

  G.hand:change_size(-666)
  local doomedCards = {}
  for i = 1, #G.hand.cards do
    doomedCards[#doomedCards + 1] = G.hand.cards[i]
  end

  local _first_dissolve = false
  G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 2.5,
            blockable = false,
            func = function()
              for k, v in pairs(doomedCards,true) do
                  v:start_dissolve({G.C.BLACK})
              end
              return true
            end}))
  end

-- Golden Idol
SMODS.Joker {
  key= "golden-idol",
  atlas = "uncommons",
  pos = { x = 0, y = 0},
  rarity = 3,
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
