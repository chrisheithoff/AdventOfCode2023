# Advent of Code 2023.  
# Day 17: Clumsy Crucible
# Part 1: Find path of minimal heat loss.
source ../aoc_library.tcl


proc get_new_loc {loc dir} {
    lassign $loc r c
    if {$dir eq "E"} {
        incr c 
    } elseif {$dir eq "W"} {
        incr c -1
    } elseif {$dir eq "N"} {
        incr r -1
    } else {
        incr r 
    }
    return [list $r $c]
}

proc is_valid_loc {loc} {
    global max_r
    lassign $loc r c
    if {$r < 0 || $c < 0 || $r > $max_r || $c > $max_r} {
        return 0
    } else {
        return 1
    }
}

proc get_next_states {state} {
    set next_states [list]
    lassign $state loc dir streak

    # Right turn (only if grid exists. reset streak to 1)
    set new_dir [dict get "E S S W W N N E" $dir]
    set new_loc [get_new_loc $loc $new_dir]
    if {[is_valid_loc $new_loc]} {
        lappend next_states [list $new_loc $new_dir 1]
    }

    # Left turn (only if grid exists. reset streak to 1)
    set new_dir [dict get "E N S E W S N W" $dir]
    set new_loc [get_new_loc $loc $new_dir]
    if {[is_valid_loc $new_loc]} {
        lappend next_states [list $new_loc $new_dir 1]
    }

    # Straight (only if streak if less than 3)
    if {$streak < 3} {
        set new_dir $dir
        set new_loc [get_new_loc $loc $dir]
        if {[is_valid_loc $new_loc]} {
            lappend next_states [list $new_loc $new_dir [incr streak]]
        }
    }
    return $next_states
}

proc iterate {} {
    global go
    global heat_loss
    global visited
    global unvisited
    global state
    global end_loc
    global grid
     
    set heat_loss_so_far [dict get $heat_loss $state]

    # Step 1:  Mark state as visited
    dict incr  visited   $state

    # Step 2: Get the possible next states.
    set next_states     [get_next_states $state]

    # Step 3: Update the tables for the next states.
    foreach next_state $next_states {
        
        # Skip if already visited that exact state.
        if {[dict exists $visited $next_state]} {
            continue
        }

        # Figure out the total heat loss if we were to visit this state.
        set next_loc         [lindex $next_state 0]
        set incr_heat_loss   [lindex $grid {*}$next_loc]
        set next_heat_loss   [expr {$heat_loss_so_far + $incr_heat_loss}]

        # Add a new state to the heat loss table (or replace with a better value)
        if {![dict exists $heat_loss $next_state]} {
            dict set heat_loss $next_state $next_heat_loss
        } elseif {$next_heat_loss < [dict get $heat_loss $state]} {
            dict set heat_loss $next_state $next_heat_loss
        } else {
            continue
        }

        # Add the next_state to the unvisited priority queue according to its distance to goal.
        lassign $next_loc next_r next_c
        set priority   [expr {$next_heat_loss - $next_r - $next_c}]
        set i          [lsearch -index 1 -bisect -integer $unvisited $priority]
        set unvisited  [linsert $unvisited[set unvisited {}] $i+1 [list $next_state $priority]]
    }

    # Step 5: Choose the first value in the sorted priority queue
    set unvisited [lassign $unvisited[set unvisited {}] first]
    set state     [lindex $first 0]

}

# Parse input
# set lines [file_to_list demo.txt]
set lines [file_to_list input.txt]
set grid  [make_grid_from_lines $lines]
set num_rows [llength $grid]
set num_cols [llength [lindex $grid 0]]
set max_r    [expr {$num_rows - 1}]
set max_c    [expr {$num_cols - 1}]

# Keep your records here.
set heat_loss [dict create]
set visited   [dict create]
set unvisited [list] 

# Special conditions. The start state is the place where streak = 0
set start_state    [list [list 0 0] E 0]
set end_loc        [list $max_r $max_c]
dict set heat_loss $start_state 0
lappend unvisited  [list $start_state 0]

set state $start_state
while {[lindex $state 0] != $end_loc} {
    iterate
}

puts "Part1 answer = [dict get $heat_loss $state]"

