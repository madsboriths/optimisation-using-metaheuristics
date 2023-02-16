using Random



function applyTwoOptPertubation(solution, pertubations)
    newSolution = solution
    for i in 1:pertubations
        edgeA = rand(1:dim-1)
        edgeB = ((edgeA+rand(2:dim-2)-1) % dim)+1
    
        if (edgeB < edgeA) 
            edgeA, edgeB = edgeB, edgeA
        end
        newSolution, newObjectiveValue = twoOpt(newSolution, 0, edgeA, edgeB)
    end
    return newSolution
end

function shufflePertubation(solution)
    return shuffle!([i for i in 1:dim])
end