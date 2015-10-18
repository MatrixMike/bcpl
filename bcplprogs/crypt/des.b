/*

This is a demonstration implementation of the DES Algorithm

Implemented in BCPL by Martin Richards  (c) June 2001

Based on the description of DES by J. Orlin Grabbe
in http://www.zolatimes.com/V2.28/DES.htm
and the DES Standard in
http://csrc.nist.gov/publications/fips/fips46-3/fips43-3.pdf
*/

GET "libhdr"

LET start() = VALOF
{ LET mess = VEC 1
  LET key  = VEC 1
  LET code = VEC 1
  LET res  = VEC 1
//selectoutput(findoutput("res"))
  mess!0, mess!1 := #x01234567, #x89ABCDEF  // The message
  key!0,  key!1  := #x13345779, #x9BBCDFF1  // The key

  des   (mess, key, code)
  writef("encode: %x8%x8 with key: %x8%x8 => %x8%x8*n",
                mess!0, mess!1, key!0, key!1, code!0, code!1)
  invdes(code, key, res)
  writef("decode: %x8%x8 with key: %x8%x8 => %x8%x8*n",
                code!0, code!1, key!0, key!1, res!0, res!1)
//endwrite()
  RESULTIS 0
}

AND des(m, k, c) BE
{ LET cd = VEC 1
  LET kl = VEC 16
  LET kr = VEC 16
  LET l, r = 0, 0
  pc1(k!0, k!1, cd)
  writef("Key schedule computation*n*n")
  writef("CD%i2 = %bS %bS*n", 0, cd!0, cd!1)
  FOR i = 1 TO 16 DO
  { rotleft(cd)
    UNLESS i=1 | i=2 | i=9 | i=16 DO rotleft(cd)
    writef("CD%i2 = %bS %bS*n", i, cd!0, cd!1)
    pc2(cd!0, cd!1, @kl!i, @kr!i)
    writef("K %i2 = %bO %bO*n", i, kl!i, kr!i)
  }

  writef("*nEncryption computation*n*n")
  writef("M:    %bW %bW*n", m!0, m!1)

  ip(m!0, m!1, c)
  l, r := c!0, c!1
  writef("LR 0: %bW %bW*n", l, r)
  FOR i = 1 TO 16 DO
  { LET nl = r
    r := l NEQV f(r, kl!i, kr!i)
    l := nl
    writef("LR%i2: %bW %bW*n", i, l, r)
  }
  invip(r, l, c)
  writef("C:    %bW %bW*n", c!0, c!1)
}

AND invdes(c, k, m) BE
{ LET cd = VEC 1
  LET kl = VEC 16
  LET kr = VEC 16
  LET l, r = 0, 0
  pc1(k!0, k!1, cd)
  FOR i = 1 TO 16 DO
  { rotleft(cd)
    UNLESS i=1 | i=2 | i=9 | i=16 DO rotleft(cd)
    pc2(cd!0, cd!1, @kl!i, @kr!i)
  }

  writef("*nDecryption computation*n*n")
  writef("C:    %bW %bW*n", c!0, c!1)

  ip(c!0, c!1, m)
  r, l := m!0, m!1
  FOR i = 16 TO 1 BY -1 DO
  { LET nr = l
    writef("LR%i2: %bW %bW*n", i, l, r)
    l := r NEQV f(l, kl!i, kr!i)
    r := nr
  }
  writef("LR 0: %bW %bW*n", l, r)
  invip(l, r, m)
  writef("M:    %bW %bW*n", m!0, m!1)
}

AND pc1(k0, k1, cd) BE
{ LET t = TABLE 57,49,41,33,25,17, 9,
                 1,58,50,42,34,26,18,
                10, 2,59,51,43,35,27,
                19,11, 3,60,52,44,36,
                63,55,47,39,31,23,15,
                 7,62,54,46,38,30,22,
                14, 6,61,53,45,37,29,
                21,13, 5,28,20,12, 4
  LET c0, d0 = 0, 0
  FOR i = 0 TO 27 DO
  { c0 := c0<<1 | getbit(k0, k1, t!i)
    d0 := d0<<1 | getbit(k0, k1, t!(i+28))
  }
  cd!0, cd!1 := c0, d0

}

