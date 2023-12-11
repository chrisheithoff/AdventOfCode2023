# Advent of Code 2023.  
# Day 09:  Mirage Maintenance
# Part 2:  Go backwards instead.
source ../aoc_library.tcl

set sequences [file_to_list input.txt]

proc deltas {seq} {
    set deltas [list]
    for {set i 0} {$i < [llength $seq] - 1} {incr i} {
        lappend deltas [expr [lindex $seq $i+1] - [lindex $seq $i]]
    }
    return $deltas
}

proc get_prev_in_seq {seq} {
    set first_in_seq [lindex $seq 0]


    # If deltas are all zero, then the next in seq is the same as the last_in_seq
    set deltas [deltas $seq]
    if {[lsort -unique -integer $deltas] == [list 0]} {
        return $first_in_seq
    } 

    # Otherwise, the subtract the extrapolated prev delta from first in seq
    set prev_in_seq [expr $first_in_seq - [get_prev_in_seq $deltas]]
    return $prev_in_seq
}

set sum 0
foreach seq $sequences {
    set prev_in_seq [get_prev_in_seq $seq]
    incr sum $prev_in_seq
    puts "$prev_in_seq <- $seq  (sum= $sum)"
}


puts "Part1 answer = $sum"
