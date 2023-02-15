
function legalPair(n, m)
    if (abs(n-m) < 2) 
        return false
    end 
    if (n == 1 && m == dim) 
        return false
    end
    return true
end

function swapObjectiveValue(solution, sum, n, m)
    sum = sum - (dist[solution[n],solution[n+1]] + dist[solution[m],solution[(m % dim)+1]])
    sum = sum + (dist[solution[n],solution[m]] + dist[solution[n+1],solution[(m % dim)+1]])
    return sum
end

function getObjectiveValue(solution)
    val = 0
    n = size(solution)[1]
    for i in 1:n-1
        val = val + dist[solution[i], solution[i+1]]
    end
    return val
end

function localSearch(solution, initObjectiveValue, twoOptMode, time)   
    start = time_ns()
    elapsedTime = 0
    
    objectiveValue = initObjectiveValue
    while (elapsedTime < time) 
        newSolution, newObjectiveValue = twoOptImprovement(solution, objectiveValue, twoOptMode)
        newSolution = makeFeasible(newSolution, dist)
        newObjectiveValue = getObjectiveValue(newSolution)
        if (newObjectiveValue < objectiveValue) 
            objectiveValue = newObjectiveValue
            solution = newSolution
        else 
            break
        end
        elapsedTime = round((time_ns()-start)/1e9,digits=3)
    end
    return solution, objectiveValue
end