import GLMakie: text!, lift, scatter!, linesegments!

"""
    createGameDisplay(scene::GLMakie.scene)
"""

# constante de conversion : 1 m = 100 px
m2px = 100


function createGameDisplay(scene, pos_vel, attachs, edges)
    current_positions = lift(extract_positions, pos_vel)
    
    # attach
    attach_lines = lift(extract_attach, attachs, current_positions)
    linesegments!(scene, attach_lines)

    # edges
    attach_edges = lift(extract_edges, edges, current_positions)
    linesegments!(scene, attach_edges)

    # Goos
    scatter!(scene, current_positions, color = :black)

end

function extract_positions(pos_vel::Vector{Float64})
    return [((pos_vel[i] + 4.) * m2px, (pos_vel[i+1] + 4.) * m2px) for i in 1:4:length(pos_vel)]
end

function extract_attach(attachs::Vector{Vector{Tuple{Tuple{Float64, Float64}, Float64}}}, positions::Vector{Tuple{Float64, Float64}})
    out = Tuple{Float64, Float64}[]
    for (i, la) in enumerate(attachs)
        for a in la
            push!(out, positions[i])
            push!(out, (a[1] .+ (1., 2.)) .* m2px)
        end
    end
    out
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

#=function to_screen_space(pos, bounds)
    window_size = GLMakie.GLFW.GetWindowSize(glw)

end=#