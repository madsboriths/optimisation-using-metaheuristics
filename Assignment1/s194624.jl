using Random
include("ConstructionHeuristic.jl")
include("LocalSearch.jl")
include("InstanceReader.jl")
include("Pertubation.jl")

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
    println(name)
    pertubations = 1

    # "first" or "best" two opt improvement
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
        
        #sMark = applyTwoOptPertubation(s, pertubations)
        sMark = shufflePertubation(s)
        sStar, newObjectiveValue = localSearch(sMark, objectiveValue, twoOptMode, localSearchTime)
        if (newObjectiveValue < objectiveValue) 
            println(string("Found better solution: ", newObjectiveValue, " < ", objectiveValue))
            objectiveValue = newObjectiveValue
            s = copy(sStar)
        end
        elapsedTime = round((time_ns()-start)/1e9,digits=3)
        iterations += 1
    end  
    
    println(string(iterations, " iterations"))
    println(string("Final solution: ", s, " with objective value ", objectiveValue))
    println(string("Upper bound: ", UB))

    writeSolution(s)
end

main()