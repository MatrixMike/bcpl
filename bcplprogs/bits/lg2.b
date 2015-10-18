// This program tries out various methods to compute lg2(s) where
// n = lg2(s) is the minimum integer such that 2**n >= s 

// Implemented in Cintcode BCPL by Martin Richards (c) Mar 2003

GET "libhdr"

LET start() = VALOF
{ LET t = TABLE //         Cintcode instruction executed

  //  test data  result  lg2  lg2a lg2b lg2c lg2d lg2e lg2f lg2g lg2h lg2i lg2j

     #x00000000, //  0:    3   39    3   10   30   19   19   19   32   32   32 
     #x00000001, //  0:  290   39   37   10   30   19   19   19   32   32   32 
     #x00000012, //  5:  255   39   40   60   30   26   19   19   32   32   32 
     #x00000123, //  9:  219   39   40  100   30   30   26   26   32   32   32 
     #x00001234, // 13:  183   39   44  140   30   34   30   26   32   32   32 
     #x00001FFF, // 13:  183   39   44  140   30   34   30   26   32   32   32 
     #x00004000, // 14:  164   39   49  150   31   34   30   26   32   32   32 
     #x00008000, // 15:  155   39   53  160   31   34   30   26   32   32   32 
     #x0000FFFF, // 16:  156   39   52  170   30   34   30   26   32   32   32 
     #x00010000, // 16:  146   39   41  170   31   38   30   30   32   32   32 
     #x00012345, // 17:  147   39   40  180   30   38   30   30   32   32   32 
     #x00123456, // 21:  111   39   44  220   30   42   34   30   32   32   32 
     #x01234567, // 25:   75   39   44  260   30   46   38   30   32   32   32 
     #x10101010, // 29:   39   39   48  300   30   46   38   30   32   32   32 
     #x12345678, // 29:   39   39   48  300   30   46   38   30   32   32   32 
     #x20202020, // 30:   30   39   52  310   30   46   38   30   32   32   32 
     #x40000000, // 30:   20   39   53  310   31   46   38   30   32   32   32 
     #x40404040, // 31:   21   39   52  315   30   46   38   30   32   32   32 
     #x7FF23456, // 31:   21   39   52  315   30   46   38   30   32   32   32 
     #x7FFFFFFF, // 31:   21   39   52  315   30   46   38   30   32   32   32 
     #x80000000, // 31:   11   39   57    6   31   46   38   30   32   32   32 
     #x80808080, // 32:   12   39   56    6   30   46   38   30   32   32   32 
     #x87654321, // 32:   12   39   56    6   30   46   38   30   32   32   32 
     #xF0F0F0F0, // 32:   12   39   56    6   30   46   38   30   32   32   32 
     #xFFFFFFFF  // 32:   12   39   56    6   30   46   38   30   32   32   32 

  writef("*nTest various implementations of lg2*n*n")

  { trial(!t)
    IF !t=-1 BREAK
    t := t+1
  } REPEAT
  //FOR i = 0 TO 31 DO { trial(1<<i); trial(1<<i | 1); trial(3<<i) }
  writef("*n*nEnd of test*n")
  RESULTIS 0
}

AND trial(s) BE
{ LET n = lg2(s)
  writef("%x8 %i2: ", s, n)
  try(s, lg2);  try(s, lg2a); try(s, lg2b); try(s, lg2c)
  try(s, lg2d); try(s, lg2e); try(s, lg2f); try(s, lg2g)
  try(s, lg2h); try(s, lg2i); try(s, lg2j)
  newline()
}

AND try(w, f) BE writef(" %i3%c", instrcount(f, w), lg2(w)=f(w) -> ' ', '#')

AND lg2(s) = s=0 -> 0, VALOF
{ LET n = 31
  UNTIL s<0 DO s, n := s<<1, n-1
  RESULTIS s<<1 -> n+1, n
}

AND lg2a(w) = VALOF
{ LET t = TABLE  0, 1,26, 2,23,27,-1, 3,16,24,30,28,11,-1,13, 4, 7,17,
                -1,25,22,31,15,29,10,12, 6,-1,21,14, 9, 5,20, 8,19,18,-1
  LET c = (w = (w & -w)) + 1 // =0 if w is exact power of 2, =1 otherwise
  w := w | w>>1
  w := w | w>>2
  w := w | w>>4
  w := w | w>>8
  w := w | w>>16
  RESULTIS t!((w>>1) REM 37) + c
}

AND lg2b(w) = w=0 -> 0, VALOF
{ LET r = w = (w & -w) -> 0, 1
  LET a = ?
  a := w>>16; IF a DO w, r := a, r + 16
  a := w>> 8; IF a DO w, r := a, r + 8
  a := w>> 4; IF a DO w, r := a, r + 4
  a := w>> 2; IF a DO w, r := a, r + 2
  a := w>> 1; IF a DO w, r := a, r + 1
  RESULTIS r
}

AND lg2c(w) = VALOF
{ IF w<0 RESULTIS w<<1 -> 32, 31
  FOR n = 0 TO 30 IF (1<<n) >= w RESULTIS n
  RESULTIS 31
}

