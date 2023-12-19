# Advent of Code 2023.  
# Day 13: Point of Incidence  
# Part 1:  Find the mirrors
source ../aoc_library.tcl

# Grid is a list of strings.
proc find_mirror {grid} {
    for {set i 1} {$i < [llength $grid] } {incr i} {
        # puts "--- $i ---------"
        set is_reflection 1
        set m [expr {$i - 1}]
        set n $i
        while {$m >=0 && $n < [llength $grid]} {
            set first  [lindex $grid $m]
            set second [lindex $grid $n]
            # puts ""
            # puts "$m : $first"
            # puts "$n : $second"
            if {$first ne $second} {
                set is_reflection 0
                # puts "--> Not a reflection"
                break
            }
            incr m -1
            incr n  1
        }
        if {$is_reflection == 1} {
            # puts "--> Reflection after $i"
            return $i
        }
    }
    # puts "--> No reflection"
    return 0
}

proc rotate_right {grid} {
    set rotated_grid [list]
    set num_columns [string length [lindex $grid 0]]
    for {set j 0} {$j < $num_columns} {incr j} {
        set column_j [lmap g $grid {string index $g $j}]
        lappend rotated_grid [join [lreverse $column_j] ""]
    }
    return $rotated_grid
}


set grids [file_to_list_of_lists input.txt]

set sum 0
foreach grid $grids {
    # Find the location of the mirror reflecting rows.
    set r [find_mirror $grid]
    set c [find_mirror [rotate_right $grid]]

    set note [expr {$c + 100*$r}]
    set sum  [incr sum $note]
    puts "$r $c : sum += $note => $sum"

}
puts "Part1 answer = $sum"

