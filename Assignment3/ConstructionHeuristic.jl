
function init(n_jobs, n_processors, UB, duration, processor)

    s = [Tuple{Int,Int,Int,Int}[] for i in 1:n_processors]
    occupiedRanges = [Tuple{Int,Int}[] for i in 1:n_jobs]

    for operation in 1:n_processors
        for job in 1:n_jobs
            d = duration[job, operation]
            p = processor[job, operation]
            
            if (length(s[p]) == 0)
                newRange = (0,d)
            else
                prevElement = s[p][length(s[p])]
                newRange = (prevElement[4]+1,prevElement[4]+1+d)
            end
            overlappingRange = checkOverlap(newRange, occupiedRanges[job])
            while (!isnothing(overlappingRange))
                newRange = (overlappingRange[2]+1, overlappingRange[2]+1+d)
                overlappingRange = checkOverlap(newRange, occupiedRanges[job])
            end
            newElement = (job,operation,newRange[1],newRange[2])
            push!(s[p], newElement)  
            push!(occupiedRanges[job], newRange)
        end
    end
    return s, occupiedRanges
end

function checkOverlap(range, ranges)
    for i in ranges
        if (rangesOverlap(range, i))
            return i
        end
    end
    return nothing
end

function rangesOverlap(range1, range2)
    if (range1[1] > range2[2] || range1[2] < range2[1])
        return false
    end
    return true
end