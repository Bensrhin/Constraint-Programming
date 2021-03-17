% minimize the longest distance
include "alldifferent.mzn";
include "inverse.mzn";
int: n;
int: n_prefs;
array[1..n_prefs, 1..2] of 1..n: prefs;
array[1..n] of var 1..n: placements;
array[1..n] of var 1..n: persons;

var 1..n :distance;

constraint alldifferent(placements);
constraint inverse(placements, persons);


constraint distance = max(i in 1..n_prefs)(abs(persons[prefs[i, 1]] - persons[prefs[i, 2]]));


solve :: int_search(placements, first_fail, indomain_min)
 minimize distance;
 
