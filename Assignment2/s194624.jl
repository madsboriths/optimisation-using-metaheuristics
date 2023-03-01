using Random
include("PlastOutReader.jl")
include("ConstructionHeuristic.jl")
include("GRASP.jl")

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
    
    println("name ", name)
    println("dim ", dim)
    println("rev ", typeof(rev), " size ", size(rev))
    println("revpair ", typeof(rev_pair), " size ", size(rev_pair))
    println("k ", k)
    println("H ", H)
    println("p ", typeof(p), " size ", size(p))

    sol, objectiveValue = GRCPlast(dim, LB , rev, rev_pair, k, H, p, alpha)

    println("Final solution: ", sol, " with objective value ", objectiveValue)
end

main()