"""
Contains functions to create the grid for SI simulations.

"""

"""
create_grid(architecture, Ly, Lz, Ny, Nz)

creates a 2D grid structure for the SI problem.
"""
function create_grid(architecture, Ly, Lz, Ny, Nz)
	return RectilinearGrid(architecture,
				size=(Ny, Nz),
				extent=(Ly, Lz),
				topology=(Flat, Periodic, Bounded))
end