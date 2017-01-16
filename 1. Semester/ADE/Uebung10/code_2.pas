FUNCTION IntOf(dual: STRING): INTEGER;
VAR
    result, i: INTEGER;
BEGIN
    result := 0;
    i := 1;
    WHILE i <= Length(dual) DO BEGIN
        result := result * 2;
        IF dual[i] = '1' THEN
            result := result + 1;
        i := i + 1;
    END; (*WHILE*)
    IntOf := result;
END; (*IntOf*)