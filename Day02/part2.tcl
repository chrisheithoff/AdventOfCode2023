# Advent of Code 2023.  
# Day 02:  Cube Conundrum
# Part 2:  In each game, what is the fewest number of cubes of each
#          color that could have been in the bag to make the game possible.
#          Answer = Sum of (min(red) * min(blue) * min(green)
source ../aoc_library.tcl

set data [file_to_list input.txt]


set sum 0

proc power_of_set_of_cubes {reveals} {
    set min(red)   0
    set min(green) 0
    set min(blue)  0
    foreach reveal [split $reveals ";"] {
        foreach set [split $reveal ","] {
            lassign $set count color
            if {$count > $min($color)} {
                set min($color) $count
                puts "  min($color) = $count"
            }
        }
    }
    set power [expr {$min(red) * $min(green) * $min(blue)}]
    puts "  power = $power"
    return $power
}

foreach line $data {

    # Each line looks like this:
    # Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    lassign [split $line ":"] game reveals

    set game_id [lindex $game 1]
    
    puts ""
    puts $line

    puts "sum = [incr sum [power_of_set_of_cubes $reveals]]"

}

puts ""
puts "Part2 answer = $sum"

