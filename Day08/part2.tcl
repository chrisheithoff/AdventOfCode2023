# Advent of Code 2023.  
# Day 08:  Haunted Wasteland
# Part 2:  Actually, the map is for ghosts. Start at all nodes ending with A and
#          end at all nodes ending with Z.
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


# Find all nodes ending in A.
set a_nodes [list]
foreach node [dict keys $node_dict] {
    if {[string match *A $node]} {
        lappend a_nodes $node
    }
}

proc get_z_steps {a_node "num_z_nodes 2"} {

    global node_dict directions
    # Set an index counter for cycling through the directions list (RLLRRLRLRLRLRRL....)
    set i 0
    set max_i [expr [string length $directions] - 1]

    set num_steps 0
    set current_node $a_node
    set z_nodes_found 0
    set z_steps [list]
    puts "a_node = $a_node"

    while {1} {
        incr num_steps

        set choice    [string index $directions $i]
        set next_node [dict get $node_dict $current_node $choice]

        if {[string match *Z $next_node]} {
            incr z_nodes_found
            puts "$num_steps ($z_nodes_found):  ${current_node} $choice --> $next_node ([expr $num_steps % ($max_i)])"
            lappend z_steps $num_steps 
            if {$z_nodes_found == $num_z_nodes} {
                break
            }
        }

        # Increment the index or return to 0.
        if {$i == $max_i} {
            set i 0
        } else {
            incr i
        }
        set current_node $next_node
    }

    return $z_steps
}

# To disbelief, the number of steps from an "a" node to a "z" is the same as the
# number of steps from a "z" to the next "z"
set cycles [list]
foreach a_node $a_nodes {
    set z_steps [get_z_steps $a_node 2]
    set period [expr [lindex $z_steps end] - [lindex $z_steps end-1]]
    lappend cycles $period
}

# From https://rosettacode.org/wiki/Least_common_multiple#Tcl
proc lcm {p q} {
    set m [expr {$p * $q}]
    if {!$m} {return 0}
    while 1 {
        set p [expr {$p % $q}]
        if {!$p} {return [expr {$m / $q}]}
        set q [expr {$q % $p}]
        if {!$q} {return [expr {$m / $p}]}
    }
}

puts "Need to find the least common multiple of $cycles"
set lcm 1
foreach cycle $cycles {
    set lcm [lcm $lcm $cycle]
    puts "lcm = $lcm"
}

puts "Part2 answer = ???"
