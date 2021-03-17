%task precedence constraints
%resource constraints
%di: task duration
%ti: starting time

include "globals.mzn";

int : del_add; % Delay adder.
int : del_mul; % Delay multiplier.
int : number_add; % Number of adders.
int : number_mul; % Number of multipliers.
int : n; % Number of tasks/operations.
int : n_add_tasks = length(add); % Number of adder tasks.
int: n_mul_tasks = length(mul);
int: max_resources = max(number_add, number_mul);
int: max_delay = max(del_add, del_mul);
int: last_length = length(last);

var 1..number_add: add_limit; % Limit of number of adders. Used in cumulative.
var 1..number_mul: mul_limit; % Limit of number of multipliers. Used in cumulative.

set of int : last; % Last tasks.
set of int : add; % Adder tasks.
set of int : mul; % Multiplier tasks.
array[1..n] of set of int : dependencies; % Dependencies.


array[1..n] of var 1..n*max_delay: start_times; % Start times for all tasks. 
array[1..n] of var 1..max_resources: resources; % Resource numbers of all tasks.
array[1..n] of var 1..max_delay: delays; % Delays of all tasks.
%array[1..n] of var 1..1: heights; % Heights of all rectangles.
array[1..n_add_tasks] of int: heights_add = [1 | i in 1..n_add_tasks]; % Heights of all rectangles.
array[1..n_mul_tasks] of int: heights_mul = [1 | i in 1..n_mul_tasks]; % Heights of all rectangles.

% Length from 1..(n*2)
var 1..(n*max_delay): schedule_length;


array[1..n_add_tasks] of var 0..n*max_delay: start_times_add = [start_times[i] | i in add];
array[1..n_add_tasks] of var 1..number_add: resources_add = [resources[i] | i in add];
array[1..n_add_tasks] of var 1..del_add: delays_add = [delays[i] | i in add];

array[1..n_mul_tasks] of var 0..n*max_delay: start_times_mul = [start_times[i] | i in mul];
array[1..n_mul_tasks] of var 1..number_mul: resources_mul = [resources[i] | i in mul];
array[1..n_mul_tasks] of var 1..del_mul: delays_mul = [delays[i] | i in mul];


% Iterate over the nodes. The dependency has to finish before the dependant.
predicate constrain_task_order() = 
	forall(dependency in 1..n)
		(forall(dependant in dependencies[dependency])(start_times[dependency] + delays[dependency] <= start_times[dependant]));

predicate task_is_add(int: task) = 
	forall(i in add)(if (task = i) then true else false endif);

% Constrain all tasks to the right resources (adders or multipliers).
predicate constrain_tasks() = 
	forall(task in 1..n)(if (task_is_add(task)) then resources[task] in 1..number_add
		else resources[task] in 1..number_mul endif); 

% Add addition delay to the addition tasks.
predicate add_add_delay() = 
	forall(i in add)(delays[i] = del_add);

% Add multiplier delay to the multiplier tasks.
predicate add_mul_delay() = 
	forall(i in mul)(delays[i] = del_mul);


array[1..last_length] of var 0..100: last_task_lengths = [start_times[task] + delays[task] | task in last];

constraint add_add_delay();
constraint add_mul_delay();
constraint constrain_tasks();
constraint constrain_task_order();
constraint schedule_length = max(last_task_lengths) - 1;

% Resource constraints for adders. One rectangle represents one execution of one task.
% One rectangle per execution.
% Start times, resource numbers, Delays, 1.
constraint diffn(start_times_add, resources_add, delays_add, heights_add);
constraint diffn(start_times_mul, resources_mul, delays_mul, heights_mul);

% No new requirements imposed, just better pruning and consistency checks.
constraint cumulative(start_times_add, delays_add, heights_add, number_add);
constraint cumulative(start_times_mul, delays_mul, heights_mul, number_mul);

solve :: seq_search([
             int_search(delays, smallest, indomain_min),
             int_search(start_times, first_fail, indomain_min)])
minimize schedule_length;