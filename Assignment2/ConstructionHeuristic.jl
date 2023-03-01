using Random

function GRCPlast(dim, LB , rev, rev_pair, k, H, p, alpha)
    println("Entered GRC")
    
    sol = [Int[] for i in 1:k]
    currentObjectiveValue = 0

    # Put in initial elements to each assembly line
    products = [i for i in 1:dim]
    println
    for i in eachindex(sol)
        element = rand(products)
        append!(sol[i], element)
        currentObjectiveValue += rev[element]
        deleteat!(products, element)
    end

    for i in 1:1
        candidates, objectiveValues = getCandidates(sol[i], products, rev, rev_pair, dim, alpha, H, p)
        element = rand(candidates)
        append!(sol[i], element)
        currentObjectiveValue += objectiveValues[i]
    end
    return sol, currentObjectiveValue
end

function getCandidates(productionLine, products, rev, rev_pair, dim, alpha, H, p)
    objectiveValues = fill(-1, dim)

    for i in products
        for j in productionLine
            objectiveValues[i] = rev[i] + rev_pair[j,i]
        end
    end
    nonNegativeValues = filter(x -> x >= 0, objectiveValues)
    
    max = maximum(nonNegativeValues)
    min = Int(round(alpha*(max-minimum(nonNegativeValues))))

    candidates = findall(x -> withinRange(x, min, max), objectiveValues)
    
    candidateValues = Int[]
    for i in candidates
        push!(candidateValues, objectiveValues[i])
    end
    return candidates, candidateValues
end

function withinRange(x, a, b)
    return x >= a && x <= b
end