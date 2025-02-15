"""
Contains functions to create the output for SI simulations.

"""

"""
set_output!()

defines output for the SI problem.
"""
function set_output!(simulation, model, filename, T, Nt, checkpoint)

	fields = create_fields(model)

	simulation.output_writers[:field_writer] = NetCDFOutputWriter(model, fields, 
						filename = filename * ".nc", 
						schedule = TimeInterval(T/Nt),
						overwrite_existing = true)

	if checkpoint
		simulation.output_writers[:checkpointer] = Checkpointer(model,
						schedule=TimeInterval(T),
						prefix="SI_checkpoint")
	end

	return nothing
end