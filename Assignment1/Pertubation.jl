using Random

function twoOpt(solution, edgeA, edgeB)
    newSolution = copy(solution)
    newSolution[edgeA+1], newSolution[edgeB] = newSolution[edgeB], newSolution[edgeA+1]
    newObjectiveValue = getObjectiveValue(newSolution)    
    #newObjectiveValue = swapObjectiveValue(solution,initObjectiveValue,edgeA,edgeB)
    return newSolution, newObjectiveValue
end

function twoOptImprovement(initSolution, initObjectiveValue, twoOptMode)
    solution = copy(initSolution)
    objectiveValue = initObjectiveValue
    for i in 1:dim
        for j in i:dim
            if(legalPair(i,j))
                newSolution, newObjectiveValue = twoOpt(initSolution, i, j)
                if (newObjectiveValue < objectiveValue)
                    solution = newSolution
                    objectiveValue = newObjectiveValue
                    if (twoOptMode == "first") 
                        break
                    end 
                end
            end
        end
    end
    return solution, objectiveValue
end

function applyTwoOptPertubation(solution, pertubations)
    newObjectiveValue = 0
    newSolution = solution
    for i in 1:pertubations
        edgeA = rand(1:dim-1)
        edgeB = ((edgeA+rand(2:dim-2)-1) % dim)+1
    
        if (edgeB < edgeA) 
            edgeA, edgeB = edgeB, edgeA
        end
        newSolution, newObjectiveValue = twoOpt(newSolution, edgeA, edgeB)
    end
    return newSolution
end

