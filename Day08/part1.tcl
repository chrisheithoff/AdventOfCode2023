# Advent of Code 2023.  
# Day 08:  Haunted Wasteland
# Part 1:  How many steps following the RL instructions to go from AAA to ZZZ.
source ../aoc_library.tcl


set data [file_to_list input.txt]

set directions [lindex $data 0]
set node_data  [lrange $data 2 end]

# key1: starting point
#    key2: L  left point
#    key2: R  right point
#
set node_dict [dict create]
foreach line $node_data {
    set line [regsub -all {[=(,)]} $line ""]
    lassign $line start left right
    dict set node_dict $start L $left
    dict set node_dict $start R $right
}


set i 0
set max_i [expr [string length $directions] - 1]
set current_node "AAA"
set num_steps 0
puts "0:  $current_node"
while {1} {
    incr num_steps
    set choice    [string index $directions $i]
    set next_node [dict get $node_dict $current_node $choice]

    puts "$num_steps:  $choice --> $next_node"
    if {$next_node eq "ZZZ"} {
        puts "DONE"
        break
    }

    # Increment the index or return to 0.
    if {$i == $max_i} {
        set i 0
    } else {
        incr i
    }

    set current_node $next_node
}
        
puts "Part1 answer = $num_steps"
