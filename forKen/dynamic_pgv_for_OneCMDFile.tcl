#!/home/eda/public/Linux64/bin/tclsh

set mem_trigger_list [glob "*_trigger.txt"]
set fp_list [open "dynamic_mem.list" w]
foreach mem_trigger $mem_trigger_list {
	regexp {([a-zA-Z0-9_]+)_trigger.txt} $mem_trigger all memName
	#set mem_cmd [glob -nocomplain "macros_$memName.cmd"]
	#if {$mem_cmd==""} {
	#	puts $fp_fail $memName
	#	continue
	#}

	exec rm -rf macros_$memName.cl
	
	## edit the memory cmd file ######
	set fp_op_cmd [open "mem.cmd" r]
    set fp_w_cmd  [open "macros_${memName}.dpgv.cmd" w]
	set mem_list  [open "${memName}.list" w]
	puts $mem_list $memName

    while {[gets $fp_op_cmd line]!=-1} {
		if {[regsub {MEM} $line $memName new_line]} {
			puts $fp_w_cmd $new_line
		} elseif {[regexp "current_distribution" $line]} {
			puts $fp_w_cmd "-current_distribution {dynamic_simulation $mem_trigger} \\"
        } else {
			puts $fp_w_cmd $line
        }
    }
	puts $fp_list $memName
	
    close $fp_w_cmd
    close $fp_op_cmd
	close $mem_list
}	
close $fp_list
