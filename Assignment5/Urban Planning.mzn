include "globals.mzn";

% Inputs
int: n;
int: n_commercial;
int: n_residential;
array[1..n+1] of int: point_distribution;

%------------------- Variables --------------------

% The nxn Grid where -1 are commercial lots and +1 are residential lots.
array[1..n, 1..n] of var {-1, 1}: grid;

% contains costs of each row
array[1..n] of var int: rows_points;
% contains costs of each column
array[1..n] of var int: columns_points;

% Final cost
var int: cost;

% ----------------- Constraints -------------

% Symmetry breaking constraints
constraint lex2(grid);
% the number of residentials in the grid is the same as parameter
constraint sum(i in 1..n)(sum(j in 1..n)(grid[i, j] == 1)) = n_residential;
% the number of commercials in the grid is the same as parameter
constraint sum(i in 1..n)(sum(j in 1..n)(grid[i, j] == -1)) = n_commercial;

% adding costs based on the number of residential/commercial lots
constraint forall(i in 1..n)(rows_points[i] = point_distribution[sum(j in 1..n)(grid[i, j]==1) + 1]);
constraint forall(i in 1..n)(columns_points[i] = point_distribution[sum(j in 1..n)(grid[j, i]==1) + 1]);

% The total cost
constraint cost = sum(i in 1..n)(rows_points[i] + columns_points[i]);

%----------------- Search + maximize cost -----------------
solve :: int_search(grid, input_order, indomain_max) 
    maximize(cost);
    
output["max points = ", show(cost), "\n", "Grid =\n", show2d(grid), "\n"];
