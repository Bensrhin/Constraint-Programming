![urban](https://user-images.githubusercontent.com/64482881/111470691-6b165780-8728-11eb-9627-b1fce2bfe8bc.png)

Urban planning requires careful placement and distribution of commercial and residential lots. Too many commercial lots in one area leave no room for residential shoppers. Conversely, too many residential lots in one area leave no room for shops or restaurants.

The 5x5 grid in depicted in the figure bellow shows a sample configuration of residential and commercial lots. Your job is to place a mix of residential and commercial lots to maximize the quality of the layout. The quality of the layout is determined by a points system, where all rows and columns adds points based on the number of residential/commercial lots. In the example picture points are awarded as follows:

    Any column or row that has 5 Residential lots = +5 points
    Any column or row that has 4 Residential lots = +4 points
    Any column or row that has 3 Residential lots = +3 points
    Any column or row that has 5 Commercial lots = -5 points
    Any column or row that has 4 Commercial lots = -4 points
    Any column or row that has 3 Commercial lots = -3 points

The layout displayed in the figure bellow has a total of 9 points:

    Points for each column, from left to right = -3, -5, +3, +4, +3
    Points for each row, from top to bottom = +3, +3, +3, +3, -5.

**Task:** Write a CP-program to solve this optimization problem. Your program must be flexible, all data must be parameters, i.e. the data from the files linked bellow must be accessed using the parameter names and may now be hard coded in your program.

