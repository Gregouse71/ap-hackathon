# Contient les types relatifs à la l'implémentation de la scène de jeux

module Game

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
    objects::Vector{Platform}
    bounds::NTuple{4, Float64}
end

s = Game_Scene([Platform(((-1., -1.), (1., -1.)))], (-10.0, -5.0, 10.0, 5.0))

end