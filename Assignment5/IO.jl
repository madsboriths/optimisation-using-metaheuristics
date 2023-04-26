function read_instance(filename)
    f = open(filename)
    name = readline(f) # name of the instance
    size = parse(Int32,readline(f)) # number of order
    LB = parse(Int32,readline(f)) # best known revenue
    rev = parse.(Int32,split(readline(f)))# revenue for including an order
    rev_pair = zeros(Int32,size,size) # pairwise revenues
    for i in 1:size-1
        data = parse.(Int32,split(readline(f)))
        j=i+1
        for d in data
            rev_pair[i,j]=d
            rev_pair[j,i]=d
            j+=1
        end
    end
    readline(f)
    k = parse(Int32,readline(f)) # number of production lines
    H = parse(Int32,readline(f)) # planning horizon
    p = parse.(Int32,split(readline(f))) # production times
    close(f)
    return name, size, LB ,rev, rev_pair, k, H, p
end

function writeSolution(solution, solutionLocation)
    wDir = string(pwd())
    
    dir, file = splitdir(solutionLocation)
    if (!isdir(dir))
        mkpath(string("./", dir, "/"))
    end
    
    open(string(wDir, "/", solutionLocation), "w") do f
        for i in eachindex(solution)
            for j in solution[i]
                write(f, string(j, " "))
            end
            write(f, "\n")
        end
    end    
end