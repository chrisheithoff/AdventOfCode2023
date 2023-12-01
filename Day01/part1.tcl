# Advent of Code 2023.  
# Day 01:  Trebuchet?!
# Part 1:  Calibration.  Sum of all two digit numbers formed by first,last digit in each line.
source ../aoc_library.tcl

set data [file_to_list input.txt]

set sum 0
foreach line $data {
    set chars [split $line ""]

    set digits [lsearch -all -inline -regexp $chars {\d}]

    set two_digit_number "[lindex $digits 0][lindex $digits end]"

    incr sum $two_digit_number

    puts "$digits -> $two_digit_number = $sum"

    
}

puts "Part1 answer = $sum"

