# Advent of Code 2023.  
# Day 06:  Wait For It
# Part 2:  Same as part1, but with a much bigger number.
source ../aoc_library.tcl


set data [file_to_list input.txt]

# Join the numbers together into a big number.
set time   [join [lrange [lindex $data 0] 1 end] ""]
set record [join [lrange [lindex $data 1] 1 end] ""]

puts ""
puts "Total time = $time"
puts "Record distance = $record"

set ways_to_win 0
for {set b 0} {$b < $time} {incr b} {

    # Progress report just to monitor if the runtime will be insane
    if {$b % 100000 == 0} {
        puts "$b : [expr double($b) / $time * 100] % "
    }
    set distance [expr {$b * ($time - $b)}]
    if {$distance > $record} {
        incr ways_to_win
    }
}
puts "   $ways_to_win ways to win"

puts "Part2 answer = $ways_to_win"

