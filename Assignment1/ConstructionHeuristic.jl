function insertElement(list, element, dist)
    n = size(list)[1]
    for i in n:-1:1
        if (dist[element,list[i]] == -1)
            insert!(list, i+1, element)
            return list
        end
    end
    insert!(list, 1, element)
    return list
end

function makeFeasible(visited, dist)
    n = size(visited)[1]
    solution = [visited[n]]
    for i in n-1:-1:1
        solution = insertElement(solution, visited[i], dist)
    end
    return solution
end

function nearestNeighbor(dist, dim) 
    println("Starting nearest neighbor")

    visited = zeros(Int,1)
    visited[1] = 1

    nextNode = 1
    while(size(visited)[1] < dim)
        shortDist, nextNode = checkNeighbors(nextNode, visited, dist, dim)
        append!(visited,nextNode)
    end
    solution = makeFeasible(visited, dist)
    return solution
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
