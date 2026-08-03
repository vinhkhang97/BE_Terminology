#!/home/eda/public/Linux64/bin/tclsh

set mem_trigger_list [glob "*_trigger.txt"]
set fp_fail [open "fail.list" w]
foreach mem_trigger $mem_trigger_list {
	regexp {([a-zA-Z0-9_]+)_tt0p9v85c_trigger.txt} $mem_trigger all memName
	set mem_cmd [glob -nocomplain "macros_$memName.cmd"]
	if {$mem_cmd==""} {
		puts $fp_fail $memName
		continue
	}

	exec rm -rf macros_$memName.cl

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
}

close $fp_fail
