using Oceananigans

grid = RectilinearGrid(GPU(), size=(64, 16), extent=(10, 10), topology=(Bounded, Periodic, Flat))
model = NonhydrostaticModel(; grid)
simulation = Simulation(model, Δt=1, stop_time=10)
conjure_time_step_wizard!(simulation)
run!(simulation)