AND pc2(ci, di, p, q) BE
{ LET t = TABLE 14,17,11,24, 1, 5,
                 3,28,15, 6,21,10,
                23,19,12, 4,26, 8,
                16, 7,27,20,13, 2,
                41,52,31,37,47,55,
                30,40,51,45,33,48,
                44,49,39,56,34,53,
                46,42,50,36,29,32
  LET kl, kr = 0, 0
  FOR i = 0 TO 47 DO
  { LET sh = t!i
    LET w = ci
    TEST sh<=28
    THEN w, sh := ci, 28-sh
    ELSE w, sh := di, 56-sh
    TEST i<24 THEN kl := kl<<1 | (w>>sh)&1
              ELSE kr := kr<<1 | (w>>sh)&1
  }
  !p, !q := kl, kr
}

AND ip(m0, m1, ipv) BE
{ LET t = TABLE 58,50,42,34,26,18,10, 2,
                60,52,44,36,28,20,12, 4,
                62,54,46,38,30,22,14, 6,
                64,56,48,40,32,24,16, 8,
                57,49,41,33,25,17, 9, 1,
                59,51,43,35,27,19,11, 3,
                61,53,45,37,29,21,13, 5,
                63,55,47,39,31,23,15, 7
  LET x, y = 0, 0
  FOR i = 0 TO 31 DO
  { x := x<<1 | getbit(m0, m1, t!i)
    y := y<<1 | getbit(m0, m1, t!(i+32))
  }
  ipv!0, ipv!1 := x, y
}

AND invip(m0, m1, ipv) BE
{ LET t = TABLE 40, 8,48,16,56,24,64,32,
                39, 7,47,15,55,23,63,31,
                38, 6,46,14,54,22,62,30,
                37, 5,45,13,53,21,61,29,
                36, 4,44,12,52,20,60,28,
                35, 3,43,11,51,19,59,27,
                34, 2,42,10,50,18,58,26,
                33, 1,41, 9,49,17,57,25
  LET x, y = 0, 0
  FOR i = 0 TO 31 DO
  { x := x<<1 | getbit(m0, m1, t!i)
    y := y<<1 | getbit(m0, m1, t!(i+32))
  }
  ipv!0, ipv!1 := x, y
}

AND getbit(w0, w1, i) = VALOF
{ LET w, sh = ?, ?
  TEST i<=32
  THEN w, sh := w0, 32-i
  ELSE w, sh := w1, 64-i
  RESULTIS (w>>sh) & 1
}

AND rotleft(v) BE
{ LET c, d = v!0, v!1
  v!0 := (c<<1 | c>>27) & #xFFFFFFF 
  v!1 := (d<<1 | d>>27) & #xFFFFFFF 
}

