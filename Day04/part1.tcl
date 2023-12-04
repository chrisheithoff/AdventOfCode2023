# Advent of Code 2023.  
# Day 04:  Scratchcards
# Part 1:  How many points are your scratch cards worth.
source ../aoc_library.tcl

package require struct 

proc get_card_value {card} {
    lassign [split $card ":|"] card_info winning_numbers my_numbers

    set my_wins [struct::set intersect $winning_numbers $my_numbers]

    set value [expr 2 ** ([llength $my_wins]-1) ]
}

set data [file_to_list input.txt]

set sum 0
foreach card $data {
    set card_value [get_card_value $card]
    puts "$card_value : sum = [incr sum $card_value]"
}

puts "Part1 answer = $sum"

