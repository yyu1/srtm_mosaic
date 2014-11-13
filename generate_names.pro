;Generate array of file names for SRTM tiles

Function generate_names, long_min, long_max, lat_min, lat_max, suffix

	;check longitude and latitude are not out of bounds
	if ((long_min lt -180) or (long_max gt 180) or (lat_min lt -90) or (lat_max gt 90)) then begin
		print, 


End
