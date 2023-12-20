# Advent of Code 2023.  
# Day 14: Parabolic Reflector Dish
# Part 2: Spin Cycle.   Roll north, then west, then south, then east. ONE BILLION TIMES!!!
source ../aoc_library.tcl

# With lots of help from https://github.com/matheusstutzel/adventOfCode/blob/main/2023/14/p2.py
proc tiltV {grid "dir N"} {
    if {$dir == "S"} {
        set grid [lreverse $grid]
    }
        
    foreach {i row} [enumerate $grid] {
        foreach {j char} [enumerate $row] {
            if {$char eq "O"} {
                # Can this 'O' be rolled to the previous row?
                set k [expr $i - 1]
                while {$k >= 0} {
                    # Get previous row's character
                    set w [lindex $grid $k $j]

                    if {$w in "# O"} {
                        incr k
                        break
                    }

                    incr k -1
                }
                set k [expr max($k, 0)]
                # Swap 'O' and '.'
                lset grid $i $j "."
                lset grid $k $j "O"
            }
        }
    }

    if {$dir == "S"} {
        set grid [lreverse $grid]
    }
        
    return $grid
}

proc tiltH {grid "dir W"} {
        
    foreach {i row} [enumerate $grid] {
        if {$dir == "E"} {
            set row [lreverse $row]
        }
        foreach {j char} [enumerate $row] {
            if {$char eq "O"} {
                # Can this 'O' be rolled to the previous column.
                set k [expr $j - 1]
                while {$k >= 0} {
                    # Get previous column's character
                    set w [lindex $row $k]
                    if {$w in "# O"} {
                        incr k
                        break
                    }
                    incr k -1
                }
                set k [expr max($k, 0)]
                # Swap columns j and k
                lset row $j "."
                lset row $k "O"
            }
        }
        if {$dir == "E"} {
            set row [lreverse $row]
        }
        lset grid $i $row
    }

    return $grid
}

proc cycle {grid} {
    # puts "\nOriginal"
    # print_grid $grid
    set grid [tiltV $grid N]
    # puts "\nNorth"
    # print_grid $grid
    set grid [tiltH $grid W]
    # puts "\nWest"
    # print_grid $grid
    set grid [tiltV $grid S]
    # puts "\nSouth"
    # print_grid $grid
    set grid [tiltH $grid E]
    # puts "\nEast"
    # print_grid $grid
    return $grid
}

proc process {grid target} {
    # There must be a cycle that repeats.  Save the grid state in a list
    #  - if a state has been seen before in the history, then you know
    #    that a repeat cycle has completed and how many steps it was.
    #  - Add a dummy value '0' so that the index matches the 'i' variable.
    set hist [list 0]

    set i 0
    while {$i < $target} {
        incr i
        set grid    [cycle $grid]

        puts "$i : [total_north_load $grid]"

        # Compress the entire grid into one string.
        set gridstr [join [join $grid] ""]

        # Have we seen this grid before?  
        #    - If so, then derive the cycle and do some math.
        #    - If not, then save to cache list and continue
        if {$gridstr in $hist} {
            set first          [lsearch $hist $gridstr]
            set cycle          [expr $i - $first]

            set target_position_in_cycle  [expr ($target - $first) % $cycle]
            set hist_index [expr $first + $target_position_in_cycle]

            puts "REPEAT!!!  $i --> $first"
            puts "    cycle will now repeat every $cycle steps"

            puts "    target = $target"
            puts "    target - first = [expr ($target - $first)]"
            puts "    (target - first) % cycle = [expr ($target - $first) % $cycle]"
            puts "    hist_index = $hist_index"

            set target_gridstr [lindex $hist $hist_index]

            # convert the gridstr back to list of lists.  Assume a square grid.
            set grid_size [expr int(sqrt([string length $target_gridstr]))]
            set grid [list]
            set flat_list [split $target_gridstr ""]
            while {[llength $flat_list] > 0} {
                lappend grid        [lrange $flat_list 0 $grid_size-1] 
                set flat_list       [lrange $flat_list $grid_size end]
            }   
            return $grid

        } else {
            lappend hist $gridstr
        }

    }
    
    return $grid
}

proc total_north_load {grid} {
    set load 0
    set weight 1
    foreach row [lreverse $grid] {
        set num_round_rocks [llength [lsearch -all $row "O"]]
        incr load [expr $num_round_rocks * $weight]
        incr weight
    }
    return $load
}

set lines [file_to_list demo.txt]
set lines [file_to_list input.txt]

set grid  [make_grid_from_lines $lines]
print_grid $grid
puts ""
puts "------------------------------------------------------"
puts ""


print_grid $grid
set grid       [process $grid 1000000000]
print_grid $grid
set north_load [total_north_load $grid]


puts "Part2 answer = $north_load"

