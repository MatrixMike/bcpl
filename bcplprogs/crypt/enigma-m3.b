/*
  This is a simulation of the 3 rotor German Enigma M3 Machine.
  Influenced by a C program written by Fauzan Mirza, and
  by the excellent document and Enigma Machine simulator
  written and implemented by Dirk Rijmenants. I strongly
  recommend you visit the following web sites:

  http://users.telenet.be/d.rijmenants
  www.rijmenants.blogspot.com

  Implemented in BCPL by Martin Richards (c) August 2013

Usage:

Entered by the command: enigma-m3

Input:

?        Print this help info
#rst     Set the left, middle and right hand rotors to r, s and t
         where r, s and t are single digits in the range 1 to 5
         representing rotors I, II, ..., V.
!abc     Set the ring positions for the left, middle and right
         rotors where a, b and c are letters or numbers in the
         range 1 to 26 separated by spaces.
=abc     Set the start positions of the left, middle and right
         hand rotors.
/B       Select reflector B.
/C       Select reflector C.
+ab      Set swap pairs on the plug board, a, b are letters.
         Setting a letter to itself removes that plug connection.
|        Toggle rotor stepping.
~        Toggle signal tracing.
-        Remove the latest message character, if any.
.        Exit
letter   Add a message letter.
space and newline are ignored.


The following is an example encrypted message (used with permission):

U6Z DE C 1500 = 49 = EHZ TBS =

TVEXS QBLTW LDAHH YEOEF
PTWYB LENDP MKOXL DFAMU
DWIJD XRJZ=

This was sent on the 31 day of the month from C to U6Z at 1510 and
contains 49 letters.

The recipient had the secret daily key sheet containing the following
line for day 31:

31 I II V  06 22 14 PO ML IU KJ NH YT GB VF RE DC  EXS TGY IKJ LOP

This showed that the enigma machine must be set up with rotors I, II
and V in the left, middle and right positions, and be given ring
setting 6, 22 and 14, respectively. The plug board should be with set
the 10 specified connections.

The rotor start positions should be set to EHZ then the three letters
TBS typed.  This generates XWB which is the start positions of the
rotors for the body of the message. The first group TVEXS confirms we
have the right daily key since it contains EXS together with two
random letters. Decoding begins at the second group QBLTW. To decode
message using this program type the following:

#125
!6 22 14
+PO+ML+IU+KJ+NH+YT+GB+VF+RE+DC
=EHZ
TBS
=XWB
QBLTW LDAHH YEOEF PTWYB LENDP MKOXL DFAMU DWIJD XRJZ

This generates the following decrypted text (with spaces added).

DER FUEHRER IST TOD X DER KAMPF GEHTWETTER X DOENITZ X 

If you run enigma-m3 with the default settings and type Q, the output
indicates the signal path through the plug board, rotors and
reflector and is as follows:

 ----     ---------     ---------     ---------    -------    - 
|   M|   |J|E     E|   |I|N     N|   |O|B     B|  |M     M|  |M|
| *<L|<<<|I|D<*   D|   |H|M     M|   |N*A     A|  |L     L|  |L|
| v K|   |H|C ^   C|   |G|L     L|   |M|Z     Z|  |K     K|  |K|
| v J|   |G|B ^   B|   |F|K     K|   |L|Y     Y|  |J     J|  |J|
|-v--|   |-|--^----|   |-|-------|   |-|-------|  |-------|  |-|
| v I|   |F*A ^   A|  =|E|J     J|   |K|X     X|  |I     I|  |I|
| v H|   |E|Z ^   Z|   |D|I  *>>I|>>>|J|W>>*  W|  |H     H|  |H|
| *>G|>>>|D|Y>^>* Y|   |C|H  ^  H|   |I|V  v  V|  |G     G|  |G|
|   F|   |C|X ^ v X|   |B|G  ^  G|   |H|U  v  U|  |F     F|  |F|
|----|   |-|--^-v--|   |-|---^---|   |-|---v---|  |-------|  |-|
|   E|   |B|W ^ v W|   |A|F  ^  F|   |G|T  v  T|  |E     E|  |E|
|   D|   |A|V ^ v V|   |Z|E  ^  E|   |F|S  v  S|  |D  *>>D|>>|D|>>D
|   C|   |Z|U ^ v U|   |Y|D  ^  D|   |E|R  *>>R|>>|C>>*  C|  |C|
|   B|   |Y|T ^ v T|   |X|C  ^  C|   |D|Q     Q|  |B     B|  |B|
|----|   |-|--^-v--|   |-|---^---|   |-|-------|  |-------|  |-|
|   A|   [X]S ^ v S|   [W]B  ^  B|   [C]P     P|  |A     A|  |A|
|----|   |-|--^-v--|   |-|---^---|   |-|-------|  |-------|  |-|
|   Z|   |W|R ^ v R|   |V*A  ^  A|   |B|O     O|  |Z     Z|  |Z|
|   Y|   |V|Q ^ v Q|   |U|Z  ^  Z|   |A|N     N|  |Y     Y|  |Y|
|   X|   |U|P ^ v P|   |T|Y  ^  Y|  =|Z|M     M|  |X     X|  |X|
|   W|   |T|O ^ *>O|>>>|S|X>>*  X|   |Y|L     L|  |W     W|  |W|
|----|   |-|--^----|   |-|-------|   |-|-------|  |-------|  |-|
|   V|   |S|N ^   N|   |R|W     W|   |X|K     K|  |V     V|  |V|
|   U|   |R|M ^   M|   |Q|V     V|   |W|J     J|  |U     U|  |U|
|   T|  =|Q|L ^   L|   |P|U  *<<U|<<<|V|I<<*  I|  |T     T|  |T|
|   S|   |P|K ^   K|   |O|T  v  T|   |U|H  ^  H|  |S     S|  |S|
|----|   |-|--^----|   |-|---v---|   |-|---^---|  |-------|  |-|
|   R|   |O|J ^   J|   |N|S  v  S|   |T|G  ^  G|  |R     R|  |R|
|   Q|   |N|I ^   I|   |M|R  v  R|   |S|F  *<<F|<<|Q<<<<<Q|<<|Q|<<Q
|   P|   |M|H ^   H|   |L|Q  v  Q|   |R|E     E|  |P     P|  |P|
|   O|   |L|G *<<<G|<<<|K|P<<*  P|   |Q|D     D|  |O     O|  |O|
|   N|   |K|F     F|   |J|O     O|   |P|C     C|  |N     N|  |N|
 ----     ---------     ---------     ---------    -------    - 
refl B     rotor I       rotor II      rotor V      plugs    kbd
*/

