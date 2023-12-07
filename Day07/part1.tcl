# Advent of Code 2023.  
# Day 07:  Camel Cards
# Part 1:  find the amount won (sum of rank * bet) 
source ../aoc_library.tcl


set data [file_to_list input.txt]

# The hand_value will be a two item list:
#     1)  hand_type_value is a number from 1 to 7.
#          (five of a kind = 7, four of a kind = 6, etc)
#     2)  cards remapped to a sortable ascii string.
#             2 3 4 5 6 7 8 9 T J Q K A
#         ->  2 3 4 5 6 7 8 9 A B C D E
proc get_hand_value {hand} {
    set counts [dict create]

    foreach card [split $hand ""] {
        dict incr counts $card
    }

    set count_values [lsort -decreasing -integer [dict values $counts]]

    set type_signatures {
        {1 1 1 1 1}  1    ; # high card
        {2 1 1 1}    2    ; # one pair
        {2 2 1}      3    ; # two pair
        {3 1 1}      4    ; # three of a kind
        {3 2}        5    ; # full house
        {4 1}        6    ; # 4 of a kind
        {5}          7    ; # 5 of a kind
    }
    foreach {signature type} $type_signatures {
        if {$signature == $count_values} {
            break
        }
    }

    # Remap TJQKA to a sequence of numbers that sort after 9 in ascii
    set order [string map "T A J B Q C K D A E" $hand]
    return [list $type $order]
}

# Use this proc later with "lsort -command"
proc hand_sort {a b} {
    global hand_values
    set value_a [dict get $hand_values $a]
    set value_b [dict get $hand_values $b]

    if {$value_a > $value_b} {
        return 1
    } else {
        return -1
    } 
}

set sum 0
set hands [list]
set hand_values [dict create]
set hand_bets   [dict create]

# Save the value and bet for each card in two dictionaries
foreach line $data {
    lassign $line hand bet
    lappend hands $hand
    set value [get_hand_value $hand]

    dict set hand_values $hand $value
    dict set hand_bets   $hand $bet
}

# Sort the hands by their hand type and first card (or second card, etc..)
set sorted_hands [lsort -command hand_sort $hands]

# Use the sorted hands to get the answer"
set rank 0
foreach hand $sorted_hands {
    incr rank
    set bet   [dict get $hand_bets $hand]
    set value [dict get $hand_values $hand]
    
    set winnings [expr {$bet * $rank}]

    incr sum $winnings
    puts "$rank: $hand ($value):  bet = $bet : sum = $sum"
}
        
puts "Part1 answer = $sum"
