using Random
include("ConstructionHeuristic.jl")
include("LocalSearch.jl")
include("InstanceReader.jl")
include("Pertubation.jl")

#name, UB, dim, dist = read_instance("Assignment1/Instances/Instances/ESC47.sop")
pertubations = 3
localSearchTime = 10
instanceLocation = ARGS[1]
solutionLocation = ARGS[2]
totalTime = parse(Int, ARGS[3])

name, UB, dim, dist = read_instance(instanceLocation)

function writeSolution(solution)
    dir = dirname(solutionLocation)

    if (!isdir(dir))
        mkpath("./sols/")
    end
    
    open(solutionLocation, "w") do f
        for i in eachindex(solution)
            write(f, string(solution[i]-1, " "))
        end
    end    
end

function main()
    println(name)

    # "first" or "best
    twoOptMode = "first"

    # Initialize with solution using nearest neighbor 
    s0 = nearestNeighbor(dist, dim)
    objectiveValue = getObjectiveValue(s0)

    # Find the initial local minimum
    s, objectiveValue = localSearch(s0, objectiveValue, twoOptMode, localSearchTime)

    elapsedTime = 0
    start = time_ns()

    iterations = 0
    while (elapsedTime < totalTime)
        sMark = applyTwoOptPertubation(s, pertubations) # TODO Pertubate
        sStar, newObjectiveValue = localSearch(sMark, objectiveValue, twoOptMode, localSearchTime)
        if (newObjectiveValue < objectiveValue) 
            println(string("Found better solution: ", newObjectiveValue, " < ", objectiveValue))
            objectiveValue = newObjectiveValue
            s = copy(sStar)
        end
        elapsedTime = round((time_ns()-start)/1e9,digits=3)
        iterations += 1
        #println(string(elapsedTime, " seconds passed"))
    end  

    println(string(iterations, " iterations"))
    println(string("Final solution: ", s, " with objective value ", objectiveValue))
    println(string("Upper bound: ", UB))

    writeSolution(s)
end

main()