GET "libhdr"

GLOBAL
{ rotor:ug
  rotorI;   notchI
  rotorII;  notchII
  rotorIII; notchIII
  rotorIV;  notchIV
  rotorV;   notchV
  rotorLname; rotorMname; rotorRname
  reflectorB
  reflectorC
  reflectorname
  // Ring and notch settings of the selected rotors
  ringL;  ringM;  ringR
  notchL; notchM; notchR

  // Rotor start positions at the beginning of the message
  initposL; initposM; initposR
  // Rotor current positions
  posL; posM; posR; 

  inchar    // String of input characters
  outchar   // String of output characters
  len
  ch        // Current keyboard character

  stepping  // =FALSE to stop the rotors from stepping
  tracing   // =TRUE causes signal tracing output

  rdrotor
  rdringsetting

  newvec
  spacev; spacep; spacet

  // The following vectors have subscripts from 0 to 25
  // representing letters A to Z
  plugboard 
  rotorFR; rotorFM; rotorFL
  reflector
  rotorBL; rotorBM; rotorBR // Inverse rotors

  // Variables for printing signal path
  pluginF
  rotorRinF; rotorMinF; rotorLinF
  reflin
  rotorLinB; rotorMinB; rotorRinB
  pluginB; plugoutB
}


LET newvec(upb) = VALOF
{ LET p = spacep - upb -1
  IF p<spacev DO
  { writef("More space needed*n")
    RESULTIS 0
  }
  spacep := p
  RESULTIS p
}

LET setvec(str, v) BE
  IF v FOR i = 0 TO 25 DO v!i := str%(i+1) - 'A'

LET setrotor(str, rf, rb) BE
  IF rf & rb FOR i = 0 TO 25 DO
  { rf!i := str%(i+1)-'A'; rb!(rf!i) := i }

LET pollrdch() = VALOF
{ LET ch = sys(Sys_pollsardch)
  IF ch=-3 DO
  { delay(100) // Wait 100 msecs
    LOOP       // and try again
  }
  RESULTIS ch
} REPEAT

