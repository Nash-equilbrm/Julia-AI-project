include("./Travelers.jl")
include("./NashEquilibrium.jl")
include("./HierarchicalSoftmax.jl")
include("./IteratedBestResponse.jl")


using LinearAlgebra
using GridInterpolations
using Plots


traveler = Travelers()
simpleGame = SimpleGame(traveler)


# Iterated Best Response
k_max = 100
println("Iterated Best Response...")
IBR = IteratedBestResponse(simpleGame, k_max)
π_IBR = solve(IBR, simpleGame, true)
println("Done!")


# Hierarchical Softmax
k = 100
λ = 0.5
println("Hierarchical Softmax...")
HS = HierarchicalSoftmax(simpleGame,λ,k)
π_HS = solve(HS, simpleGame)
c = bar(collect(keys(π_HS[1].p)),collect(values(π_HS[1].p)), orientation = :vertical, legend = false )
xlabel!("Actions")
ylabel!("Probability")
title!("Level k = $(k), precision λ = $(λ)")
display(c)
print("Done!")