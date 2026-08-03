#!/bin/csh -f

# CRITICAL FIX: Disable history expansion (!) to prevent "Event not found" errors
# This allows filenames with '!' to be processed safely.
set histchars = ""

echo "=========================================="
echo "Checking for Missing TC_FILES Folders"
echo "=========================================="

# ------------------------------------------------------------------------------
# 1. Safely Get List of Command Files (.dpgv.cmd)
# ------------------------------------------------------------------------------
set raw_cmds = (`echo macros_*.dpgv.cmd`)
set cmd_cells = ()

if ($#raw_cmds == 1 && "$raw_cmds[1]" == "macros_*.dpgv.cmd") then
    echo "ERROR: No macros_*.dpgv.cmd files found."
    exit 1
else
    foreach f ($raw_cmds)
        # Extract cell name
        set cell = $f:s/macros_//
        set cell = $cell:s/.dpgv.cmd//
        set cmd_cells = ($cmd_cells $cell)
    end
endif

# ------------------------------------------------------------------------------
# 2. Safely Get List of Folders (*_TC_FILES)
# ------------------------------------------------------------------------------
set raw_dirs = (`echo *_TC_FILES`)
set folder_cells = ()

if ($#raw_dirs == 1 && "$raw_dirs[1]" == "*_TC_FILES") then
    echo "WARNING: No *_TC_FILES folders found."
else
    foreach d ($raw_dirs)
        # Extract cell name
        set cell = $d:s/_TC_FILES//
        set folder_cells = ($folder_cells $cell)
    end
endif

echo "Found $#cmd_cells command files."
echo "Found $#folder_cells TC_FILES folders."
echo ""

# ------------------------------------------------------------------------------
# 3. Find Missing Folders
# ------------------------------------------------------------------------------
set missing_folders = ()

foreach cell ($cmd_cells)
    set found = 0
    foreach f_cell ($folder_cells)
        if ("$cell" == "$f_cell") then
            set found = 1
            break
        endif
    end
    
    if ($found == 0) then
        set missing_folders = ($missing_folders $cell)
    endif
end

# ------------------------------------------------------------------------------
# 4. Output Results
# ------------------------------------------------------------------------------
if ($#missing_folders == 0) then
    echo "SUCCESS: All command files have matching folders."
else
    echo "!!! MISSING FOLDERS (${#missing_folders} cells) !!!"
    echo "The following cells have .dpgv.cmd but NO _TC_FILES folder:"
    foreach m ($missing_folders)
        # Use quotes to prevent any interpretation of special chars
        echo "  - $m"
    end
endif

echo "=========================================="
