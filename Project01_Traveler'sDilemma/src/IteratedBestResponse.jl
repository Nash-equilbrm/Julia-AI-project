include("./ResponseModels.jl")

struct IteratedBestResponse
    k_max # number of iterations
    π # initial policy
end
function IteratedBestResponse(𝒫::SimpleGame, k_max) 
    π = [SimpleGamePolicy(ai => 1.0 for ai in 𝒜i) for 𝒜i in 𝒫.𝒜]
    return IteratedBestResponse(k_max, π)
end
function solve(M::IteratedBestResponse, 𝒫, plot = false) 
    agent_best_responses =[]
    π = M.π
    for k in 1:length(π)
        append!(agent_best_responses,[[]])
    end 
    for k in 1:M.k_max
        π = [best_response(𝒫, π, i) for i in 𝒫.ℐ]
        for j = 1:length(agent_best_responses)
            append!(agent_best_responses[j], collect(keys(π[j].p))[1]) # agent 1
        end
    end
    if plot
        for i=1:length(agent_best_responses)
            c = bar(collect(1:k_max),agent_best_responses[i], orientation = :vertical, legend = false)
            xlabel!("Iteration")
            ylabel!("Best action")
            title!("agent $i best response")
            display(c)
        end
    end
    return π
end