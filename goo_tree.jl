"""
    GooTree{N}
Représente un arbre de goo:
- *positions[2i:2i + 1]* est la position est la position du i ème goo
- *aretes* est la matrice d'adjacence du graphe formé par les goos, avec pour coefficients les longueurs à vide des ressorts

"""
struct GooTree{N}
    positions::Vector{Float64}
    aretes::Matrix{Float64}
end