AND f(r, kl, kr) = VALOF
{ LET et = TABLE 32, 1, 2, 3, 4, 5,
                  4, 5, 6, 7, 8, 9,
                  8, 9,10,11,12,13,
                 12,13,14,15,16,17,
                 16,17,18,19,20,21,
                 20,21,22,23,24,25,
                 24,25,26,27,28,29,
                 28,29,30,31,32, 1
  LET x, y = 0, 0
  LET res = 0
//writef("R  = %bW*n", r)
  FOR i =  0 TO 23 DO x := x<<1 | (r>>(32-et!i))&1
  FOR i = 24 TO 47 DO y := y<<1 | (r>>(32-et!i))&1
//writef("ER = %bO %bO*n", x, y)
  x := x NEQV kl
  y := y NEQV kr
writef("K   = %bO %bO*n", kl, kr)
//writef("KE = %bO %bO*n", x, y)
  res := res<<4 | s1(x>>18 & 63)
  res := res<<4 | s2(x>>12 & 63)
  res := res<<4 | s3(x>> 6 & 63)
  res := res<<4 | s4(x>> 0 & 63)
  res := res<<4 | s5(y>>18 & 63)
  res := res<<4 | s6(y>>12 & 63)
  res := res<<4 | s7(y>> 6 & 63)
  res := res<<4 | s8(y>> 0 & 63)
//writef("SB = %bW*n", res)
  res := perm(res, TABLE 16, 7,20,21,
                         29,12,28,17,
                          1,15,23,26,
                          5,18,31,10,
                          2, 8,24,14,
                         32,27, 3, 9,
                         19,13,30, 6,
                         22,11, 4, 25)
  writef("F   = %bW*n", res)
  RESULTIS res
}

AND s1(b) = VALOF
{ LET i = b>>1 & 15
  SWITCHON b&#41 INTO
  { CASE #00:RESULTIS i!TABLE 14, 4,13, 1, 2,15,11, 8, 3,10, 6,12, 5, 9, 0, 7
    CASE #01:RESULTIS i!TABLE  0,15, 7, 4,14, 2,13, 1,10, 6,12,11, 9, 5, 3, 8
    CASE #40:RESULTIS i!TABLE  4, 1,14, 8,13, 6, 2,11,15,12, 9, 7, 3,10, 5, 0
    CASE #41:RESULTIS i!TABLE 15,12, 8, 2, 4, 9, 1, 7, 5,11, 3,14,10, 0, 6,13
  }
  RESULTIS 0
}

AND s2(b) = VALOF
{ LET i = b>>1 & 15
  SWITCHON b&#41 INTO
  { CASE #00:RESULTIS i!TABLE 15, 1, 8,14, 6,11, 3, 4, 9, 7, 2,13,12, 0, 5,10
    CASE #01:RESULTIS i!TABLE  3,13, 4, 7,15, 2, 8,14,12, 0, 1,10, 6, 9,11, 5
    CASE #40:RESULTIS i!TABLE  0,14, 7,11,10, 4,13, 1, 5, 8,12, 6, 9, 3, 2,15
    CASE #41:RESULTIS i!TABLE 13, 8,10, 1, 3,15, 4, 2,11, 6, 7,12, 0, 5,14, 9
  }
  RESULTIS 0
}

AND s3(b) = VALOF
{ LET i = b>>1 & 15
  SWITCHON b&#41 INTO
  { CASE #00:RESULTIS i!TABLE 10, 0, 9,14, 6, 3,15, 5, 1,13,12, 7,11, 4, 2, 8
    CASE #01:RESULTIS i!TABLE 13, 7, 0, 9, 3, 4, 6,10, 2, 8, 5,14,12,11,15, 1
    CASE #40:RESULTIS i!TABLE 13, 6, 4, 9, 8,15, 3, 0,11, 1, 2,12, 5,10,14, 7
    CASE #41:RESULTIS i!TABLE  1,10,13, 0, 6, 9, 8, 7, 4,15,14, 3,11, 5, 2,12
  }
  RESULTIS 0
}

AND s4(b) = VALOF
{ LET i = b>>1 & 15
  SWITCHON b&#41 INTO
  { CASE #00:RESULTIS i!TABLE  7,13,14, 3, 0, 6, 9,10, 1, 2, 8, 5,11,12, 4,15
    CASE #01:RESULTIS i!TABLE 13, 8,11, 5, 6,15, 0, 3, 4, 7, 2,12, 1,10,14, 9
    CASE #40:RESULTIS i!TABLE 10, 6, 9, 0,12,11, 7,13,15, 1, 3,14, 5, 2, 8, 4
    CASE #41:RESULTIS i!TABLE  3,15, 0, 6,10, 1,13, 8, 9, 4, 5,11,12, 7, 2,14
  }
  RESULTIS 0
}

