import GLMakie: activate!, Scene, campixel!, events, Events, Observable, on
include("display.jl")
include("goo_tree.jl")

function main()
    tree = GooTree([-1., 2., 0., 0., 1., 0., 0., 0.], [[(2, 2.)], [(1, 2.)]], [[], []])
    tree1 = GooTree([-1., 0., 0., 0.], [[]], [[]])
    sol = simulate_tree(tree, (0., 10.))
    
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
        positions[] = sol(tick.time % 10)
        notify(positions)
    end

    scene
end
