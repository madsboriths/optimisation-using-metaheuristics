using Random
include("ConstructionHeuristic.jl")
include("LocalSearch.jl")
include("InstanceReader.jl")
include("Pertubation.jl")

#name, coord, dim = readTSPInstance("Exercises/Week1/EX01-TSP/tsp_toy20.tsp")
name, UB, dim, dist = read_instance("Assignment1/Instances/Instances/ESC47.sop")
pertubations = 3
localSearchTime = 3
totalTime = 10

function main()
    println(name)
    
    # "first" or "best
    twoOptMode = "firs"

    # Initialize with solution using nearest neighbor 
    s0 = nearestNeighbor(dist, dim)
    objectiveValue = getObjectiveValue(s0)

    # Find the initial local minimum
    s, objectiveValue = localSearch(s0, objectiveValue, twoOptMode, localSearchTime)

    elapsedTime = 0
    start = time_ns()
    
    while (elapsedTime < totalTime)
        sMark = applyPertubationTwoOpt(s, pertubations) # TODO Pertubate
        sStar, newObjectiveValue = localSearch(sMark, objectiveValue, twoOptMode, localSearchTime)
        if (newObjectiveValue < objectiveValue) 
            objectiveValue = newObjectiveValue
            s = copy(sStar)
        end
        elapsedTime = round((time_ns()-start)/1e9,digits=3)
        #println(string(elapsedTime, " seconds passed"))
    end  

    println(string("Final solution: ", s, " with objective value ", objectiveValue))
    println(string("Upper bound: ", UB))
end

main()