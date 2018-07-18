program coba;

const
     pi = 3.14;
     jurusan = 'informatika';

type
     abc = array [1..100] of integer;
     bla = record
            ab : integer;
            bc : string;
            cd : boolean;
       end;

var
    data : abc;
    i, count, n : integer;
    x,y : char;


procedure swap(var a : integer; var b : integer);

var
    temp : integer;
begin
    temp := a;
    a := b;
    while (count <= n) do
    begin
        readln(data[i]);
        count := count + 1;
        for i := 1 to 10 do
        begin
            count := count +1;
        end;
    end;
    b := temp;
end;

procedure bubblesort(var data : abc;  jumlah : integer);

var
    i, j : integer;
begin
    for i := 1 to jumlah do
    begin
        for j := 1 to jumlah do
        begin
            if (data[i] > data[j]) then
            begin
                swap(data[i],data[j]);
            end;
        end;
    end;
end;


function max2( a : integer;  b : integer) : integer;

begin
    if (a>b) then
    begin
       max2 :=  a;
    if (b > a) then
    begin
       max2 :=  b;
  end;
end;



begin
    count := 0;
    readln(n);
    while (count <= n) do
    begin
        readln(data[i]);
        count := count + 1;
    end;
    bubblesort(data, n);
    writeln(jurusan + 'Jurusan ku');
end.
