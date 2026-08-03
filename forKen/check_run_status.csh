#!/bin/csh -f

echo "=========================================="
echo "Comparing .dpgv.cmd files vs _TC_FILES folders"
echo "=========================================="

# 1. Extract cell names from .dpgv.cmd files
# Pattern: macros_<CELL_NAME>.dpgv.cmd
set cmd_cells = ()
foreach f (`ls -1 macros_*.dpgv.cmd 2>/dev/null`)
    # Remove 'macros_' prefix and '.dpgv.cmd' suffix
    set cell = $f:s/macros_//
    set cell = $cell:s/.dpgv.cmd//
    set cmd_cells = ($cmd_cells $cell)
end

# 2. Extract cell names from *_TC_FILES folders
# Pattern: <CELL_NAME>_TC_FILES
set folder_cells = ()
foreach d (`ls -d *_TC_FILES 2>/dev/null`)
    # Remove '_TC_FILES' suffix
    set cell = $d:s/_TC_FILES//
    set folder_cells = ($folder_cells $cell)
end

# 3. Compare Lists
set missing_folders = ()
set missing_cmds = ()

# Check: For every cmd file, is there a matching folder?
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

# Check: For every folder, is there a matching cmd file?
foreach cell ($folder_cells)
    set found = 0
    foreach c_cell ($cmd_cells)
        if ("$cell" == "$c_cell") then
            set found = 1
            break
        endif
    end
    if ($found == 0) then
        set missing_cmds = ($missing_cmds $cell)
    endif
end

# 4. Report Results
echo ""
if ($#missing_folders == 0 && $#missing_cmds == 0) then
    echo "SUCCESS: All $#{cmd_cells} command files have matching TC_FILES folders."
else
    if ($#missing_folders > 0) then
        echo "ERROR: ${#missing_folders} Command files have NO matching folder:"
        foreach m ($missing_folders)
            echo "  [MISSING FOLDER] macros_${m}.dpgv.cmd"
        end
        echo ""
    endif
    
    if ($#missing_cmds > 0) then
        echo "WARNING: ${#missing_cmds} Folders have NO matching command file:"
        foreach m ($missing_cmds)
            echo "  [MISSING CMD]    ${m}_TC_FILES/"
        end
    endif
endif
echo "=========================================="
