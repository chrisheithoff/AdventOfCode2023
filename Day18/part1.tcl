# Advent of Code 2023.  
# Day 18: Lavaduct Lagoon
# Part 1: How much cubic meters of lava?
source ../aoc_library.tcl

# Let's follow this:
#     https://advent-of-code.xavd.id/writeups/2023/day/18/

# Parse input
# set lines [file_to_list demo.txt]
set lines [file_to_list input.txt]

set offsets [dict create]
dict set offsets R {0 1}
dict set offsets L {0 -1}
dict set offsets D {1 0}
dict set offsets U {-1 0}

# Create a list of points.
set points [list]
lappend points [list 0 0]
foreach line $lines {
    lassign $line dir distance
    set start_point [lindex $points end]
    set offset      [vector_mult $distance [dict get $offsets $dir]]
    set new_point   [vector_add $start_point $offset]
    puts "$new_point"
    lappend points $new_point
}

# Return the number of points on the outline plus the number of points enclosed by the outline
proc num_points {outline_points} {
    # Shoelace Formula : The area inside an outline is the half the sum of determinates
    #     formed by each pair of consecutive points.
    #   In our special case, each pair of consecutive points forms the side of a 1-wide or 1-high rectangle.
    set sum 0
    set perimeter 0
    foreach p1 [lrange $outline_points 0 end-1] p2 [lrange $outline_points 1 end] {
        lassign $p1 row1 col1
        lassign $p2 row2 col2
        set determinate [expr {$row1 * $col2 - $row2 * $col1}]
        incr sum $determinate
        
        set edge_length [expr {abs($row1 - $row2) + abs($col1 - $col2)}]
        incr perimeter $edge_length
    }
    set area [expr {abs($sum) / 2}]

    # Pick's Theorem: Find the number of points inside a shape given its area and perimeter.
    set inside     [expr {$area - $perimeter / 2 + 1}]
    puts "area: $area"
    puts "p = $perimeter"
    puts "inside = $inside"
    set num_points [expr {$perimeter + $inside}]
return $num_points

}

set part1 [num_points $points]
# print_grid $grid
puts "Part1 answer = $part1"

