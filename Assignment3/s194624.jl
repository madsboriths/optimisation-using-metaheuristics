### s194624.jl
using Random

include("CloudCompReader.jl")


struct ArgumentException <: Exception
    message::String
end

function main()
    n_jobs, n_processors, UB, duration, processor = read_instance("CloudComp_instances/tai4_4_1.txt")

    println("Jobs: ", n_jobs)
    println("Processors: " , n_processors)
    println(duration)
    println(processor)

    s, occupiedRanges = init(n_jobs, n_processors, UB, duration, processor)

end

main()