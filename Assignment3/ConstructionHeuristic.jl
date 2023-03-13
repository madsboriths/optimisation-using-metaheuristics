
function init(n_jobs, n_processors, UB, duration, processor)
    s = [Int[] for i in 1:n_processors]
    occupiedRanges = [Int[] for i in 1:n_jobs]
    for i in 1:n_jobs
        for j in 1:n_processors
            d = duration[i,j]
            p = processor[i,j]
            
            
        end
    end
end