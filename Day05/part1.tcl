# Advent of Code 2023.  
# Day 05:  If you give a seed a fertilizer
# Part 1:  Find the lowest location number that corresponds 
#          to any of the initial seed numbers.
source ../aoc_library.tcl


# set data [file_to_list_of_lists demo.txt]
set data [file_to_list_of_lists input.txt]

set seed_list [lindex [split [lindex $data 0 0] ":"] end]

set things [list seed]
foreach list [lrange $data 1 end] {
    set map_type [lindex $list 0 0]
    lassign [split $map_type "-"] from ___ to
    lappend things $to
    set mapping($from,$to) [lrange $list 1 end]
    puts "Map type = $from -> $to:  [llength $mapping($from,$to)]"
}

# Note:  I initially created a lookup dict for each mapping that 
#  required an offset.  This worked fine with the demo.txt, but 
#  was bad with the input.txt because the ranges could be in the millions.
#  Many dictionaries, each with multi-million number of keys would take 
#  an extremely long time to create!!

proc map {from_value from to} {
    global mapping
    foreach line $mapping($from,$to) {
        lassign $line dest source range

        set offset [expr $from_value - $source]
        if {$offset >= 0 && $offset < $range} {
            return [expr $dest + $offset]
        }
    }

    return $from_value
}

set seed_dict [dict create]
set locations [list]
foreach seed $seed_list {
    puts ""
    set from_value $seed

    for {set i 0} {$i < [llength $things]-1} {incr i} {
        set from [lindex $things $i]
        set to   [lindex $things $i+1]

        set to_value [map $from_value $from $to]

        puts "$from ($from_value) --> $to ($to_value)"

        # Cache the result 
        dict set seed_dict $seed $to $to_value

        set from_value $to_value
    }

    lappend locations $to_value
}

set min_location [tcl::mathfunc::min {*}$locations]
puts "Part1 answer = $min_location"

