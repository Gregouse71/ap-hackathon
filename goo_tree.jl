"""
    GooTree{N}
Représente un arbre de goo:
- *positions[2i:2i + 1]* est la position est la position du i ème goo
- *aretes* est la matrice d'adjacence du graphe formé par les goos: aretes[i] est la liste des voisins du i eme goo avec la longueur à vide associée

"""
struct GooTree{N}
    positions::Vector{Float64}
    edges::Vector{Vector{Tuple{Int, Float64}}}
end

