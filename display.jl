import GLMakie: text!, lift, scatter!

"""
    createGameDisplay(scene::GLMakie.scene)
"""

# constante de conversion : 1 m = 100 px
m2px = 100


function createGameDisplay(scene, pos_vel)
    #text!(scene, 100, 100, text=lift(t -> string(count[]), count))
    current_positions = lift(extract_positions, pos_vel)
    scatter!(scene, current_positions, color = :black)
end

function extract_positions(pos_vel::Vector{Float64})
    return [((pos_vel[i] + 1.) * m2px, (pos_vel[i+1] + 2.) * m2px) for i in 1:4:length(pos_vel)]
end

#=function to_screen_space(pos, bounds)
    window_size = GLMakie.GLFW.GetWindowSize(glw)

end=#