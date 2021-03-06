include("./SimpleGame.jl")
include("./SetCategorical.jl")
using LinearAlgebra
using GridInterpolations
using Random

struct SimpleGamePolicy
    p # dictionary mapping actions to probabilities
    function SimpleGamePolicy(p::Base.Generator)
        return SimpleGamePolicy(Dict(p))
    end

    function SimpleGamePolicy(p::Dict)
        vs = collect(values(p))
        vs ./= sum(vs)
        return new(Dict(k => v for (k,v) in zip(keys(p), vs)))
    end 
    
    SimpleGamePolicy(ai) = new(Dict(ai => 1.0))
end
    
(πi::SimpleGamePolicy)(ai) = get(πi.p, ai, 0.0)

function (πi::SimpleGamePolicy)()
    D = SetCategorical(collect(keys(πi.p)), collect(values(πi.p)))
    return rand(D)
end

# joint(X) = vec(collect(product(X...)))
joint(X) = vec(collect(Iterators.product(X...)))
    
joint(π, πi, i) = [i == j ? πi : πj for (j, πj) in enumerate(π)]
    
function utility(𝒫::SimpleGame, π, i)
    𝒜, R = 𝒫.𝒜, 𝒫.R
    p(a) = prod(πj(aj) for (πj, aj) in zip(π, a))
    return sum(R(a)[i]*p(a) for a in joint(𝒜))
end