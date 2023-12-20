# Advent of Code 2023.  
# Day 14: Parabolic Reflector Dish
# Part 1: What's the load on the north end after rolling all rocks in that direction?
source ../aoc_library.tcl

proc roll_north {grid} {
    set grid [rotate_left $grid]

    set rolled_west_grid [list]
    foreach row $grid {
        set parts        [split $row "X"]
        set rolled_parts [lmap part $parts {lsort -decreasing $part}]
        set rolled_row   [split [join [join $rolled_parts "X"] ""] ""]
        lappend rolled_west_grid $rolled_row
    }

    set grid [rotate_right $rolled_west_grid]

    return $grid
}

proc total_north_load {grid} {
    set load 0
    set weight 1
    foreach row [lreverse $grid] {
        set num_round_rocks [llength [lsearch -all $row "O"]]
        incr load [expr $num_round_rocks * $weight]
        incr weight
    }
    return $load
}

set lines [file_to_list demo.txt]
set lines [file_to_list input.txt]

# Change '#' to 'X' because '#' is the comment character and does funny things.
set lines [string map "# X" $lines]
set grid  [make_grid_from_lines $lines]
print_grid $grid
puts ""
puts "------------------------------------------------------"
puts ""

set rolled_grid [roll_north $grid]
print_grid $rolled_grid

set north_load [total_north_load $rolled_grid]


puts "Part1 answer = $north_load"

