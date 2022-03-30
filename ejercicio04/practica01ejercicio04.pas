program practica01ejercicio04;

type
	empleado = record
		nro: integer;
		apellido: string[15];
		nombre: string[15];
		edad: integer;
		dni: string[10];
	end;
	
	archivo = file of empleado;


procedure leer_empleado ( var e: empleado );
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
procedure cargar_archivo ( var arch: archivo );
var
    e: empleado;
begin
    leer_empleado( e );
    while ( e.apellido <> 'fin' ) do begin
        write( arch, e );
        leer_empleado( e );
    end;
end;

procedure crear_archivo ( var arch: archivo );
begin
    Rewrite( arch );
    cargar_archivo( arch );
    Close( arch );
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
	reg_emp: empleado;
begin
	reset( arch );
	while ( not EOF( arch ) ) do begin
		read( arch, reg_emp );
		listar_empleado( reg_emp );
	end;
	close( arch );
end;


procedure listar_mayores_70( var arch: archivo );
var
	reg_emp: empleado;
begin
	reset( arch );
	while ( not EOF( arch ) ) do begin
		read( arch, reg_emp );
		if ( reg_emp.edad > 70 ) then
			listar_empleado( reg_emp );
	end;
	close( arch );
end;

procedure agregar_empleados ( var arch: archivo );
var
	e: empleado;
begin
	reset( arch );
	seek( arch, filesize( arch ) );
	leer_empleado( e );
	while ( e.apellido <> 'fin' ) do begin
		write( arch, e );
		leer_empleado( e );
	end;
	close( arch );
end;


procedure modificar_edad ( var arch: archivo );
var
	reg_emp: empleado;
	nro_buscado: integer;
	edad_nueva: integer;
begin
	write( 'Ingrese numero de empleado a modificar (-1 para detener): ' );
	readln( nro_buscado );
	while ( nro_buscado <> -1 ) do begin		//para modificar la edad de más de un empleado
		reset( arch );
		read( arch, reg_emp );
		if ( reg_emp.nro = nro_buscado ) then begin
			write( 'Ingrese nueva edad: ');
			readln( edad_nueva );
			reg_emp.edad := edad_nueva;
			seek( arch, filepos( arch ) - 1 );
			write( arch, reg_emp );
		end
		else begin
			while ( ( not EOF( arch ) ) and ( reg_emp.nro <> nro_buscado) ) do begin	//para detener el recorrido del archivo
				read( arch, reg_emp );
				if ( reg_emp.nro = nro_buscado ) then begin
					write( 'Ingrese nueva edad: ');
					readln( edad_nueva );
					reg_emp.edad := edad_nueva;
					seek( arch, filepos( arch ) - 1 );
					write( arch, reg_emp );
				end;
			end;
		end;
		close( arch );
		write( 'Ingrese numero de empleado a modificar (-1 para detener): ' );
		readln( nro_buscado );
	end;
end;

procedure importar_txt_todos ( var arch: archivo );
var
	arch_txt: Text;
	reg_emp: empleado;
begin
	assign( arch_txt, 'todos_empleados.txt' );
	reset( arch );
	rewrite( arch_txt );
	while ( not EOF( arch ) ) do begin
	  	read( arch, reg_emp );
		write( arch_txt, reg_emp.nro, ' ', reg_emp.apellido, ' ', reg_emp.nombre,
		 ' ', reg_emp.dni, ' ', reg_emp.edad, ' ');
	end;
	close( arch );
	close( arch_txt );
end;

procedure importar_txt_sin_dni ( var arch: archivo );
var
	arch_txt: Text;
	reg_emp: empleado;
begin
	assign( arch_txt, 'faltaDNIEmpleado.txt' );
	reset( arch );
	rewrite( arch_txt );
	while ( not EOF( arch ) ) do begin
	  	read( arch, reg_emp );
		if ( reg_emp.dni = '' ) then
			write( arch_txt, reg_emp.nro, ' ', reg_emp.apellido, ' ',
			reg_emp.nombre, ' ', reg_emp.dni, ' ', reg_emp.edad, ' ');
	end;
	close( arch );
	close( arch_txt );
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
	writeln( '4 -> para agregar empleados al archivo' );
	writeln( '5 -> para modificar la edad de uno o mas empleados');
	writeln( '6 -> para importar todo a un archivo txt');
	writeln( '7 -> para importar empleados sin DNI a un archivo txt');
	writeln( '8 -> para salir' );
	readln( opcion );
	
	case opcion of
		'1': listar_por_nom_ape( arch );
		'2': listar_todo( arch );
		'3': listar_mayores_70( arch );
		'4': agregar_empleados( arch );
		'5': modificar_edad( arch );
		'6': importar_txt_todos( arch );
		'7': importar_txt_sin_dni( arch );
		'8': halt;
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
	writeln( '2 -> para trabajar con el archivo' );
	writeln( '3 -> salir' );
	readln( opcion );
	
	case opcion of
		'1': crear_archivo( arch );
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
