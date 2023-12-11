# Advent of Code 2023.  
# Day 10:  Pipe Maze
# Part 1:  Find the farthest distance in the pipe from the animal.
source ../aoc_library.tcl

set lines [file_to_list input.txt]
set grid  [make_grid_from_lines $lines]

set num_rows [llength $grid]
set num_cols [llength [lindex $grid 0]]

# Find the 'S' character
set S_row [lsearch $grid "*S*"]
set S_col [lsearch [lindex $grid $S_row] "S"]
set S     [list $S_row $S_col]

proc get_next_coordinate {coord direction} {
    set map {E {0 1}   W {0 -1}   N {-1 0}  S {1 0}}
    set delta [dict get $map $direction]
    return [vector_add $coord $delta]
}

proc get_pipe_output_dir {pipe_input_dir pipe_char} {
    set map {
        {W -} W  {W L} N  {W F} S
        {N |} N  {N 7} W  {N F} E
        {S |} S  {S J} W  {S L} E
        {E -} E  {E J} N  {E 7} S
    }
    return [dict get $map [list $pipe_input_dir $pipe_char]]
}


# Find the an abutting part of the grid with a connected pipe.
puts "Searching for a connected pipe:"
set start(E) "- 7 J"
set start(W) "- F L"
set start(N) "| F 7"
set start(S) "| J L"
foreach dir {E W N S} {
    
    set coord [get_next_coordinate $S $dir]
    set char  [lindex $grid {*}$coord]
    puts "   $dir: $char"
    if {$char in $start($dir)} {
        puts "    start going here"
        break
    }
}


puts "Step (1): Go $dir to: {$coord} = $char"

set solved_grid [lrepeat $num_rows [lrepeat $num_cols .]]
set num_steps 1
while {1} {
    incr num_steps

    set next_dir   [get_pipe_output_dir $dir $char]
    set next_coord [get_next_coordinate $coord $next_dir]
    set next_char  [lindex $grid {*}$next_coord]
    
    lset solved_grid {*}$next_coord $next_char

    if {$next_char == "S"} {
        puts "Step ($num_steps):  Back at S."
        break
    } else {
        set dir   $next_dir
        set coord $next_coord
        set char  $next_char
        puts "Step ($num_steps): Go $dir to: {$coord} = $char"
    }

}

print_grid $solved_grid 
# Divide the total loop distance by 2 to get the part1 answer.

set max_distance [expr {$num_steps / 2}]

puts "Part1 answer = $max_distance"

