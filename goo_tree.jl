import LinearAlgebra: norm
import OrdinaryDiffEq: solve, ODEProblem

include("game.jl")

"""
    GooTree
Représente un arbre de goo:
- *positions[4i:4i + 3]* est la position et la vitesse du i ème goo
- *aretes* est la matrice d'adjacence du graphe formé par les goos: aretes[i] est la liste des voisins du i eme goo avec la longueur à vide associée
- *attach* est la liste des points d'attache des goo: attach[i] est la liste des points auquel le i eme goo est attaché associés au longueur à vide
"""
struct GooTree
    positions::Vector{Float64}  # Position des goo dans l'espace des phases (q_ix, q_iy, p_ix, p_iy)
    edges::Vector{Vector{Tuple{Int64, Float64}}}
    attach::Vector{Vector{Tuple{Tuple{Float64, Float64}, Float64}}}
end

k = 100  # J/m²
m = 0.4

"""
    function step(du::Vector{Float64}, u::Vector{Float64}, p, t)

Calcul, dans du, la dérivée de positions.
"""
function step!(positions_derivee, positions::Vector{Float64}, params , t)
    adjacence, attach = params
    for i in 1:length(positions)÷4
        positions_derivee[4i - 3:4i - 2] = positions[4i - 1:4i]  # la vitesse est la dérivée de la position

        ΣF = [0., -80.]  # Accumulateur des forces
        for voisin in adjacence[i]  # Pour chaque voisin du point
            pos, l0 = voisin
            δpos = pos .- positions[4i - 3:4i - 2]  # Difference de position des points
            ΣF .+= k * (1 - l0/norm(δpos)) .* δpos  # Force du ressort: loi de Hooke
        end
        for attaché in attach[i]
            att, l0 = attaché
            δpos = att .- positions[4i - 3:4i - 2]  # Difference de position des points
            ΣF .+= k * (1 - l0/norm(δpos)) .* δpos  # Force du ressort: loi de Hooke
        end
        positions_derivee[4i - 1:4i] = ΣF / m  # l'accélération est la dérivée de la vitesse
    end
end

"""
    function simulate_tree(init::GooTree, tspan)

Simule le *GooTree* init sur une durée tspan.
Renvoie la liste des positions successives et la liste des pas de temps correspondants.
"""
function simulate_tree(init::GooTree, tspan)
    u0 = init.positions
    p = init.edges, init.attach
    prob = ODEProblem(step!, u0, tspan, p)
    return solve(prob)
end