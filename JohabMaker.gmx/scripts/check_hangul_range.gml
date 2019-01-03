///check_hangul_range(unicode)
/*
    Check if the given Unicode is inside of hangul range (Syllables & Compat. Jamo)
    Only returns true if its VISIBLE, USED character (AKA Not in "reserved")
*/

return (argument0 >= $3131 && argument0 <= $3160) || (argument0 >= $AC00 && argument0 <= $D7AF);
