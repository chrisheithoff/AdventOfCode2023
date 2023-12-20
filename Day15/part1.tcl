# Advent of Code 2023.  
# Day 15: Lens Library
# Part 1: Develop the HASH algorithm.
source ../aoc_library.tcl

# 1) Determine the ASCII code for the current character of the string.
# 2) Increase the current value by the ASCII code you just determined.
# 3) Set the current value to itself multiplied by 17.
# 4) Set the current value to the remainder of dividing itself by 256.
proc HASH {str} {
    set result 0
    foreach char [split $str ""] {
        set ascii [scan $char %c]
        set result [expr {($result+$ascii) * 17} % 256]
    }
    return $result
}

# set line [file_to_list demo.txt]
set line [file_to_list input.txt]

set steps [split $line ","]

set sum 0
foreach step $steps {
    set hash [HASH $step]
    incr sum $hash
    puts "$step: $hash  (sum = $sum)"
}
puts "Part1 answer = $sum"

