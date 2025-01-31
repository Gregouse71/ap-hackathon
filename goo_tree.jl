using LinearAlgebra: norm
using DifferentialEquations: ODEProblem, solve, TSit5

"""
    GooTree
Représente un arbre de goo:
- *positions[4i:4i + 3]* est la position et la vitesse du i ème goo
- *aretes* est la matrice d'adjacence du graphe formé par les goos: aretes[i] est la liste des voisins du i eme goo avec la longueur à vide associée

"""
struct GooTree
    positions::Vector{Float64}
    edges::Vector{Vector{Tuple{Int, Float64}}}
end

k = 100  # J/m²

"""
    function step(du::Vector{Float64}, u::Vector{Float64}, p::Vector{Vector{Tuple{Int, Float64}}}, t)

Calcul, dans du, la dérivée de positions
"""
function step!(positions_derivee, positions, params, t)
    for i in 1::length(positions)÷4
        positions_derivee[4i:4i + 1] = positions[4i + 2:4i + 3]  # la vitesse est la dérivée de la position

        ΣF = [0., 0.]  # Accumulateur des forces
        for voisin in params[i]  # Pour chaque voisin du point
            pos, l0 = voisin
            δpos = pos .- positions[4i:4i + 1]  # Difference de position des points
            ΣF .+= k * (1 - l0/norm(δpos)) .* δpos  # Force du ressort: loi de Hooke
        end
        positions_derivee[4i + 2:4i + 3] = ΣF  # l'accélération est la dérivée de la vitesse
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