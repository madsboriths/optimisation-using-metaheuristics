### s194624.jl

using Random

include("./IO.jl")
include("Heuristic.jl")
include("LocalSearch.jl")

struct ArgumentException <: Exception
    message::String
end

function main()
    ## Initialization
    instanceLocation = ARGS[1]
    solutionLocation = ARGS[2]
    maxTime = parse(Int, ARGS[3])
    
    println(instanceLocation)

    name, dim, LB ,rev, rev_pair, k, H, p = read_instance(instanceLocation)
    
    if (ARGS[2] == " ")
        solutionLocation = string("sols/", name, ".sol")
    end
    
    bestKnownSol, bestKnownRevenue, mF, rP = initSolution(dim, rev, rev_pair, k, H, p)

    println(bestKnownSol)
    println(bestKnownRevenue)
    
    ## ALSN
    iterations = 0    
    elapsedTime = 0
    println()
    println("Running ALSN for ", maxTime, " seconds...")
    println()
    start = time_ns()

    functions = [f1, f2, f3]
    random_index = rand(1:length(functions))
    selected_function = functions[random_index]
    while (elapsedTime < maxTime)

        newSolution, newRevenue = ()

        switch( )

        if (newRevenue > bestKnownRev)
            println("Better solution found: ", newRevenue, " > ", bestKnownRev)
            bestKnownSol = newSol
            bestKnownRev = newRevenue
        end
        elapsedTime = round((time_ns()-start)/1e9,digits=3)
        iterations += 1
    end

    println()
    println("Iterations: ", iterations)
    println("Final solution with revenue: ", bestKnownRev)
    println("Lower bound: ", LB)

    writeSolution(bestKnownSol, solutionLocation)
end
main()