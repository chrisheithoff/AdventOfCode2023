# Advent of Code 2023.  
# Day 01:  Trebuchet?!
# Part 2:  Calibration.  Some digits are actually spelled out!
source ../aoc_library.tcl

set data [file_to_list input.txt]

set sum 0
foreach line $data {
    puts ""
    puts $line

    # Find first digit
    set word ""
    foreach char [split $line ""] {
        # If the character a literal digit?
        if {[regexp {\d} $char]} {
            set first_digit $char
            break
        }
        # Is the digit spelled out?
        append word $char
        if {[regexp {one$}   $word]} {set first_digit 1; break}
        if {[regexp {two$}   $word]} {set first_digit 2; break}
        if {[regexp {three$} $word]} {set first_digit 3; break}
        if {[regexp {four$}  $word]} {set first_digit 4; break}
        if {[regexp {five$}  $word]} {set first_digit 5; break}
        if {[regexp {six$}   $word]} {set first_digit 6; break}
        if {[regexp {seven$} $word]} {set first_digit 7; break}
        if {[regexp {eight$} $word]} {set first_digit 8; break}
        if {[regexp {nine$}  $word]} {set first_digit 9; break}
    }

    # Find last digit 
    set word ""
    foreach char [lreverse [split $line ""]] {
        if {[regexp {\d} $char]} {
            set last_digit $char
            break
        }
        # Is the digit spelled out?
        append word $char
        if {[regexp {eno$}   $word]} {set last_digit 1; break}
        if {[regexp {owt$}   $word]} {set last_digit 2; break}
        if {[regexp {eerht$} $word]} {set last_digit 3; break}
        if {[regexp {ruof$}  $word]} {set last_digit 4; break}
        if {[regexp {evif$}  $word]} {set last_digit 5; break}
        if {[regexp {xis$}   $word]} {set last_digit 6; break}
        if {[regexp {neves$} $word]} {set last_digit 7; break}
        if {[regexp {thgie$} $word]} {set last_digit 8; break}
        if {[regexp {enin$}  $word]} {set last_digit 9; break}
    }

    set two_digit_number "${first_digit}${last_digit}"

    incr sum $two_digit_number

    puts "$first_digit $last_digit -> $two_digit_number = $sum"

    
}

puts "Part2 answer = $sum"

