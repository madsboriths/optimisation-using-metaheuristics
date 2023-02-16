

## 
# Having a function for each kind of pertubation is not very pretty 
# as much of the code is redundant, but saves the time it would take
# to check which pertubation method to use in every iteration, if a general 
# "pertubation" method was used instead.
##

function ILS(s, objectiveValue, twoOptMode, localSearchTime, totalTime, pertubationMode, dim, dist)
    if (pertubationMode == "shuffle")
        return shuffleILS(s, objectiveValue, twoOptMode, totalTime)
    elseif (pertubationMode == "2Opt")
        return twoOptILS(s, objectiveValue, twoOptMode, localSearchTime, totalTime, dim, dist)
    elseif (pertubationMode == "DB")
        return doubleBridgeILS(s, objectiveValue, twoOptMode, totalTime)
    end
end

function shuffleILS(s, objectiveValue, twoOptMode, totalTime)
    elapsedTime = 0
    start = time_ns()
    
    iterations = 0
    while (elapsedTime < totalTime)
        sMark = shufflePertubation(s)
        sStar, newObjectiveValue = localSearch(sMark, objectiveValue, twoOptMode, localSearchTime, dist, dim)
        if (newObjectiveValue < objectiveValue) 
            println(string("Found better solution: ", newObjectiveValue, " < ", objectiveValue))
            objectiveValue = newObjectiveValue
            s = copy(sStar)
        end
        elapsedTime = round((time_ns()-start)/1e9,digits=3)
        iterations += 1
    end  
    return s, objectiveValue, iterations
end

function twoOptILS(s, objectiveValue, twoOptMode, localSearchTime, totalTime, dim, dist)
    elapsedTime = 0
    start = time_ns()

    pertubations = 5
    
    iterations = 0
    while (elapsedTime < totalTime)
        sMark = applyTwoOptPertubation(s, pertubations, dim, dist)
        sStar, newObjectiveValue = localSearch(sMark, objectiveValue, twoOptMode, localSearchTime, dist, dim)
        if (newObjectiveValue < objectiveValue) 
            println(string("Found better solution: ", newObjectiveValue, " < ", objectiveValue))
            objectiveValue = newObjectiveValue
            s = copy(sStar)
        end
        
        elapsedTime = round((time_ns()-start)/1e9,digits=3)
        iterations += 1
    end  
    return s, objectiveValue, iterations
end

function doubleBridgeILS(s, objectiveValue, twoOptMode, totalTime)
    elapsedTime = 0
    start = time_ns()

    iterations = 0
    while (elapsedTime < totalTime)
        sMark = doubleBridgePertubation(s)
        sStar, newObjectiveValue = localSearch(sMark, objectiveValue, twoOptMode, localSearchTime, dist, dim)
        if (newObjectiveValue < objectiveValue) 
            println(string("Found better solution: ", newObjectiveValue, " < ", objectiveValue))
            objectiveValue = newObjectiveValue
            s = copy(sStar)
        end
        
        elapsedTime = round((time_ns()-start)/1e9,digits=3)
        iterations += 1
    end  
    return s, objectiveValue, iterations
end
