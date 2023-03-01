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

function printInstanceInformation(name, dim, LB , rev, rev_pair, k, H, p)
    println("name ", name)
    println("dim ", dim)
    println("rev ", typeof(rev), " size ", size(rev))
    println("revpair ", typeof(rev_pair), " size ", size(rev_pair))
    println("k ", k)
    println("H ", H)
    println("p ", typeof(p), " size ", size(p))
end