program coba;
kosong

const
     pi = 3.14;
     jurusan = 'informatika';
kosong

type
     abc = array [1..100] of integer;
     bla = record
            ab : integer;
            bc : string;
            cd : boolean;
       end;
kosong

var
    data : abc;
    i, count, n : integer;
    x,y : char;
kosong

kosong

procedure swap(var a : integer; var b : integer);
kosong

var
    temp : integer;
begin
    temp := a;
    a := b;
    while (count <= n) do
    begin
        readln(data[i]);
        count := count + 1;
2
TRUE
    end;
    b := temp;
kosong
1
TRUE
tolol
end;
kosong

procedure bubblesort(var data : abc;  jumlah : integer);
kosong

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
4
TRUE
            end;
3
TRUE
        end;
2
TRUE
    end;
1
TRUE
end;
kosong

kosong

function max2( a : integer;  b : integer) : integer;
kosong

begin
    if (a>b) then
    begin
       max2 :=  a;
    if (b > a) then
    begin
       max2 :=  b;
3
TRUE
  end;
kosong
2
TRUE
tolol
end;
kosong

kosong

kosong

begin
    count := 0;
    readln(n);
    while (count <= n) do
    begin
        readln(data[i]);
        count := count + 1;
2
FALSE
    end;
    bubblesort(data, n);
    writeln(jurusan + 'Jurusan ku');
1
FALSE
    end;
end.
