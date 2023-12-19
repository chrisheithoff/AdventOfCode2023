# Advent of Code 2023.  
# Day 13: Point of Incidence  
# Part 2:  Every mirror has exactly one smudge (exactly one '.' or '#' should be opposite)
source ../aoc_library.tcl

# Grid is a list of list of chars
proc find_mirror {grid "not_this_mirror 0"} {
    for {set i 1} {$i < [llength $grid] } {incr i} {
        if {$i == $not_this_mirror} {continue}
        # puts "--- $i ---------"
        set is_reflection 1
        set m [expr {$i - 1}]
        set n $i
        while {$m >=0 && $n < [llength $grid]} {
            set first  [lindex $grid $m]
            set second [lindex $grid $n]
            # puts ""
            # puts "$m : $first"
            # puts "$n : $second"
            if {$first ne $second} {
                set is_reflection 0
                # puts "--> Not a reflection"
                break
            }
            incr m -1
            incr n  1
        }
        if {$is_reflection == 1} {
            # puts "--> Reflection after $i"
            return $i
        }
    }
    # puts "--> No reflection"
    return 0
}

proc find_smudge {grid not_this_mirror} {
    set num_rows [llength $grid]
    set num_cols [llength [lindex $grid 0]]
    # Brute force.   Try a smudge at every location.
    for {set r 0} {$r < $num_rows} {incr r} {
        for {set c 0} {$c < $num_cols} {incr c} {
            set char       [lindex $grid $r $c]
            set other_char [string map "# . . #" $char]
            lset grid $r $c $other_char

            set mirror [find_mirror $grid $not_this_mirror]
            if {$mirror > 0} {
                puts "  smudge at = {$r $c}: mirror = $mirror"
                return $mirror
            }

            lset grid $r $c $char
        }
    }
    puts "  No smudge"
    return 0
}


set grids [file_to_list_of_lists input.txt]

set sum 0
foreach grid $grids {
    puts "----------------------"
    # Convert the list of strings to list of lists
    set grid [make_grid_from_lines $grid]

    # Find the original location of the mirror reflecting rows.
    set r [find_mirror $grid]
    set c [find_mirror [rotate_right $grid]]

    # Find the mirror after finding and fixing the smudge
    puts "r : (not $r)"
    set r_smudge [find_smudge $grid $r]
    puts "c : (not $c)"
    set c_smudge [find_smudge [rotate_right $grid] $c]

    # Only report the NEW DIFFERENT mirrors
    set new_r [lsearch -all -inline -not $r_smudge $r]
    set new_c [lsearch -all -inline -not $c_smudge $c]
    if {$new_r == ""} {set new_r 0}
    if {$new_c == ""} {set new_c 0}
    

    set note [expr {$new_c + 100*$new_r}]
    set sum  [incr sum $note]
    puts "$new_r $new_c : sum += $note => $sum"

}
puts "Part2 answer = $sum"

