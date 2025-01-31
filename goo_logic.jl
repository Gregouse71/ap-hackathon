module GooLogic
using LinearAlgebra: norm, dot

include("goo_tree.jl")
include("game.jl")

max_link_goo = 1.0
max_link_attach = 0.5

"""
    function goo_distances(tree::GooTree, pos)

- pos sous la forme (x, y)

Renvoie la liste de distances jusqu'à chaque Goo à partir de la position pos.
"""
function goo_distances(tree::GooTree, pos)
    n = length(tree.positions) ÷ 4
    coord = reshape(tree.positions, (4, n))
    lengths = Float64[]
    for i in 1:n
        x, y = coord[1:2, i]
        push!(lengths, norm((x, y) .- pos))
    end
    lengths
end

"""
    function platform_distances(platforms::Scene, pos)

- pos sous la forme (x, y)

Renvoie la liste de distances jusqu'à chaque plateforme à partir de la position pos.  
Renvoie aussi la liste de positions les plus proches sur chaque plateforme sous la forme (x, y).
"""
function platform_distances(platforms::Game_Scene, pos)
    lengths = Float64[]
    positions = Tuple{Float64, Float64}[]
    for plat in platforms.objects
        ((x1, y1), (x2, y2)) = plat.ends
        vect1 = (x2 - x1, y2 - y1)
        vect2 = pos .- (x1, y1)
        vect3 = pos .- (x2, y2)
        prod = dot(vect1, vect2)
        factor = prod / (dot(vect1, vect1))
        col_vect = vect1 .* factor
        norm_vect = vect2 .- col_vect

        if factor > 1
            push!(lengths, norm(vect3))
            push!(positions, (x2, y2))
        elseif factor < 0
            push!(lengths, norm(vect2))
            push!(positions, (x1, y1))
        else
            push!(lengths, norm(norm_vect))
            push!(positions, (x1, y1) .+ col_vect)
        end
    end
    lengths, positions
end

"""
    function add_goo!(tree::GooTree, pos)
    
Rajoute un goo à la position donnée.  
Renvoie true si le rajout est possible et false sinon.
"""
function add_goo!(tree::GooTree, platforms::Game_Scene, pos)
    goo_added = false
    plat_added = false

    goo_dist = goo_distances(tree, pos)
    if minimum(goo_dist, init = Inf64) > max_link_goo
        goo_added = false
    else
        n = length(goo_dist) + 1
        append!(tree.positions, pos, 0, 0)
        push!(tree.edges, [])
        for (i, dist) in enumerate(goo_dist)
            if dist <= max_link_gooi
                push!(tree.edges[i], (n, goo_dist[i]))
                push!(tree.edges[n], (i, goo_dist[i]))
            end
        end
        goo_added = true
    end

    plat_dist, plat_pos = platform_distances(platforms, pos)
    if minimum(plat_dist, init = Inf64) > max_link_attach
        plat_added = false
    else
        if !goo_added
            append!(tree.positions, pos, 0, 0)
            push!(tree.edges, [])
        end
        n = length(goo_dist) + 1
        push!(tree.attach, [])
        for (i, dist) in enumerate(plat_dist)
            if dist <= max_link_attach
                push!(tree.attach[n], (plat_pos[i], plat_dist[i]))
            end
        end
        plat_added = true
    end
    if !plat_added && goo_added
        push!(tree.attach, [])
    end
    plat_added || goo_added
end

"""
    function remove_goo(tree::GooTree, index)

Enlève le goo à la position donnée
"""
function remove_goo(tree::GooTree, index)
    if index > length(tree.edges)
        return false
    end
    deleteat!(tree.positions, 4*index - 3 : 4*index)
    for neighbor in tree.edges[index]
        second, _ = neighbor
        popat!(tree.edges[second], findfirst(x -> x[1] == index, tree.edges[second]))
    end
    tree.edges[index] = []
    tree.attach[index] = []
    for (i, edges) in enumerate(tree.edges)
        for (j, edge) in enumerate(edges)
            (second, l) = edge
            if second > index
                tree.edges[i][j] = (second - 1, l)
            end
        end
    end
    for i in index:(length(tree.edges) - 1)
        tree.edges[i] = tree.edges[i + 1]
        tree.attach[i] = tree.attach[i + 1]
    end
    pop!(tree.edges)
    pop!(tree.attach)
    return true
end

#=
Voici un petit test:

plat = Game_Scene([Platform(((-1., -1.), (1., -1.)))], (-10.0, -5.0, 10.0, 5.0))
test = GooTree([], [], [])
add_goo!(test, plat, (0.55, -1.0))
add_goo!(test, plat, (0.50, -1.0))
=#
end