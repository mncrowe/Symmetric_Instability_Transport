"""
Contains functions to create the tracer forcing for SI simulations.

"""

"""
create_forcingd()

creates a forcing function for the tracer field. A Gaussian distribution
of tracer is released in the the center of the y domain at the specified
time. This distribution is depth independent initially.
"""
function create_forcing(Lz, Ly, Tʳ, Tᶜ, C₀, Lᶜ)

	C_params = (H=Lz, Ly=Ly, Tʳ=Tʳ, Tᶜ=Tᶜ, Lᶜ=Lᶜ, C₀=C₀)
	dye_forcing(y,z,t,C,p) = p.C₀/(p.Lᶜ*p.Tᶜ*p.H*2*π)*exp(-(t-p.Tʳ)^2/p.Tᶜ^2/2)*exp(-(y-p.Ly/2)^2/p.Lᶜ^2/2)
	dye_dynamics = Forcing(dye_forcing, field_dependencies = :C, parameters=C_params)

	return (; C=dye_dynamics)
end