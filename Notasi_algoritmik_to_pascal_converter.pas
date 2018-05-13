program converter;

const
    satuTab = '   ';
    semiColon = ';';
var
    prevIndent, currentIndent, firstElmt, content, source, temp : string;
    fileNameNot, directoryNot, fileNamePas, directoryPas, fileNot, filePas : string;
    notMik,pascal : text;
    typeOn, constOn, subProgram : boolean;

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
        write(source[idx]);
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
        writeln(apustruk);
        delete(source,idx,1);
        writeln(source);
        insert(isi,apustruk,2);
        apustruk := apustruk + '''';
        writeln(apustruk);
        insert(apustruk,source,idx);
        writeln(source);
    end;
    content := content + source;
    writeln(pascal, content + semiColon);
end;

procedure starter(var currentIndent, prevIndent, source : string; var notMik : text);
begin
    getPrevIndent(currentIndent,prevIndent);
    readln(notMik, source);
    getIndent(source,currentIndent);
    getFirstElmt(source,firstElmt);
end;

procedure allCase(var source,content,firstElmt, currentIndent, prevIndent : string; var pascal,notMik : text);
begin
    case firstElmt of
        '{ALGORITMA}' :   writeln(pascal, currentIndent + 'begin');
        'program' :  writeln(pascal,currentIndent + firstElmt + source + semiColon);
        'constant' : convConst(source, content, constOn, pascal);
        '' : writeln(pascal);
        'INPUT' : convInp(source,content,pascal);
        'OUTPUT' : convOut(source, content, pascal);
    end;
end;

begin
    write('Masukkan nama file notasi algoritmik : '); readln(fileNameNot);
  //  write('Masukkan directory notasi algoritmik : '); readln(directoryNot);
  //  fileNot := directoryNot + fileNameNot;
    write('Masukkan nama file pascal : '); readln(fileNamePas);
  //  write('Masukkan directory pascal : '); readln(directoryPas);
  //  filePas := directoryPas + fileNamePas;
    assign(notMik, fileNameNot);
    assign(pascal, fileNamePas);
    reset(notMik);
    rewrite(pascal);
    currentIndent := ''; typeOn := false; constOn := false;
    while not eof(notMik) do
    begin
        content := '';
        starter(currentIndent, prevIndent, source, notMik);
        varChar(source);
        if (firstElmt = '{KAMUS}') then
        begin
            writeln(pascal,'var');
            starter(currentIndent, prevIndent, source, notMik);
            while (length(currentIndent) >= length(prevIndent)) do
            begin
                writeln(pascal,currentIndent + firstElmt + source + semiColon);
                starter(currentIndent, prevIndent, source, notMik);
            end;
        end;
        if (firstElmt = 'type') then
        begin
            if not(typeOn) then
            begin
                writeln(pascal,'type');
                typeOn := true;
            end;
            if (source[length(source)] = ':') then
            begin
                delete(source,pos(':',source),1);
                writeln(pascal,satuTab + source + '= record');
                starter(currentIndent, prevIndent, source, notMik);
                while (source[length(source)] <> '>') do
                begin
                    if (source[1] = '<') then
                        delete(source,1,1);
                    if (source[length(source)] = ',') then
                        delete(source,length(source),1);
                    content := satuTab + satuTab + satuTab + source+ semiColon;
                    writeln(pascal,content);
                    starter(currentIndent, prevIndent, source, notMik);
                end;
                delete(source,length(source),1);
                content := satuTab + satuTab + satuTab + source + semiColon;
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
        end;
        if (firstElmt = 'if') then
        begin
            writeln(pascal,currentIndent + firstElmt + source);
            writeln(pascal,currentIndent + 'begin');
            starter(currentIndent, prevIndent, source, notMik);
            repeat
                content := currentIndent + firstElmt + source;
                writeln(pascal,content);
                starter(currentIndent, prevIndent, source, notMik);
            until
        end;
        allCase(source, content, firstElmt, currentIndent, prevIndent, pascal, notMik);
    end;
    writeln(pascal,'end.');
    close(notMik);
    close(pascal);
end.
