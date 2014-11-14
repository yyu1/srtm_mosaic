;Generate array of file names for SRTM tiles

Function generate_names, long_min, long_max, lat_min, lat_max

	;check longitude and latitude are not out of bounds
	if ((long_min lt -180) or (long_max gt 180) or (lat_min lt -90) or (lat_max gt 90)) then begin
		print, 'Error! Max/Min values for lat lon are out of bounds', long_min, long_max, lat_min, lat_max
	endif

	if((long_min gt long_max) or (lat_min gt lat_max)) then begin
		print, 'Error! Min values greater than max', long_min, long_max, lat_min, lat_max
	endif

	;create matrix for holding file names
	nx = fix(long_max-long_min+1)
	ny = fix(lat_max-lat_min+1)
	name_matrix = strarr(nx,ny)

	for j=0ULL, ny-1 do begin
		cur_lat = fix(lat_max - j)
		if (cur_lat ge 0) then lat_letter = 'N' else lat_letter = 'S'
		for i=0ULL, nx-1 do begin
			cur_lon = fix(long_min + i)
			if (cur_lon ge 0) then lon_letter = 'E' else lon_letter = 'W'
			cur_name = lat_letter + string(cur_lat,format='(i02)') + lon_letter + string(cur_lon,format='(i03)')
			name_matrix[i,j] = cur_name
		endfor
	endfor

	return, name_matrix

End
