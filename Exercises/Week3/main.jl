
using Random
include("../../Assignment1/IOHandler.jl")
include("ConstructionHeuristic.jl")

struct ArgumentException <: Exception
    message::String
end

function main()
    Random.seed!(1)
    println(rand(1:20))
    alpha = 0.2
    
    instanceLocation = ARGS[1]
    solutionLocation = ARGS[2]
    totalTime = parse(Int, ARGS[3])
    
    name, coord, dim = readTSPInstance(instanceLocation)
    dist = getDistanceMatrix(coord, dim)

    println("Running instance: ", name)

    if (ARGS[2] == " ")
        vals = rsplit(name, ".", limit=2)
        solutionLocation = string("sols/", vals[1], ".sol")
    end

    finalSolution = GRC(dim, dist, alpha)
    println(finalSolution)

    #=
    # Initialize with solution using nearest neighbor 
    elapsedTime = 0
    start = time_ns()
    sMark = []
    while(elapsedTime < totalTime)
        sMark = GRC(dim, dist, alpha)
        #sStar, newObjectiveValue = localSearch(sMark, objectiveValue, twoOptMode, localSearchTime, dist, dim)
        elapsedTime = round((time_ns()-start)/1e9,digits=3)
    end
    =#

    #finalSolution = sMark

    writeSolution(finalSolution, solutionLocation)
end

main()