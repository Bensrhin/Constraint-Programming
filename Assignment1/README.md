A group of n people wants to take a group photo. Each person can give preferences next to whom he or she wants to be placed in the photo. A person can give any number of preferences and a preference is unidirectional, i.e. if both Per and Vicky wants to stand next to the other placing them next to each other satisfies two preferences.  All people are place on one line, so everyone have two neighbours, with the exception of the people at the ends of the line, which have one neighbour.

Task 1: Write a program that finds a placement that maximizes the number satisfied preferences, i.e. the cost function counts the number of satisfied preferences. The preferences are provided in a data input file. Two examples are provided bellow.

With this approach some people might be placed far from everyone they want to stand next to. Another way to rank placements is to minimise the longest distance between the people that want to stand next to another.

Task 2: Write a MiniZinc program that finds a placement that minimise the longest distance between people with a preference, i.e. for each preference there is a distance between the two people. The cost function is the largest of these distances.
