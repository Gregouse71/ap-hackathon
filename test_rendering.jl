using GLMakie, CairoMakie
GLMakie.activate!()

scene = Scene(camera = campixel!)

count = Observable(1)

text!(scene, 100, 100, text=lift(t -> string(count[]), count))

on(events(scene).tick) do tick
    count[] = tick.count
    notify(count)
    println(tick.count)
    
    #=For a simulation you may want to use delta times for updates:
    position[] = position[] + tick.delta_time * velocity

    # For a solved system you may want to use the total time to compute the current state:
    position[] = trajectory(tick.time)

    # For a data record you may want to use count to move to the next data point(s)
    position[] = position_record[mod1(tick.count, end)]=#
end

#display(scene)
scene