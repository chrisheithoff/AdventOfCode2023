# Advent of Code 2023.  
# Day 16: Clumsy Crucible
# Part 1: Find path of minimal heat loss.
source ../aoc_library.tcl

#  - Start at top left.   
#  - End at bottom right.
#  - You can turn left, continue straight, or turn right.
#  - You can't move in the same direction more than three times.

# Use Dijkstra's algorithm.
#   - each node of the graph should be location, direction and streak.
#
# Initialize:  Start at top left with streak=0 and undefined direction  
# state            heat_loss    from 
# 0,0,*,0          0            start
# 
# Step1: Mark the current state as visited.
#
# Step2: Get the possible next_states.  Mark these as unvisited.
# 0,1,E,1 
# 1,0,S,1 
#
# Step3: Record the total heat_loss if we were to visit that state.
# state            heat_loss    from 
# 0,0,*,0          0            start
# 0,1,E,1          2            0,0,*,0
# 1,0,S,1          3            0,0,*,0
#
# Step 4:  Choose the unvisited state with the minimum heat_loss:
# state            heat_loss    from 
# 0,0,*,0          0            start
# 0,1,E,1          2            0,0,*,0  <--------- 
# 1,0,S,1          3            0,0,*,0
#
# Go back to step 1.  Repeat until you're at the bottom right.

# Parse input
# set lines [file_to_list demo.txt]
set lines [file_to_list input.txt]
set grid  [make_grid_from_lines $lines]
set num_rows [llength $grid]
set num_cols [llength [lindex $grid 0]]
set max_r    [expr $num_rows - 1]
set max_c    [expr $num_cols - 1]


proc get_new_loc {loc dir} {
    set delta   [dict get "E {0 1} W {0 -1} N {-1 0} S {1 0}" $dir]
    set new_loc [vector_add $loc $delta]
}

proc is_valid_loc {loc} {
    global grid
    if {[lindex $grid {*}$loc] == {}} {
        return 0
    } else {
        return 1
    }
}

proc get_next_states {state} {
    global grid
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

proc print_path {} {
    global grid
    global from
    global visited
    global end_loc
    set grid_with_path [regsub -all {[0-9]} $grid "."]

    foreach state [dict keys $visited] {
        set loc [lindex $state 0]
        if {$loc == $end_loc} {
            break
        }
    }

    set prev $state
    while {$prev ne "start"} {
        lassign $prev loc dir streak
        set char [string map "E > W < N ^ S v" $dir]
        lset grid_with_path {*}$loc $char
        set prev [dict get $from $prev]

    }

    print_grid $grid_with_path
}

# Implement the table as two dictionaries with key = state.
set heat_loss [dict create]
set from      [dict create]
set visited   [dict create]
set unvisited [dict create]

# Special conditions. The start state is the place where streak = 0
set start_state [list {0 0} E 0]
set end_loc     [list $max_r $max_c]
dict set heat_loss $start_state 0
dict set from      $start_state "start"

set state $start_state
while {1} {
    incr i

    set total_heat_loss [dict get $heat_loss $state]
    puts "Visted state = $state ($total_heat_loss)"

    # Step 1:  Mark state as visited
    dict incr  visited   $state
    dict unset unvisited $state

    # Are we there yet?
    lassign $state loc dir streak
    if {$loc == $end_loc} {
        break
    }


    # Step 2: Get the possible next states and the total heat loss if we were to visit that state.
    set next_states     [get_next_states $state]

    # Step 3: Update the tables for the next states.
    foreach next_state $next_states {
        
        # Skip if already visited or add to the unvisited dict. 
        if {[dict exists $visited $next_state]} {
            continue
        } else {
            dict incr unvisited $next_state
        }

        # Set the total heat loss if we were to visit this state.
        set next_loc         [lindex $next_state 0]
        set incr_heat_loss   [lindex $grid {*}$next_loc]
        set next_heat_loss   [expr {$total_heat_loss + $incr_heat_loss}]

        if {![dict exists $heat_loss $next_state]} {
            dict set heat_loss $next_state $next_heat_loss
            dict set from      $next_state $state
        } else {
            set heat_loss_from_table [dict get $heat_loss $state]
            if {$next_heat_loss < $heat_loss_from_table} {
                dict set heat_loss $next_state $next_heat_loss
                dict set from      $next_state $state
            }
        }
    }

    # Step 4: Choose the next UNVISITED state with the one with minimum heat loss.
    #         If multiple states share the minimum value, then chose the one with 
    #         the biggest row+col score.
    set min_heat    1000000000
    set max_score   0 
    foreach state [dict keys $unvisited] {
        set heat [dict get $heat_loss $state]
        if {$heat <= $min_heat} {
            set min_heat   $heat

            set score [expr [lindex $state 0 0] + [lindex $state 0 1]]
            # puts "MIN: $min_heat , $score"
            if {$score > $max_score} {
                set max_score $score
                # puts "MIN: $min_heat , $score (new max)"
            } else {
                # puts "MIN: $min_heat , $score"
            }
            set next_state $state
        }            
    }

    set state $next_state

}
print_path
puts "Part1 answer = $min_heat"

