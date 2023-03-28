using Random
include("IO.jl")
include("TABU.jl")

struct ArgumentException <: Exception
    message::String
end

function main()
    localSearchTime = 60
    instanceLocation = ARGS[1]
    solutionLocation = ARGS[2]
    totalTime = parse(Int, ARGS[3])
    
    name, UB, dim, dist = read_instance(instanceLocation)
    k = dim/4

    println("Running instance: ", name)
    println(string("Upper bound: ", UB))

    # Default
    pertubationMode = "DB/2Opt"
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
        if (!(ARGS[5] == "shuffle" || ARGS[5] == "2Opt" || ARGS[5] == "DB" || ARGS[5] == "DB/2Opt"))
            throw(ArgumentException(string("illegal argument: ", ARGS[5])))
        end
    end

    if (ARGS[2] == " ")
        vals = rsplit(name, ".", limit=2)
        solutionLocation = string("sols/", vals[1], ".sol")
    end

    # Initialize with solution using nearest neighbor 
    println("Finding initial solution...")
    s, objectiveValue = nearestNeighbor(dist, dim)
    println("Initial solution found")

    # Find the initial local minimum
    iterations = 0
    elapsedTime = 0
    
    # Perform iterated local search 
    println("Allowed time: ", totalTime, " seconds")

    bestS = copy(s)
    bestObjective = objectiveValue

    previousMove = (-1,-1)
    visitedSolutions = [s]
    
    lastUpdateTime = elapsedTime
    start = time_ns()
    while (elapsedTime < totalTime)
        newSolution, newObjectiveValue, previousMove = BestNonTABU(s, objectiveValue, dim, dist, visitedSolutions, previousMove)

        visitSolution(visitedSolutions, newSolution, k)
        if (newObjectiveValue < bestObjective)
            bestS = copy(newSolution)
            bestObjective = newObjectiveValue

            s = newSolution
            objectiveValue = newObjectiveValue

            println("Better solution found: ", bestObjective, " time: ", elapsedTime)
            lastUpdateTime = elapsedTime
        end

        if ((elapsedTime - lastUpdateTime) > totalTime / 5) 
            println("Diversification")
            shuffle!(s)
            makeFeasible(s, dist)
            objectiveValue = getObjectiveValue(s, dist)
            lastUpdateTime = elapsedTime
        end
        
        iterations += 1
        elapsedTime = round((time_ns()-start)/1e9,digits=3)
    end

    println("\nSearch completed.")
    println(string(iterations, " total iterations"))
    println(string("Final objective value: ", bestObjective))
    println(string("Upper bound: ", UB))

    writeSolution(s, solutionLocation)
end
main()