LET start() = VALOF
{ LET argv = VEC 50

  UNLESS rdargs("-t/s", argv, 50) DO
  { writef("Bad arguments for enigma-m3*n")
    RESULTIS 0
  }

writef("*nEnigma M3 simulator*n")
writef("Type ? for help*n*n")

  tracing := TRUE
  IF argv!0 DO tracing := ~tracing             // -t/s

  spacev := getvec(1000)
  spacet := spacev+1000
  spacep := spacet

// Set the rotor and reflector wirings
// and the notch positions. 

// Input      "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  rotorI   := "EKMFLGDQVZNTOWYHXUSPAIBRCJ";  notchI   := 'Q'
  rotorII  := "AJDKSIRUXBLHWTMCQGZNPYFVOE";  notchII  := 'E'
  rotorIII := "BDFHJLCPRTXVZNYEIWGAKMUSQO";  notchIII := 'V'
  rotorIV  := "ESOVPZJAYQUIRHXLNFTGKDCMWB";  notchIV  := 'J'
  rotorV   := "VZBRGITYUPSDNHLXAWMJQOFECK";  notchV   := 'Z'

  reflectorB := "YRUHQSLDPXNGOKMIEBFZCWVJAT"
  reflectorC := "FVPJIAOYEDRZXWGCTKUQSBNMHL"

// Allocate several vectors
  rotorFL   := newvec(25)
  rotorFM   := newvec(25)
  rotorFR   := newvec(25)
  rotorBL   := newvec(25)
  rotorBM   := newvec(25)
  rotorBR   := newvec(25)
  plugboard := newvec(25)
  reflector := newvec(25)
  inchar    := newvec(255)
  outchar   := newvec(255)

  UNLESS rotorFL & rotorFM & rotorFR &
         rotorBL & rotorBM & rotorBR &
         plugboard & reflector &
         inchar & outchar DO
  { writef("*nMore memory needed*n")
    GOTO fin
  }

// Set default encryption parameters, suitable for the
// example message.

  setvec(reflectorB, reflector)
  reflectorname := "B"
  setrotor(rotorI,  rotorFL, rotorBL)
  rotorLname, notchL := "I  ", notchI  - 'A'
  setrotor(rotorII, rotorFM, rotorBM)
  rotorMname, notchM := "II ", notchII - 'A'
  setrotor(rotorV,  rotorFR, rotorBR)
  rotorRname, notchR := "V  ", notchV  - 'A'
 
  ringL := 06-1; ringM := 22-1; ringR := 14-1

  initposL := 'X'-'A'; posL := initposL
  initposM := 'W'-'A'; posM := initposM
  initposR := 'B'-'A'; posR := initposR

  FOR i = 0 TO 25 DO plugboard!i := i

// Perform +PO+ML+IU+KJ+NH+YT+GB+VF+RE+DC
// to set the plug board.

  setplugpair('P', 'O')
  setplugpair('M', 'L')
  setplugpair('I', 'U')
  setplugpair('K', 'J')
  setplugpair('N', 'H')
  setplugpair('Y', 'T')
  setplugpair('G', 'B')
  setplugpair('V', 'F')
  setplugpair('R', 'E')
  setplugpair('D', 'C')

//writef("Set the the example message string*n")

  {  LET s = "QBLTWLDAHHYEOEFPTWYBLENDPMKOXLDFAMUDWIJDXRJZ"
     len := s%0
     FOR i = 1 TO len DO inchar!(i-1) := s%i
  }

  len := 0
  stepping := TRUE
  ch := '*n'

  { // Start of main input loop
    IF ch='*n' DO { writef("*n> "); deplete(cos); ch := 0 }
    
    UNLESS ch DO rch()

    SWITCHON ch INTO
    { DEFAULT:  LOOP

      CASE endstreamch:
      CASE '.':  BREAK

      CASE '?':
         newline()
         writef("?        Output this help info*n")
         writef("#rst     Set the left, middle and *
                *right hand rotors to r, s and t where*n") 
         writef("         r, s and t are single digits *
                *in the range 1 to 5 representing*n")
         writef("         rotors I, II, ..., V.*n")
         writef("!abc     Set the ring positions for the *
                *left, middle and right rotors where*n")
         writef("         a, b and c are letters or numbers *
                *in the range 1 to 26 separated*n")
         writef("         by spaces.*n")
         writef("=abc     Set the initial positions of the *
                *left, middle and right hand rotors*n")
         writef("/B       Select reflector B*n")
         writef("/C       Select reflector C*n")
         writef("+ab      Set swap pairs on the plug board, *
                *a, b are letters.*n")
         writef("         Setting a letter to itself removes *
                *that plug*n")
         writef("|        Toggle rotor stepping*n")
         writef(",        Print the current settings*n")
         writef("letter   Add a message letter*n")
         writef("-        Remove the latest message *
                *character, if any*n")
         writef(".        Exit*n")
         writef("space and newline are ignored*n")
         ch := '*n'
         LOOP

      CASE '#': // Set left hand rotor
              { LET str = ?
                rch()
                str := rdrotor()        // Rotor string
                rotorLname := result2   // Rotor name
                setrotor(str, rotorFL, rotorBL)
                str := rdrotor()        // Rotor string
                rotorMname := result2   // Rotor name
                setrotor(str, rotorFM, rotorBM)
                str := rdrotor()        // Rotor string
                rotorRname := result2   // Rotor name
                setrotor(str, rotorFR, rotorBR)
                writef("*nRotors: %s %s %s*n", rotorLname, rotorMname, rotorRname)
                encodestr()
                ch := '*n'
                LOOP                
              }

      CASE '!': // Set ring positions
                rch()
                ringL := rdringsetting(); rch()
                ringM := rdringsetting(); rch()
                ringR := rdringsetting()
                writef("*nRing settings: %c%c%c*n", ringL+'A', ringM+'A', ringR+'A')
                encodestr()
                ch := '*n'
                LOOP                


      CASE '=': // Set the rotor positions
                rch()
                initposL := rdlet() - 'A'; rch()
                initposM := rdlet() - 'A'; rch()
                initposR := rdlet() - 'A'
                writef("*nRotor positions: %c%c%c*n", initposL+'A', initposM+'A', initposR+'A')
                encodestr()
                ch := '*n'
                LOOP
                
      CASE '/': rch()  // Set reflector B or C
                IF ch = 'B' DO
                { setvec(reflectorB, reflector)
                  reflectorname := "B"
                  encodestr()
                  ch := '*n'
                  LOOP
                }
                IF ch = 'C' DO
                { setvec(reflectorC, reflector)
                  reflectorname := "C"
                  encodestr()
                  ch := '*n'
                  LOOP
                }
                writef("*nShould be /B or /C*n")
                ch := '*n'
                LOOP
 
      CASE '+': // Set a plug board pair
              { LET a, b, c = ?, ?, ?
                rch()
                a := capitalch(ch)
                rch()
                b := capitalch(ch)
                UNLESS 'A'<=a<='Z' & 'A'<=b<='Z' DO
                { writef("+ should be followed by two *
                         *letters, eg +AB*n")
                  LOOP
                }
                setplugpair(a, b)
                encodestr()
                ch := '*n'
                LOOP
              }

      CASE ',': // Print the settings
                newline()
                writef("Rotors:            %s %s %s*n",
                        rotorLname, rotorMname, rotorRname)
                writef("Notches:           %c %c %c*n",
                        notchL+'A', notchM+'A', notchR+'A')
                writef("Ring setting:      %c-%z2 %c-%z2 %c-%z2*n",
                        ringL+'A', ringL+1,
                        ringM+'A', ringM+1,
                        ringR+'A', ringR+1)
                writef("Current positions: %c %c %c*n",
                       posL+'A', posM+'A', posR+'A')
                writef("Plug board:        ")
                prplugboardpairs()
                newline()
                ch := '*n'
                LOOP

      CASE '-': // Remove one message character
                IF len>0 DO len := len-1
                encodestr()
                ch := '*n'
                LOOP

      CASE '~': // Toggle signal tracing
                tracing := ~tracing
                TEST tracing
                THEN writef("*nSignal tracing now on*n")
                ELSE writef("*nSignal tracing turned off*n")
                ch := '*n'
                LOOP

      CASE 'A':CASE 'B':CASE 'C':CASE 'D':CASE 'E':
      CASE 'F':CASE 'G':CASE 'H':CASE 'I':CASE 'J':
      CASE 'K':CASE 'L':CASE 'M':CASE 'N':CASE 'O':
      CASE 'P':CASE 'Q':CASE 'R':CASE 'S':CASE 'T':
      CASE 'U':CASE 'V':CASE 'W':CASE 'X':CASE 'Y':
      CASE 'Z':
                len := len + 1
                inchar!len := ch
                outchar!len := enigmafn(ch-'A') + 'A'
                encodestr()
                ch := '*n'
                LOOP

    }
  } REPEAT

  newline()

fin:
  IF spacev DO freevec(spacev)

  RESULTIS 0
}

AND setplugpair(a, b) BE
{ // a and b are capital letters
  LET c = ?
  a := a - 'A'
  b := b - 'A'
  c := plugboard!a
  UNLESS plugboard!a = a DO
  { // Remove previous pairing for a
    plugboard!a := a
    plugboard!c := c
  }
  c := plugboard!b
  UNLESS plugboard!b = b DO
  { // Remove previous pairing for b
    plugboard!b := b
    plugboard!c := c
  }
  UNLESS a=b DO
  { // Set swap pair (a, b).
    plugboard!a := b
    plugboard!b := a
  }
}

AND rdlet() = VALOF
{ LET res = ch
  UNLESS 'A'<=res<='Z' DO
    writef("*n%c is not a letter*n", res)
  RESULTIS res
}

AND rch() BE
{ // Read a keyboard key as soon as it is pressed.
  ch := capitalch(pollrdch())
  wrch(ch)
  deplete(cos)
}

AND rdrotor() = VALOF
{ // Returns the rotor wiring string
  // result2 is the rotor name: I, II, III, IV or V
  WHILE ch='*s' DO rch()

  IF ch='1' DO { rch(); result2 := "I  "; RESULTIS rotorI  }
  IF ch='2' DO { rch(); result2 := "II "; RESULTIS rotorII }
  IF ch='3' DO { rch(); result2 := "III"; RESULTIS rotorIII}
  IF ch='4' DO { rch(); result2 := "IV "; RESULTIS rotorIV }
  IF ch='5' DO { rch(); result2 := "V  "; RESULTIS rotorV  }
  IF ch='I' DO { rch()
                 IF ch='V' DO
                 { rch(); result2 := "IV "; RESULTIS rotorIV}
                 result2 := "I  "
                 UNLESS ch='I' RESULTIS rotorI
                 rch()
                 result2 := "II "
                 UNLESS ch='I' RESULTIS rotorII
                 rch()
                 result2 := "III"
                 UNLESS ch='I' RESULTIS rotorIII
               }
  IF ch='V' DO { rch(); result2 := "V  "; RESULTIS rotorV}
  RESULTIS 0
}

AND rdringsetting() = VALOF
{ // Return 0 to 25 representing ring setting A to Z

  WHILE ch='*s' DO rch()

  IF 'A'<=ch<='Z' RESULTIS ch - 'A'

  IF '0'<= ch <= '9' DO
  { LET n = ch-'0'
    rch()
    IF '0'<= ch <= '9' DO n := 10*n + ch - '0'
    // n = 1 to 26 represent ring settings of A to Z
    // encoded as 0 to 25
    IF 1<=n<=26 RESULTIS n - 1
    RESULTIS 0
  }
}

AND prplugboardpairs() BE FOR a = 0 TO 25 DO
{ // Print plug board pairs in alphabetical order
  LET b = plugboard!a
  IF a < b DO writef("%c%c ", a+'A', b+'A')
}

AND rotorfn(x, map, rot) = VALOF
{ LET a = (x-rot+52) MOD 26
  LET b = map!a
  LET c = (b+rot+52) MOD 26
  RESULTIS c
}

AND step_rotors() BE IF stepping DO
{ LET advM = posR=notchR | posM=notchM
  LET advL = posM=notchM

  // Always step the right hand rotor
  posR := (posR+1) MOD 26
  // Possibly step the middle rotor
  IF advM DO posM := (posM+1) MOD 26
  // Possibly step the left rotor
  IF advL DO posL := (posL+1) MOD 26
}

AND encodestr() BE
{ // Set initial state
  posL, posM, posR := initposL, initposM, initposR
  // The rotor numbers and ring settings are already set up.
  IF len=0 RETURN

  FOR i = 1 TO len DO
  { LET x = inchar!i - 'A'         // letter to encode
    IF stepping DO step_rotors()
    outchar!i := enigmafn(x) + 'A'
    IF tracing DO prsigpath()
  }
  UNLESS tracing DO writef(" %c", plugoutB+'A')
}

AND enigmafn(x) = VALOF
{ // Plug board
  pluginF := x
  rotorRinF := plugboard!pluginF
  // Rotors right to left
  rotorMinF := rotorfn(rotorRinF, rotorFR, ringR-posR)
  rotorLinF := rotorfn(rotorMinF, rotorFM, ringM-posM)
  reflin    := rotorfn(rotorLinF, rotorFL, ringL-posL)
  // Reflector
  rotorLinB := reflector!reflin
  // Rotors left to right
  rotorMinB := rotorfn(rotorLinB, rotorBL, ringL-posL)
  rotorRinB := rotorfn(rotorMinB, rotorBM, ringM-posM)
  pluginB   := rotorfn(rotorRinB, rotorBR, ringR-posR)
  // Plugboard
  plugoutB := plugboard!pluginB

  RESULTIS plugoutB
}

// The following functions are used to output an
// ASCII graphics representation of the signal path
// through the machine when decoding the latest letter.
// All the arguments are in the range 0 to 25
// representing A to Z except n which may be 26.

AND prsigwiring(n, sp, inF, outF, inB, outB) BE
{ LET c1,c2,c3=' ',' ',' '
  // The following represent wire positions with
  // 13 for A, 14 for B, etc
  LET iF = (inF +13) MOD 26
  LET oF = (outF+13) MOD 26
  LET iB = (inB +13) MOD 26
  LET oB = (outB+13) MOD 26

  LET Flo,Fhi,Blo,Bhi = iF,oF,iB,oB
  LET aF, aB = '^','^'

  IF iF>oF DO Flo,Fhi,aF := oF,iF,'v'
  IF iB>oB DO Blo,Bhi,aB := oB,iB,'v'
  // aF and aB = ^ or v giving the vertical direction
  //             for the forward and backward paths.
  // n = the machine line number in range 0 to 26
  //     by convention n=13 for position A
  // sp = TRUE for space lines
  // c1, c2 and c3 are for the three wiring characters
  //               for this line.

  IF sp DO
  { // Find every space line containing no wires.
    IF n>Fhi & n>Bhi   |
       n<=Flo & n<=Blo |
       Bhi<n<=Flo      |
       Fhi<n<=Blo      DO
    { writef("---") // Draw a space line with no wires.
      RETURN
    }
    c1,c2,c3 := '-','-','-'
  }

  // Find all non space lines containing no wires.
  IF n>Fhi & n>Bhi |
     n<Flo & n<Blo |
     Bhi<n<Flo     |
     Fhi<n<Blo     DO
  { // Non space line at position n contains no wires.
    writef("   ")
    RETURN
  }

  // Position n contains at least one wire.

  IF Flo>Bhi |
     Blo>Fhi DO
  { // There is only one wire at this region so
    // the middle column can be used.
    UNLESS sp DO
    { IF iF=n=oF DO { writef("<<<"); RETURN }
      IF iB=n=oB DO { writef(">>>"); RETURN }
      // Position n has an up or down going wire.
      IF n=iF DO { writef(" **<"); RETURN }
      IF n=oF DO { writef("<** "); RETURN }
      IF n=iB DO { writef(">** "); RETURN }
      IF n=oB DO { writef(" **>"); RETURN }
    }
    IF Flo<n<=Fhi DO c2 := aF
    IF Blo<n<=Bhi DO c2 := aB

    writef("%c%c%c", c1, c2,c3)
    RETURN
  }

  IF iB<oF<iF & oB<iF |
     iF<oB & iF<oF<iB DO
  { // With the F wire on the left, the wires can be
    // drawn without crossing.
    TEST sp
    THEN { // This is a space line
           // so only contains vertical wires
           IF Flo<n<=Fhi DO c1 := aF
           IF Blo<n<=Bhi DO c3 := aB
         }
    ELSE { // This is a non space line
           IF n=iF DO c1,c2,c3 := '**','<','<'
           IF n=oF DO c1 := '**'
           IF n=iB DO c1,c2,c3 := '>','>','**'
           IF n=oB DO c3 := '**'
           IF Flo<n<Fhi DO c1 := aF
           IF Blo<n<Bhi DO c3 := aB
         }
    writef("%c%c%c", c1,c2,c3)
    RETURN
  }

  IF oB<iF<oF & iB<oF |
     oF<iB & oF<iF<oB DO
  { // With the F wire on the right, the wires can be
    // drawn without crossing.
    TEST sp
    THEN { // This is a space line
           // so only contains vertical wires
           IF Flo<n<=Fhi DO c3 := aF
           IF Blo<n<=Bhi DO c1 := aB
            }
    ELSE { // This is a non space line
           IF n=oF DO c1,c2,c3 := '<','<','**'
           IF n=iF DO c3 := '**'
           IF n=oB DO c1,c2,c3 := '**','>','>'
           IF n=iB DO c1 := '**'
           IF Flo<n<Fhi DO c3 := aF
           IF Blo<n<Bhi DO c1 := aB
         }
    writef("%c%c%c", c1,c2,c3)
    RETURN
  }

  // There are two wires that must cross.

  IF iF=oF DO
  { // The B wire can use the centre column.
    c2 := aB
    TEST sp
    THEN { IF n=Blo DO c2 := '-'
         }
    ELSE { IF n=iF DO c1,c3 := '<','<'
           IF n=iB DO c1,c2 := '>','**'
           IF n=oB DO c2,c3 := '**','>'
         }
    writef("%c%c%c", c1,c2,c3)
    RETURN
  }

  IF iB=oB DO
  { // The F wire can use the centre column.
    c2 := aF
    TEST sp
    THEN { IF n=Flo DO c2 := '-'
         }
    ELSE { IF n=iB DO c1,c3 := '>','>'
           IF n=oF DO c1,c2 := '<','**'
           IF n=iF DO c2,c3 := '**','<'
         }
    writef("%c%c%c", c1,c2,c3)
    RETURN
  }

  // Test whether the F and B signals enter at the
  // same level, and leave at the same level.
  // Note that iF cannot equal oB,
  //      and  iB cannot equal oF.
  IF iF=iB &
     oF=oB TEST Fhi-Flo<=2
  THEN { // No room for a cross over
         TEST sp
         THEN { IF n>iF | n>oF DO c2 := '|'
              }
         ELSE { IF Flo<n<Fhi DO c2 := '|'
                IF n=iF DO c1,c2,c3 := '>','**','<'
                IF n=oF DO c1,c2,c3 := '<','**','>'
              }
         writef("%c%c%c", c1,c2,c3)
         RETURN
       }
  ELSE { // The gap between iF and oF is more than 1 line
         // so the F wire can use the centre column and
         // the B wire can cross it half way down.
         LET m = (iF+oF)/2
         // Place the F wire down the centre.
         c2 := aF
         IF n=iF DO c2,c3 := '**','<'
         IF n=oF DO c1,c2 := '<','**'
         // Now place the B wire, crossing half way down.
         TEST iB>oB
         THEN { IF n>=m DO c1 := aB
                IF n<=m DO c3 := aB
              }
         ELSE { IF n>=m DO c3 := aB
                IF n<=m DO c1 := aB
              }
         UNLESS sp DO
         { IF n=iB DO c1 := '**'
           IF n=oB DO c3 := '**'
           IF n=m DO c1,c2,c3 := '**','>','**'
         }
         writef("%c%c%c", c1,c2,c3)
         RETURN
       }

  IF Flo<iB<Fhi |
     Blo<iF<Bhi DO
  { // The F wire can be on the left.
    IF Flo<n<=Fhi DO c1 := aF
    IF Blo<n<=Bhi DO c3 := aB

    UNLESS sp DO
    { IF n=iF DO c1,c2,c3 := '**','<','<'
      IF n=iB DO c2,c3 := '>','**'
      IF n=oF DO c1 := '**'
      IF n=oB DO c3 := '**'
    }
    writef("%c%c%c", c1,c2,c3)
    RETURN
  }

  IF Flo<oB<Fhi |
     Blo<oF<Bhi DO
  { // The F wire can be on the right.
    IF Flo<n<=Fhi DO c3 := aF
    IF Blo<n<=Bhi DO c1 := aB

    UNLESS sp DO
    { IF n=iF DO c3 := '**'
      IF n=iB DO c1 := '**'
      IF n=oF DO c1,c2,c3 := '<','<','**'
      IF n=oB DO c1,c2 := '**','>'
    }
    writef("%c%c%c", c1,c2,c3)
    RETURN
  }

  // There should be no other possibilities
  writef("???")
}

AND prsigreflector(n, sp, inF, outB) BE
{ LET letter = (n+13) MOD 26 + 'A'
  LET c0, c1, c2, c3 = '|', ' ', ' ', ' '
  LET c4, c5, c6 = letter, '|', ' '
  LET iF = (inF  +13) MOD 26
  LET oB = (outB +13) MOD 26

  TEST sp
  THEN { c1,c2,c3,c4 := '-', '-','-','-'
         IF iF<n<=oB DO c2 := '^'
         IF iF>=n>oB DO c2 := 'v'
         IF n=0 | n=26 DO c0,c5 := ' ',' '
       }
  ELSE { IF iF=n | oB=n DO c2 := '**'
         IF iF<n<oB DO c2 := '^'
         IF iF>n>oB DO c2 := 'v'
         IF iF=n DO c3,c6 := '<','<'
         IF oB=n DO c3,c6 := '>','>'
       }
  writef("%c%c%c%c%c%c%c%c", c0,c1,c2,c3,c4,c5,c6,c6)
}

AND prsigrotor(n, sp, pos, ring, notch,
               inF, outF, inB, outB) BE
{ // All the signals are in range 0 to 25
  // representing the letters A to Z
  LET let1 = (n+pos+13+26) MOD 26 + 'A'
  LET let2 = (n+pos-ring+13+26) MOD 26 + 'A'
  LET c0,c1,c2,c3,c4 = ' ','|',let1,'|',let2
  LET c5,c6,c7,c8,c9 = ' ',' ',let2,'|',' '
  // The following signals represent positions
  // with 13 corresponding to A, 14 to B, etc
  LET iF = (inF+13) MOD 26
  LET iB = (inB+13) MOD 26
  LET oF = (outF+13) MOD 26
  LET oB = (outB+13) MOD 26
  LET nch = (notch-pos+13+52) MOD 26
  LET r = (ring-pos+13+52) MOD 26

  TEST sp
  THEN { c2,c3,c4,c5 := '-','|','-','-'
         c6,c7 := '-','-'
         IF n=0 | n=26 DO c1,c3,c8 := ' ','-',' '
       }
  ELSE { IF n=iF DO c6,c9 := '<','<'
         IF n=oB DO c6,c9 := '>','>'
         IF n=oF DO c0,c5 := '<','<'
         IF n=iB DO c0,c5 := '>','>'
         IF n=nch DO c0 := '='
         IF n=r DO c3 := '**'
         IF n=13 DO c1,c3 := '[',']'
       }
  writef("%c%c%c%c%c%c", c0,c1,c2,c3,c4,c5)
  prsigwiring(n, sp, inF, outF, inB, outB)
  writef("%c%c%c%c%c", c6,c7,c8,c9,c9)
}

AND prsigplug(n, sp, inF, outF, inB, outB) BE
{ LET letter = (n-13+26) MOD 26 +'A'
  LET c0, c1, c2 = '|', letter, ' '
  LET c3, c4, c5, c6 = ' ', letter, '|', ' '
  LET iF = (inF-13+26) MOD 26
  LET oF = (outF-13+26) MOD 26
  LET iB = (inB-13+26) MOD 26
  LET oB = (outB-13+26) MOD 26

  TEST sp
  THEN { c1,c2,c3,c4 := '-','-','-','-'
         IF n=0 | n=26 DO c0,c5,c6 := ' ',' ',' '
       }
  ELSE { IF n=iF DO c3,c6 := '<','<'
         IF n=oF DO c2 := '<'
         IF n=iB DO c2 := '>'
         IF n=oB DO c3,c6 := '>','>'
       }
  writef("%c%c%c", c0,c1,c2)
  prsigwiring(n, sp, inF,outF,inB,outB)
  writef("%c%c%c%c%c", c3,c4,c5,c6,c6)
}

AND prsigkbd(n, sp, inF, outB) BE
{ LET letter = (n-13+26) MOD 26 + 'A'
  LET c0,c1,c2 = '|',letter,'|'

  LET iF = (inF-13+26) MOD 26
  LET oB = (outB-13+26) MOD 26

  IF sp DO
  { c1 := '-'
    IF n=0 | n=26 DO c0,c2 := ' ',' '
  }

  writef("%c%c%c", c0,c1,c2)
  IF n=iF UNLESS sp DO { writef("<<%c", letter); RETURN }
  IF n=oB UNLESS sp DO { writef(">>%c", letter); RETURN }
}

AND prsigline(n, sp) BE
{ prsigreflector(n, sp, reflin, rotorLinB)
  prsigrotor(n, sp, posL, ringL, notchL,
             rotorLinF, reflin, rotorLinB, rotorMinB)
  prsigrotor(n, sp, posM, ringM, notchM,
             rotorMinF, rotorLinF, rotorMinB, rotorRinB)
  prsigrotor(n, sp, posR, ringR, notchR,
             rotorRinF, rotorMinF, rotorRinB, pluginB)
  prsigplug(n, sp, pluginF, rotorRinF, pluginB, plugoutB)
  prsigkbd(n, sp, pluginF, plugoutB)
  newline()
}

AND prsigpath() BE
{ LET coreL = (posL - ringL + 26) MOD 26
  LET coreM = (posM - ringM + 26) MOD 26
  LET coreR = (posR - ringR + 26) MOD 26

  newline()
  prsigline(26, TRUE)
  prsigline(25, FALSE)
  prsigline(24, FALSE)
  prsigline(23, FALSE)
  prsigline(22, FALSE)
  prsigline(22, TRUE)
  prsigline(21, FALSE)
  prsigline(20, FALSE)
  prsigline(19, FALSE)
  prsigline(18, FALSE)
  prsigline(18, TRUE)
  prsigline(17, FALSE)
  prsigline(16, FALSE)
  prsigline(15, FALSE)
  prsigline(14, FALSE)
  prsigline(14, TRUE)
  prsigline(13, FALSE)
  prsigline(13, TRUE)
  prsigline(12, FALSE)
  prsigline(11, FALSE)
  prsigline(10, FALSE)
  prsigline( 9, FALSE)
  prsigline( 9, TRUE)
  prsigline( 8, FALSE)
  prsigline( 7, FALSE)
  prsigline( 6, FALSE)
  prsigline( 5, FALSE)
  prsigline( 5, TRUE)
  prsigline( 4, FALSE)
  prsigline( 3, FALSE)
  prsigline( 2, FALSE)
  prsigline( 1, FALSE)
  prsigline( 0, FALSE)
  prsigline( 0, TRUE)
  writef("refl %s  ",  reflectorname)
  writef("   rotor %s  ", rotorLname)
  writef("   rotor %s  ", rotorMname)
  writef("   rotor %s  ", rotorRname)
  writef("  plugs  ")
  writef("  kbd*n")
}
