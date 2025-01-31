import GLMakie: activate!, Scene, campixel!, events, Events, Observable, on, Mouse
include("display.jl")
include("goo_tree.jl")
include("game.jl")
include("goo_logic.jl")

function main()
    sim_continue = 1  # temps de simulation d'une traite
    last_time = 0#Observable(0.)  # Temps auquel on a calculé la scene pour la solution pour la derniere foi
    last_tick_time = 0#Observable(0.)

    tree = GooTree([-1., 2., 0., 0., 1., 0., 0., 0.], [[(2, 2.)], [(1, 2.)]], [[((-1., -1.), 1.)], [((1., -1.), 1.)]])
    tree1 = GooTree([-1., 0., 0., 0.], [[]], [[]])

    sol = simulate_tree(tree, (0., sim_continue))#sol = Observable(simulate_tree(tree, (0., sim_continue)))
    game_scene = Game_Scene([Platform(((-1., -1.), (1., -1.)))], (-10.0, -5.0, 10.0, 5.0))
    
    positions = Observable(tree.positions)
    attachs = Observable(tree.attach)
    edges = Observable(tree.edges)
    platforms = Observable(game_scene.objects)

    # activates a interactive window and creates a scene (= Figure())
    activate!()
    scene = Scene(camera = campixel!)

    # renders interactively the whole game
    createGameDisplay(scene, positions, attachs, edges, platforms, game_scene, scene)

    on(events(scene).tick) do tick
        # update function
        if tick.time - last_time >= sim_continue  # Si on a dépassé la derniere simulation
            last_time = tick.time
            last_tree = GooTree(sol.u[end], tree.edges, tree.attach)
            sol = simulate_tree(last_tree, (tick.time, tick.time + sim_continue))
        end
        last_tick_time = tick.time
        positions[] = sol(tick.time)
        notify(positions)
    end

    on(events(scene).mousebutton) do event
        if event.button == Mouse.left && event.action == Mouse.press
            mp = events(scene).mouseposition[]
            
            tree = GooTree(sol(last_tick_time), tree.edges, tree.attach)
            add_goo!(tree, game_scene, screen_to_world(mp, game_scene, scene))
            sol = simulate_tree(tree, (last_tick_time, last_tick_time + sim_continue))
            last_time = last_tick_time
            #=attachs[] = tree.attach
            edges[] = tree.edges=#
        end
    end

    scene
end
