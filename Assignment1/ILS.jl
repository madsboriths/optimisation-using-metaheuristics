

## 
# Having a function for each kind of pertubation is not very pretty 
# as much of the code is redundant, but saves the time it would take
# to check which pertubation method to use in every iteration, if a general 
# "pertubation" method was used instead.
##

function ILS(s, objectiveValue, twoOptMode, localSearchTime, totalTime, pertubationMode, dim, dist)
    if (pertubationMode == "shuffle")
        return shuffleILS(s, objectiveValue, twoOptMode, localSearchTime, totalTime, dim, dist)
    elseif (pertubationMode == "2Opt")
        return twoOptILS(s, objectiveValue, twoOptMode, localSearchTime, totalTime, dim, dist)
    elseif (pertubationMode == "DB")
        return doubleBridgeILS(s, objectiveValue, twoOptMode, localSearchTime, totalTime, dim, dist)
    elseif (pertubationMode == "DB/2Opt")
        return DB2OptILS(s, objectiveValue, twoOptMode, localSearchTime, totalTime, dim, dist)
    end
end

function DB2OptILS(s, objectiveValue, twoOptMode, localSearchTime, totalTime, dim, dist)
    elapsedTime = 0
    start = time_ns()

    pertubations = 3
    
    iterations = 0
    while (elapsedTime < totalTime)
        if (iterations % 1000 == 0) 
            sMark = doubleBridgePertubation(s, 10)
        else
            sMark = applyTwoOptPertubation(s, pertubations, dim, dist)
        end
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

function shuffleILS(s, objectiveValue, twoOptMode, localSearchTime, totalTime, dim, dist)
    elapsedTime = 0
    start = time_ns()
    
    iterations = 0
    while (elapsedTime < totalTime)
        sMark = shufflePertubation(s, dim)
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

function doubleBridgeILS(s, objectiveValue, twoOptMode, localSearchTime, totalTime, dim, dist)
    elapsedTime = 0
    start = time_ns()

    iterations = 0
    while (elapsedTime < totalTime)
        sMark = doubleBridgePertubation(s, 1)
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
