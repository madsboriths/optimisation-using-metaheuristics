
function read_instance(filename::String)
    f = open(filename)
    readline(f)#comment
    n_jobs, n_processors, UB = parse.(Int,split(readline(f)))
    readline(f)#comment
    duration = zeros(Int,n_jobs,n_processors)
    for i in 1:n_jobs
        duration[i,:] = parse.(Int,split(readline(f)))
    end
    readline(f)#comment
    processor = zeros(Int,n_jobs,n_processors)
    for i in 1:n_jobs
        processor[i,:] = parse.(Int,split(readline(f)))
    end
    close(f)

    return n_jobs, # the number of jobs
           n_processors, # the number of processors = number of operations
           UB, # the best-known upper bound
           duration, # the duration of each operation
           processor # the processor assinged to each operation
end