AND s5(b) = VALOF
{ LET i = b>>1 & 15
  SWITCHON b&#41 INTO
  { CASE #00:RESULTIS i!TABLE  2,12, 4, 1, 7,10,11, 6, 8, 5, 3,15,13, 0,14, 9
    CASE #01:RESULTIS i!TABLE 14,11, 2,12, 4, 7,13, 1, 5, 0,15,10, 3, 9, 8, 6
    CASE #40:RESULTIS i!TABLE  4, 2, 1,11,10,13, 7, 8,15, 9,12, 5, 6, 3, 0,14
    CASE #41:RESULTIS i!TABLE 11, 8,12, 7, 1,14, 2,13, 6,15, 0, 9,10, 4, 5, 3
  }
  RESULTIS 0
}

AND s6(b) = VALOF
{ LET i = b>>1 & 15
  SWITCHON b&#41 INTO
  { CASE #00:RESULTIS i!TABLE 12, 1,10,15, 9, 2, 6, 8, 0,13, 3, 4,14, 7, 5,11
    CASE #01:RESULTIS i!TABLE 10,15, 4, 2, 7,12, 9, 5, 6, 1,13,14, 0,11, 3, 8
    CASE #40:RESULTIS i!TABLE  9,14,15, 5, 2, 8,12, 3, 7, 0, 4,10, 1,13,11, 6
    CASE #41:RESULTIS i!TABLE  4, 3, 2,12, 9, 5,15,10,11,14, 1, 7, 6, 0, 8,13
  }
  RESULTIS 0
}

AND s7(b) = VALOF
{ LET i = b>>1 & 15
  SWITCHON b&#41 INTO
  { CASE #00:RESULTIS i!TABLE  4,11, 2,14,15, 0, 8,13, 3,12, 9, 7, 5,10, 6, 1
    CASE #01:RESULTIS i!TABLE 13, 0,11, 7, 4, 9, 1,10,14, 3, 5,12, 2,15, 8, 6
    CASE #40:RESULTIS i!TABLE  1, 4,11,13,12, 3, 7,14,10,15, 6, 8, 0, 5, 9, 2
    CASE #41:RESULTIS i!TABLE  6,11,13, 8, 1, 4,10, 7, 9, 5, 0,15,14, 2, 3,12
  }
  RESULTIS 0
}

AND s8(b) = VALOF
{ LET i = b>>1 & 15
  SWITCHON b&#41 INTO
  { CASE #00:RESULTIS i!TABLE 13, 2, 8, 4, 6,15,11, 1,10, 9, 3,14, 5, 0,12, 7
    CASE #01:RESULTIS i!TABLE  1,15,13, 8,10, 3, 7, 4,12, 5, 6,11, 0,14, 9, 2
    CASE #40:RESULTIS i!TABLE  7,11, 4, 1, 9,12,14, 2, 0, 6,10,13,15, 3, 5, 8
    CASE #41:RESULTIS i!TABLE  2, 1,14, 7, 4,10, 8,13,15,12, 9, 0, 3, 5, 6,11
  }
  RESULTIS 0
}

AND perm(w, t) = VALOF
{ LET res = 0
  FOR i = 0 TO 31 DO res := res<<1 | (w>>(32-t!i))&1
  RESULTIS res
}

