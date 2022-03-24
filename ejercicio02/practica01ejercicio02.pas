program practica01ejercicio02;

type
	archivo = file of integer;

//cálculo del promedio
function prom ( sum: integer; cant: integer ): real;
begin
	prom := sum / cant ;
end;


var
	a_int: archivo;
	cant: integer;	{ cantidad de nros menores a 1500 }
	num: integer;	{ promedio de los nros del archivo }
	sum: integer; { suma de los nros del archivo }
	nombre: string;

begin
	writeln ( 'Ingresar nombre del archivo: ' );
	readln ( nombre );
	cant := 0;
	sum := 0;
	Assign( a_int, nombre );
	reset ( a_int );
	while ( not EOF( a_int ) ) do begin
		read ( a_int, num );
		writeln ( num );
		sum := sum + num;
		if ( num < 1500 ) then
			cant := cant + 1;
	end;
	
	writeln( 'La cantidad de numeros menores a 1500 es: ' );
	writeln( 'El promedio de los numeros del archivo es: ', prom( sum, FileSize(a_int) ):2:2 );
end.
