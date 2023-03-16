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
    n_jobs, n_processors, UB, duration, processor, name = read_instance(instanceLocation)
    
    printInstance(n_jobs, n_processors, UB, duration, processor)

    println("Finding initial solution...")
    s, occupiedRanges = init(n_jobs, n_processors, UB, duration, processor)
    println("Initial solution found!")

    #TODO Find initial temperature setting
    alpha = 0.999999

    # Number of random elements to remove
    k = 5

    elapsedTime = 0
    iterations = 0
    deltaSum = 0
    betaMinus = 0
    betaPlus = 0
    gamma = 0.99999999
    K = 10000
    T = 0
    start = time_ns()

    while (iterations <= K)
        if (iterations < K)
            sMark, occupiedRangesMark = randomStep(s, occupiedRanges, duration, processor, k)
            diff = Float64(cost(sMark) - cost(s))
            if (diff > 0)
                deltaSum += diff
                betaPlus += 1
            elseif (diff < 0)
                betaMinus += 1
            end
        else
            T = deltaSum / log(betaMinus / (betaMinus*gamma-betaPlus*(1-gamma)))
        end
        iterations += 1
    end

    eta = 0.0000001
    alpha = exp(log(-1/(T*log(eta)))/100000)
    
    println("Init temperature: ", T)
    println("Alpha decay: ", alpha)

    while (!terminate(elapsedTime, maxTimeAllowed))
        sMark, occupiedRangesMark = randomStep(s, occupiedRanges, duration, processor, k)
        sMarkCost = cost(sMark)
        sCost = cost(s)
        delta = Float64(sMarkCost - sCost)

        if (delta < 0 || rand() < exp(-(delta/T)))
            s = sMark
            occupiedRanges = occupiedRangesMark
        end

        #TODO Determine temperature decay
        T *= alpha
        
        elapsedTime = round((time_ns()-start)/1e9,digits=3)
        iterations += 1
    end

    println(iterations, " iterations total...", )
    println()

    println("Final solution:")
    printResults(s, occupiedRanges)

    if (ARGS[2] == " ")
        vals = rsplit(name, ".", limit=2)
        solutionLocation = string("sols/", vals[1], ".sol")
    end
    writeSolution(s, solutionLocation, n_jobs, n_processors)
end

function cost(s)
    max = 0
    for processor in s
        if (length(processor) > 0)
            element = processor[length(processor)]
            if (element[4] > max)
                max = element[4]
            end
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