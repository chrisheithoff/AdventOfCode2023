# Advent of Code 2023.  
# Day 09:  Mirage Maintenance
# Part 1:  Find next predicted numbers in each sequence.
source ../aoc_library.tcl

set sequences [file_to_list input.txt]

proc deltas {seq} {
    set deltas [list]
    for {set i 0} {$i < [llength $seq] - 1} {incr i} {
        lappend deltas [expr [lindex $seq $i+1] - [lindex $seq $i]]
    }
    return $deltas
}

proc get_next_in_seq {seq} {
    set last_in_seq [lindex $seq end]


    # If deltas are all zero, then the next in seq is the same as the last_in_seq
    set deltas [deltas $seq]
    if {[lsort -unique -integer $deltas] == [list 0]} {
        return $last_in_seq
    } 

    # Otherwise, the add the last in seq to the next predicted delta.  Enter recursion
    set next_in_seq [expr $last_in_seq + [get_next_in_seq $deltas]]
    return $next_in_seq
}

set sum 0
foreach seq $sequences {
    set next_in_seq [get_next_in_seq $seq]
    incr sum $next_in_seq
    puts "$seq -> $next_in_seq  (sum= $sum)"
}


puts "Part1 answer = $sum"
