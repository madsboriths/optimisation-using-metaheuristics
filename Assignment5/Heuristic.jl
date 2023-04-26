### Heuristic.jl

using Random

function initSolution(dim, rev, rev_pair, k, H, p)
    products = [i for i in 1:dim]
    mF = Int[0 for i in 1:k]
    sol = [Int[] for i in 1:k]

    # Put in initial elements to each assembly line
    totalRevenue = 0
    while(length(products) > 0)
        # Extract random element
        element = rand(products)

        m = rand(1:k)

        if (mF[m] + p[element] <= H)
            # Update available time
            mF[m] += p[element]
            
            # Add to solution
            push!(sol[rand(1:k)], element)
    
            # Update revenue
            revenue += rev[element]
    
            # Mark as visited
            filter!(x -> x != element, products)
        else
            break
        end
    end
    return sol, revenue, mF, products
end

function repairGreedy(initSol, initRevenue, mF, rP, dim, rev, rev_pair, k, H, p)
    max = 0
    maxIdx
    idx = argmin(mF)
    while(true)
        for i in rP
            for j in initSol[idx]
                revGain = rev_pair[j,i] + rev[i]
                if (revGain > max)
                    maxIdx = i
                    max = revGain
                end
            end
        end
        if(any(x -> x > H, mF))
            break
        else
            
        end
    end
    return sol, revenue
end

function repair2(initSol, initRevenue, mF, dim, rev, rev_pair, k, H, p)
    sol = initSol
    revenue = initRevenue
    return sol, revenue
end