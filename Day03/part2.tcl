# Advent of Code 2023.  
# Day 03:  Gear Ratios
# Part 2:  Find all pairs of numbers that touch the same * symbol.
source ../aoc_library.tcl

set data [file_to_list input.txt]

# Preprocess the data into a 2d grid
set grid [make_grid_from_lines $data]

set num_lines   [llength $grid]
set num_columns [llength [lindex $grid 0]]

# Find all the gear symbols. Set the adjacent cells to a gear_neighbors dict
set gear_neighbors [dict create]
for {set line 0} {$line < $num_lines} {incr line} {
    for {set col 0} {$col < $num_columns} {incr col} {
        set char [lindex $grid $line $col]
        if {$char == "*"} {
            foreach l {-1 0 1} {
                foreach c {-1 0 1} {
                    set key "[expr $line+$l] [expr $col+$c]"
                    dict set gear_neighbors $key "$line $col"
                }
            }
        }
    }
}

# Find numbers in each row.  If they touch a gear, then save it.
set sum 0
set gear_numbers [dict create]
for {set line 0} {$line < $num_lines} {incr line} {
    for {set col 0} {$col < $num_columns} {incr col} {
        set char [lindex $grid $line $col]
        set char_is_number [regexp {\d} $char]
        set current_number ""
        set gear_location ""

        # If a number is found, then advance to the next character 
        #  until the complete number is found.
        if {$char_is_number} {
            while {$char_is_number && $col < $num_columns} {
                if {[dict exists $gear_neighbors "$line $col"]} {
                    set gear_location [dict get $gear_neighbors "$line $col"]
                }
                append current_number $char
                incr col
                set char [lindex $grid $line $col]
                set char_is_number [regexp {\d} $char]
            }
            if {$gear_location != ""} {
                dict lappend gear_numbers $gear_location $current_number
                puts "gear at {$gear_location} : $current_number"
            } else {
                puts "($current_number)"
            }

        }
    }
}

set sum 0
dict for {gear_loc numbers} $gear_numbers {
    puts "Gear location: $gear_loc"
    puts "   numbers: $numbers"
    if {[llength $numbers] == 2} {
        set gear_ratio [tcl::mathop::* {*}$numbers]
        puts "    --> gear_ratio = $gear_ratio:   sum = [incr sum $gear_ratio]"
    }
}


puts "Part2 answer = $sum"

