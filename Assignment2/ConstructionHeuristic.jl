using Random

function GRCPlast(dim, LB , rev, rev_pair, k, H, p, alpha)
    sol = [Int[] for i in 1:k]
    currentObjectiveValue = 0

    # Put in initial elements to each assembly line
    products = [i for i in 1:dim]
    for i in eachindex(sol)
        element = rand(products)
        append!(sol[i], element)
        println("element ", i, " revenue: ", rev[element])
        currentObjectiveValue += rev[element]
        deleteat!(products, element)
    end

    println("yo")
    println(currentObjectiveValue)

    #candidates = getCandidates(sol, products, rev, rev_pair)
    #while(length(products) > 0) 
    #    element = rand(candidates)
    #    candidates = getCandidates(products, rev, rev_pair)
    #end

    return sol
end

function getCandidates(products, rev, rev_pair)
    cMin = minimum(rev)
    cMax = maximum(rev)

    return candidates
end

function withinRange(x, a, b)
    return x >= a && x <= b
end