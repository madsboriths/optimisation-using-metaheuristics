### s194624.jl
using Random

include("IO.jl")
include("ConstructionHeuristic.jl")

struct ArgumentException <: Exception
    message::String
end

function main()
    instanceLocation = ARGS[1]
    solutionLocation = ARGS[2]

    n_jobs, n_processors, UB, duration, processor = read_instance(instanceLocation)

    printInstance(n_jobs, n_processors, UB, duration, processor)

    println("Finding initial solution...")
    s, occupiedRanges = init(n_jobs, n_processors, UB, duration, processor)
    println("Initial solution found!")

    printResults(s, occupiedRanges)
    writeSolution(s, solutionLocation, n_jobs, n_processors)
end

main()