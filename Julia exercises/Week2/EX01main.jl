using Random

function readInstance(filename)
    #open file for reading
    file = open(filename)
    #read the name of the instance
    name = split(readline(file))[2]
    #The next two lines are not interesting for us. Skip them
    readline(file);readline(file)
    #Read the size of the instance (the number of cities)
    dim = parse(Int32,split(readline(file))[2])
    #The next two lines are not interesting for us. Skip them
    readline(file);readline(file)
    #Create a Matrix (dim ⋅ 2) to hold the coordinates
    coord = zeros(Float32,dim,2)
    #Read coordinates
    for i in 1:dim
        data = parse.(Float32,split(readline(file)))
        coord[i,:]=data[2:3]
    end
    #Close the file
    close(file)
    #return the data we need
    return name,coord,dim
end

function getDistanceMatrix(coord::Array{Float32,2},dim::Int32)
    dist = zeros(Float32,dim,dim)
    for i in 1:dim
       for j in 1:dim
        if i!=j
            dist[i,j]=round(sqrt((coord[i,1]-coord[j,1])^2+(coord[i,2]-coord[j,2])^2),digits=2)
        end
    end
end
return dist

end
function checkNeighbors(ID, visited, dist, dim)
    max = maximum(dist)+1
    currentList = zeros(dim)

    for i in eachindex(currentList)
        if i in visited
            currentList[i] = max
        else
            currentList[i] = dist[ID,i]
        end 
    end
    return findmin(currentList)
end

name, coord, dim = readInstance("Week1/EX01-TSP/tsp_toy20.tsp")
dist = getDistanceMatrix(coord,dim)
function main()
    println(name)

    visited = zeros(Int,1)
    visited[1] = 1

    nextNode = 1
    while(size(visited)[1] < dim)
        shortDist, nextNode = checkNeighbors(nextNode, visited, dist, dim)
        append!(visited,nextNode)
    end
    append!(visited,1)

    N = dim #the number of cities
    randSol = shuffle!([i for i in 1:N])
    append!(randSol, randSol[1])

    initHeuristicObjective = objectiveValue(visited)
    initRandomObjective = objectiveValue(randSol)

    println(string("Initial heuristic solution: ", visited, " Objective value: ", initHeuristicObjective))
    println(string("Initial random solution: ", randSol), " Objective value: ", initRandomObjective)

    time = 30    
    start = time_ns()

    currentObjectiveValue = initHeuristicObjective
    bestSolution = visited
    for i in 1:dim
        for j in i:dim
            if(legalPair(i,j))
                newSolution = copy(bestSolution)
                newSolution[i+1], newSolution[j] = newSolution[j], newSolution[i+1]
                newObjectiveValue = swapObjectiveValue(currentObjectiveValue,i,j)
                #newObjectiveValue = objectiveValue(newSolution)
                if (newObjectiveValue < currentObjectiveValue)
                    #println(string("Better solution found: ", newObjectiveValue, " < ", currentObjectiveValue))
                    currentObjectiveValue = newObjectiveValue
                    bestSolution = copy(newSolution)
                end
            end
        end
    end

    println(string("New: ", bestSolution, " Value: ", currentObjectiveValue))
    println(string("Old: ", visited, " Value: ", initHeuristicObjective))

    elapsed = round((time_ns()-start)/1e9,digits=3)
    println(string("Time passed: ", elapsed))

end

function legalPair(n, m)
    if (abs(n-m) < 2) 
        return false
    end 
    if (n == 1 && m == dim) 
        return false
    end
    return true
end

function swapObjectiveValue(val, n, m)
    sum = copy(val)
    sum = sum - (dist[n,n+1] + dist[m,(m % dim)+1])
    sum = sum + (dist[n,m] + dist[n+1,(m % dim)+1])
    return sum
end

function objectiveValue(solution)
    val = 0
    for i in eachindex(solution)
        if (i <= dim) 
            val = val + dist[solution[i], solution[i+1]]
        end
    end
    return val
end

main()