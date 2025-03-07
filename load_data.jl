using NetCDF

u = ncread("data/data.nc", "u")[1, :, :, :]
v = ncread("data/data.nc", "v")[1, :, :, :]
w = ncread("data/data.nc", "w")[1, :, :, :]
b = ncread("data/data.nc", "b")[1, :, :, :]

