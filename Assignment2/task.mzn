include "globals.mzn";

int: graph_size;
int: start;
int: n_dests;
array[1..n_dests] of int: dest;
int: n_edges;
array[1..n_edges] of 1..graph_size: from;
array[1..n_edges] of 1..graph_size: to;
array[1..n_edges] of int: cost;


var int: min_costs;

array[1..n_dests, 1..graph_size] of var 1..graph_size: paths; % Array of subcircuits for each destination.
array[1..graph_size, 1..graph_size] of var 0..max(cost): visitedCost; % Array contains the cost of visited edge (i,j) or (j,i)


% Returns true if node is one of the destination nodes.
predicate node_is_dest_node(var int: node) = exists(dest_node in dest)(node = dest_node);

% Get all possible domain values for node 'node', including value 'node', and put them in a set.
function var set of int: get_prel_domain_values(var int: node) = 
               {if (from[edge_index] = node) 
                   then to[edge_index] 
                elseif (to[edge_index] = node) 
                   then from[edge_index] 
               else node  endif 
               | edge_index in 1..n_edges};

% Add paths from the destination nodes to the start node by adding 1s to the destination
% nodes domains.
function var set of int: get_complete_domain_values(var int: node) = 
                if (node_is_dest_node(node)) 
                    then get_prel_domain_values(node) union {start} else get_prel_domain_values(node) 
                endif;

% Assign the domain of values for each node
constraint forall(i in 1..graph_size, j in 1..n_dests)(paths[j, i] in get_complete_domain_values(i));

% Find one subcircuit for each destination.
constraint forall(k in 1..n_dests)(subcircuit([paths[k, i] | i in 1..graph_size])); % Picks out a subcircuit.

% The start node can't be left out of the subcircuit.
constraint forall(k in 1..n_dests)(paths[k, start] != start);

% The destination node must lead to the start node.
constraint forall(k in 1..n_dests)(paths[k, dest[k]] = start);

% Get cost from node n1 to node n2. 
function var int: get_cost_n1_n2(1..graph_size: n1, var 1..graph_size: n2) = 
        sum(j in 1..n_edges)(if ((from[j] == n1 /\ to[j] == n2) \/ (from[j] == n2 /\ to[j] == n1)) 
            then cost[j] 
            else 0 endif);
            
% Insert the cost of visited edges in the matrix, the cost will be counted only once
constraint  forall(k in 1..n_dests ,i in 1..graph_size)(
                  if (i != paths[k, i] /\ paths[k, i] != start) 
                       then  get_cost_n1_n2(i, paths[k, i]) = visitedCost[i, paths[k, i]] 
                else true endif);   

% the sum of visited costs
constraint min_costs = sum(i in 1..graph_size, j in 1..graph_size)(visitedCost[i,j]);

solve minimize min_costs;

output["cost = ", show(min_costs),"\n"];

