"""
Contains functions to create the CFL condition for SI simulations.

"""

"""
set_CFL!(simulation, CFL_on, max_Δt; cfl=1.0)

applies a CFL condition to the given simulation.
"""
function set_CFL!(simulation; CFL_on=false, max_Δt=10*Δt, cfl=1.0, schedule=IterationInterval(10))

	if CFL_on
		conjure_time_step_wizard!(simulation, schedule; cfl=cfl, max_Δt=max_Δt)
	end

	return nothing
end
