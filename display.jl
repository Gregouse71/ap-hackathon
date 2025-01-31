import GLMakie: text!, lift, scatter!, linesegments!

"""
    createGameDisplay(scene::GLMakie.scene)
"""

function createGameDisplay(scene, pos_vel, attachs, edges, platforms, game_scene, screen_scene)
    current_positions = lift(extract_positions, pos_vel, game_scene, screen_scene)
    m2px = world_to_screen((1.0, 0.0), game_scene, screen_scene)[1]
    
    # platforms
    platfoms_lines = lift(extract_platforms, platforms, game_scene, screen_scene)
    linesegments!(scene, platfoms_lines, linewidth = 0.05*m2px, color = :black, linecap=:round)

    # attach
    attach_lines = lift(extract_attach, attachs, current_positions, game_scene, screen_scene)
    attach_widths = lift(extract_attach_widths, attachs, current_positions, game_scene, screen_scene)
    linesegments!(scene, attach_lines, linewidth = attach_widths, color = :orange, linecap=:round)

    # edges
    edges_lines = lift(extract_edges, edges, current_positions)
    edges_widths = lift(extract_edges_widths, edges, current_positions, game_scene, screen_scene)
    linesegments!(scene, edges_lines, linewidth = edges_widths, color = :yellow, linecap=:round)

    # Goos
    scatter!(scene, current_positions, markersize = 0.1*m2px, color = :black)
end

function extract_positions(pos_vel::Vector{Float64}, game_scene, screen_scene)
    return [world_to_screen((pos_vel[i], pos_vel[i+1]), game_scene, screen_scene) for i in 1:4:length(pos_vel)]
end

function extract_platforms(platforms, game_scene, screen_scene)
    out = Tuple{Float64, Float64}[]
    for plt in platforms
        push!(out, world_to_screen(plt.ends[1], game_scene, screen_scene))
        push!(out, world_to_screen(plt.ends[2], game_scene, screen_scene))
    end
    out
end

function extract_attach(attachs::Vector{Vector{Tuple{Tuple{Float64, Float64}, Float64}}}, positions::Vector{Tuple{Float64, Float64}}, game_scene, screen_scene)
    lines = Tuple{Float64, Float64}[]

    for (i, la) in enumerate(attachs)
        for a in la
            push!(lines, positions[i])
            push!(lines, world_to_screen(a[1], game_scene, screen_scene))
        end
    end
    
    lines
end

function extract_attach_widths(attachs::Vector{Vector{Tuple{Tuple{Float64, Float64}, Float64}}}, positions::Vector{Tuple{Float64, Float64}}, game_scene, screen_scene)
    widths = Float64[]
    m2px = world_to_screen((1.0, 0.0), game_scene, screen_scene)[1]

    for (i, la) in enumerate(attachs)
        for a in la
            push!(widths, get_edge_width(screen_to_world(positions[i], game_scene, screen_scene), a[1], a[2]) * m2px)
        end
    end
    
    widths
end

function extract_edges_widths(edges::Vector{Vector{Tuple{Int64, Float64}}}, positions::Vector{Tuple{Float64, Float64}}, game_scene, screen_scene)
    widths = Float64[]
    m2px = world_to_screen((1.0, 0.0), game_scene, screen_scene)[1]

    for (i, links) in enumerate(edges)
        for l in links
            p1 = screen_to_world(positions[i], game_scene, screen_scene)
            p2 = screen_to_world(positions[l[1]], game_scene, screen_scene)
            push!(widths, get_edge_width(p1, p2, l[2]) * m2px)
        end
    end
    
    widths
end

function extract_edges(edges::Vector{Vector{Tuple{Int64, Float64}}}, positions::Vector{Tuple{Float64, Float64}})
    out = Tuple{Float64, Float64}[]
    for (i, links) in enumerate(edges)
        for l in links
            push!(out, positions[i])
            push!(out, positions[l[1]])
        end
    end
    out
end

"""
    screen_to_world(pos::Tuple{Float64, Float64}, bounds::NTuple{4, Float64}, w::Float64, h::Float64)
conversion depuis les coordonnées à l'écran vers les coordonneés dans le monde
"""
function screen_to_world(pos, game_scene, screen_scene)
    w, h = size(screen_scene)
    scale = min(w / (game_scene.bounds[3] - game_scene.bounds[1]), h / (game_scene.bounds[4] - game_scene.bounds[2]))
    return (pos ./ scale) .+ (game_scene.bounds[1], game_scene.bounds[2])
end

"""
    world_to_screen(pos::Tuple{Float64, Float64}, bounds::NTuple{4, Float64}, w::Float64, h::Float64)
conversion depuis les coordonnées dans le monde vers les coordonnées à l'écran
"""
function world_to_screen(pos, game_scene, screen_scene)
    w, h = size(screen_scene)
    scale = min(w / (game_scene.bounds[3] - game_scene.bounds[1]), h / (game_scene.bounds[4] - game_scene.bounds[2]))
    return (pos .- (game_scene.bounds[1], game_scene.bounds[2])) .* scale
end


"""
    get_edge_width(p1::Tuple{Float64, Float64}, p2::Tuple{Float64, Float64}, l0::Float64)

get the width of the link of length l0, pulled between the positions p1 and p2
"""
function get_edge_width(p1::Tuple{Float64, Float64}, p2::Tuple{Float64, Float64}, l0::Float64)
    l = length(p1, p2)
    compression = exp((l0 - l) * 0.5)
    return (compression * 0.02 + 0.02);
end

function Base.length(p1::Tuple{Float64, Float64}, p2::Tuple{Float64, Float64})
    return sum((x -> x*x).(p1 .- p2)) ^ 0.5
end