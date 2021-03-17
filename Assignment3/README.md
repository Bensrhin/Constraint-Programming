The file **SimpleDFS.java** contains a simple but fully functional depth first search (DFS). 
It implements the basic functionality of DFS and Branch-and-Bound for minimization. 
The program is very simple since it makes it possible to select variables based on the order defined by the variable vector
and it always assigns a minimal value to each variable.

You can try the search on the provided example, Golomb.java. It is minimization example and it is described, 
for example here https://mathworld.wolfram.com/GolombRuler.html.

In this assignment you have to change the behavior of this search. You are to implement a split search that selects a variable, x, 
based on input order, as it is done in SimpleDFS, but then narrows the domain of the variable without assigning a single value to 
the selected variable. Instead the domain is split around the middle point, c, of the domain, that is c = (x.min() + x.max())/2.

The two search strategies do the following selections:

        The first search strategy makes a choice point which first tries the lower half of the selected variable x:
            first choice x ≤ c, and if this fails
            second choice: x > c, the negation of x ≤ c
        The second search strategy first tries the upper half of the selected variable x:
            first choice x ≥ c, and if this fails
            second choice: x < c, the negation of x ≥ c.

**Task 1**: implement search strategy 1.

**Task 2:** implement search strategy 2.

**Task 3:** Experiment with different variable selection methods and select the best method for the golomb example. 
Report the following statistics for the search (requires some code in the search):

    total number of search nodes
    number of wrong decisions
