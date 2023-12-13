# Advent of Code 2023.  
# Day 11:  Cosmic Expansion
# Part 1:  Find sum of length of the shortest path between every pair of galaxies...
#          ...but the universe has expanded in the meantime!
source ../aoc_library.tcl

set lines [file_to_list input.txt]
set grid  [make_grid_from_lines $lines]

#  - Any rows of columns that contain no galaxies should be twice as big!
proc expand_empty_rows {grid} {

    # Find which rows are empty
    set num_cols       [llength [lindex $grid 0]]
    set empty_row      [lrepeat $num_cols "."]
    set rows_to_expand [lsearch -all $grid $empty_row]


    # Go in reverse to preserve index position.
    foreach i [lreverse $rows_to_expand] {
        set grid [linsert $grid $i $empty_row]
    }

    return $grid
}

proc expand_the_universe {grid} {
    # Expand rows
    set grid [expand_empty_rows $grid]

    # Expand columns.   
    set grid [rotate_left $grid]
    set grid [expand_empty_rows $grid]
    set grid [rotate_right $grid]

    return $grid
}

proc galaxy_distance {g1 g2} {
    lassign $g1 x1 y1
    lassign $g2 x2 y2
    set distance [expr {abs($x1 - $x2) + abs($y1 - $y2)}]
    return $distance
}

proc locate_galaxies {grid} {
    set galaxy_locations [list]
    set r -1
    foreach row $grid {
        incr r
        set c -1
        foreach char $row {
            incr c
            if {$char ne "."} {
                lappend galaxy_locations [list $r $c]
            }
        }
    }
    return $galaxy_locations
}
#  - The distance between any pair of galaxies is Manhattan distance.

set grid [expand_the_universe $grid]
print_grid $grid

set galaxy_locations [locate_galaxies $grid]
set sum 0
foreach g1 $galaxy_locations {
    foreach g2 $galaxy_locations {
        # avoid measuring g1 vs g2, and then g2 vs g1 later
        if {$g1 < $g2} {
            set distance [galaxy_distance $g1 $g2]
            incr sum $distance
            puts "{$g1} to {$g2}: $distance  (sum = $sum)"
        }
    }
}
puts "Part1 answer = $sum"

