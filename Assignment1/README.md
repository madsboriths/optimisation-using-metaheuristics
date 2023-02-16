# Iterated local search for TSP
## Notes

To execute the program the default way, run the command:
"julia s194624.jl <instance_location> <solution_location> <number_of_seconds>"

By default the first improvement is used for 2Opt. 
Alternatively this can be specified by the extra command line argument:
"julia s194624.jl <instance_location> <solution_location> <number_of_seconds> <improvement_strategy>"

Where <improvement_strategy> is either the string "first" or "best"
