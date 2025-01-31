import GLMakie: activate!, Scene, campixel!, events, Events, Observable, on
include("display.jl")
include("goo_tree.jl")

function main()
    tree = GooTree([-1., 2., 0., 0., 1., 0., 0., 0.], [[(2, 2.)], [(1, 2.)]], [[((-1., -1.), 1.)], [((1., -1.), 1.)]])
    tree1 = GooTree([-1., 0., 0., 0.], [[]], [[]])
    sol = simulate_tree(tree, (0., 100.))
    
    positions = Observable(tree.positions)
    attachs = Observable(tree.attach)
    edges = Observable(tree.edges)

    println(tree.attach)

    # activates a interactive window and creates a scene (= Figure())
    activate!()
    scene = Scene(camera = campixel!)

    # renders interactively the whole game
    createGameDisplay(scene, positions, attachs, edges)

    on(events(scene).tick) do tick
        # update function
        positions[] = sol(tick.time % 100)
        notify(positions)
    end

    #=on(events(scene).mousebutton) do event
        if event.button == Mouse.left && event.action == Mouse.press
            mp = events(scene).mouseposition[]
    
            add_goo!(tree, platforms, mp)
        end
    end=#

    scene
end
