### s194624.jl

using Random

include("IO.jl")
include("ConstructionHeuristic.jl")
include("LocalSearch.jl")

struct ArgumentException <: Exception
    message::String
end

function main()
    ## Initialization
    instanceLocation = ARGS[1]
    solutionLocation = ARGS[2]
    maxTime = parse(Int, ARGS[3])
    
    if (length(ARGS) > 3) 
        alpha = parse(Float32, ARGS[4])
    else 
        alpha = 0.8
    end
    
    name, dim, LB , rev, rev_pair, k, H, p = read_instance(instanceLocation)
    printInstanceInformation(name, dim, LB , rev, rev_pair, k, H, p)
    
    if (ARGS[2] == " ")
        solutionLocation = string("sols/", name, ".sol")
    end
    
    bestKnownRev = 0
    bestKnownSol = [Int[] for i in 1:k]
    
    ## GRASP
    iterations = 0    
    elapsedTime = 0
    println()
    println("Running GRASP for ", maxTime, " seconds...")
    println()
    start = time_ns()
    while (elapsedTime < maxTime)
        sol, revenue, mF = GRCPlast(dim, rev, rev_pair, k, H, p, alpha)
        newSol, newRevenue = LocalSearch(sol, revenue, dim, rev, rev_pair, k, H, p, alpha, mF, maxTime)
        if (newRevenue > bestKnownRev)
            println("Better solution found: ", newRevenue, " > ", bestKnownRev)
            bestKnownSol = newSol
            bestKnownRev = newRevenue
        end
        elapsedTime = round((time_ns()-start)/1e9,digits=3)
        iterations += 1
    end

    println()
    println("GRASP Executed...")
    println("Iterations: ", iterations)
    println("Final solution with revenue: ", bestKnownRev)
    println("Lower bound: ", LB)

    writeSolution(bestKnownSol, solutionLocation)
end
main()