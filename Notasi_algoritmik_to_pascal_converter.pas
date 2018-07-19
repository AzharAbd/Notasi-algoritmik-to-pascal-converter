program converter;

const
    satuTab = '    ';
    semiColon = ';';
var
    prevIndent, currentIndent, firstElmt, content, source: string;
    fileNameNot,  fileNamePas,  namaFungsi : string;
    notMik,pascal : text;
    typeOn, constOn, coba, subprogOn, algoOn  : boolean;
    beginCount,i : integer;

procedure getPrevIndent(current : string; var prev : string);
begin
    prev := current;
end;

procedure getIndent(var source : string; var Indent : string);
var
    idx : integer;
begin
    idx := 1;
    Indent := '';
    while (source[idx] = ' ') do
    begin
        Indent := Indent + source[idx];
        inc(idx);
    end;
    delete(source,1,idx-1);
end;

procedure getFirstElmt(var source : string; var Elmt : string);
var
    idx : integer;
begin
    idx := 1;
    Elmt := '';
    while (source[idx] <> ' ') and (source[idx] <> '(') and (idx <= length(source)) do
    begin
        Elmt := Elmt + source[idx];
        inc(idx);
    end;
    delete(source,1,idx-1);
end;

procedure convConst(source : string; var content : string; var kamusOn : boolean;var pascal : text);
begin
    if not(kamusOn) then
    begin
        writeln(pascal,'const');
        kamusOn := true;
    end;
    content := satuTab + source + semiColon;
    writeln(pascal,currentIndent + content);
end;

procedure varChar(var source : string);
begin
    if (pos('character',source) > 0) then
    begin
        insert('char',source, pos('character',source));
        delete(source,pos('character',source),9);
    end;
end;

procedure panahMasuk(var source, firstElmt : string);
var
    idx : integer;
begin
    idx := pos('<-',source);
    if (idx > 0) then
    begin
        insert(':=',source, idx);
        delete(source,idx+2,2);
    end;
end;

procedure  convInp(source : string; var content : string; var pascal : text);
begin
    content := 'readln' + source;
    writeln(pascal,currentIndent + content + semiColon);
end;

procedure convOut(source : string; var content : string; var pascal : text);
var
    i ,idx : integer;
    isi,apustruk : string;
begin
    isi := '';
    apustruk := '''';
    content := currentIndent + 'writeln';
    if (pos('"',source) > 0) then
    begin
        idx := pos('"',source);
        delete(source,idx,1);
        for i := idx to pos('"',source)-1 do
        begin
            isi := isi + source[idx];
            delete(source,idx,1);
        end;
        delete(source,idx,1);
        insert(isi,apustruk,2);
        apustruk := apustruk + '''';
        insert(apustruk,source,idx);
    end;
    content := content + source;
    writeln(pascal, content + semiColon);
end;

procedure starter(var currentIndent, prevIndent, firstElmt, source : string; var notMik : text);
begin
    getPrevIndent(currentIndent,prevIndent);
    readln(notMik, source);
    getIndent(source,currentIndent);
    getFirstElmt(source,firstElmt);
end;

procedure ifStatment(var pascal : text; var currentIndent, firstElmt, source : string; var beginCount : integer);
begin
    inc(beginCount);
    writeln(pascal,currentIndent + firstElmt + source);
    writeln(pascal,currentIndent + 'begin');
end;

procedure subProgram(var pascal : text; var content, currentIndent, firstElmt, source : string; var beginCount : integer; var subprogOn : boolean);
var
    i : integer;
begin
    subprogOn := true;
    while pos('INPUT',source) > 0 do
        delete(source,pos('INPUT',source),5);
    while pos('/',source) > 0 do
        delete(source,pos('/',source),1);
    while pos('OUTPUT',source) > 0 do
    begin
        insert('var',source, pos('OUTPUT',source));
        delete(source,pos('OUTPUT', source),6);
    end;
    while pos(',',source) > 0 do
    begin
        insert(';', source, pos(',', source));
        delete(source,pos(',',source),1);
    end;
    if pos('->', source) > 0 then
    begin
        insert(':', source, pos('->', source));
        delete(source, pos('->', source),2);
    end;
    content := firstElmt + source + semiColon;
    writeln(pascal,content);
    if (firstElmt = 'function') then
    begin
        namaFungsi :='';
        for i := 1 to pos('(',source)-1 do
          namaFungsi :=  namaFungsi + source[i]
    end;
end;

procedure outFungsi(var pascal : text; var  currentIndent, firstElmt, source, namaFungsi : string);
begin
    writeln(pascal, currentIndent + namaFungsi+ ' := ' + source + semiColon);
end;

procedure forloops(var pascal : text; var source, currentIndent, firstElmt : string; var beginCount : integer);
var
    awal, akhir : string;
    idx : integer;
begin
    inc(beginCount);
    awal := ''; akhir := '';
    idx := pos('[', source) +1;
    while source[idx] <> '.' do
    begin
        awal := awal + source[idx];
        inc(idx);
    end;
    inc(idx,2);
    while source[idx] <> ']' do
    begin
        akhir := akhir + source[idx];
        inc(idx);
    end;
    writeln(pascal, currentIndent + 'for ' + firstElmt + ' := ' + awal + ' to ' + akhir + ' do');
    writeln(pascal, currentIndent + 'begin');
end;

procedure mulaiAlgo(var pascal : text; var currentIndent, firstElmt, source : string; var algoOn, subprogOn : boolean; var beginCount : integer);
begin
    writeln(pascal, currentIndent + 'begin');
    algoOn := true;
    if (subprogOn) then
        inc(beginCount);
end;

