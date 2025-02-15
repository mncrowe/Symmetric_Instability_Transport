"""
Contains functions to create the boundary conditions for SI simulations.

"""

"""
create_BC(uʷ, vʷ, Q, N²)

creates top and bottom boundary conditions for the SI problem. Here:

Cᴰ: dimensionless drag coefficient
ρₒ: water density (kg/m^3)
ρₐ: air density (kg/m^3)
"""
function create_BC(uʷ, vʷ, Q, N²; ρₐ=1.225, ρₒ=1026.0, Cᴰ=2.5e-3,)

	b_bc = FieldBoundaryConditions(top = FluxBoundaryCondition(Q),
				    bottom = GradientBoundaryCondition(N²))
	u_bc = FieldBoundaryConditions(top = FluxBoundaryCondition(-ρₐ/ρₒ*Cᴰ*uʷ*√(uʷ^2+vʷ^2)))
	v_bc = FieldBoundaryConditions(top = FluxBoundaryCondition(-ρₐ/ρₒ*Cᴰ*vʷ*√(uʷ^2+vʷ^2)))

	return (u=u_bc, v=v_bc, b=b_bc)
end


