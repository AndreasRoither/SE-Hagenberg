(* Persons03                                      DA, 17.05.2017 *)
(* First OO Program                                              *)
(* dynamische (Methoden-)Bindung                                 *)
(* ------------------------------------------------------------- *)
PROGRAM Persons03;

  CONST
    maxStudents = 10;

  TYPE
    Person = OBJECT
      name: STRING;
      CONSTRUCTOR Init(name: STRING);
      DESTRUCTOR Done;   VIRTUAL;
      PROCEDURE Greet;   VIRTUAL;
    END; 
    
    Student = OBJECT(Person)
      studentNr: INTEGER;
      CONSTRUCTOR Init(name: STRING; studentNr: INTEGER);
      DESTRUCTOR Done;   VIRTUAL;
      PROCEDURE Greet;   VIRTUAL;
    END; 

    StudentPtr = ^Student;        
    Teacher = OBJECT(Person)
      studentCnt: INTEGER;
      students: ARRAY[1..maxStudents] OF StudentPtr;
      CONSTRUCTOR Init(name: STRING);
      DESTRUCTOR Done;   VIRTUAL;
      PROCEDURE Greet;   VIRTUAL;
      PROCEDURE AddStudent(s: StudentPtr);
    END; (*Teacher*)
      
      
  (* Person *)
  CONSTRUCTOR Person.Init(name: STRING);
  BEGIN
    SELF.name := name;
  END; (*Person.Init*)

  DESTRUCTOR Person.Done;
  BEGIN
    (*do nothing*)
  END; (*Person.Done*)

  PROCEDURE Person.Greet;
  BEGIN
    WriteLn('Hello, my name is ', SELF.name);
  END; (*Person.Greet*)

  (* Student *)
  CONSTRUCTOR Student.Init(name: STRING; studentNr: INTEGER);
  BEGIN
    Person.Init(name);
    SELF.studentNr := studentNr;
  END; (*Student.Init*)

  DESTRUCTOR Student.Done;
  BEGIN
    (*do nothing*)
    INHERITED;
  END; (*Student.Done*)

  PROCEDURE Student.Greet;
  BEGIN
    WriteLn('Hi, I am ', SELF.name, ' with student number ', studentNr);
  END; (*Greet*)

  (* Teacher *)
  CONSTRUCTOR Teacher.Init(name: STRING);
  BEGIN
    Person.Init(name);
    SELF.studentCnt := 0;
  END; (*Teacher.Init*)

  DESTRUCTOR Teacher.Done;
  BEGIN
    (*do nothing*)
    INHERITED;
  END; (*Teacher.Done*)
  
  PROCEDURE Teacher.Greet;
    VAR
      i: INTEGER;
  BEGIN
    IF studentCnt = 0 THEN BEGIN
      Person.Greet;
    END
    ELSE BEGIN
      WriteLn('Good morning, I am teacher ', name, ' and let me introduce my ', studentCnt, ' students');
      i := 1;
      WHILE i <= studentCnt DO BEGIN
        students[i]^.Greet;
        i := i + 1;
      END;
    END;
  END; (*Teacher.Greet*)

  PROCEDURE Teacher.AddStudent(s: StudentPtr);
  BEGIN
    IF studentCnt < maxStudents THEN BEGIN
      studentCnt := studentCnt + 1;
      students[studentCnt] := s;
    END
    ELSE
      WriteLn('no more students allowed to register');
  END; (*Teacher.Greet*)

  VAR
    pPtr: ^Person;
    sPtr, sPtr2, sPtr3: ^Student;
    tPtr: ^Teacher;
    
    i: INTEGER;
    allPersons: ARRAY[1..10] OF ^Person;
    personCnt: INTEGER;
    
BEGIN


  New(pPtr);
  pPtr^.Init('Person');
  

  New(sPtr, Init('Andi', 1));
  sPtr^.Greet;
  New(sPtr2, Init('Betti', 2));
  sPtr2^.Greet;
  New(sPtr3, Init('Charly', 3));
  sPtr3^.Greet;

  New(tPtr, Init('Teacher'));
  tPtr^.Greet;
  tPtr^.AddStudent(sPtr);
  tPtr^.AddStudent(sPtr2);
  tPtr^.AddStudent(sPtr3);
  WriteLn;
  tPtr^.Greet;
 
  personCnt := 1;
  allPersons[personCnt] := pPtr;
  Inc(personCnt);
  allPersons[personCnt] := sPtr;
  Inc(personCnt);
  allPersons[personCnt] := sPtr2;
  Inc(personCnt);
  allPersons[personCnt] := sPtr3;
  Inc(personCnt);
  allPersons[personCnt] := tPtr;
  
  WriteLn; WriteLn('all persons greet');
  FOR i := 1 TO personCnt DO
    allPersons[i]^.Greet;
  WriteLn('end greeting');

  Dispose(tPtr, Done);

  Dispose(sPtr3, Done);
  Dispose(sPtr2, Done);
  Dispose(sPtr, Done);
END. (*Persons03*)