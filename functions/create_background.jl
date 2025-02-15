"""
Contains functions to create the background fields for SI simulations.

"""

"""
create_background(M², f)

creates a background state for the SI problem.
"""
function create_background(M², f)

	parameters = (M²=M², f=f)
	U_b(y,z,t,p) = p.M²/p.f*z
	B_b(y,z,t,p) = - p.M²*y
	
	return (u=BackgroundField(U_b,parameters), b=BackgroundField(B_b,parameters))
end