"""
Contains functions to create the initial conditions for SI simulations.

"""

using Random

"""
create_IC(M², N², f, Lz)

creates a thermal wind IC for the SI problem.
"""
function create_IC(M², N², f, Lz)

	Random.seed!(1234)
	v₀(y,z) = 1e-3 * M²/f * Lz * randn()
	b₀(y,z) = N²*(z + Lz)

	return v₀, b₀
end

"""
set_IC!(model, M², N², f, Lz)

sets IC for the given model using `create_IC`.
"""
function set_IC!(model, M², N², f, Lz)

	v₀, b₀ = create_IC(M², N², f, Lz)	# define initial conditions
	set!(model, v=v₀, b=b₀)			# set initial conditions

	return nothing
end

			
					


