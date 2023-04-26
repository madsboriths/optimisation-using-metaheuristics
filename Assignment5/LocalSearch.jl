### LocalSearch.jl

function LocalSearch(sol, revenue, dim, rev, rev_pair, k, H, p, alpha, mF, maxTime)
    
    bestKnownSol = deepcopy(sol)
    bestKnownRev = deepcopy(revenue)
    bestKnownMF = deepcopy(mF)

    # Remove alpha
    elapsedTime = 0
    start = time_ns()

    while (elapsedTime < maxTime)
        newSol, newRevenue, newMF = swapImprovement(bestKnownSol, bestKnownRev, dim, rev, rev_pair, k, H, p, alpha, bestKnownMF)
        if (newRevenue > bestKnownRev)
            bestKnownSol = newSol
            bestKnownRev = newRevenue
            bestKnownMF = newMF
        else 
            break
        end
        elapsedTime = round((time_ns()-start)/1e9,digits=3)
    end

    return bestKnownSol, bestKnownRev
end

# Uses first improvement
function swapImprovement(sol, revenue, dim, rev, rev_pair, k, H, p, alpha, mF)

    bestKnownSol = deepcopy(sol)
    bestKnownRev = deepcopy(revenue)
    bestKnownMF = deepcopy(mF)

    for i in 1:(k-1)
        for j in (i+1):k
            newSol, newRevenue, newMF = productionLineImprovement(bestKnownSol, bestKnownRev, dim, rev, rev_pair, k, H, p, alpha, i, j, bestKnownMF)
            if (newRevenue > bestKnownRev)
               return newSol, newRevenue, newMF
            end
        end
    end
    return bestKnownSol, bestKnownRev, bestKnownMF
end

function productionLineImprovement(sol, revenue, dim, rev, rev_pair, k, H, p, alpha, pl1, pl2, mF)

    bestKnownSol = deepcopy(sol)
    bestKnownRev = deepcopy(revenue)
    bestKnownMF = deepcopy(mF)

    for i in bestKnownSol[pl1]
        for j in bestKnownSol[pl2]
            if (legalPair(H, p, pl1, pl2, i, j, bestKnownMF))
                newSol, newRevenue, newMF = swap(bestKnownSol, bestKnownRev, dim, rev, rev_pair, k, H, p, alpha, pl1, pl2, i, j, bestKnownMF)
                if (newRevenue > bestKnownRev)
                    return newSol, newRevenue, newMF
                end
            end
        end
    end
    return bestKnownSol, bestKnownRev, bestKnownMF
end

function swap(sol, revenue, dim, rev, rev_pair, k, H, p, alpha, pl1, pl2, leftElement, rightElement, mF)
    
    finalSol = deepcopy(sol)
    finalRev = deepcopy(revenue)
    finalMF = deepcopy(mF)
    
    # Remove from each line
    filter!(x -> x != leftElement, finalSol[pl1])
    filter!(x -> x != rightElement, finalSol[pl2])
    
    # Update times
    finalMF[pl1] += (p[rightElement] - p[leftElement])
    finalMF[pl2] += (p[leftElement] - p[rightElement])
    
    # Update revenue
    for i in finalSol[pl1]
        finalRev -= rev_pair[leftElement, i]
        finalRev += rev_pair[rightElement, i]
    end
    for i in finalSol[pl2]
        finalRev -= rev_pair[rightElement, i]
        finalRev += rev_pair[leftElement, i]
    end
    
    # Insert back into lines
    push!(finalSol[pl1], rightElement)
    push!(finalSol[pl2], leftElement)
    
    return finalSol, finalRev, finalMF
end

function legalPair(H, p, pl1, pl2, leftElement, rightElement, mF)
    p1 = mF[pl1] + (p[rightElement] - p[leftElement]) <= H
    p2 = mF[pl2] + (p[leftElement] - p[rightElement]) <= H
    return p1 && p2 
end