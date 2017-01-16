FUNCTION IntOf2(dual: STRING): INTEGER;
    FUNCTION IORec(pos: INTEGER): INTEGER;
    BEGIN
        IF pos = 0 THEN
            IORec := 0
        ELSE IF dual[pos] = '1' THEN
            IORec:= IORec(pos - 1) * 2 + 1
        ELSE
            IORec:= IORec(pos - 1) * 2;
    END; (*IORec*)
BEGIN (*IntOf2*)
    IntOf2 := IORec(Length(dual));
END; (*IntOf2*)