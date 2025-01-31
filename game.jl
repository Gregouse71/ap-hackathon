# Contient les types relatifs à la l'implémentation de la scène de jeux

"""
    struct Platfrom

Représente une platforme sous forme d'un segment
"""
struct Platform
    ends::Tuple{Tuple{Float64, Float64}, Tuple{Float64, Float64}}
end

struct Game_Scene
    objects::Vector{Platform}
end