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
  WriteLn('GTFractals for MS-DOS');
  WriteLn('(c)Copyright 1992-2025 by Gennaro Eduardo Tangari.');
  WriteLn;
END;

PROCEDURE ShowParameters;
BEGIN
  WriteLn; WriteLn('Here the provided parameters:');
  WriteLn('X-Min: ', realMin);
  WriteLn('X-Max: ', realMax);
  WriteLn('Y-Min: ', imagMin);
  WriteLn('Y-Max: ', imagMax);
  WriteLn('Iteractions: ', maxIterations);
  WriteLn;
END;

BEGIN
  ClrScr; Beep; Header;

  Write('X-Min (default = -2.25): ');
  ReadLn(paramString);

  IF paramString = '' THEN
    realMin := -2.25
  ELSE
  BEGIN
    Val(paramString, paramValue, paramCode);
    realMin := paramValue;
  END;

  Write('X-Max (default = 0.75): ');
  ReadLn(paramString);

  IF paramString = '' THEN
    realMax := 0.75
  ELSE
  BEGIN
    Val(paramString, paramValue, paramCode);
    realMax := paramValue;
  END;

  Write('Y-Min (default = -1.5): ');
  ReadLn(paramString);

  IF paramString = '' THEN
    imagMin := -1.5
  ELSE
  BEGIN
    Val(paramString, paramValue, paramCode);
    imagMin := paramValue;
  END;

  Write('Y-Max (default = 1.5): ');
  ReadLn(paramString);

  IF paramString = '' THEN
    imagMax := 1.5
  ELSE
  BEGIN
    Val(paramString, paramValue, paramCode);
    imagMax := paramValue;
  END;

  Write('Iterations (default = 150): ');
  ReadLn(paramString);

  IF paramString = '' THEN
    maxIterations := 150
  ELSE
  BEGIN
    Val(paramString, iterations, paramCode);
    maxIterations := iterations;
  END;

  ShowParameters;

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
        iter := iter + 1;
      END;

      IF iter = maxIterations THEN
        PutPixel(x, y, 0)
      ELSE
        PutPixel(x, y, (iter MOD 15) + 1);
    END;
  END;

  Beep; ReadLn;
  CloseGraph;
  ClrScr;
  WriteLn('Thanks for using GTFractals!');
END.