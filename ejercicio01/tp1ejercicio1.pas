program tp1Ejercicio1;

type archivo = file of integer; {definición tipo de dato archivo}

var nlogico: archivo; {define nombre logico del archivo}
	nro: integer;	{se usa para obtener la info de teclado}
	nfisico: string[12];	{usada para obtener nombre físico del archivo desde teclado}
	

BEGIN
	writeln( 'Ingrese el nombre del archivo: ' );
	readln( nfisico ); { se obtiene nombre del archivo }
	assign( nlogico, nfisico ); { se establece la relacion para el SO }
	rewrite( nlogico ); { se crea el archivo }
	writeln( 'Ingresar un numero: ' );
	readln( nro ); { se obtiene de teclado el primer valor }
	while ( nro <> 30000 ) do begin
		write( nlogico, nro ); { se escribe el numero en el archivo }
		writeln( 'Ingresar un numero: ' );
		readln( nro ); { se lee otro numero }
	end;
	close( nlogico ); { se cierra el archivo }
END.

