include("goo_tree.jl")

tree = GooTree{2}(Float64[2, 2, 0, 0, 1, 2, 0, 0], [[(2, 1)], [(1, 1)]])

sol = simulate_tree(tree, (0., 3.))
println(sol.u)
