using Random
include("IO.jl")
include("ConstructionHeuristic.jl")
include("LocalSearch.jl")

struct ArgumentException <: Exception
    message::String
end

function main()
    instanceLocation = ARGS[1]
    solutionLocation = ARGS[2]
    totalTime = parse(Int, ARGS[3])
    
    if (length(ARGS) > 3) 
        alpha = parse(Float32, ARGS[4])
    else 
        alpha = 0
    end

    name, dim, LB , rev, rev_pair, k, H, p = read_instance(instanceLocation)
    
    printInstanceInformation(name, dim, LB , rev, rev_pair, k, H, p)

    availableTimes = Int[H for i in 1:k]
    actualRevenue = 0
    sol = [Int[] for i in 1:k]
    
    iterations = 0    
    elapsedTime = 0
    start = time_ns()
    while (elapsedTime <= totalTime)
        newSol, newRevenue, availableTimes = GRCPlast(dim, rev, rev_pair, k, H, p, alpha)
        newSol, newRevenue = LocalSearch(newSol, newRevenue, availableTimes, totalTime, dim, rev, rev_pair, k, H, p, alpha)
        if (newRevenue > actualRevenue)
            sol = newSol
            actualRevenue = newRevenue
        end
        elapsedTime = round((time_ns()-start)/1e9,digits=3)
        iterations += 1
    end
    println("iterations: ", iterations)

    println("Final solution dimensions: ", sol, " with objective value ", actualRevenue)
end
main()