using Random
include("ConstructionHeuristic.jl")
include("LocalSearch.jl")
include("IOHandler.jl")
include("Pertubation.jl")
include("ILS.jl")

struct ArgumentException <: Exception
    message::String
end

function main()
    localSearchTime = 60
    instanceLocation = ARGS[1]
    solutionLocation = ARGS[2]
    totalTime = parse(Int, ARGS[3])
    name, UB, dim, dist = read_instance(instanceLocation)
    println("Running instance: ", name)

    # Default
    pertubationMode = "2Opt"
    twoOptMode = "first"

    # Read 2Opt improvement mode
    if (length(ARGS) > 3)
        twoOptMode = ARGS[4]
        if (!(ARGS[4] == "first" || ARGS[4] == "best"))
            throw(ArgumentException(string("illegal argument: ", ARGS[4])))
        end
    end

    # Read pertubation mode
    if (length(ARGS) > 4)
        pertubationMode = ARGS[5]
        if (!(ARGS[5] == "shuffle" || ARGS[5] == "2Opt" || ARGS[5] == "DB"))
            throw(ArgumentException(string("illegal argument: ", ARGS[5])))
        end
    end

    if (ARGS[2] == " ")
        vals = rsplit(name, ".", limit=2)
        solutionLocation = string("sols/", vals[1], ".sol")
    end

    # Initialize with solution using nearest neighbor 
    s0 = nearestNeighbor(dist, dim)
    objectiveValue = getObjectiveValue(s0, dist)
    
    # Find the initial local minimum
    s, objectiveValue = localSearch(s0, objectiveValue, twoOptMode, localSearchTime, dist, dim)

    # Perform iterated local search 
    println("\nBeginning iterated local search...")
    println("2Opt strategy: ", twoOptMode, " improvement")
    println("Pertubation strategy: ", pertubationMode, "\n")
    println("Allowed time: ", totalTime, " seconds")
    
    finalSolution, finalObjectiveValue, iterations = ILS(s, objectiveValue, twoOptMode, localSearchTime, totalTime, pertubationMode, dim, dist)

    println("\nSearch completed.")
    println(string(iterations, " total iterations"))
    println(string("Final solution: ", finalSolution, " with objective value ", finalObjectiveValue))
    println(string("Upper bound: ", UB))

    writeSolution(finalSolution, solutionLocation)
end
main()