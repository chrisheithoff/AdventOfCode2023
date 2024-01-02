# Advent of Code 2023.  
# Day 19: Aplenty
# Part 2:  How many distinct combinations of parts will be accepted by the workflows?
source ../aoc_library.tcl

# Let's follow this:
#     https://advent-of-code.xavd.id/writeups/2023/day/19/

# Parse input
set input [file_to_list_of_lists input.txt]
# set input [file_to_list_of_lists demo.txt]

set workflows [lindex $input 0]
set parts     [lindex $input 1]

# Turn each workflow into a proc.
#  in{s<1351:px,qqz}
foreach workflow $workflows {
    # Split into a list like this:
    #  in s<1351 px qqz {} 
    set s [split $workflow "{:,}"]

    set s [lassign $s proc_name]
    set default [lindex $s end-1]
    set steps   [lrange $s 0 end-2]

    set proc_args "part"
    set proc_body ""

    foreach {condition result} $steps {
        set var_name [string index $condition 0]
        set op       [string index $condition 1]
        set value    [string range $condition 2 end]
        append proc_body "if {\[dict get \$part $var_name\] $op $value} {\n  return \[$result \$part\]\n}\n"
    }
    append proc_body "return \[$default \$part\]\n"

    proc $proc_name {part} "$proc_body"

}

proc A {part} {return [tcl::mathop::+ {*}[dict values $part]]}
proc R {part} {return 0}

set sum 0
foreach line $parts {
    set part  [dict create {*}[split [join $line] ",="]]
    set score [in $part]
    incr sum $score
    puts "$part:  $score (sum = $sum)"
    
}

puts "Part1 answer = $sum"

