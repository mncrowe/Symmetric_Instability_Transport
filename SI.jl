"""
Runs a 2D simulation of a front in the surface mixed layer.

The setup is chosen to be susceptible to symmetric instability
and the goal is to examine transport across the boundaries of SI
cells.

parameter ranges: (uʷ, M²) = (0, 1, 2, 5) x (0.7e-7, 2.1e-7, 6.3e-7)

Work by Matthew Crowe and Leif Thomas.

"""

# Import dependencies and load functions from "functions/":

using Oceananigans
include.(filter(contains(r".jl$"), readdir("functions"; join=true)))

# Set parameters:

architecture = GPU()				# GPU() or CPU()
Ly, Lz, Ny, Nz = 10000, 100, 1000, 200		# domain sizes (m) and number of gridpoints
f, M² = 1.4e-4, 6.3e-7				# Coriolis parameter (1/s), horizontal buoyancy gradient (1/s^2)
N² = 0.1*M²^2/f^2				# vertical buoyancy gradient in mixed layer (1/s^2)
uʷ, vʷ, Q = 5, 0, 0				# wind friction velocities (m/s), surface buoyancy flux (m^2/s^3)
Nt = 500					# number of time saves
T₀ = 2*π/f	 				# inertial timescape (s)
T = 20*T₀					# simulation stop time (s)
Δt = 1.0*(Ly/Ny)/max(Lz*M²/f, uʷ)		# initial timestep (s), vary coeffient for strong forcing, 0.4*
filename = "data/data"				# save name of data file
Tʳ, Tᶜ = 5*T₀, T₀/10				# release time and release duration for tracer (s)
C₀, Lᶜ = 1, 250					# total amount of tracer, width of initial tracer distribution (m)
closure_type = 1				# closure type, 1: AMD, 2: const visc/diff
checkpoint, pickup = false, false		# save final timestep as checkpoint, restart from checkpoint
CFL_on = false					# use CFL condition for timestep

# Define grid, BCs, background state, forcing and closure scheme:

grid = create_grid(architecture, Ly, Lz, Ny, Nz)	# create grid
boundary_conditions = create_BC(uʷ, vʷ, Q, N²)		# create boundary conditions
background_fields = create_background(M², f)		# create background fields
forcing = create_forcing(Lz, Ly, Tʳ, Tᶜ, C₀, Lᶜ)	# create forcing for dye release
closure = create_closure(closure_type)			# create closure scheme

# Create model:

model = NonhydrostaticModel(; grid,
		background_fields = background_fields,
			advection = Centered(order=4),
		      timestepper = :RungeKutta3,
			  closure = closure,
			 coriolis = FPlane(f=f),
			  tracers = (:b,:C),
			 buoyancy = BuoyancyTracer(),
			  forcing = forcing,
	      boundary_conditions = boundary_conditions)

# Set IC, build simulation, and apply CFL, progress updates and output:

set_IC!(model, M², N², f, Lz)				 		# set initial condition
simulation = Simulation(model, Δt=round(Δt, sigdigits=3), stop_time=T)	# create simulation
set_CFL!(simulation; CFL_on=CFL_on, max_Δt=10*Δt, cfl=1.0)		# set CFL condition
set_progress!(simulation; interval=IterationInterval(500))		# add callback with progress updates
set_output!(simulation, model, filename, T, Nt, checkpoint)		# define output and checkpointing

# Run simulation:

try run!(simulation, pickup=pickup) catch; println("\n:(") end		# catch errors to avoid messy stacktrace