function level_up_hand(card, hand, instant, amount)
    amount = amount or 1
    G.GAME.hands[hand].level = math.max(0, G.GAME.hands[hand].level + amount)
    G.GAME.hands[hand].mult = math.max(G.GAME.hands[hand].s_mult + G.GAME.hands[hand].l_mult*(G.GAME.hands[hand].level - 1), 1)
    G.GAME.hands[hand].chips = math.max(G.GAME.hands[hand].s_chips + G.GAME.hands[hand].l_chips*(G.GAME.hands[hand].level - 1), 0)
    if true then
        
        G.E_MANAGER:add_event(Event({func = function()
            ease_dollars(7, true)
        end}))
    end
    if not instant then 
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            play_sound('tarot1')
            if card then card:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = true
            return true end }))
        update_hand_text({delay = 0}, {mult = G.GAME.hands[hand].mult, StatusText = true})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
            play_sound('tarot1')
            if card then card:juice_up(0.8, 0.5) end
            return true end }))
        update_hand_text({delay = 0}, {chips = G.GAME.hands[hand].chips, StatusText = true})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
            play_sound('tarot1')
            if card then card:juice_up(0.8, 0.5) end
            G.TAROT_INTERRUPT_PULSE = nil
            return true end }))
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level=G.GAME.hands[hand].level})
        delay(1.3)
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function() check_for_unlock{type = 'upgrade_hand', hand = hand, level = G.GAME.hands[hand].level} return true end)
    }))
end