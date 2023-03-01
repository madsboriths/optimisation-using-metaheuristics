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


function GRC(dim, dist, alpha)

    s = Int[]
    init = rand( 1:dim)
    push!(s, init)
    println(s)
    list = deleteat!(dist[init,1:dim],init)
    currentCity = init

    while(length(s) < (dim))
        cMin = minimum(list)
        cMax = maximum(list)
        maxRange = cMin + alpha*(cMax - cMin)
        RCL = Int[]
        for i in 1:dim
            if (!(i in s) && withinRange(dist[currentCity,i], cMin, maxRange))
                push!(RCL, i)
            end
        end
        s = push!(s, rand(RCL))
        currentCity = s[length(s)]

        list = dist[currentCity, filter(x -> !(x in s),collect(1:dim))]
    end
    push!(s, s[1])
end


function withinRange(x, a, b)
    return x >= a && x <= b
end

function getRCL(dist, alpha)
    
end