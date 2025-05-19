{$N+}
PROGRAM MandelbrotSet;

USES
  Crt, Graph;

CONST
  ESCAPE_RADIUS = 2.0;

VAR
  gDriver, gMode: INTEGER;
  x, y: INTEGER;
  realPart, imagPart: REAL;
  realMin, realMax, imagMin, imagMax: REAL;
  iter: INTEGER;
  zReal, zImag, tempReal: REAL;
  screenWidth, screenHeight: INTEGER;
  realScale, imagScale: REAL;
  paramString: STRING;
  paramValue: REAL;
  paramCode: INTEGER;
  maxIterations: INTEGER;
  iterations: INTEGER;

PROCEDURE Beep;
BEGIN
  Sound(1000);
  Delay(500);
  NoSound;
END;

PROCEDURE Header;
BEGIN
  TextColor(14);
  WriteLn('GTFractals for MS-DOS');
  Writeln('(c)Copyright 1992-2025 by Gennaro Eduardo Tangari.');
  TextColor(7);
  Writeln;
END;

PROCEDURE ShowParameters;
BEGIN
  TextColor(15);
  Writeln; Writeln('Here the provided parameters:');
  Write('X-Min: '); TextColor(7); Writeln(realMin:2:8);
  TextColor(15);
  Write('X-Max: '); TextColor(7); Writeln(realMax:2:8);
  TextColor(15);
  Write('Y-Min: '); TextColor(7); Writeln(imagMin:2:8);
  TextColor(15);
  Write('Y-Max: '); TextColor(7); Writeln(imagMax:2:8);
  TextColor(15);
  Write('Iteractions: '); TextColor(7); Writeln(maxIterations);
  Writeln;
END;

BEGIN
  ClrScr; Beep; Header;
  TextColor(15);
  Write('X-Min');
  TextColor(7);
  Write(' (default = -2.25): ');
  Readln(paramString);

  IF paramString = '' THEN
    realMin := -2.25
  ELSE
  BEGIN
    Val(paramString, paramValue, paramCode);
    realMin := paramValue;
  END;

  TextColor(15);
  Write('X-Max');
  TextColor(7);
  Write(' (default = 0.75): ');
  Readln(paramString);

  IF paramString = '' THEN
    realMax := 0.75
  ELSE
  BEGIN
    Val(paramString, paramValue, paramCode);
    realMax := paramValue;
  END;

  TextColor(15);
  Write('Y-Min');
  TextColor(7);
  Write(' (default = -1.5): ');
  Readln(paramString);

  IF paramString = '' THEN
    imagMin := -1.5
  ELSE
  BEGIN
    Val(paramString, paramValue, paramCode);
    imagMin := paramValue;
  END;

  TextColor(15);
  Write('Y-Max');
  TextColor(7);
  Write(' (default = 1.5): ');
  Readln(paramString);

  IF paramString = '' THEN
    imagMax := 1.5
  ELSE
  BEGIN
    Val(paramString, paramValue, paramCode);
    imagMax := paramValue;
  END;

  TextColor(15);
  Write('Iterations');
  TextColor(7);
  Write(' (default = 150): ');
  Readln(paramString);

  IF paramString = '' THEN
    maxIterations := 150
  ELSE
  BEGIN
    Val(paramString, iterations, paramCode);
    maxIterations := iterations;
  END;

  ShowParameters;

  TextColor(15 + Blink);
  WriteLn('Press <ENTER> to start');
  ReadLn;
  gDriver := Detect;
  gMode := VGAMed;
  InitGraph(gDriver, gMode, 'C:\SOFTWARE\TP\BGI');

  screenWidth := GetMaxX;
  screenHeight := GetMaxY;

  realScale := (realMax - realMin) / screenWidth;
  imagScale := (imagMax - imagMin) / screenHeight;

  FOR y := 0 TO screenHeight DO
  BEGIN
    imagPart := imagMin + y * imagScale;

    FOR x := 0 TO screenWidth DO
    BEGIN
      realPart := realMin + x * realScale;

      zReal := 0.0;
      zImag := 0.0;
      iter := 0;

      WHILE (Sqr(zReal) + Sqr(zImag) <= Sqr(ESCAPE_RADIUS)) AND (iter < maxIterations) DO
      BEGIN
        tempReal := Sqr(zReal) - Sqr(zImag) + realPart;
        zImag := 2.0 * zReal * zImag + imagPart;
        zReal := tempReal;
        Inc(iter);
      END;

      IF iter = maxIterations THEN
        PutPixel(x, y, 0)
      ELSE
        PutPixel(x, y, (iter MOD 15) + 1);
    END;
  END;

  Beep; ReadLn;
  CloseGraph;
  TextColor(15);
  WriteLn('Thanks for using GTFractals, goodbye!');
  TextColor(7); Write('Press <ENTER> to quit'); ReadLn;
  clrscr;
END.