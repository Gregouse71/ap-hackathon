include("goo_tree.jl")

tree = GooTree([-1., 0., 0., 0., 1., 0., 0., 0.], [[(2, 1)], [(1, 1)]], [[([-1., -1.], 1.)], [([1., -1.], 1.)]])

sol = simulate_tree(tree, (0., 3.))
println(sol.u)
