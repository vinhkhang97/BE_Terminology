# ==============================================================================
# CHANGE 1: Define your specific list of cell names here
# ==============================================================================
set specific_cell_names { \
VZNL0NNDS3PAJ_1024X9X1M4B \
VZNL0NNDS1PAJ_512X8X1M4B \
VZNL0NNDH0PAJ_32X64X1M2B \
VPNL0CNDS1PAJ_4096X32M8BA \
VYNL0CNDS1PCJ_256X8X1M2B \
VZNL0NNDS1PAJ_256X32X1M4B \
VPNL0CNDS0PAJ_4096X64M16BA \
VQNL0CODL1PAJ_256X64X1M4B \
VQNL0CODL1PAJ_256X44X1M4B \
VQNL0CODL0PAJ_256X8X1M4B \
VQNL0CODL1PAJ_256X43X1M4B \
# ... Add the rest of your cells here ...
}

set fp_fail [open "fail.list" w]

# ==============================================================================
# CHANGE 2: Loop over the specific list instead of globbing files
# ==============================================================================
foreach cell_name $specific_cell_names {
    
    # Construct the full trigger filename based on your naming convention
    set mem_trigger "${cell_name}_tt0p9v85c_trigger.txt"
    
    # Check if this specific file exists before proceeding
    if {![file exists $mem_trigger]} {
        puts $fp_fail "$cell_name"
        continue
    }

    # --- Original Logic Starts Here (Unchanged) ---
    
    # Extract name using your original regex
    regexp {([a-zA-Z0-9_]+)_tt0p9v85c_trigger.txt} $mem_trigger all memName
    
    set mem_cmd [glob -nocomplain "macros_$memName.cmd"]
    if {$mem_cmd==""} {
        puts $fp_fail $memName
        continue
    }

#    exec rm -f macros_$memName.cl

    set fp_op_cmd [open "macros_$memName.cmd" r]
    set fp_w_cmd [open "macros_${memName}.dpgv.cmd" w]
    while {[gets $fp_op_cmd line]!=-1} {
        if {[regexp "current_distribution" $line]} {
            puts $fp_w_cmd "    -current_distribution {dynamic_simulation $mem_trigger} \\"
        } else {
            puts $fp_w_cmd $line
        }
    }
    close $fp_w_cmd
    close $fp_op_cmd
    
    # --- Original Logic Ends Here ---
}

close $fp_fail
