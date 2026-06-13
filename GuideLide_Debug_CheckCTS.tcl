# Sink pin is Startpoint (Launch) / Endpoint (Capture)
# SHOW CTS GUI
ctd_win
# Trace latency path from clk pin to sink pin in GUI
ctd_trace -to <sink_pin/CP>
# Trace latency path from root clk pin / generated clk to sink pin in GUI
ctd_trace -from <begin_point> (-longest: Use this option to trace max latency)
# Trace latency path from root clk pin to the longest sink pin 
ctd_trace -from [lindex [get_ccopt_skew_group_path -skew_group <skew_group_name> -longest] 0] -to [lindex [get_ccopt_skew_group_path -skew_group <skew_group_name> -longest] end] -color yellow

# Check list of attribution of get_ccopt_property CMD begin with a letter
get_ccopt_property -help <letter>*
=>>>> EX: get_ccopt_property -help s*

# Get skew groups of sink pin -> Show sink pin belongs to which skew groups -> In the future, the sink pin will balance follow their skew groups
get_ccopt_property skew_groups_active -pin <sink_pin/CP>

# Get latency value of sink pin from skew groups of sink pin
get_ccopt_skew_group_delay -skew_group <Skew_group> -to <sink_pin/CP>

# Get root clock pins of sink pin
get_property  [get_pins <Sink_pin/CP> ] clocks

# Show all information about active analysis views - Analysis view: VIEW_FUNC* & Delay Corner: DC_FUNC_HOLD_FF*CMIN
report_analysis_views -type active

# Check insertion_delay value of a sink pin
get_ccopt_property insertion delay -delay_corner <Delay_corner_name> -pin <sink_pin/CK>

# Running CLUSTERING ONLY stage
set_ccopt_property balance_mode cluster
or 
set_ccopt_property save_db_after_cts ./DBS/04_clustering.enc

# Debug by report clk tree.
report_ccopt_clock_trees_tructure -expand_below_generators -expand_below_logic -show_sinks -file RPT/300_ccopt/300_ccopt. clock_trace_after.rpt
report_ccopt_clock_trees -filenane RPT/300_ccopt/300_ccopt.clock_trees.rpt
