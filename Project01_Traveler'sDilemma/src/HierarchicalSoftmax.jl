include("./SimpleGame.jl")
include("./ResponseModels.jl")

struct HierarchicalSoftmax
    λ # precision parameter
    k # level
    π # initial policy
end
function HierarchicalSoftmax(𝒫::SimpleGame, λ, k) 
    π = [SimpleGamePolicy(ai => 1.0 for ai in 𝒜i) for 𝒜i in 𝒫.𝒜]
    return HierarchicalSoftmax(λ, k, π)
end
function solve(M::HierarchicalSoftmax, 𝒫, plot = false)
    π = M.π
    for k in 1:M.k 
        π = [softmax_response(𝒫, π, i, M.λ) for i in 𝒫.ℐ]
        if plot
            c = bar(collect(keys(π[1].p)),collect(values(π[1].p)), orientation = :vertical, legend = false )
            xlabel!("Actions")
            ylabel!("Probability")
            title!("Level $(M.k), precision $(M.λ)")
            display(c)
        end
    end
    return π
end