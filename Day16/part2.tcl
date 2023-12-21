# Advent of Code 2023.  
# Day 16: The Floor Will Be Lava
# Part 2: Find the most energized possible state.
source ../aoc_library.tcl

proc next_dir {dir char} {

    if {$char == ""} {
        return ""
    } 
    
    # Don't retrace a tile in the same direction as earlier.
    if {$dir eq $char} {
        #
        return ""
    } 

    # These conditions will change the direction (or even split it)
    set new_dir_dict [dict create]
    dict set new_dir_dict {> /} ^
    dict set new_dir_dict {> b} v
    dict set new_dir_dict {> |} [list ^ v]

    dict set new_dir_dict {< /} v
    dict set new_dir_dict {< b} ^
    dict set new_dir_dict {< |} [list ^ v]

    dict set new_dir_dict {^ /} >
    dict set new_dir_dict {^ b} <
    dict set new_dir_dict {^ -} [list < >]

    dict set new_dir_dict {v /} <
    dict set new_dir_dict {v b} >
    dict set new_dir_dict {v -} [list < >]

    # Return a new direction or the same one as before.
    set key [list $dir $char]
    if {[dict exists $new_dir_dict $key]} {
        set new_dir [dict get $new_dir_dict $key]
    } else {
        set new_dir $dir
    }

    return $new_dir
}

proc mark_grid {loc dir} {
    global grid
    set char [lindex $grid {*}$loc]
    if {$char == ""} {
        return
    } elseif {$char in {- | / b}} {
        return
    } elseif {$char == $dir} {
        return
    } elseif {$char == "."} {
        lset grid {*}$loc $dir
    } elseif {$char in "v ^ < >"} {
        lset grid {*}$loc #
    } else {
        # leave it as is
    }
}

# Return a list of lists:
#   - state = {loc dir}
proc next_states {current_state} {
    global grid

    # Return a list of the next state or states as a result of moving 
    #  one grid location in the current direction.
    set next_states [list]

    # Define a state as a list "location direction"
    lassign $current_state loc dir

    # Use the direction to move one direction.
    set dir_to_delta  {">" {0 1}  "<" {0 -1} "v" {1 0}  "^" {-1 0} }
    set delta         [dict get $dir_to_delta $dir]
    set new_loc       [vector_add $loc $delta]

    # Use the new location's character to define the new direction.
    set new_char  [lindex $grid {*}$new_loc]
    set new_dir   [next_dir $dir $new_char]

    # Mark the grid
    mark_grid $new_loc $dir

    foreach d $new_dir {
        lappend next_states [list $new_loc $d]
    }

    return $next_states
}



# backslashes cause problems later.  Replace with b.
# set f    [open demo.txt]
set f    [open input.txt]
set data [read $f]
set data [string map [list "\\" "b"] $data]
set lines [lrange [split $data "\n"] 0 end-1]
close $f

set orig_grid [make_grid_from_lines $lines]

# Find all the starting locations and directions
set start_locs [list]
set start_dirs [list]
set num_rows [llength $orig_grid] 
set num_cols [llength [lindex $orig_grid 0]] 
foreach c "-1 $num_cols" d "> <" {
    for {set r 0} {$r < $num_rows} {incr r} {
        lappend start_locs [list $r $c]
        lappend start_dirs $d
    }
}
foreach r "-1 $num_rows" d "v ^" {
    for {set c 0} {$c < $num_cols} {incr c} {
        lappend start_locs [list $r $c]
        lappend start_dirs $d
    }
}

set max_energized 0
set max_grid 0
foreach start_loc $start_locs start_dir $start_dirs {
    set grid $orig_grid
    set start_state [list $start_loc $start_dir]
    set stack [list $start_state]

    set energized [dict create]
    while {[llength $stack] > 0} {
        # pop off from the stack
        set stack [lassign $stack state]
        # puts ""
        # puts "state = $state"

        # Mark this location as energized
        set loc [lindex $state 0]
        dict incr energized $loc 

        set next_states [next_states $state]
        # after 40
        # puts [exec clear]
        # print_grid $grid

        # put next_states back on the stack.  This is how we can manage splits
        set stack [list {*}$next_states {*}$stack]
    }

    dict unset energized $start_loc
    set num_energized [dict size $energized]
    if {$num_energized > $max_energized} {
        set max_energized $num_energized
        set max_grid      $grid
        set max_start_loc $start_loc
        set max_start_dir $start_dir
    }
    puts "{$start_loc} $start_dir:  $num_energized (max = $max_energized)"
}
puts ""
puts "{$max_start_loc} $max_start_dir"
print_grid $max_grid
puts "Part2 answer = $max_energized"

