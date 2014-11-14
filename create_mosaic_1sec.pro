;Create mosaic image from 1arcsec SRTM tiles
;SRTM tiles has an extra row/column that overlaps with the next tile


PRO create_mosaic_1sec, min_lon, max_lon, min_lat, max_lat, data_type, in_dir, out_file

	;Check if output file name already exist
	if (file_test(out_file)) then begin
		print, 'Error: Output file already exist!', out_file
		exit
	endif

	;Check input directory
	if (~file_test(in_dir,/directory)) then begin
		print, 'Error: Input directory does not exist or is not a directory', in_dir
	endif

	;Get array of input files
	name_matrix = generate_names(min_lon,max_lon,min_lat,max_lat)

	matrix_inf = size(name_matrix)
	tiles_x = matrix_inf[1]
	tiles_y = matrix_inf[2]

	if(data_type eq 1) then begin
		;byte
		in_tile_row = bytarr(3601,3601,tiles_x)
		tmp_image = bytarr(3601,3601)
	endif

	if (data_type eq 2) then begin
		;integer
		in_tile_row = intarr(3601,3601,tiles_x)
		tmp_image = intarr(3601,3601)
	endif

	openw, out_lun, out_file, /get_lun

	for j=0, tiles_y-1 do begin
		print, 'row ', j+1, ' of ', tiles_y
		in_lun_row[*] = 0
		;open current row of files
		for i=0, tiles_x-1 do begin
			if (data_type eq 1) then begin
				name_zip=name_matrix[i,j]+'.SRTMSWBD.raw.zip'
				tmp_name=name_matrix[i,j]+'.raw'
			endif

			if (data_type eq 2) then begin
				name_zip=name_matrix[i,j]+'.SRTMGL1.hgt.zip'
				tmp_name=name_matrix[i,j]+'.hgt'
			endif
			
			spawn, 'unzip '+name_zip

			openr, temp_lun, tmp_name, /get_lun
			readu, temp_lun, tmp_image
			free_lun, tmp_lun
			in_tile_row[*,*,i] = tmp_image

			;remove uncompressed file.
			spawn, 'rm '+tmp_name
		endfor

		;write current row of tiles out to file			

		if (j eq 0) then begin
			for jj=0ULL, 3600ULL do begin
				writeu, out_lun, in_tile_row[*,jj,0]
				for ii=1ULL, tiles_x-1 do begin
					writeu, out_lun, in_tile_row[1:3600,jj,ii]
				endfor
			endfor
		endif else begin
			for jj=1ULL, 3600ULL do begin
				writeu, out_lun, in_tile_row[*,jj,0]
				for ii=1ULL, tiles_x-1 do begin
					writeu, out_lun, in_tile_row[1:3600,jj,ii]
				endfor
			endfor
		endelse
	endfor

	free_lun, out_lun				
	
End
