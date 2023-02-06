using Parameters


struct Instance
    G::Int32
    T::Int32
    S::Int32
    shared_interests::Array{Int32,2}
    partner::Array{Int32,1}
    gender::Array{Int32,1}
    relation::Array{Bool,2}
end

function readInstance(filename)
    f = open(filename)
    readline(f)#header line comment

    #read instance size data
    data = split(readline(f))
    G = parse(Int32,data[1]) # no. guests
    T = parse(Int32,data[2]) # no. tables
    S = parse(Int32,data[3]) # no. sits per table

    #read common interests data
    readline(f);readline(f) #empty line + header
    shared_interests = zeros(Int32,G,G)
    for g1 in 1:G
        data = parse.(Int32,split(readline(f)))
        for g2 in 1:G
            shared_interests[g1,g2] = data[g2]
        end
    end

    #read guests' data
    readline(f);readline(f) #empty line + header
    partner = zeros(Int32,G)
    gender = zeros(Int32,G)
    relation = zeros(Bool,G,G)

    for g in 1:G
        data = split(readline(f))#read guest data
        partner[g] = parse(Int32,data[1])#read partner
        gender[g]=data[2]=="M" ? 0 : 1 #read gender Male 0, Female 1
        #TODO: read the list of guest that guest g knows.
        for gg in parse.(Int32,data[3:end])
            relation[g,gg] = true
        end
    end
    close(f)

    return Instance(G, T, S, shared_interests, partner, gender, relation)

end

inst = readInstance("EX02-WeddingPlaner-files/WeddingData_100_10_50_40.dat")
tables = zeros(Int, inst.T, inst.S)
partners = inst.partner

function main()
    currentTable = 0
    for i in eachindex(partners)
        currentTable = mod(currentTable, inst.T)+1
        if (partners[i] != 0)
            seatGuest(partners[i],currentTable)
            seatGuest(partners[partners[i]],currentTable)
            currentTable = currentTable + 1
            partners[partners[i]] = 0
            partners[i] = 0
        end
    end
    println(partners)
    println(string("\n", tables))
end

function seatGuest(G, T)
    for i in 1:inst.S
        if (tables[T,i] == 0) 
            tables[T,i] = G
            break
        end
    end
end

main()