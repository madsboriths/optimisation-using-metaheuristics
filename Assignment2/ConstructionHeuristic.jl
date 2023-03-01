using Random

function GRCPlast(dim, rev, rev_pair, k, H, p, alpha)
    products = [i for i in 1:dim]
    availableTimes = Int[H for i in 1:k]
    sol = [Int[] for i in 1:k]

    # Put in initial elements to each assembly line
    currentObjectiveValue = 0
    for i in eachindex(sol)
        # Extract random element
        element = rand(products)
        
        # Add to solution
        push!(sol[i], element)

        # Update revenue
        currentObjectiveValue += rev[element]
        
        # Update available time
        availableTimes[i] -= p[element]
        
        # Mark as visited
        filter!(x -> x != element, products)
    end

    hasCandidates = [true for i in 1:k]
    while (true)
        for i in 1:k
            # Get candidate list
            candidates, objectiveValues = getCandidates(sol[i], availableTimes[i], products, rev, rev_pair, dim, alpha, H, p)

            if (!isempty(candidates))
                # Select element from candidate
                index = rand(1:length(candidates))
                element = candidates[index]
    
                # Add to solution
                append!(sol[i], element)
    
                # Update revenue
                currentObjectiveValue += objectiveValues[index]
    
                # Update available time
                availableTimes[i] -= p[element]
    
                # Mark as visited
                filter!(x -> x != element, products)
            else
                hasCandidates[i] = false
            end
        end
        if (!any(hasCandidates))
            break
        end
    end

    #TODO Add any remaining elements?
    return sol, currentObjectiveValue, availableTimes
end

function getCandidates(productionLine, availableTime, products, rev, rev_pair, dim, alpha, H, p)
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
    filter!(x -> p[x] <= availableTime, candidates)

    candidateValues = Int[]
    for i in candidates
        push!(candidateValues, objectiveValues[i])
    end

    return candidates, candidateValues
end

function withinRange(x, a, b)
    return x >= a && x <= b
end