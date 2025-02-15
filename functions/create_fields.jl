"""
Contains functions to create the save fields for SI simulations.

"""

using Oceanostics: ErtelPotentialVorticity, KineticEnergyDissipationRate, ZShearProductionRate, TurbulentKineticEnergy

"""
create_fields(model)

creates the save fields for the SI problem.
"""
function create_fields(model)

	# Define EPV and average diagnostics:

	u	= model.velocities.u
	v	= model.velocities.v
	w	= model.velocities.w
	b	= model.tracers.b
	C	= model.tracers.C
	ν	= model.diffusivity_fields.νₑ

	EPV     = ErtelPotentialVorticity(model)
	PV_flux = Average(EPV * w, dims=(1, 2))
	q_ave   = Average(EPV, dims=(1, 2))
	b_ave   = Average(b, dims=(1, 2))
	C_ave   = Integral(C, dims=(1, 3))
	C_tot   = Integral(C)

	# Define energetics diagnostics, d/dt[TKE] = -(GSP + AGSP_x + AGSP_y) + BP - Diss, where:

	U, V, B	= Field(Average(u, dims=(1, 2))), Field(Average(v, dims=(1, 2))), Field(Average(b, dims=(1, 2)))
	TKE 	= Average(TurbulentKineticEnergy(model; U, V))
	GSP 	= Average(M²/f * (u - U) * w)
	BP 	= Average((b - B) * w)
	AGSP_x 	= Average(ZShearProductionRate(model; U, V=0))
	AGSP_y 	= Average(ZShearProductionRate(model; U=0, V))
	Diss 	= Average(KineticEnergyDissipationRate(model; U, V))

	# Create NETCDF output files:

	fields = Dict("u" => u, 
        	      "b" => b, 
        	      "v" => v,
        	      "w" => w,
		      "C" => C,
		     "nu" => ν,
		    "GSP" => GSP,
		 "AGSP_x" => AGSP_x,
		 "AGSP_y" => AGSP_y,
		     "BP" => BP,
		   "Diss" => Diss,
		    "TKE" => TKE,
        	    "EPV" => EPV,
        	"PV_flux" => PV_flux,
        	  "q_ave" => q_ave,
        	  "b_ave" => b_ave,
		  "C_ave" => C_ave,
		  "C_tot" => C_tot);

	return fields
end