/* This program outputs the following:

Key schedule computation

CD 0 = 1111000011001100101010101111 0101010101100110011110001111
CD 1 = 1110000110011001010101011111 1010101011001100111100011110
K  1 = 000110110000001011101111 111111000111000001110010
CD 2 = 1100001100110010101010111111 0101010110011001111000111101
K  2 = 011110011010111011011001 110110111100100111100101
CD 3 = 0000110011001010101011111111 0101011001100111100011110101
K  3 = 010101011111110010001010 010000101100111110011001
CD 4 = 0011001100101010101111111100 0101100110011110001111010101
K  4 = 011100101010110111010110 110110110011010100011101
CD 5 = 1100110010101010111111110000 0110011001111000111101010101
K  5 = 011111001110110000000111 111010110101001110101000
CD 6 = 0011001010101011111111000011 1001100111100011110101010101
K  6 = 011000111010010100111110 010100000111101100101111
CD 7 = 1100101010101111111100001100 0110011110001111010101010110
K  7 = 111011001000010010110111 111101100001100010111100
CD 8 = 0010101010111111110000110011 1001111000111101010101011001
K  8 = 111101111000101000111010 110000010011101111111011
CD 9 = 0101010101111111100001100110 0011110001111010101010110011
K  9 = 111000001101101111101011 111011011110011110000001
CD10 = 0101010111111110000110011001 1111000111101010101011001100
K 10 = 101100011111001101000111 101110100100011001001111
CD11 = 0101011111111000011001100101 1100011110101010101100110011
K 11 = 001000010101111111010011 110111101101001110000110
CD12 = 0101111111100001100110010101 0001111010101010110011001111
K 12 = 011101010111000111110101 100101000110011111101001
CD13 = 0111111110000110011001010101 0111101010101011001100111100
K 13 = 100101111100010111010001 111110101011101001000001
CD14 = 1111111000011001100101010101 1110101010101100110011110001
K 14 = 010111110100001110110111 111100101110011100111010
CD15 = 1111100001100110010101010111 1010101010110011001111000111
K 15 = 101111111001000110001101 001111010011111100001010
CD16 = 1111000011001100101010101111 0101010101100110011110001111
K 16 = 110010110011110110001011 000011100001011111110101

Encryption computation

M:    00000001001000110100010101100111 10001001101010111100110111101111
LR 0: 11001100000000001100110011111111 11110000101010101111000010101010
K   = 000110110000001011101111 111111000111000001110010
F   = 00100011010010101010100110111011
LR 1: 11110000101010101111000010101010 11101111010010100110010101000100
K   = 011110011010111011011001 110110111100100111100101
F   = 00111100101010111000011110100011
LR 2: 11101111010010100110010101000100 11001100000000010111011100001001
K   = 010101011111110010001010 010000101100111110011001
F   = 01001101000101100110111010110000
LR 3: 11001100000000010111011100001001 10100010010111000000101111110100
K   = 011100101010110111010110 110110110011010100011101
F   = 10111011001000110111011101001100
LR 4: 10100010010111000000101111110100 01110111001000100000000001000101
K   = 011111001110110000000111 111010110101001110101000
F   = 00101000000100111010110111000011
LR 5: 01110111001000100000000001000101 10001010010011111010011000110111
K   = 011000111010010100111110 010100000111101100101111
F   = 10011110010001011100110100101100
LR 6: 10001010010011111010011000110111 11101001011001111100110101101001
K   = 111011001000010010110111 111101100001100010111100
F   = 10001100000001010001110000100111
LR 7: 11101001011001111100110101101001 00000110010010101011101000010000
K   = 111101111000101000111010 110000010011101111111011
F   = 00111100000011101000011011111001
LR 8: 00000110010010101011101000010000 11010101011010010100101110010000
K   = 111000001101101111101011 111011011110011110000001
F   = 00100010001101100111110001101010
LR 9: 11010101011010010100101110010000 00100100011111001100011001111010
K   = 101100011111001101000111 101110100100011001001111
F   = 01100010101111001001110000100010
LR10: 00100100011111001100011001111010 10110111110101011101011110110010
K   = 001000010101111111010011 110111101101001110000110
F   = 11100001000001001111101000000010
LR11: 10110111110101011101011110110010 11000101011110000011110001111000
K   = 011101010111000111110101 100101000110011111101001
F   = 11000010011010001100111111101010
LR12: 11000101011110000011110001111000 01110101101111010001100001011000
K   = 100101111100010111010001 111110101011101001000001
F   = 11011101101110110010100100100010
LR13: 01110101101111010001100001011000 00011000110000110001010101011010
K   = 010111110100001110110111 111100101110011100111010
F   = 10110111001100011000111001010101
LR14: 00011000110000110001010101011010 11000010100011001001011000001101
K   = 101111111001000110001101 001111010011111100001010
F   = 01011011100000010010011101101110
LR15: 11000010100011001001011000001101 01000011010000100011001000110100
K   = 110010110011110110001011 000011100001011111110101
F   = 11001000110000000100111110011000
LR16: 01000011010000100011001000110100 00001010010011001101100110010101
C:    10000101111010000001001101010100 00001111000010101011010000000101
encode: 0123456789ABCDEF with key: 133457799BBCDFF1 => 85E813540F0AB405

Decryption computation

C:    10000101111010000001001101010100 00001111000010101011010000000101
LR16: 01000011010000100011001000110100 00001010010011001101100110010101
K   = 110010110011110110001011 000011100001011111110101
F   = 11001000110000000100111110011000
LR15: 11000010100011001001011000001101 01000011010000100011001000110100
K   = 101111111001000110001101 001111010011111100001010
F   = 01011011100000010010011101101110
LR14: 00011000110000110001010101011010 11000010100011001001011000001101
K   = 010111110100001110110111 111100101110011100111010
F   = 10110111001100011000111001010101
LR13: 01110101101111010001100001011000 00011000110000110001010101011010
K   = 100101111100010111010001 111110101011101001000001
F   = 11011101101110110010100100100010
LR12: 11000101011110000011110001111000 01110101101111010001100001011000
K   = 011101010111000111110101 100101000110011111101001
F   = 11000010011010001100111111101010
LR11: 10110111110101011101011110110010 11000101011110000011110001111000
K   = 001000010101111111010011 110111101101001110000110
F   = 11100001000001001111101000000010
LR10: 00100100011111001100011001111010 10110111110101011101011110110010
K   = 101100011111001101000111 101110100100011001001111
F   = 01100010101111001001110000100010
LR 9: 11010101011010010100101110010000 00100100011111001100011001111010
K   = 111000001101101111101011 111011011110011110000001
F   = 00100010001101100111110001101010
LR 8: 00000110010010101011101000010000 11010101011010010100101110010000
K   = 111101111000101000111010 110000010011101111111011
F   = 00111100000011101000011011111001
LR 7: 11101001011001111100110101101001 00000110010010101011101000010000
K   = 111011001000010010110111 111101100001100010111100
F   = 10001100000001010001110000100111
LR 6: 10001010010011111010011000110111 11101001011001111100110101101001
K   = 011000111010010100111110 010100000111101100101111
F   = 10011110010001011100110100101100
LR 5: 01110111001000100000000001000101 10001010010011111010011000110111
K   = 011111001110110000000111 111010110101001110101000
F   = 00101000000100111010110111000011
LR 4: 10100010010111000000101111110100 01110111001000100000000001000101
K   = 011100101010110111010110 110110110011010100011101
F   = 10111011001000110111011101001100
LR 3: 11001100000000010111011100001001 10100010010111000000101111110100
K   = 010101011111110010001010 010000101100111110011001
F   = 01001101000101100110111010110000
LR 2: 11101111010010100110010101000100 11001100000000010111011100001001
K   = 011110011010111011011001 110110111100100111100101
F   = 00111100101010111000011110100011
LR 1: 11110000101010101111000010101010 11101111010010100110010101000100
K   = 000110110000001011101111 111111000111000001110010
F   = 00100011010010101010100110111011
LR 0: 11001100000000001100110011111111 11110000101010101111000010101010
M:    00000001001000110100010101100111 10001001101010111100110111101111
decode: 85E813540F0AB405 with key: 133457799BBCDFF1 => 0123456789ABCDEF

*/