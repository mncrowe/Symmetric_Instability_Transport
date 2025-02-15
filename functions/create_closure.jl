"""
Contains functions to define the closure scheme for SI simulations.

"""

using Oceananigans.TurbulenceClosures

"""
create_closure(type)

creates a closure scheme for the SI problem.
"""
function create_closure(type; νₕ=0.05, κₕ=νₕ, νᵥ=1e-3, κᵥ=νᵥ)

	if (closure_type == 1)
		closure = AnisotropicMinimumDissipation()
	else
		closure = (HorizontalScalarDiffusivity(ν=νₕ, κ=κₕ), VerticalScalarDiffusivity(ν=νᵥ, κ=νᵥ))
	end

	return closure
end