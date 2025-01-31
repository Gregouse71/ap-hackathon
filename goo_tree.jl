using LinearAlgebra: norm
using OrdinaryDiffEq

include("game.jl")

"""
    GooTree{N}
Représente un arbre de goo:
- *positions[4i:4i + 3]* est la position et la vitesse du i ème goo
- *aretes* est la matrice d'adjacence du graphe formé par les goos: aretes[i] est la liste des voisins du i eme goo avec la longueur à vide associée

"""
struct GooTree{N}
    positions::Vector{Float64}
    edges::Vector{Vector{Tuple{Int64, Float64}}}
end

k = 100  # J/m²

"""
    function step(du::Vector{Float64}, u::Vector{Float64}, p, t)

Calcul, dans du, la dérivée de positions.
"""
function step!(positions_derivee, positions::Vector{Float64}, params::Vector{Vector{Tuple{Int64, Float64}}}, t)
    for i in 0:length(positions)÷4 - 1
        positions_derivee[4i + 1:4i + 2] = positions[4i + 3:4i + 4]  # la vitesse est la dérivée de la position

        ΣF = [0., 0.]  # Accumulateur des forces
        for voisin in params[i + 1]  # Pour chaque voisin du point
            pos, l0 = voisin
            δpos = pos .- positions[4i + 1:4i + 2]  # Difference de position des points
            ΣF .+= k * (1 - l0/norm(δpos)) .* δpos  # Force du ressort: loi de Hooke
        end
        positions_derivee[4i + 3:4i + 4] = ΣF  # l'accélération est la dérivée de la vitesse
    end
end

"""
    function simulate_tree(init::GooTree, tspan)

Simule le *GooTree* init sur une durée tspan.
Renvoie la liste des positions successives et la liste des pas de temps correspondants.
"""
function simulate_tree(init::GooTree, tspan)
    u0 = init.positions
    p = init.edges
    prob = ODEProblem(step!, u0, tspan, p)
    sol = solve(prob)
    sol.u, sol.t
end