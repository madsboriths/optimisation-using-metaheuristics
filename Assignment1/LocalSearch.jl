
function legalPair(n, m)
    if (abs(n-m) < 2) 
        return false
    end 

    ## Relevant special case if the path was cyclic
    #if (n == 1 && m == dim-1) 
    #    return false
    #end

    return true
end

# Perform 2Opt operation swapping two particular edges
function twoOpt(solution, initObjectiveValue, edgeA, edgeB)
    newSolution = copy(solution)
    newSolution[edgeA+1], newSolution[edgeB] = newSolution[edgeB], newSolution[edgeA+1]
    #newObjectiveValue = getObjectiveValue(newSolution)    
    newObjectiveValue = swapObjectiveValue(solution, initObjectiveValue, edgeA, edgeB)
    return newSolution, newObjectiveValue
end

# Search for a better solution using 2Opt in solution neighborhood
# Can be set to "best" or "first" mode
function twoOptImprovement(initSolution, initObjectiveValue, twoOptMode)
    solution = copy(initSolution)
    objectiveValue = initObjectiveValue
    for i in 1:dim-1
        for j in i:dim-1
            if(legalPair(i,j))
                newSolution, newObjectiveValue = twoOpt(initSolution, initObjectiveValue, i, j)
                if (newObjectiveValue < objectiveValue)
                    solution = newSolution
                    objectiveValue = newObjectiveValue
                    if (twoOptMode == "first") 
                        return solution, objectiveValue
                    end
                end
            end
        end
    end
    return solution, objectiveValue
end

# Given two edges 'n' and 'm' recalculate the relevant costs for the new solution
function swapObjectiveValue(solution, sum, n, m)
    if (abs(n-m) == 2)
        sum = sum - (dist[solution[n],solution[n+1]] + dist[solution[n+1],solution[m]]
                   + dist[solution[m],solution[m+1]])
        sum = sum + (dist[solution[n],solution[m]] + dist[solution[m],solution[n+1]]
                   + dist[solution[n+1],solution[m+1]])
    else
        sum = sum - (dist[solution[n],solution[n+1]] + dist[solution[n+1],solution[n+2]]
                   + dist[solution[m-1],solution[m]] + dist[solution[m],solution[m+1]])
        sum = sum + (dist[solution[n],solution[m]] + dist[solution[m],solution[n+2]]
                   + dist[solution[m-1],solution[n+1]] + dist[solution[n+1],solution[m+1]])
    end
    return sum
end

# Calculates the objective value of a given solution iteratively
function getObjectiveValue(solution)
    val = 0
    n = size(solution)[1]
    for i in 1:n-1
        val = val + dist[solution[i], solution[i+1]]
    end
    return val
end

# Perform local search on a particular solution
# Can be set to "best" or "first" mode
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