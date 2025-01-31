import GLMakie: activate!, Scene, campixel!, events, Events, Observable, on
include("display.jl")

include("test_sim.jl")

function main()
    positions = Observable(sol(0))

    # activates a interactive window and creates a scene (= Figure())
    activate!()
    scene = Scene(camera = campixel!)

    # renders interactively the whole game
    createGameDisplay(scene, positions)

    on(events(scene).tick) do tick
        # update function
        positions[] = sol(min(tick.time, 3))
        notify(positions)
    end

    scene
end
