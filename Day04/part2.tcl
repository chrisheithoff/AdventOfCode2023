# Advent of Code 2023.  
# Day 04:  Scratchcards
# Part 2:  How many total scratchcards (originals and copies) do you end up with?
source ../aoc_library.tcl

package require struct 

proc get_card_value {card} {
    lassign [split $card ":|"] card_info winning_numbers my_numbers

    set my_wins [struct::set intersect $winning_numbers $my_numbers]

    set return [struct::set size $my_wins]
}

set data [file_to_list input.txt]

# Key = card #
# Value = number of cards for that card#
set num_cards [dict create]

set card_id 0
set sum 0
foreach card $data {
    puts ""
    incr card_id

    # Count the original card.  There may have already been copies counted.
    dict incr num_cards $card_id
    set card_id_count [dict get $num_cards $card_id]
    puts "Card $card_id: $card_id_count"

    # The current card's value, N, means that you get M copies of the next N cards.
    #  (where M is the number of total copies of card_id)
    set offset [get_card_value $card]
    while {$offset > 0} {  
        set other_card_id [expr $card_id + $offset]
        dict incr num_cards $other_card_id $card_id_count
        puts "Card $other_card_id: [dict get $num_cards $other_card_id]"
        incr offset -1
    }

    puts " sum = [incr sum [dict get $num_cards $card_id]]"
}

set sum [tcl::mathop::+ {*}[dict values $num_cards]]
puts "Part2 answer = $sum"

