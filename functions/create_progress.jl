"""
Contains functions to display the progress for SI simulations.

"""

using Printf

"""
set_progress!()

adds a callback with progress updates to the SI problem.
"""
function set_progress!(simulation; interval=IterationInterval(500))

	progress_message(sim) = @printf("Iteration: %03d, time: %s, Δt: %s, max(|v|) = %.1e ms⁻¹, wall time: %s\n",
		iteration(sim),
		prettytime(sim),
		prettytime(sim.Δt),
		maximum(abs, sim.model.velocities.v),
		prettytime(sim.run_wall_time))

	add_callback!(simulation, progress_message, interval)

	return nothing
end