
# Iterated local search for TSP
## Running with default settings
In order to run the program with default settings use the assignments specified command:
    "julia s194624.jl <instance_location> <solution_location> <number_of_seconds>"
If the directory for a filepath does not exist, the directory will be created.

The default pertubation function performs a double bridge move every 1000 iteratons.
For the remaining iterations, a 2Opt operation is carried out 3 times. 
Each 2Opt operation is based on a random (but valid) choice of edges to swap.

After any perbutation, a function determines whether the precedence property is satisfied,
and moves elements if necessary.

By default, first improvement is used for 2Opt improvement.

## Optional arguments
If you want to run it with any variations, you can use the following optional arguments:

The 2Opt improvement stategy can be specified by the command line argument <improvement_strategy>
and the pertubation strategy by <pertubation_strategy> as such:
    "julia s194624.jl <instance_location> <solution_location> <number_of_seconds> <improvement_strategy> <pertubation_strategy>"
Where <improvement_strategy> takes on values "first"(default) or "best"
and <pertubation_strategy> takeso on values "DB/2Opt"(default), "2Opt", "DB" or "shuffle"

"2Opt" performs 5 random (but valid) 2Opt operations on the given solution
"DB" performs just the double bridge move
"shuffle" shuffles the elements in the solution randomly