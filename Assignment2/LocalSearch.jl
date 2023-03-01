

function LocalSearch(sol, revenue, availableTimes, totalTime, dim, rev, rev_pair, k, H, p, alpha)
    maxTime = totalTime / 100
    elapsedTime = 0

    start = time_ns()
    while (elapsedTime < maxTime) 
        newSolution, newRevenue = swapImprovement(sol, revenue, availableTimes, dim, rev, rev_pair, k, H, p, alpha)
        if (newRevenue > revenue)
            sol = newSolution
            revenue = newRevenue
        else 
            break
        end
        elapsedTime = round((time_ns()-start)/1e9,digits=3)
    end
    return sol, revenue    
end

## Uses first improvement
function swapImprovement(sol, revenue, availableTimes, dim, rev, rev_pair, k, H, p, alpha)
    done = false
    for i in 1:(k-1)
        for j in (i+1):k
            newSol, newRevenue = productionLineImprovement(i, j, sol, revenue, availableTimes, dim, rev, rev_pair, k, H, p, alpha)
            if (newRevenue > revenue)
                sol = newSol
                revenue = newRevenue
                done = true
                return sol, revenue
            end
        end
    end
    return sol, revenue
end

function productionLineImprovement(pl1, pl2, sol, revenue, availableTimes, dim, rev, rev_pair, k, H, p, alpha)

    for i in 1:(length(sol[pl1])-1)
        for j in (i+1):(length(sol[pl2]))
            leftElement = sol[pl1,i]
            rightElement = sol[pl2,j]            
            if (p[rightElement] <= (availableTimes[pl1] + p[leftElement]) 
                && p[leftElement] <= (availableTimes[pl2] + p[rightElement]))


                availableTimes[pl1] + p[leftElement] - p[rightElement]
                availableTimes[pl2] + p[rightElement] - p[leftElement]
                replace!(sol[pl1], leftElement => rightElement)
                replace!(sol[pl2], rightElement => leftElement)
                
                if (newRevenue > revenue)
                    return newSol, newRevenue
                end
            end
        end
    end
    return sol, revenue
end
