The data-flow graph for the auto regression filter is depicted on the figure bellow. It consists of 16 multiplications and 12 additions. 
These operations need to be scheduled on multipliers and adders. Write a program which will optimize the schedule length for different
amount of resources as specified in the table bellow. Each node must be assigned both a time and a resource, i.e. which adder/multiplier.

Fill the table with results obtained from your program. Assume that multiplication takes two clock cycles and addition only one,
but write your program in such a way that you can easily specify otherwise. Make your program data independent, 
so if new operations is added the program does not have to be changed but only the database of facts.
Note, that this means that the graph can change.

**Task:** Write a program to solve the scheduling and allocation problem described above.
Fill the table. Optimal means that you have proved that there do not exist ay shorter schedule.

**Hints:**

• An efficient model should use Cumulative and Diff2/Diffn constraints. You may need to use special labeling.
• The example with 1 adder and 3 multipliers may take several minutes to compute.

