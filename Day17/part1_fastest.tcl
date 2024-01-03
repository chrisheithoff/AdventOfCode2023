# Advent of Code 2023.  
# Day 17: Clumsy Crucible
# Part 1: Find path of minimal heat loss.
source ../aoc_library.tcl

#  - Start at top left.   
#  - End at bottom right.
#  - You can turn left, continue straight, or turn right.
#  - You can't move in the same direction more than three times.

# Use Dijkstra's algorithm (actually the A* variation)
#   - each node of the graph is a state: {location direction streak}
#
# Initialize:  Start at top left with streak=0 and undefined direction  
# state         heat_loss  
# {0 0} E 0     0          
# 
# Step1: Mark the current state as visited.
#
# Step2: Get the possible next_states.  
# {0 1} E 1
# {1 0} S 1 
#
# Step3: Record the total heat_loss if we were to visit that state.
# state         heat_loss  
# {0 0} * 0     0          
# {0 1} E 1     2          
# {1 0} S 1     3          
#
# Step 4:  Add the new states to a priority queue.  Each state is sorted
#  by "heat_loss + distance_to_goal" from low to high.  
#
# Step 5:  Pop the first state off the priority queue.
#
# Go back to step 1.  Repeat until you're at the bottom right.

# Parse input
# set lines [file_to_list demo.txt]
set lines [file_to_list input.txt]
set grid  [make_grid_from_lines $lines]
set num_rows [llength $grid]
set num_cols [llength [lindex $grid 0]]
set max_r    [expr {$num_rows - 1}]
set max_c    [expr {$num_cols - 1}]


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

proc distance_to_goal {loc} {
    global max_distance
    lassign $loc x y 
    set distance [expr {$max_distance - $x - $y}]
    return $distance
}

# Implement the table as two dictionaries with key = state. 
set heat_loss [dict create]

# Record each visited state in a dict.  key = state.   value doesn't matter.
set visited   [dict create]

# Keep unvisited states in a priority queue.
#  {"state_a 1" "state_c 3" "state_b 5"}
set unvisited [list] 

# Special conditions. The start state is the place where streak = 0
set start_loc      [list 0 0]
set start_state    [list $start_loc E 0]
set end_loc        [list $max_r $max_c]
dict set heat_loss $start_state 0
set max_distance   [expr {$max_r + $max_c}]
lappend unvisited  [list $start_state $max_distance]

set state $start_state
while {1} {

    set heat_loss_so_far [dict get $heat_loss $state]
    # puts "Visited state = $state ($heat_loss_so_far)"

    # Step 1:  Mark state as visited
    dict incr  visited   $state

    # Are we there yet?
    lassign $state loc dir streak
    if {$loc == $end_loc} {
        break
    }

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
        #   - use "lsearch -bisect"
        set priority       [expr {$next_heat_loss + [distance_to_goal $next_loc]}]
        set insertion_spot [expr {[lsearch -index 1 -bisect -integer $unvisited $priority]+1}]
        set unvisited      [linsert $unvisited[set unvisited {}] $insertion_spot [list $next_state $priority]]
    }

    # Step 5: Choose the first value in the sorted priority queue
    set unvisited [lassign $unvisited[set unvisited {}] first]
    set state     [lindex $first 0]

}
set part1_answer [dict get $heat_loss $state]
puts "Part1 answer = $part1_answer"

