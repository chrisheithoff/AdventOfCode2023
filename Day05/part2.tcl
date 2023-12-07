# Advent of Code 2023.  
# Day 05:  If you give a seed a fertilizer
# Part 2:  Still find the lowest location number, but
#          now the "seeds:" line describes a RANGE seed numbers.
#          ...this means there can be LOTS AND LOTS of seeds.
source ../aoc_library.tcl


set data [file_to_list_of_lists input.txt]


# Parse the input data into:
#   seed_ranges : list of seed ranges
#   mapping($to,$from):  mapping for each step
set seed_info   [lindex [split [lindex $data 0 0] ":"] end]
set seed_ranges [list]
foreach {start range} $seed_info {
    lappend seed_ranges [list $start $range]
}
foreach list [lrange $data 1 end] {
    set map_type [lindex $list 0 0]
    lassign [split $map_type "-"] from ___ to
    set map_name "$from,$to"
    set mapping($map_name) [lrange $list 1 end]
}

# Change the map data into a list of lists, where element is:
#   {slice_point offset_to_the_left_of_the slice}
# Example: map = {80 10 10} {10 80 10}
#     0  to 9  is zero offset.
#     10 to 19 is +70 offset mapping.
#     20 to 79 is zero offset 
#     80 to 89 is -70 offset mapping
#     90 and above is zero offset.
# Return : {10 0} {20 70} {80 0} {90 -70}
proc get_slice_points {map} {
    set map [lsort -integer -index 1 $map]
    
    set slice_dict [dict create]

    # From each line of the map, we can get two slice points:
    #  1)  The offset to the left of the upper slice point is immediately known.
    #  2)  The offset to the left of the lower slice point will be zero if
    #      not already defined in 1)
    
    foreach line $map {
        lassign $line destination slice1 length
        set slice2 [expr {$slice1 + $length}]
        set offset [expr {$destination - $slice1}]
        
        dict set slice_dict $slice2 $offset
    }

    foreach line $map {
        lassign $line destination slice1 length
        set offset [expr {$destination - $slice1}]
        
        if {![dict exists $slice_dict $slice1]} {
            dict set slice_dict $slice1 0
        }
    }
    
    # Return the dict as a sorted list of lists.
    set slice_list  [list]
    set sorted_keys [lsort -integer [dict keys $slice_dict]]
    foreach key $sorted_keys {
        set value [dict get $slice_dict $key]
        lappend slice_list [list $key $value]
    }
    return $slice_list
}


# Return a remapped list of ranges given a mapping.
proc remap_ranges {ranges map} {
    set mapped_ranges [list]

    # Sort the ranges from low to high.  Consider it a stack
    set stack [lsort -index 0 -integer $ranges]

    # Convert the map into slice points. 
    set slices [get_slice_points $map]
    puts "Map:     $map"
    puts "Slices : $slices"
    puts "Ranges : $stack"

    set i 0
    while {[llength $stack] > 0 && $i < [llength $slices]} {

        # Select a slice.  This will increment based on conditions below. 
        set slice [lindex $slices $i]
        lassign $slice slice_point offset

        # Pop the first range off the stack 
        set stack [lassign $stack range]
        lassign $range start length
        set end [expr {$start + $length -1}]


        # The slice point is one of these:
        #    - before or at the start of the range    -> (put range back on the stack)
        #    - between the start and end of the range -> (slice, remap the left slice, put leftover back)
        #    - after the end of the range             -> (remap the entire range go back to previous slice)
        puts ""
        puts "  Slice {$slice} Range {$range}"
        if {$slice_point <= $start} {
            puts "   Before"
            set stack [linsert $stack 0 $range]
            # Move to next slice
            incr i
        } elseif {$slice_point <= $end} {
            puts "   Between"
            set sliced_length  [expr {$slice_point - $start -1}]
            set sliced_range   [list $start $sliced_length]
            set mapped_range   [list [expr $start + $offset] $sliced_length]
            puts "       add {$mapped_range} to mapped_ranges."
            lappend mapped_ranges $mapped_range

            set leftover_length [expr {$end - $slice_point - 1}]
            set leftover_range  [list $slice_point $leftover_length]
            set stack [linsert $stack 0 $leftover_range]
            # Move to next slice
            incr i
        } else {
            puts "   After"
            # The entire range is not sliced, but will be mapped.
            set mapped_range [list [expr {$start + $offset}] $length]
            puts "       add {$mapped_range} to mapped_ranges."
            lappend mapped_ranges $mapped_range

            # Do NOT move to the next slice.  
        }
    }

    # Add any remaining stack of ranges to mapped_ranges.
    if {[llength $stack] > 0} {
        lappend mapped_ranges {*}$stack
    }

    return $mapped_ranges
}

# Start with the list of seed ranges and go through all the mappings.
# We expect a smaller number of initial seed ranges to be sliced into 
# pieces and shuffled around....but never overlapping and never flipping the 
# order within a sub range.
set soil_ranges  [remap_ranges $seed_ranges  $mapping(seed,soil)]
set fert_ranges  [remap_ranges $soil_ranges  $mapping(soil,fertilizer)]
set water_ranges [remap_ranges $fert_ranges  $mapping(fertilizer,water)]
set light_ranges [remap_ranges $water_ranges $mapping(water,light)]
set temp_ranges  [remap_ranges $light_ranges $mapping(light,temperature)]
set humid_ranges [remap_ranges $temp_ranges  $mapping(temperature,humidity)]
set loc_ranges   [remap_ranges $humid_ranges $mapping(humidity,location)]

# This is what we're looking for...the minimum location given all the 
# initial seeds. Each range is a start point followed by a length, so
# we just need the minimum start point.
set loc_ranges [lsort -index 0 -integer $loc_ranges]
set min_loc    [lindex $loc_ranges 0 0]

puts "Part2 answer = $min_loc"

