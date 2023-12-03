# Advent of Code 2023.  
# Day 02:  Cube Conundrum
# Part 1:  Which games would have been possible if the bag had been loaded 
#          with only 12 red cubes, 13 green cubes and 14 blue cubes.
source ../aoc_library.tcl

set data [file_to_list input.txt]


proc is_possible {reveals} {
    set max(red)   12
    set max(green) 13
    set max(blue)  14
    foreach reveal [split $reveals ";"] {
        foreach set [split $reveal ","] {
            lassign $set count color
            if {$count > $max($color)} {
                set possible 0
                puts "   $color:  $count > $max($color)"
                return 0
            }
        }
    }
    return 1
}

set sum 0
foreach line $data {

    # Each line looks like this:
    # Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    lassign [split $line ":"] game reveals

    set game_id [lindex $game 1]
    
    puts ""
    puts $line

    if {[is_possible $reveals]} {
        puts "  possible: $sum --> [incr sum $game_id]"
    } else {
        puts "  impossible"
    }  

}

puts "Part1 answer = $sum"

