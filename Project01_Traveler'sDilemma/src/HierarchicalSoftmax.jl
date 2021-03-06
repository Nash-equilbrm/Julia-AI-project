include("./SimpleGame.jl")
include("./ResponseModels.jl")

struct HierarchicalSoftmax
    位 # precision parameter
    k # level
    蟺 # initial policy
end
function HierarchicalSoftmax(饾挮::SimpleGame, 位, k) 
    蟺 = [SimpleGamePolicy(ai => 1.0 for ai in 饾挏i) for 饾挏i in 饾挮.饾挏]
    return HierarchicalSoftmax(位, k, 蟺)
end
function solve(M::HierarchicalSoftmax, 饾挮, plot = false)
    蟺 = M.蟺
    for k in 1:M.k 
        蟺 = [softmax_response(饾挮, 蟺, i, M.位) for i in 饾挮.鈩怾
        if plot
            c = bar(collect(keys(蟺[1].p)),collect(values(蟺[1].p)), orientation = :vertical, legend = false )
            xlabel!("Actions")
            ylabel!("Probability")
            title!("Level $(M.k), precision $(M.位)")
            display(c)
        end
    end
    return 蟺
end