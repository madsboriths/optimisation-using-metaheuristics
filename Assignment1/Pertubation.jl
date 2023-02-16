using Random

function getRandomEdgePair()
    edgeA = rand(1:dim-1)
    #edgeB = ((edgeA+rand(2:dim-2)-1) % dim)+1

    println(string(edgeA, " ", edgeB))
    if (edgeB < edgeA) 
        edgeA, edgeB = edgeB, edgeA
    end
    return edgeA, edgeB
end

function applyTwoOptPertubation(solution, pertubations)
    newSolution = solution
    for i in 1:pertubations
        edgeA, edgeB = getRandomEdgePair()        
        newSolution, newObjectiveValue = twoOpt(newSolution, 0, edgeA, edgeB)
    end
    return newSolution
end

function shufflePertubation(solution)
    return shuffle!([i for i in 1:dim])
end

