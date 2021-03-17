include "alldifferent.mzn";

array[1..9] of var 1..9: alpha;

constraint 2*alpha[1] = alpha[2] + 2*alpha[3];
constraint alpha[6] = alpha[5] + 2*alpha[4];
constraint alpha[8] + 2*alpha[7] = 3*alpha[9];
constraint 2*sum(i in 4..6)(alpha[i]) + 3*sum(i in 7..9)(alpha[i]) = 3*sum(i in 1..3)(alpha[i]);
constraint alldifferent(alpha);
solve satisfy;