# Iterated local search for TSP

## Default settings
Running the default command:
"julia s194624.jl <instance_location> <solution_location> <number_of_seconds>"

By default, first improvement is used for 2Opt improvement.
The default pertubation function performs 5 random (but valid) 2Opt operations on the given solution.


## Optional arguments
The 2Opt improvement stategy can be specified by the extra command line argument <improvement_strategy>
and the pertubation strategy by <pertubation_strategy> as such:
"julia s194624.jl <instance_location> <solution_location> <number_of_seconds> <improvement_strategy> <pertubation_strategy>"

Where <improvement_strategy> takes on values "first" or "best"
and <pertubation_strategy> takeso on values "2Opt","shuffle" or "DB" (for 'double bridge')