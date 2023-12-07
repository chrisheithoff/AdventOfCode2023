# Advent of Code 2023.  
# Day 06:  Wait For It
# Part 1:  Find the number of the sets of ways to set a toy boat record
source ../aoc_library.tcl


set data [file_to_list input.txt]

set times   [lrange [lindex $data 0] 1 end]
set records [lrange [lindex $data 1] 1 end]

set product 1
foreach time $times record $records {
    puts ""
    puts "Total time = $time"
    puts "Record distance = $record"

    set ways_to_win 0
    for {set b 0} {$b < $time} {incr b} {
        set distance [expr {$b * ($time - $b)}]
        if {$distance > $record} {
            incr ways_to_win
        }
    }
    puts "   $ways_to_win ways to win"
    set product [expr $product * $ways_to_win]
    puts "   product = $product"

}
puts "Part1 answer = $product"

