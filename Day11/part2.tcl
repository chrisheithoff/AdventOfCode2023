# Advent of Code 2023.  
# Day 11:  Cosmic Expansion
# Part 2:  Same, but now empty space is expanded by 1 million, not just two!
#          ...but the universe has expanded in the meantime!
source ../aoc_library.tcl


proc get_empty_rows {grid} {
    set num_cols       [llength [lindex $grid 0]]
    set empty_row      [lrepeat $num_cols "."]
    set empty_rows     [lsearch -all $grid $empty_row]
    return $empty_rows
}

proc get_empty_cols {grid} {
    set rotated_grid [rotate_right $grid]
    return [get_empty_rows $rotated_grid]
}

proc galaxy_distance {g1 g2 "expansion_factor 2"} {
    set extra [expr $expansion_factor - 1]

    lassign $g1 r1 c1
    lassign $g2 r2 c2
    global empty_rows
    global empty_cols

    # Find the number empty cols between g1 and g2.
    set min_c [expr min($c1,$c2)]
    set max_c [expr max($c1,$c2)]
    set num_empty_cols 0
    lmap c $empty_cols {if {$min_c < $c && $c < $max_c} {incr num_empty_cols}}

    # Find the number empty rows between g1 and g2.
    set min_r [expr min($r1,$r2)]
    set max_r [expr max($r1,$r2)]
    set num_empty_rows 0
    lmap r $empty_rows {if {$min_r < $r && $r < $max_r} {incr num_empty_rows}}

    # Distance = Manhattan distance + empty_rows + empty_cols
    set manhattan_distance [expr {abs($r1 - $r2) + abs($c1 - $c2)}]
    set extra_rows         [expr {$num_empty_rows * $extra}]
    set extra_cols         [expr {$num_empty_cols * $extra}]

    set distance [expr {$manhattan_distance + $extra_rows + $extra_cols}]
    
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


set lines [file_to_list input.txt]
set grid  [make_grid_from_lines $lines]
set empty_rows [get_empty_rows $grid]
set empty_cols [get_empty_cols $grid]

set galaxy_locations [locate_galaxies $grid]
set expansion_factor 1000000
set sum 0
foreach g1 $galaxy_locations {
    foreach g2 $galaxy_locations {
        # avoid measuring g1 vs g2, and then g2 vs g1 later
        if {$g1 < $g2} {
            set distance [galaxy_distance $g1 $g2 $expansion_factor]
            incr sum $distance
            puts "{$g1} to {$g2}: $distance  (sum = $sum)"
        }
    }
}
puts "Part2 answer = $sum"

