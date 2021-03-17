include "alldifferent.mzn";
include "inverse.mzn";
% maximizes the number satisfied preferences

int: n;
int: n_prefs;
array[1..n_prefs, 1..2] of 1..n: prefs;

var 1..n_prefs :cost;
array[1..n] of var 1..n: placements;
array[1..n] of var 1..n: persons;


constraint inverse(placements, persons);

constraint cost = sum(j in 1..n_prefs)(abs(persons[prefs[j, 1]] - persons[prefs[j, 2]]) == 1);

constraint alldifferent(placements);


solve :: int_search(placements, first_fail, indomain_min)
 maximize cost;

