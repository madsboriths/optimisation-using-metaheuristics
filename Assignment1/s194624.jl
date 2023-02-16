using Random
include("ConstructionHeuristic.jl")
include("LocalSearch.jl")
include("InstanceReader.jl")
include("Pertubation.jl")
include("ILS.jl")

struct ArgumentException <: Exception
    message::String
end

#name, UB, dim, dist = read_instance("Assignment1/Instances/Instances/ESC47.sop")
localSearchTime = 60
instanceLocation = ARGS[1]
solutionLocation = ARGS[2]
totalTime = parse(Int, ARGS[3])

name, UB, dim, dist = read_instance(instanceLocation)

function writeSolution(solution)
    wDir = string(pwd())
    
    dir, file = splitdir(solutionLocation)
    if (!isdir(dir))
        mkpath(string("./", dir, "/"))
    end
    
    open(string(wDir, "/", solutionLocation), "w") do f
        for i in eachindex(solution)
            write(f, string(solution[i]-1, " "))
        end
    end    
end

function main()
    println("Running instance: ", name)

    # Default
    pertubationMode = "shuffle"
    twoOptMode = "first"

    # "first" or "best" two opt improvement
    if (length(ARGS) > 3)
        twoOptMode = ARGS[4]
        if (!(ARGS[4] == "first" || ARGS[4] == "best"))
            throw(ArgumentException(string("illegal argument: ", ARGS[4])))
        end
    end

    if (length(ARGS) > 4)
        pertubationMode = ARGS[5]
        if (!(ARGS[5] == "shuffle" || ARGS[5] == "2Opt"))
            throw(ArgumentException(string("illegal argument: ", ARGS[5])))
        end
    end
    
    # Initialize with solution using nearest neighbor 
    s0 = nearestNeighbor(dist, dim)
    objectiveValue = getObjectiveValue(s0)
    
    # Find the initial local minimum
    s, objectiveValue = localSearch(s0, objectiveValue, twoOptMode, localSearchTime)

    println("\nBeginning iterated local search...")
    println("2Opt strategy: ", twoOptMode, " improvement")
    println("Pertubation strategy: ", pertubationMode, "\n")
    println("Allowed time: ", totalTime, " seconds")
    
    finalSolution, finalObjectiveValue, iterations = shuffleILS(s, objectiveValue, twoOptMode, totalTime)

    println("\nSearch completed.")
    println(string(iterations, " total iterations"))
    println(string("Final solution: ", finalSolution, " with objective value ", finalObjectiveValue))
    println(string("Upper bound: ", UB))

    writeSolution(finalSolution)
end

main()