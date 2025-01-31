module Game
# Contient les types relatifs à la l'implémentation de la scène de jeux

"""
    struct Platfrom

Représente une platforme sous forme d'un segment
"""
struct Platform
    ends::Tuple{Tuple{Float64, Float64}, Tuple{Float64, Float64}}
end

"""
    struct Scene

L'ensemble des objets de la scène de jeux
"""
struct Game_Scene
    goal::Vector{Platform}
    objects::Vector{Platform}
    bounds::NTuple{4, Float64}
end
end