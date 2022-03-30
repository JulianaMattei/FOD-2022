program ejercicio07;
type
    novela = record
        codigo: integer;
        nombre: string;
        genero: string;
        precio: real;
    end;

    novelas_arch = file of novela;

procedure mostrar_menu ( var novelas_bin: novelas_arch; var novelas_txt: text );
var
    opcion: string;
begin
    writeln( 'Ingrese: ');
    writeln( '1 -> para ');
    writeln( '2 -> para ' );
    writeln( '3 -> para ');
    writeln( '4 -> para ');

end;


var
    novelas_bin: novelas_arch;
    novelas_txt: text;
    n_fisico: string;
begin
    assign( novelas_txt, 'novelas.txt' );
    writeln( 'Ingrese nombre del archivo: ' );
    readln( n_fisico );
    assign( novelas_bin, n_fisico );
    mostrar_menu ( novelas_bin, novelas_txt );
end.