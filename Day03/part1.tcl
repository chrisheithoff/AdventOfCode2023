# Advent of Code 2023.  
# Day 03:  Gear Ratios
# Part 1:  Find all the numbers in the input which are touching a symbol
source ../aoc_library.tcl

set data [file_to_list input.txt]

# Preprocess the data into a 2d grid
set grid [make_grid_from_lines $data]

set num_lines   [llength $grid]
set num_columns [llength [lindex $grid 0]]

# Find all the symbols. Set the adjacent cells to a valid_positions dict
set valid_positions [dict create]
for {set line 0} {$line < $num_lines} {incr line} {
    for {set col 0} {$col < $num_columns} {incr col} {
        set char [lindex $grid $line $col]
        if {$char ni "0 1 2 3 4 5 6 7 8 9 ."} {
            foreach l {-1 0 1} {
                foreach c {-1 0 1} {
                    set key "[expr $line+$l] [expr $col+$c]"
                    dict set valid_positions $key 1
                }
            }
        }
    }
}

# Find numbers in each row.  If they all occupy valid positions, then it's a good number.
set sum 0
for {set line 0} {$line < $num_lines} {incr line} {
    for {set col 0} {$col < $num_columns} {incr col} {
        set char [lindex $grid $line $col]
        set char_is_number [regexp {\d} $char]
        set keep_number 0
        set current_number ""

        # If a number is found, then advance to the next character 
        #  until the complete number is found.
        if {$char_is_number} {
            while {$char_is_number && $col < $num_columns} {
                set valid [dict exists $valid_positions "$line $col"]
                if {$valid == 1} {
                    set keep_number 1
                }
                append current_number $char
                incr col
                set char [lindex $grid $line $col]
                set char_is_number [regexp {\d} $char]
            }
            if {$keep_number} {
                incr sum $current_number
                puts "keep $current_number : sum = $sum"
            } else {
                puts "($current_number)"
            }

        }
    }
}


puts "Part1 answer = $sum"

