#!/bin/csh -f
#
#set target_dir = "/home/ASICQA2026/ada/proj/FSJ0AS099B/IDC/OutSource/MEMORY"
#if ("$target_dir" == "") set target_dir = "."
#
#set suffix1 = "_tt0p9v85c_read.pwl"
#set suffix2 = "_tt0p9v85c_trigger.txt"
#set suffix3 = "_tt0p9v85c_write.pwl"
#
#echo "Scanning $target_dir using cells.txt..."
#
#foreach cell (`cat memory_11cells_left.list`)
#    # Skip empty lines
#    if ("$cell" == "") continue
#    
#    if (-e "$target_dir/${cell}/current_profile/${cell}${suffix1}") echo "ln -sf  $target_dir/${cell}/current_profile/${cell}${suffix1} ." >> link_11mems_left_pwl.tcl
#    if (-e "$target_dir/${cell}/current_profile/${cell}${suffix2}") echo "ln -sf $target_dir/${cell}/current_profile/${cell}${suffix2} ." >> link_11mems_left_pwl.tcl
#    if (-e "$target_dir/${cell}/current_profile/${cell}${suffix3}") echo "ln -sf $target_dir/${cell}/current_profile/${cell}${suffix3} ." >> link_11mems_left_pwl.tcl
#end

set target_dir = "/home/ASICQA/ada/proj/FSJ0AS099A/IDC/OutSource/MEMORY"
set suffix1 = "_tt0p9v85c_read.pwl"
set suffix2 = "_tt0p9v85c_trigger.txt"
set suffix3 = "_tt0p9v85c_write.pwl"

# Check if list file exists and is not empty
if (! -e memory_11cells_left.list || ! -s memory_11cells_left.list) then
    echo "ERROR: memory_11cells_left.list not found or is empty."
    exit 1
endif

echo "Scanning $target_dir..."
set missing = ()

# Use grep to filter out empty lines before passing to foreach
foreach cell (`grep -v '^$' memory_11cells_left.list`)
    set p1 = "$target_dir/${cell}/current_profile/${cell}${suffix1}"
    set p2 = "$target_dir/${cell}/current_profile/${cell}${suffix2}"
    set p3 = "$target_dir/${cell}/current_profile/${cell}${suffix3}"
    
    set found = 0
    if (-e "$p1") then
	echo "ln -sf $p1 ." >> link_11mems_left_pwl.tcl
	set found = 1
    endif
    if (-e "$p2") then
	echo "ln -sf $p2 ." >> link_11mems_left_pwl.tcl
	set found = 1
    endif
    if (-e "$p3") then
	echo "ln -sf $p3 ." >> link_11mems_left_pwl.tcl
	set found = 1
    endif
    
    if ($found == 0) set missing = ($missing $cell)
end

if ($#missing > 0) then
    echo "ERROR: Missing files for ${#missing} cells:"
    printf "  %s\n" $missing
    exit 1
else
    echo "Success: All cells found."
endif
