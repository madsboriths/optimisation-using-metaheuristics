include("TABU.jl")
function main()
    A, B = getRandomEdgePair(9)
    println(A, " ",B)
end

main()