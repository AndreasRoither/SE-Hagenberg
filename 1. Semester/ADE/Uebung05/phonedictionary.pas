program phonedictionary;

CONST   max = 10; 

TYPE   Entry = RECORD    
  firstName:    STRING[20];    
  lastName:     STRING[30];    
  phoneNumber:  INTEGER;   
END; (*RECORD*) 

PhoneBook = ARRAY [1 .. max] OF Entry;

(*adds entry to a Phonebook*)
PROCEDURE AddEntry(fname,lname : STRING; pn :INTEGER; VAR dictionary : Phonebook);
VAR i : Integer;
VAR addpossible: Boolean;
BEGIN
  addpossible := False;
  
  FOR i := 1 TO length(dictionary) DO
    IF dictionary[i].firstName = '' THEN BEGIN
      dictionary[i].firstName := fname;
      dictionary[i].lastName  := lname;
      dictionary[i].phoneNumber := pn;
      addpossible := True;
      break;
    end;
  
  IF NOT addpossible THEN
    WriteLn('AddEntry not possible');
    
END;

(*deletes entry and moves later entries down (no gaps)*)
PROCEDURE DeleteEntry(fname, lname : STRING; VAR dictionary : Phonebook);
VAR i, i2 : Integer;
VAR found : Boolean;
BEGIN
  found := False;
  FOR i := 1 TO length(dictionary) DO
    IF (dictionary[i].firstName = fname) AND (dictionary[i].lastName = lname)  THEN BEGIN
      dictionary[i].firstName := '';
      dictionary[i].lastName := '';
      dictionary[i].phoneNumber := 0;
      found := True;

      FOR i2 := i TO length(dictionary)-1 DO BEGIN
        dictionary[i2].firstName := dictionary[i2+1].firstName;
        dictionary[i2].lastName := dictionary[i2+1].lastName;
        dictionary[i2].phoneNumber := dictionary[i2+1].phoneNumber;
      end;
    end;
    
    IF NOT found THEN
      WriteLn('DeleteEntry: Entry not found');
END;

(*returns number if entry matches with strings*)
PROCEDURE SearchNumber(fname, lname : String; dictionary : Phonebook);
VAR i : Integer;
VAR found : Boolean;
BEGIN 
  found := False;
  FOR i := 1 TO length(dictionary) DO BEGIN
      IF (dictionary[i].firstName = fname) AND (dictionary[i].lastName = lname) THEN BEGIN
        WriteLn('Phonenumber of ', fname, ' ', lname, ': ', dictionary[i].phoneNumber);
        found := True;
      end;
  end;
        
  IF NOT found THEN
    WriteLn('SearchNumber: Entry not found');
END;

(*prints out the number of the entries in a Phonebook*)
FUNCTION NrofEntries(dictionary : Phonebook): Integer;
VAR i, count : INTEGER;
BEGIN
  count := 0;
  FOR i := 1 TO length(dictionary) DO
    IF dictionary[i].firstName <> '' THEN
      count := count +1;
      
  NrofEntries := count;
END;

(*procedure for printing out the whole dictionary*)
PROCEDURE PrintDictionary(dictionary : Phonebook);
VAR i : Integer;
BEGIN
  FOR i := 1 TO length(dictionary) DO
    WriteLn(dictionary[i].firstName, ' ', dictionary[i].lastName,' ', dictionary[i].phoneNumber);
END;

VAR dictionary : Phonebook;
BEGIN
  WriteLn('-- phonedictionary --');
  AddEntry('Test1','Test01',1,dictionary);
  AddEntry('Test2','Test02',2,dictionary);
  AddEntry('Test3','Test03',3,dictionary);
  AddEntry('Test4','Test04',4,dictionary);
  AddEntry('Test5','Test05',5,dictionary);
  
  PrintDictionary(dictionary);
  WriteLn('Laenge: ',NrofEntries(dictionary),#13#10);
  
  DeleteEntry('Test6','Test06',dictionary);
  
  AddEntry('Test6','Test06',6,dictionary);
  AddEntry('Test7','Test07',7,dictionary);
  
  DeleteEntry('Test6','Test06',dictionary);
  PrintDictionary(dictionary);
  WriteLn('Laenge: ',NrofEntries(dictionary),#13#10);
  
  SearchNumber('Test7','Test7',dictionary);
  SearchNumber('Test7','Test07',dictionary);

END.