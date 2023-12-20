# Advent of Code 2023.  
# Day 15: Lens Library
# Part 2:  HASHMAP
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

set boxes [dict create]
foreach step $steps {
    if {[regexp {(\w+)=(\d)} $step -> label focal_length]} {
        dict set boxes [HASH $label] $label $focal_length
    } elseif {[regexp {(\w+)-} $step -> label]} { 
        if {[dict exists $boxes [HASH $label]]} {
            dict unset boxes [HASH $label] $label
        }
    }
}

set focusing_power 0
foreach box_num [lsort -integer [dict keys $boxes]] {
    set lenses    [dict get $boxes $box_num]
    set box_score [expr {$box_num + 1}]

    if {[dict size $lenses] == 0} {
        puts "$box_score: empty"
        continue
    }
    set slot 0

    # Note, we expect the order of the lenses to be the same order that they were inserted into the dict.
    foreach {label focal_length} $lenses {
        incr slot
        set score [expr {$box_score * $slot * $focal_length}]
        incr focusing_power $score
        puts "$label: $box_score (box $box_num) * $slot (slot) * $focal_length (focal length) += $score ($focusing_power)"
    }
}
puts "Part1 answer = $focusing_power"
