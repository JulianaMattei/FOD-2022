program practica01ejercicio03;

type
	empleado = record
		nro: integer;
		apellido: string[15];
		nombre: string[15];
		edad: integer;
		dni: string[10];
	end;
	
	archivo = file of empleado;


procedure cargar_empleado ( var e: empleado );
begin
	writeln( 'Ingrese apellido: ' );
	readln( e.apellido );
	if ( e.apellido <> 'fin' ) then begin
		writeln( 'Ingrese nombre: ' );
		readln( e.nombre );
		writeln( 'Ingrese numero del empleado: ' );
		readln( e.nro );
		writeln( 'Ingrese edad: ' );
		readln( e.edad );
		writeln( 'Ingrese DNI: ' );
		readln( e.dni );
	end;
end;

//Creacion del archivo de empleados//
procedure crear_archivo_empleados( var arch: archivo );
var
	e: empleado;
begin
	rewrite( arch );
	cargar_empleado( e );
	while ( e.apellido <> 'fin' ) do begin
		write( arch, e );
		cargar_empleado( e );
	end;
	close( arch );
end;


procedure listar_empleado( e: empleado );
begin
	writeln( 'Empleado nro: ', e.nro, ' - ', e.apellido, ', ', e.nombre,
			' - DNI: ', e.dni, ' - Edad: ', e.edad);
end;


procedure listar_por_nom_ape( var arch: archivo );
var
	e: empleado;
	nombre_buscado: string;
begin
	writeln( 'Ingresar nombre u apellido a buscar: ' );
	readln( nombre_buscado );
	writeln( 'Resultados: ' );
	reset( arch );
	while (not EOF( arch ) ) do begin
		read( arch, e );
		if ( ( e.nombre = nombre_buscado ) or ( e.apellido = nombre_buscado ) ) then
			listar_empleado( e );
	end;
	close( arch );
end;


procedure listar_todo( var arch: archivo );
var
	regEmp: empleado;
begin
	reset( arch );
	while ( not EOF( arch ) ) do begin
		read( arch, regEmp );
		listar_empleado( regEmp );
	end;
	close( arch );
end;


procedure listar_mayores_70( var arch: archivo );
var
	regEmp: empleado;
begin
	reset( arch );
	while ( not EOF( arch ) ) do begin
		read( arch, regEmp );
		if ( regEmp.edad > 70 ) then
			listar_empleado( regEmp );
	end;
	close( arch );
end;


//Menu dos//
procedure mostrar_menu_dos( var arch: archivo );
var
	opcion: string;
begin
	writeln( '------*------' );
	writeln( 'Ingrese: ' );
	writeln( '1 -> para listar datos a partir de nombre o apellido' );
	writeln( '2 -> para listar todos los empleados' );
	writeln( '3 -> para listar empleados mayores de 70 anios' );
	writeln( '4 -> para salir' );
	readln( opcion );
	
	case opcion of
		'1': listar_por_nom_ape( arch );
		'2': listar_todo( arch );
		'3': listar_mayores_70( arch );
		'4': halt;
	end;
end;


//Menu uno//
procedure mostrar_menu_uno( var arch: archivo );
var
	opcion: string;
begin
	writeln( '------*------' );
	writeln( 'Ingrese: ' );
	writeln( '1 -> para crear archivo' );
	writeln( '2 -> para listar a partir del archivo' );
	writeln( '3 -> salir' );
	readln( opcion );
	
	case opcion of
		'1': crear_archivo_empleados( arch );
		'2': mostrar_menu_dos( arch );
		'3': halt;
	end;
end;


//PROGRAMA PRINCIPAL//
var
	arch: archivo;
	n_fisico: string;

begin
	writeln( 'Ingresar nombre del archivo a crear o abrir: ' );
	readln( n_fisico );
	Assign( arch, n_fisico);
	mostrar_menu_uno( arch );
	mostrar_menu_uno( arch );
end.