AND lg2d(w) = VALOF
{ LET c = (w = (w&-w)) + 1
  RESULTIS 
 (w&#xffff0000)=0 ->
   (w&#x0000ff00)=0 ->
   (w&#x000000f0)=0 -> (w&#x0000000c)=0 -> (w&#x00000002)=0 ->  0+c,  1+c,
                                           (w&#x00000008)=0 ->  2+c,  3+c,
                       (w&#x000000c0)=0 -> (w&#x00000020)=0 ->  4+c,  5+c,
                                           (w&#x00000080)=0 ->  6+c,  7+c,
   (w&#x0000f000)=0 -> (w&#x00000c00)=0 -> (w&#x00000200)=0 ->  8+c,  9+c,
                                           (w&#x00000800)=0 -> 10+c, 11+c,
                       (w&#x0000c000)=0 -> (w&#x00002000)=0 -> 12+c, 13+c,
                                           (w&#x00008000)=0 -> 14+c, 15+c,
   (w&#xff000000)=0 ->
   (w&#x00f00000)=0 -> (w&#x000c0000)=0 -> (w&#x00020000)=0 -> 16+c, 17+c,
                                           (w&#x00080000)=0 -> 18+c, 19+c,
                       (w&#x00c00000)=0 -> (w&#x00200000)=0 -> 20+c, 21+c,
                                           (w&#x00800000)=0 -> 22+c, 23+c,
   (w&#xf0000000)=0 -> (w&#x0c000000)=0 -> (w&#x02000000)=0 -> 24+c, 25+c,
                                           (w&#x08000000)=0 -> 26+c, 27+c,
                       (w&#xc0000000)=0 -> (w&#x20000000)=0 -> 28+c, 29+c,
                                           (w&#x80000000)=0 -> 30+c, 31+c
}

AND lg2e(w) = VALOF
{ LET t = TABLE 0,0,1,1,2,2,2,2,3,3,3,3,3,3,3,3
  LET c = (w = (w & -w)) + 1
  UNLESS w>> 4 RESULTIS t!w            + c
  UNLESS w>> 8 RESULTIS t!(w>> 4) +  4 + c
  UNLESS w>>12 RESULTIS t!(w>> 8) +  8 + c
  UNLESS w>>16 RESULTIS t!(w>>12) + 12 + c
  UNLESS w>>20 RESULTIS t!(w>>16) + 16 + c
  UNLESS w>>24 RESULTIS t!(w>>20) + 20 + c
  UNLESS w>>28 RESULTIS t!(w>>24) + 24 + c
  RESULTIS              t!(w>>28) + 28 + c
}

AND lg2f(w) = VALOF
{ LET t = TABLE 
      0,0,1,1,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
      5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
  LET c = (w = (w & -w)) + 1
  UNLESS w>> 6 RESULTIS t!w            + c
  UNLESS w>>12 RESULTIS t!(w>> 6) +  6 + c
  UNLESS w>>18 RESULTIS t!(w>>12) + 12 + c
  UNLESS w>>24 RESULTIS t!(w>>18) + 18 + c
  UNLESS w>>30 RESULTIS t!(w>>24) + 24 + c
  RESULTIS              t!(w>>30) + 30 + c
}

AND lg2g(w) = VALOF  // The fastest method
{ LET t = TABLE
      1,1,2,2,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
      6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
      7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,
      7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,
      8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,
      8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,
      8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,
      8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
  LET c = (w = (w & -w))
  UNLESS w>> 8 RESULTIS t!w            + c
  UNLESS w>>16 RESULTIS t!(w>> 8) +  8 + c
  UNLESS w>>24 RESULTIS t!(w>>16) + 16 + c
  RESULTIS              t!(w>>24) + 24 + c
}

AND lg2h(w) = VALOF
{ MANIFEST { b = #b10001000_10001000_10001000_10001000
             m = #b01110111_01110111_01110111_01110111
             f = 1 | 1<<7 | 1<<14 | 1<<21
           }
  LET sh = ((((w&m) + m | w)&b) * f >> 24) ! TABLE
       0, 0, 8, 8,16,16,16,16,24,24,24,24,24,24,24,24,
       4, 4, 8, 8,16,16,16,16,24,24,24,24,24,24,24,24,
      12,12,12,12,16,16,16,16,24,24,24,24,24,24,24,24,
      12,12,12,12,16,16,16,16,24,24,24,24,24,24,24,24,
      20,20,20,20,20,20,20,20,24,24,24,24,24,24,24,24,
      20,20,20,20,20,20,20,20,24,24,24,24,24,24,24,24,
      20,20,20,20,20,20,20,20,24,24,24,24,24,24,24,24,
      20,20,20,20,20,20,20,20,24,24,24,24,24,24,24,24,
      28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,
      28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,
      28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,
      28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,
      28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,
      28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,
      28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,
      28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28

  RESULTIS sh + (w = (w & -w)) +
           (w>>sh & 15) ! TABLE 1,1,2,2,3,3,3,3,4,4,4,4,4,4,4,4
}

AND lg2i(w) = VALOF
{ MANIFEST { b = #b10000000_10000000_10000000_10000000
             m = #b01111111_01111111_01111111_01111111
             f = 1 | 1<<7 | 1<<14 | 1<<21
           }
  LET sh = ((((w&m) + m | w)&b) * f >> 28) ! TABLE
       0, 0, 8, 8,16,16,16,16,24,24,24,24,24,24,24,24

  RESULTIS sh + (w = (w & -w)) + (w>>sh & 255) ! TABLE
      1,1,2,2,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
      6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
      7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,
      7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,
      8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,
      8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,
      8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,
      8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
}

AND lg2j(w) = VALOF
{ MANIFEST { b = #b100000_100000_100000_100000_100000_10
             m = #b011111_011111_011111_011111_011111_01
             f = 1 | 1<<5 | 1<<10 | 1<<15 | 1<<20 | 1<<25
           }
  LET sh = ((((w&m) + m | w)&b) * f >> 26) ! TABLE
       0, 0, 2, 2, 8, 8, 8, 8,14,14,14,14,14,14,14,14,
      20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,
      26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,
      26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26
 
  RESULTIS sh + (w = (w & -w)) + (w>>sh & 63) ! TABLE
      1,1,2,2,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
      6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
      7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,
      7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
}


