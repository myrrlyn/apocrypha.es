---
title: "Further Conjecture on the ja-Kha'jay"
reddit: 1rrqui
author: myrrlyn
date: 2013-11-30T12:13:41Z
---

(Before we begin, I'd like to take this opportunity to deconstruct the word "ja-Kha'jay". Given that we know kittens are called "ja'Khajiit" and that the suffix -iit refers to doing/being and Kha- is desert, making Khajiit one who deserts (the sandy place, not the flight from duty), then ja' must by necessity mean young. We can therefore extrapolate that ja-Kha'jay comes to mean young-desert-order or something similar)

____

In yesterday's post about Analysis of the ja-Kha'jay, I outlined the information that /u/solthas, myself, and other members of the memospore IRC collated and interpreted. I also promised to continue working on the mathematical model of the two moons with regard to the morphologies and each other.

[Link to spreadsheet](https://docs.google.com/spreadsheet/ccc?key=0Aly-sXRShwzjdGtrRlJ6a1Mzbk5PZjFXNUExMmIzWGc&amp;usp=drive_web#gid=0)

My first attempts in this area were to grant Masser more phases, as I believed a 6M x 4S grid would allow for all 24 forms of Khajiit. However, doing so also made it difficult for the moons to reach all forms, so I went back to working with the 4x4 grid to which we are accustomed. It then occurred to me that I might make Masser go through its four phases at a slower rate than did Secunda. I began by defining one cell as one arbitrarily long time unit (I prefer to go with one week in my head but the exact translation of Nirn-time to a cell is not terribly important and can easily change), and then writing out a table such that each phase of Masser (m0, m+, m1, m-) took five cells, and each phase of Secunda (s0, s+, s1, s-) took four. I then began at the top left corner of m0^1 , s0^1 , and moved one cell down and to the right and put a counter in that cell. When I reached s-^4 or m-^5, I returned to the beginning of the respective row or column, and continued on. In doing so, it took 80 iterations to reach the end of the path and return to the origin. (See Lunar Chart sheet)

In conclusion:

[`M(t) = sin(π*(t/10-p))`](http://www.wolframalpha.com/input/?i=Plot%5BSin%5BPi*%28x%2F10-.5%29%5D%2C+%7Bx%2C+0%2C+80%7D%5D) gives a function with a period of 20 (so each phase takes 5). p is the phase shift value, and a value of 0.5 will move the function by exactly one phase. The linked function is shifted so that it opens at the center of Masser-New.    
[`S(t) = sin(π*(t/8-p))`](http://www.wolframalpha.com/input/?i=Plot%5BSin%5BPi*%28x%2F8-.5%29%5D%2C+%7Bx%2C+0%2C+80%7D%5D) gives a function with a period of 16 (so each phase takes 4). p is the phase shift value, and again, n multiples of 0.5 move the function by exactly n phases. The linked function is shifted so that it opens at the center of Secunda-New.

[The combination of these two functions yields an interference-pattern with a period of 80, as seen in the chart on the provided document.](http://www.wolframalpha.com/input/?i=Plot%5BSin%5BPi*%28x%2F10-.5%29%5D+%2B+Sin%5BPi*%28x%2F8-.5%29%5D%2C+%7Bx%2C+0%2C+80%7D%5D)

I must note that, as we have no information on the Lunar Lattice, this should be taken solely as the extrapolation that it is. It is also not a finished work, as evidenced by the M6S4 sheet in the spreadsheet, which holds no presentable finds as yet. This is simply a means to interpret the information we have on the moons and Khajiit morphology. The numbers I have chosen (5 and 4) for the lengths of the lunar phases are wholly arbitrary, and are used because they provide a short full-cycle (if one cell is equal to one week, then the cycle repeats in under a year and a half) and good spacing of the forms.

Again, I hope that the information presented is useful or at least interesting to you. I still have nothing to present on the Mane, but much as the terrestrial eclipse system is dissociated from the phase-cycle, perhaps Nirn's eclipses are also their own functions tied to the mythic needs of the Khajiit, whereas the standard lunar phasing is "merely" a timekeeping device to which the Khajiit forms have been hitched.

Lastly, I'd like to again credit everyone in the IRC who helped on this document, especially /u/solthas who has a keen eye for mapping out the tables in sensible ways, and who has corrected me several times on how the tables should be laid out. I didn't listen to her when doing the Lattice plotting, because going from m0^1 and s0^1 was the most convenient, but now that the functions are mapped out they can be shifted forward or backwards with ease. The math work was done pretty much on my own, but it would be absolutely meaningless without the foundation work they put in.

^(edited for Wolfram|Alpha work)
