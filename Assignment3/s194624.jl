### s194624.jl
using Random

include("IO.jl")
include("Solver.jl")

struct ArgumentException <: Exception
    message::String
end

function main()
    instanceLocation = ARGS[1]
    solutionLocation = ARGS[2]
    maxTimeAllowed = parse(Int, ARGS[3])

    n_jobs, n_processors, UB, duration, processor = read_instance(instanceLocation)
    
    printInstance(n_jobs, n_processors, UB, duration, processor)

    println("Finding initial solution...")
    s, occupiedRanges = init(n_jobs, n_processors, UB, duration, processor)
    println("Initial solution found!")

    #TODO Find initial temperature setting
    T = 100
    alpha = 0.99
    
    elapsedTime = 0
    start = time_ns()
    iterations = 0
    while (!terminate(elapsedTime, maxTimeAllowed) && iterations < 1)

        sMark, occupiedRangesMark = randomStep(s, occupiedRanges, n_jobs, n_processors, duration, processor)
        
        #TODO Implement delta-evaluation
        delta = Float64(cost(sMark) - cost(s))

        if (delta < 0 || rand() < exp(-(delta/T)))
            s = sMark
            occupiedRanges = occupiedRangesMark
        end

        #TODO Determine temperature decay
        T = T * alpha
        
        elapsedTime = round((time_ns()-start)/1e9,digits=3)
        iterations += 1
    end

    printResults(s, occupiedRanges)
    writeSolution(s, solutionLocation, n_jobs, n_processors)
end

function cost(s)
    max = 0
    for processor in s
        element = processor[length(processor)]
        if (element[4] > max)
            max = element[4]
        end
    end
    return max
end

function terminate(elapsedTime, maxTimeAllowed)
    if (elapsedTime > maxTimeAllowed)
        return true
    end
    return false
end

main()