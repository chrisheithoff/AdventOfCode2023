# Advent of Code 2023.  
# Day 12:  Hot Springs
# Part 2:  Same but first unfold the map!
source ../aoc_library.tcl


# Another link with a Day12 tutorial:
# https://www.reddit.com/r/adventofcode/comments/18hbbxe/2023_day_12python_stepbystep_tutorial_with_bonus/

proc pound {} {
    upvar record record
    upvar groups groups 
    upvar next_group next_group

    # If the first char is a pound, then the first n characters must be
    # able to be treated as a pound, where n is the first group number.
    set this_group [string range $record 0 $next_group-1]
    set this_group [string map "? #" $this_group]

    # If the next group can't fit all the damaged springs, then abort
    if {$this_group != [string repeat "#" $next_group]} {
        return 0
    }

    # If the rest of the record is just the last group, then we're
    # done and there's only one possibility
    if {[string length $record] == $next_group} {
        # Make sure this is the last group
        if {[llength $groups] == 1} {
            # We are valid
            return 1
        } else {
            # There are more groups: we can't make it work
            return 0
        }
    }

    # Make sure the character that follows this group can be a separator
    if {[string index $record $next_group] in {? .}} {
        # It can be separator, so skip it and reduce to the next group
        set recursive_record [string range $record [expr $next_group+1] end]
        set recursive_groups [lrange $groups 1 end]
        return [calc $recursive_record $recursive_groups]
    } 

    # Can't be handled.  No possibilities
    return 0
}

proc dot {} {
    upvar record record
    upvar groups groups
    # We just skip over the dot looking for the next pound.
    return [calc [string range $record 1 end] $groups]
}

set cache [dict create]

proc calc {record groups} {
    global cache
    set cache_key [list $record [join $groups ","]]

    # Return from the cache if possible.
    if {[dict exists $cache $cache_key]} {
        puts "CACHE"
        return [dict get $cache $cache_key]
    }

    # Did we run out of groups?  We might still be valid.
    if {$groups == ""} {
        # Make sure there aren't any more damaged springs, if so, we're valid.
        if {[regexp {#} $record]} {
            # More damaged springs that aren't in groups.
            dict set cache $cache_key 0
            return 0
        } else {
            # This will return true even if record is empty, which is valid.
            dict set cache $cache_key 1
            return 1
        }
    }

    # There are more groups, but no more records
    if {$record == ""} {
        # We can't fit, exit
        dict set cache $cache_key 0
        return 0
    }

    # Look at the next element in each record and group
    set next_character [string index $record 0]
    set next_group     [lindex $groups 0]

    if {$next_character eq "#"} {
        set out [pound]
    } elseif {$next_character eq "."} {
        set out [dot]
    } elseif {$next_character eq "?"} {
        set out [expr {[dot] + [pound]}]
    } else {
        error "next character $next_character is invalid"
    }

    puts "$record {$groups} -> $out"

    dict set cache $cache_key $out
    return $out
}


set sum 0
set lines [file_to_list input.txt]
foreach line $lines {
    lassign [split $line] folded_record folded_groups

    # Unfold! 
    set record [join [lrepeat 5 $folded_record] "?"]
    set groups [split [join [lrepeat 5 $folded_groups] ","] ","]


    set num_solutions [calc $record $groups]
    puts "---------------------"
    incr sum $num_solutions
}

puts "Part1 answer = $sum"

