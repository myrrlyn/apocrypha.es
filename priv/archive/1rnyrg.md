---
series: Analyzing the ja-Kha’jay
part: 1
title: Charting the Moons
reddit: 1rnyrg
author: myrrlyn
date: 2013-11-28T20:11:03Z
---

The mechanics of Khajiit subspecies morphology has been a semi-mysterious topic
ever since outsiders first encountered different shapes of the cat-men. Study,
conversation, and observation of Khajiiti culture have resulted in the raw data
of the Khajiit forms being collected, most especially from an Interview with
Three Booksellers, but the intricacies of the relationship the Khajiit children
have with the moons has remained for the most part unexplored.

A recent endeavour on `#memospore2`, with noteworthy legwork by /u/solthas, has
resulted in what I believe to be a suitable introduction into a fuller
understanding of the ja-Kha’jay.

If one were to venture to UESP’s page on Khajiit, specifically the Morphology
section, they would find this table:

|Moons      |Masser|Full       |Waxing     |New        |Waning    |
|:---------:|:----:|:---------:|:---------:|:---------:|:--------:|
|**Secunda**|┌     |─          |─          |─          |─         |
|**Full**   |│     |Senche     |Cathay     |Ohmes      |Alfiq     |
|**Waxing** |│     |Senche-raht|Cathay-raht|Ohmes-raht |Alfiq-raht|
|**New**    |│     |Pahmar     |Tojay      |Suthay     |Dagi      |
|**Waning** |│     |Pahmar-raht|Tojay-raht |Suthay-raht|Dagi-raht |

Now, this table tells us absolutely nothing about the Masser-Secunda
interactions and their output form, save that Secunda dictates whether or not
-raht size multiplier is in play. If, however, you were to reorder this chart
so that time flows positively (defined as New->Waxing->Full->Waning->repeat) on
both axes, with phase shifts so that stance and size are properly ordered, you
would end with this chart.

|Moons      |Masser|New        |Waxing     |Full       |Waning    |
|:---------:|:----:|:---------:|:---------:|:---------:|:--------:|
|**Secunda**|┌     |─          |─          |─          |─         |
|**Waning** |│     |Suthay-raht|Tojay-raht |Pahmar-raht|Dagi-raht |
|**New**    |│     |Suthay     |Tojay      |Pahmar     |Dagi      |
|**Waxing** |│     |Ohmes-raht |Cathay-raht|Senche-raht|Alfiq-raht|
|**Full**   |│     |Ohmes      |Cathay     |Senche     |Alfiq     |

Now, depending on how well you know your Khajiit morphology, you may or may not
be beginning to see the picture here. When Secunda stabilizes in the top and
bottom quarters of its phases, the -raht forms are born. This is, of course,
known from the original table, but ordered in this manner we see that as Secunda
moves from Waning through to Full, size steadily decreases (with the exception
of Pahmar-Senche). Before I cover the rest of the physiological data, I would
like to take this time to review the sixteen known forms of Khajiit.

1. Alfiq: quadruped, very small, magical aptitude. Alfiq-raht: larger Alfiq.
1. Pahmar: quadruped, medium-large, lean and quick.
1. Senche: quadruped, very large. The raht form is particularly enormous.
1. Dagi: transitional(?) between biped and quadruped. The only description we
   have comes from Mixed Unit Tactics, describing them as tree-leapers, which
   suggests a strong quadruped state with biped capabilities.
1. Ohmes: transitional(?) between quadruped and biped. These are described as
   Bosmeri in appearance, and they are likely to be bipedal woods-dwellers with
   a quadruped stance that they are able to use at need.
1. Suthay: biped, approximately man-sized, perhaps shorter than the mannish
   average.
1. Cathay: biped, average to tall on a man. The raht form would be very tall
   relative to the human height distribution, and on par with the taller Altmer.
1. Tojay: biped. While little is directly stated about them, we believe that the
   Tojay are the bipedal equivalent of the Senche, towering over the other
   bipedal forms.

I have one last table to present, and then I will present the conclusion we have
derived of the ja-Kha’jay.

|Moons      |Masser|New                          |Waxing            |Full                  |Waning                       |
|:---------:|:----:|:---------------------------:|:----------------:|:--------------------:|:---------------------------:|
|**Secunda**|┌     |─                            |─                 |─                     |─                            |
|**Waning** |│     |Small Biped -raht            |Large Biped -raht |Medium Quadruped -raht|Transitional (favors 4) -raht|
|**New**    |│     |Small Biped                  |Large Biped       |Medium Quadruped      |Transitional (favors 4)      |
|**Waxing** |│     |Transitional (favors 2) -raht|Medium Biped -raht|Large Quadruped -raht |Small Quadruped -raht        |
|**Full**   |│     |Transitional (favors 2)      |Medium Biped      |Large Quadruped       |Small Quadruped              |

Notice that if one ignores the stance, that this table is rotationally
symmetric. Masser’s switch from new-waxing to full-waning wholly inverts the
morphologic table, shifting stance and size-time arrangement.

As for the transitional forms Dagi and Ohmes, they are both on the low end of
the size-continuum across all Khajiit, but are in the low-middle of their
respective favored stance. Alfiq are smaller than Dagi, and Pahmar and Senche
larger. Ohmes are approximately on par with Suthay, and Cathay and Tojay are
larger. Furthermore, notice that the transitional phenotypes occur on the move
from waning to new, and are on full-to-waning Secunda. Although we have yet to
create a mathematical model of each moon’s motion with respect to Nirnic time,
it is likely that this form-blurring represents a time when the motions of
Masser and Secunda line up in time (with, of course, a 90-degree phase shift
between Masser and Secunda).

So, to conclude: the phases of Secunda govern the -raht form, and the phases of
Masser govern the stance and size. Secunda operates on a simple back-and-forth
toggle between -raht and not every quarter-period, whereas Masser rotates the
table (not accounting for Secunda’s influence) every half-period.

[Here is the link to the public and pretty Gdoc spreadsheet][0]. This is not the
document on which the `#memospore2` IRC originally worked, but as that is
chaotically laid out and aesthetically poor, we have elected to condense and
cleanse the working document to a publishable form. The only data absent from
this is the foundation work into making tables to deal with the alleged 24
Khajiit types (giving Masser two more phases), and beginning work on
mathematically modeling M(t) and S(t) functions to determine the birth-order.

I hope the information here has been useful, or at least interesting, and sheds
some more light on the workings of the ja-Kha’jay.

[0]: https://docs.google.com/spreadsheet/ccc?key=0Aly-sXRShwzjdGtrRlJ6a1Mzbk5PZjFXNUExMmIzWGc&usp=drive_web#gid=0
