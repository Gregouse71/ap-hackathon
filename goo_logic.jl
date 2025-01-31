using LinearAlgebra: norm

include("goo_tree.jl")

"""
    function goo_distances(tree::GooTree, pos)

- pos sous la forme (x, y)

Renvoie la liste de distances jusqu'à chaque Goo à partir de la position pos.
"""
function goo_distances(tree::GooTree, pos)
    n = length(tree.positions) ÷ 2
    coord = reshape(tree.positions, (2, n))
    lengths = Float64[]
    for i in 1:n
        x, y = coord[:, i]
        push!(lengths, norm((x, y) .- pos))
    end
    lengths
end

"""
    function add_goo!(tree::GooTree, pos)
    
Rajoute un goo à la position donnée.  
Renvoie true si le rajout est possible et false sinon.
"""
function add_goo!(tree::GooTree, pos)
    goo_dist = goo_distances(tree, pos)
    if minimum(goo_dist) > 0.2
        return false
    else
        n = length(goo_dist) + 1
        append!(tree.positions, pos)
        push!(tree.edges, [])
        for (i, dist) in enumerate(goo_dist)
            if dist <= 0.2
                push!(tree.edges[i], (n, goo_dist[i]))
                push!(tree.edges[n], (i, goo_dist[i]))
            end
        end
        return true
    end
end