procedure kosong(var pascal : text; var beginCount : integer; var algoOn, subprogOn : boolean);
begin
    if (subprogOn) and (algoOn) and (beginCount > 0) then
    begin
          writeln(pascal,'end;');
          dec(beginCount);
          subprogOn := false;
          algoOn := false;
    end
    else
        writeln(pascal,'');
end;

procedure lainnya(var pascal : text; var content, currentIndent, firstElmt, source : string; var beginCount : integer);
begin
    if (pos('traversal',source) > 1) then
        forloops(pascal,source, currentIndent, firstElmt, beginCount)
    else
    begin
        writeln(pascal, currentIndent + firstElmt + source + semiColon);
    end;
end;

procedure allCase(var source,content,firstElmt, currentIndent, prevIndent, namaFungsi : string; var pascal,notMik : text; var beginCount : integer; var subprogOn :boolean);
begin
    case firstElmt of
        '{ALGORITMA}' : mulaiAlgo(pascal, currentIndent, firstElmt, source, algoOn, subprogOn, beginCount);
        '{algortima}' : mulaiAlgo(pascal, currentIndent, firstElmt, source, algoOn, subprogOn, beginCount);
        'program' :  writeln(pascal,currentIndent + firstElmt + source + semiColon);
        'constant' : convConst(source, content, constOn, pascal);
        'INPUT' : convInp(source,content,pascal);
        'input' : convInp(source,content,pascal);
        'OUTPUT' : convOut(source, content, pascal);
        'output' : convOut(source, content, pascal);
        'if' : ifStatment(pascal,currentIndent, firstElmt, source, beginCount);
        'else' : ifStatment(pascal,currentIndent, firstElmt, source, beginCount);
        'function' : subProgram(pascal,  content, currentIndent, firstElmt, source, beginCount,subprogOn );
        'procedure' : subProgram(pascal,  content, currentIndent, firstElmt, source,beginCount, subprogOn );
        'while' : ifStatment(pascal,currentIndent, firstElmt, source, beginCount);
        '->' : outFungsi(pascal, currentIndent, firstElmt, source, namaFungsi);
        '' : kosong (pascal, beginCount, algoOn, subprogOn);
    else
        lainnya(pascal, content, currentIndent, firstElmt, source, beginCount );
    end;
end;

begin
    writeln('======================================================');
    writeln('|       Notasi Algoritmik to Pascal Translator       |');
    writeln('|                  Azhar Abdurrasyid                 |');
    writeln('|                       16517012                     |');
    writeln('======================================================');
    writeln();
    writeln();
    write('Masukkan nama file notasi algoritmik (contoh : coba.txt) : '); readln(fileNameNot);
    write('Masukkan nama file pascal (contoh : coba.pas) : '); readln(fileNamePas);
    assign(notMik, fileNameNot);
    assign(pascal, fileNamePas);
    reset(notMik);
    rewrite(pascal);
    currentIndent := ''; typeOn := false; constOn := false; algoOn := false;
    beginCount := 0; namaFungsi := ''; subprogOn := false;
    while (not eof(notMik)) do
    begin
        content := '';
        starter(currentIndent, prevIndent, firstElmt, source, notMik);
        varChar(source);
        panahMasuk(source, firstElmt);
        coba := ((beginCount > 0) and ((length(currentIndent) < length(prevIndent)) ));
        if coba then
        begin
                if (currentIndent) = '' then
                    subprogOn := false;
                while (length(prevIndent) - length(currentIndent) >= length(satuTab)) do
                begin
                    delete(prevIndent,1,length(satuTab));
                    writeln(pascal, prevIndent + 'end;');
                    dec(beginCount);
                end;
            //end;
        end;
        if (firstElmt = '{KAMUS}') or (firstElmt = '{kamus}') then
        begin
            writeln(pascal,'var');
            starter(currentIndent, prevIndent, firstElmt, source, notMik);
            varChar(source);
            while (length(currentIndent) >= length(prevIndent)) do
            begin
                writeln(pascal,currentIndent + firstElmt + source + semiColon);
                starter(currentIndent, prevIndent, firstElmt, source, notMik);
                varChar(source);
            end;
        end
        else if (firstElmt = 'type') then
        begin
            if not(typeOn) then
            begin
                writeln(pascal,'type');
                typeOn := true;
            end;
            if (source[length(source)] = ':') then
            begin
                delete(source,length(source),1);
                writeln(pascal,satuTab + source + '= record');
                starter(currentIndent, prevIndent, firstElmt, source, notMik);
                while (source[length(source)] <> '>') do
                begin
                    if (firstElmt[1] = '<') then
                        delete(firstElmt,1,1);
                    if (source[length(source)] = ',') then
                        delete(source,length(source),1);
                    content := satuTab + satuTab + satuTab + firstElmt + source + semiColon;
                    writeln(pascal,content);
                    starter(currentIndent, prevIndent, firstElmt, source, notMik);
                end;
                delete(source,length(source),1);
                content := satuTab + satuTab + satuTab + firstElmt + source + semiColon;
                writeln(pascal,content);
                writeln(pascal,prevIndent + 'end;');
            end
            else
            begin
                insert('=',source, pos(':',source));
                delete(source,pos(':',source),1);
                content := satuTab + source + semiColon;
                writeln(pascal,content);
            end;
        end
        else
          allCase(source, content, firstElmt, currentIndent, prevIndent,namaFungsi, pascal, notMik, beginCount,subprogOn);
    end;
    while beginCount > 0 do
    begin
        content := '';
        for i := 1 to beginCount do
            content := content + satuTab;
        writeln(pascal, content + 'end;');
        dec(beginCount);
    end;
    writeln(pascal,'end.');
    close(notMik);
    close(pascal);
    writeln('Translasi Sukses');
end.
