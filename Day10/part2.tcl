# Advent of Code 2023.  
# Day 10:  Pipe Maze
# Part 2:  How many tiles are contained by the loop?
source ../aoc_library.tcl

set lines [file_to_list input.txt]
set grid  [make_grid_from_lines $lines]

set num_rows [llength $grid]
set num_cols [llength [lindex $grid 0]]

# Start at coord.  Give a direction to travel N,E,S,W.  Return new coord.
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

proc print_unicode_grid {grid} {
    # Map the 7, J, F, L, -, | to unicode characters that better represent corners.
    #   https://www.w3.org/TR/xml-entity-names/025.html
    set unicode_map { 7 \U2510 F \U250C J \U2518 L \U2514 - \U2500 | \U2502  * \U2588}
    set unicode_grid [string map $unicode_map $grid]

    # 'print_grid' proc is in aoc_library.tcl
    print_grid $unicode_grid
}

# Find where the 'S' character is.
set S_row [lsearch $grid "*S*"]
set S_col [lsearch [lindex $grid $S_row] "S"]
set S     [list $S_row $S_col]

# What type of pipe is S? Check the neighbors.
set good_neighbors [list]
set good_neighbor_chars {"E" "- 7 J"   "W" "- F L"  "N"  "| 7 F"  "S"  "| J L"}
foreach dir {N E S W} {
    set neighbor_coord [get_next_coordinate $S $dir]
    set neighbor_char  [lindex $grid {*}$neighbor_coord]
    puts "$dir: $neighbor_char $neighbor_coord"
    if {$neighbor_char in [dict get $good_neighbor_chars $dir]} {
        lappend good_neighbors $dir
        puts "  GOOD!"
    }
}
set good_neighbors [lsort $good_neighbors]
set pipe_types { "E W"  "-" "E S"  "F" "E N"  "L" "N S"  "|" "N W"  "J" "S W"  "7" }
set S_pipe [dict get $pipe_types $good_neighbors]

# Initialize a solution grid with just dots.
set solved_grid [lrepeat $num_rows [lrepeat $num_cols .]]

# Start at S.  Initialize 'dir' to be the direction to *enter* S.  
set coord $S
set char $S_pipe
set dir [string map "E W W E N S S N" [lindex $good_neighbors 0]]

set num_steps 0
while {1} {
    incr num_steps

    # If you enter a pipe in a given direction, then what direction do you leave the pipe?
    set next_dir   [get_pipe_output_dir $dir $char]
    set next_coord [get_next_coordinate $coord $next_dir]
    set next_char  [lindex $grid {*}$next_coord]
    
    if {$next_char == "S"} {
        lset solved_grid {*}$next_coord $S_pipe
        puts "Step ($num_steps):  Back at S."
        break
    } else {
        lset solved_grid {*}$next_coord $next_char
        set dir   $next_dir
        set coord $next_coord
        set char  $next_char
        puts "Step ($num_steps): Go $dir to: {$coord} = $char"
    }
}

# Now count "." tiles which lie inside the loop.
#  - scan each row from left to right.
#  - use a state machine.  start in the "OUT" state.
set next_state [dict create]
dict set next_state "OUT"  "|" "IN"  
dict set next_state "OUT"  "F" "OUTER_F"
dict set next_state "OUT"  "L" "OUTER_L"

dict set next_state "IN"   "|" "OUT"
dict set next_state "IN"   "F" "INNER_F"
dict set next_state "IN"   "L" "INNER_L"

dict set next_state "OUTER_F"  "J" "IN"
dict set next_state "OUTER_F"  "7" "OUT"

dict set next_state "OUTER_L"  "J" "OUT"
dict set next_state "OUTER_L"  "7" "IN"

dict set next_state "INNER_F"  "J" "OUT"
dict set next_state "INNER_F"  "7" "IN"

dict set next_state "INNER_L"  "J" "IN"
dict set next_state "INNER_L"  "7" "OUT"
 
set area 0
for {set r 0} {$r < $num_rows} {incr r} {
    set state "OUT"
    for {set c 0} {$c < $num_cols} {incr c} {
        set char [lindex $solved_grid $r $c]

        if {$char eq "." && $state in "IN"} {
            lset solved_grid $r $c "*"
            incr area
        }

        # Change states if required.
        if {[dict exists $next_state $state $char]} {
            set state [dict get $next_state $state $char]
        }
    }
}

# Super cool visualization
print_unicode_grid $solved_grid 
# print_grid $solved_grid 

puts "Part2 answer = $area"

