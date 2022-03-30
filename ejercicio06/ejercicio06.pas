program ejercicio06;

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

procedure leer_celular ( var cel: celular );
begin
	writeln( 'Ingrese codigo (-1 para terminar): ' );
	readln( cel.codigo );
	if ( cel.codigo <> -1 ) then begin
		writeln( 'Ingrese nombre: ' );
		readln( cel.nombre );
		writeln( 'Ingrese descripcion: ' );
		readln( cel.descripcion );
		writeln( 'Ingrese marca: ' );
		readln( cel.marca );
		writeln( 'Ingrese precio: ' );
		readln( cel.precio );
        writeln( 'Ingrese stock minimo: ' );
        readln( cel.stock_min );
        writeln( 'Ingrese stock disponible: ' );
        readln( cel.stock_disp );
	end;
end;

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
    writeln( 'Codigo: ', c.codigo, ' - ', c.marca, ', ' c.nombre, 
            ' - Descripcion: ', c.descripcion, ' - $', c.precio:2:2,
            ' - Stock minimo: ', c.stock_min, ' - Stock disponible: ',
            c.stock_disp );
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
    while ( not EOF( archivo_celulares ) ) do begin
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
        //primer linea
		write( celulares_txt, reg_cel.codigo, ' ', reg_cel.precio, ' ', 
        reg_cel.marca, ' ');
        //segunda linea
        write( celulares_txt, reg_cel.stock_disp, ' ', reg_cel.stock_min, ' ',
        reg_cel.descripcion, ' ' );
        //tercera linea
        write( celulares_txt, reg_cel.nombre, ' ');
	end;
	close( celulares_bin );
	close( celulares_txt );
end;

procedure anadir_celulares ( var celulares_bin: archivo_celulares );
var
    cel: celular;
begin
    reset( celulares_bin );
    seek( celulares_bin, filesize( celulares_bin ) );
    leer_celular( cel );
    while ( cel.codigo <> -1) do begin
        write( celulares_bin, cel );
        leer_celular( cel );
    end;
    close( celulares_bin );
end;

procedure modificar_stock ( var celulares_bin: archivo_celulares );
var
    nombre_buscado: string;
    listo: boolean;
    reg_cel: celular;
    stock_nue: integer;
begin
    listo:= false;
    writeln('Ingrese nombre del celular a modificar stock: ');
    readln( nombre_buscado );
    reset( celulares_bin );
    while ( not EOF( archivo_celulares ) and not listo ) do begin
        read( archivo_celulares, reg_cel );
        if ( reg_cel.nombre = nombre_buscado ) then begin
            writeln( 'Ingrese nuevo stock: ' );
            readln( stock_nue );
            reg_cel.stock_disp := stock_nue;
            seek( celulares_bin, filepos( celulares_bin ) -1 );
            write( celulares_bin, reg_cel );
            listo := true;
        end;
    end;
    if listo then
        writeln( 'Modificacion realizada' )
    else
        writeln( 'Celular no encontrado');
    close( celulares_bin );
end;

procedure exportar_a_txt_sin_stock ( var celulares_bin: archivo_celulares );
var
	arch_txt: Text;
	reg_cel: celular;
begin
	assign( arch_txt, 'SinStock.txt' );
	reset( celulares_bin );
	rewrite( arch_txt );
	while ( not EOF( celulares_bin ) ) do begin
	  	read( celulares_bin, reg_cel );
		if ( reg_cel.stock_disp = 0 ) then begin
			write( celulares_txt, reg_cel.codigo, ' ', reg_cel.precio, ' ', 
                reg_cel.marca, ' ');
            write( celulares_txt, reg_cel.stock_disp, ' ', reg_cel.stock_min, ' ',
                reg_cel.descripcion, ' ' );
            write( celulares_txt, reg_cel.nombre, ' ');
        end;
	end;
	close( celulares_bin );
	close( arch_txt );
end;

//Menu
procedure mostrar_menu ( var celulares_bin: archivo_celulares; celulares_txt: text );
var
    opcion: string;
begin
    writeln( '------*------' );
    writeln( 'Ingrese... ');
    writeln( '1 -> crear archivo a partir del txt');
    writeln( '2 -> para listar los celulares con stock menor al minimo' );
    writeln( '3 -> para listar celulares con una descripcion especifica' );
    writeln( '4 -> para exportar el primer todo a un txt' );
    writeln( '5 -> para anadir celulares manualmente' );
    writeln( '6 -> para modificar stock de un celular' );
    writeln( '7 -> para exportar a un txt los celulares con stock 0');
    writeln( '8 -> para salir');
    readln( opcion );

    case opcion of
        '1': crear_archivo_binario( celulares_bin, celulares_txt );
        '2': listar_stock_menor_minimo( celulares_bin );
        '3': listar_por_descripcion( celulares_bin );
        '4': exportar_a_txt( celulares_bin, celulares_txt );
        '5': anadir_celulares( celulares_bin );
        '6': modificar_stock( celulares_bin );
        '7': exportar_a_txt_sin_stock( celulares_bin );
        '8': halt;
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