using Random

function getRandomEdgePair(dim)
    edgeA = rand(1:dim-1)
    temp = rand(2:dim-3)
    edgeB = ((edgeA + (temp))%(dim-1))+1

    if (edgeB < edgeA) 
        edgeA, edgeB = edgeB, edgeA
    end
    return edgeA, edgeB
end

function doubleBridgePertubation(solution, pertubations)
    tempSolution = solution
    newSolution = []
    for i in 1:pertubations
        l = length(solution)
        k = Int(ceil(l/4))
        a = rand(1:k)
        b = a + rand(1:k)
        c = b + rand(1:k)
        
        append!(newSolution, tempSolution[1:a])
        append!(newSolution, tempSolution[c:l])
        append!(newSolution, tempSolution[b:c-1])
        append!(newSolution, tempSolution[a+1:b-1])
        tempSolution = newSolution
    end
    return newSolution
end

function applyTwoOptPertubation(solution, pertubations, dim, dist)
    newSolution = solution
    for i in 1:pertubations
        edgeA, edgeB = getRandomEdgePair(dim)        
        newSolution, newObjectiveValue = twoOpt(newSolution, 0, edgeA, edgeB, dist)
    end
    return newSolution
end

function shufflePertubation(solution, dim)
    return shuffle!([i for i in 1:dim])
end

