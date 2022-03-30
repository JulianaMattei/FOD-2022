program ejercicio05;

type
    celular = record
        codigo: integer;
        nombre: string;
        descripcion: string;
        marca: string;
        precio: real;
        stock_min: integer;
        stock_disp: integer;
    end;

    archivo_celulares = file of celular;

procedure crear_archivo_binario ( var celulares_bin: archivo_celulares; var celulares_txt: text);
var
    reg_cel: celular;
begin
    reset( celulares_txt );
    rewrite( celulares_bin );
    while ( not EOF( celulares_txt ) ) do begin
        readln( celulares_txt, reg_cel.codigo, reg_cel.precio, reg_cel.marca );
        readln( celulares_txt, reg_cel.stock_disp, reg_cel.stock_min, reg_cel.descripcion );
        readln( celulares_txt, reg_cel.nombre );
        write( celulares_bin, reg_cel );
    end;
    close( celulares_bin );
    close( celulares_txt );
end;

procedure mostrar_celular ( c: celular );
begin
    writeln( 'Codigo: ', c.codigo, ' - ', c.marca, ', ', 
    c.nombre, ' - Descripcion: ', c.descripcion, ' - $', c.precio:2:2, 
    ' - Stock minimo: ', c.stock_min, ' - Stock disponible: ', c.stock_disp );
end;

procedure listar_stock_menor_minimo ( var celulares_bin: archivo_celulares );
var
    reg_cel: celular;
begin
    reset( celulares_bin );
    while ( not EOF( celulares_bin ) ) do begin
        read( celulares_bin, reg_cel );
        if ( reg_cel.stock_disp < reg_cel.stock_min ) then
            mostrar_celular( reg_cel );
    end;
    close( celulares_bin );
end;


procedure listar_por_descripcion ( var celulares_bin: archivo_celulares );
var
    reg_cel: celular;
    texto_buscado: string;
begin
    reset( celulares_bin );
    writeln( 'Ingrese descripcion a buscar: ');
    readln( texto_buscado );
    while ( not EOF( celulares_bin ) ) do begin
        read( celulares_bin, reg_cel );
        if ( pos( texto_buscado, reg_cel.descripcion ) <> 0 ) then
            mostrar_celular( reg_cel );
    end;
    close( celulares_bin );
end;

procedure exportar_a_txt ( var celulares_bin: archivo_celulares; var celulares_txt: text );
var
	reg_cel: celular;
begin
	reset( celulares_bin );
	rewrite( celulares_txt );
	while ( not EOF( celulares_bin ) ) do begin
	  	read( celulares_bin, reg_cel );
		write( celulares_txt, reg_cel.codigo, ' ', reg_cel.precio, ' ', 
        reg_cel.marca, ' ');
        write( celulares_txt, reg_cel.stock_disp, ' ', reg_cel.stock_min, ' ',
        reg_cel.descripcion, ' ' );
        write( celulares_txt, reg_cel.nombre, ' ');
	end;
	close( celulares_bin );
	close( celulares_txt );
end;

procedure mostrar_menu ( var celulares_bin: archivo_celulares; var celulares_txt: text );
var
    opcion: string;
begin
    writeln( '------*------' );
    writeln( 'Ingrese... ');
    writeln( '1 -> crear archivo a partir del txt');
    writeln( '2 -> para listar los celulares con stock menor al minimo' );
    writeln( '3 -> para listar celulares con una descripcion especifica' );
    writeln( '4 -> para exportar el primer archivo a un txt' );
    writeln( '5 -> para salir');
    readln( opcion );

    case opcion of
        '1': crear_archivo_binario( celulares_bin, celulares_txt );
        '2': listar_stock_menor_minimo( celulares_bin );
        '3': listar_por_descripcion( celulares_bin );
        '4': exportar_a_txt ( celulares_bin, celulares_txt );
        '5': halt;
    end;
end;

var
    celulares_bin: archivo_celulares;
    celulares_txt: text;
    nombre_fisico: string;
begin
    assign( celulares_txt, 'celulares.txt' );
    write( 'Ingresar nombre para el archivo: ');
    readln( nombre_fisico );
    assign( celulares_bin, nombre_fisico );
    mostrar_menu ( celulares_bin, celulares_txt );
end.
