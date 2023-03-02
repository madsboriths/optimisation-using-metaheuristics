using Random

function GRCPlast(dim, rev, rev_pair, k, H, p, alpha)
    products = [i for i in 1:dim]
    mF = Int[0 for i in 1:k]
    sol = [Int[] for i in 1:k]

    # Put in initial elements to each assembly line
    totalRevenue = 0
    for i in eachindex(sol)
        # Extract random element
        element = rand(products)
        
        # Add to solution
        push!(sol[i], element)

        # Update revenue
        totalRevenue += rev[element]
        
        # Update available time
        mF[i] += p[element]
        
        # Mark as visited
        filter!(x -> x != element, products)
    end

    hasCandidates = [true for i in 1:k]
    while (true)
        for i in 1:k
            # Get candidate list
            candidates, revenues = getCandidates(sol[i], mF[i], products, rev, rev_pair, dim, alpha, H, p)
            if (!isempty(candidates))
                # Select element from candidate
                index = rand(1:length(candidates))
                element = candidates[index]
    
                # Add to solution
                append!(sol[i], element)
    
                # Update revenue
                totalRevenue += revenues[index]
    
                # Update available time
                mF[i] += p[element]
    
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
    return sol, totalRevenue, mF
end

function getCandidates(productionLine, mF, products, rev, rev_pair, dim, alpha, H, p)
    revenues = fill(0, dim)
    for i in products
        revenues[i] += rev[i]
        for j in productionLine
            revenues[i] += rev_pair[i,j]
        end
    end
    nonNegativeValues = filter(x -> x >= 0, revenues)
    
    max = maximum(nonNegativeValues)
    min = Int(round(alpha*(max-minimum(nonNegativeValues))))

    candidates = findall(x -> withinRange(x, min, max), revenues)
    filter!(x -> p[x] + mF <= H, candidates)

    candidateValues = Int[]
    for i in candidates
        push!(candidateValues, revenues[i])
    end

    return candidates, candidateValues
end

function withinRange(x, a, b)
    return x >= a && x <= b
end