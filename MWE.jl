using Oceananigans

grid = RectilinearGrid(GPU(), size=(100, 100), extent=(10, 10), topology=(Periodic, Periodic, Flat))
model = NonhydrostaticModel(; grid)
simulation = Simulation(model, Δt=1, stop_time=10)
conjure_time_step_wizard!(simulation)
run!(simulation)
