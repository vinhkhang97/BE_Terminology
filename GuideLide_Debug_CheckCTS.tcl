# Sink pin is Startpoint (Launch) / Endpoint (Capture)
# SHOW CTS GUI
ctd_win
# Trace latency path from clk pin to sink pin in GUI
ctd_trace -to <sink_pin/CP>
# Trace latency path from root clk pin / generated clk to sink pin in GUI
ctd_trace -from <begin_point> (-longest: Use this option to trace max latency)
# Get skew groups of sink pin -> Show sink pin belongs to which skew groups -> In the future, the sink pin will balance follow their skew groups
get_ccopt_property skew_groups_active -pin <sink_pin/CP>

# Get latency value of sink pin from skew groups of sink pin
get_ccopt_skew_group_delay -skew_group <Skew_group> -to <sink_pin/CP>

# Get root clock pins of sink pin
get_property  [get_pins <Sink_pin/CP> ] clocks


