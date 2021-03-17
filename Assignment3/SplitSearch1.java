package lab3;


import java.util.Map;
import org.jacop.constraints.Not;
import org.jacop.constraints.PrimitiveConstraint;
import org.jacop.constraints.XeqC;
import org.jacop.constraints.XgtC;
import org.jacop.constraints.XltC;
import org.jacop.constraints.XgteqC;
import org.jacop.constraints.XlteqC;
import org.jacop.core.FailException;
import org.jacop.core.IntDomain;
import org.jacop.core.IntVar;
import org.jacop.core.Store;

/**
 * Implements Simple Depth First Search .
 * 
 * @author Krzysztof Kuchcinski
 * @version 4.2
 */

public class SplitSearch1  {

    boolean trace = false;

    /**
     * Store used in search
     */
    Store store;

    /**
     * Defines varibales to be printed when solution is found
     */
    IntVar[] variablesToReport;

    /**
     * It represents current depth of store used in search.
     */
    int depth = 0;

    /**
     * It represents the cost value of currently best solution for FloatVar cost.
     */
    public int costValue = IntDomain.MaxInt;

    /**
     * It represents the cost variable.
     */
    public IntVar costVariable = null;

    /*
     * Number of visited nodes
     */
    public long N=0;

    String variable_choice;
    public boolean strategy;
    /*
     * Number of failed nodes excluding leave nodes
     */
    public long failedNodes = 0;

    public SplitSearch1(Store s, int straNb, String variable_choice) {
	store = s;
        assert straNb >= 1 || straNb <= 2 : "The strategy number must be 1 or 2";
        strategy = straNb==1;
        this.variable_choice = variable_choice;
        
    }


    /**
     * This function is called recursively to assign variables one by one.
     */
    public boolean label(IntVar[] vars) {
        
	N++;
	
	if (trace) {
	    for (int i = 0; i < vars.length; i++) 
		System.out.print (vars[i] + " ");
	    System.out.println ();
	}

	ChoicePoint choice = null;
	boolean consistent;

	// Instead of imposing constraint just restrict bounds
	// -1 since costValue is the cost of last solution
	if (costVariable != null) {
	    try {
		if (costVariable.min() <= costValue - 1)
		    costVariable.domain.in(store.level, costVariable, costVariable.min(), costValue - 1);
		else
		    return false;
	    } catch (FailException f) {
		return false;
	    }
	}

	consistent = store.consistency();
		
	if (!consistent) {
	    // Failed leaf of the search tree
	    return false;
	} else { // consistent

	    if (vars.length == 0) {
		// solution found; no more variables to label

		// update cost if minimization
		if (costVariable != null)
		    costValue = costVariable.min();

		reportSolution();

		return costVariable == null; // true is satisfiability search and false if minimization
	    }

 	    choice = new ChoicePoint(vars);
            
            if (choice.var.min() == choice.var.max()){
                N++;
                consistent = label(choice.getSearchVariables());
                if (consistent) {
                    return true;
                } else {
                    failedNodes++;
                    return false;
                }        
            }
            else{
                levelUp();
                store.impose(choice.getConstraint(strategy, true));
                consistent = label(vars);
                if (consistent) {
                    return true;
                } else {
                    failedNodes++;
                    restoreLevel();
                    store.impose(choice.getConstraint(strategy, false));
                    
                    consistent = label(vars);
                    levelDown();
                    if (consistent) {
                        return true;
                    } else {
                        return false;
                    }
                }
                
                
            }

            
	}
    }

    void levelDown() {
	store.removeLevel(depth);
	store.setLevel(--depth);
    }

    void levelUp() {
	store.setLevel(++depth);
    }

    void restoreLevel() {
	store.removeLevel(depth);
	store.setLevel(store.level);
    }

    public void reportSolution() {
	System.out.println("Nodes visited: " + N);

	if (costVariable != null)
	    System.out.println ("Cost is " + costVariable);

	for (int i = 0; i < variablesToReport.length; i++) 
	    System.out.print (variablesToReport[i] + " ");
	System.out.println ("\n---------------");
    }

    public void setVariablesToReport(IntVar[] v) {
	variablesToReport = v;
    }

    public void setCostVariable(IntVar v) {
	costVariable = v;
    }

    
    
    
    public class ChoicePoint {

	IntVar var;
	IntVar[] searchVariables;
	int c;


	public ChoicePoint (IntVar[] v) {
            if (variable_choice.equals("input_order")){
                 var = selectVariable(v);
            }
            else if (variable_choice.equals("first_fail")){
                 var = selectVarFirstFail(v);
            }
            else if (variable_choice.equals("smallest")){
                 var = selectVarSmallest(v);
            }
            else if (variable_choice.equals("largest_min")){
                 var = selectVarLargestMin(v);
            }
            else if (variable_choice.equals("smallest_max")){
                 var = selectVarSmallestMax(v);
            }
            else if (variable_choice.equals("most_constraints")){
                 var = selectMostConstraint(v);
            }
            else{
                System.err.println("This Variable Selection method is not valid");
            }
	    c = selectSplitValue(var);
	}

	public IntVar[] getSearchVariables() {
	    return searchVariables;
	}

	/**
	 * example variable selection; input order
	 */ 
	IntVar selectVariable(IntVar[] v) {
	    if (v.length != 0) {

		searchVariables = new IntVar[v.length-1];
		for (int i = 0; i < v.length-1; i++) {
		    searchVariables[i] = v[i+1]; 
		}

		return v[0];

	    }
	    else {
		System.err.println("Zero length list of variables for labeling");
		return new IntVar(store);
	    }
	}
        
        IntVar selectVarFirstFail(IntVar[] v) {
            if (v.length != 0) {
                searchVariables = new IntVar[v.length - 1];
                IntVar min = v[0];
                int minIndex = 0;

                for (int i = 0; i < v.length; i++) {
                        if (v[i].getSize() < min.getSize()) {
                                min = v[i];
                                minIndex = i;
                        }
                }

                for (int i = 0, j = 0; i < v.length; i++) {
                        if (i != minIndex) {
                                searchVariables[j] = v[i];
                                j++;
                        }
                }

                return min;

            } else {
                    System.err.println("Zero length list of variables for labeling");
                    return new IntVar(store);
            }
        }


        IntVar selectVarSmallest(IntVar[] v) {
            if (v.length != 0) {

                searchVariables = new IntVar[v.length - 1];
                IntVar min = v[0];
                int minIndex = 0;

                for (int i = 0; i < v.length; i++) {
                        if (v[i].min() < min.min()) {
                                min = v[i];
                                minIndex = i;
                        }
                }

                for (int i = 0, j = 0; i < v.length; i++) {
                        if (i != minIndex) {
                                searchVariables[j] = v[i];
                                j++;
                        }
                }

                return min;

            } else {
                    System.err.println("Zero length list of variables for labeling");
                    return new IntVar(store);
            }
        }

        IntVar selectVarLargestMin(IntVar[] v) {
            if (v.length != 0) {

                searchVariables = new IntVar[v.length - 1];
                IntVar max = v[0];
                int maxIndex = 0;

                for (int i = 0; i < v.length; i++) {
                        if (v[i].min() > max.min()) {
                                max = v[i];
                                maxIndex = i;
                        }
                }

                for (int i = 0, j = 0; i < v.length; i++) {
                        if (i != maxIndex) {
                                searchVariables[j] = v[i];
                                j++;
                        }
                }

                return max;

            } else {
                    System.err.println("Zero length list of variables for labeling");
                    return new IntVar(store);
            }
        }

        IntVar selectVarSmallestMax(IntVar[] v) {
            if (v.length != 0) {

                searchVariables = new IntVar[v.length - 1];
                IntVar min = v[0];
                int minIndex = 0;

                for (int i = 0; i < v.length; i++) {
                        if (v[i].max() > min.max()) {
                                min = v[i];
                                minIndex = i;
                        }
                }

                for (int i = 0, j = 0; i < v.length; i++) {
                        if (i != minIndex) {
                                searchVariables[j] = v[i];
                                j++;
                        }
                }

                return min;

            } else {
                System.err.println("Zero length list of variables for labeling");
                return new IntVar(store);
            }
        }
        // most constrained option selects a variable that appears in most constraints,
        IntVar selectMostConstraint(IntVar[] v) {
            if (v.length != 0) {
                
                searchVariables = new IntVar[v.length - 1];
                int max = -1;
                int index=0;
                IntVar max_var = null;
                for (int i=0; i<v.length; i++){
                    int size = v[i].sizeConstraintsOriginal();
                    if (max < size){
                        max_var = v[i];
                        index = i;
                        max = size;
                    }
                }
                for (int i = 0; i < v.length; i++) {
                    if (i < index){
                        searchVariables[i] = v[i]; 
                    }
                    if (i > index){
                        searchVariables[i - 1] = v[i]; 
                    }
		    
		}
                return max_var;

            } else {
                System.err.println("Zero length list of variables for labeling");
                return new IntVar(store);
            }
        }
        
	/**
	 * example value selection; split value
	 */ 
	int selectSplitValue(IntVar v) {  
            try{
                if (strategy){
                return (v.min() + v.max())/2;
                }
                if ((v.min() + v.max()) % 2 ==0){
                    return (v.min() + v.max())/2;
                }
                return (v.min() + v.max())/2 + 1;
            }
            catch (java.lang.NullPointerException e){
                System.out.println("Try to write the correct name of the Variable Selection method");
                System.exit(0);
            }
            return 0;
	}
        
        
	/**
	 * example constraint assigning a selected value
	 */
	public PrimitiveConstraint getConstraint(boolean strategy, boolean left) {
            if (strategy){
                if (left){
                    return new XlteqC(var, c);
                }
                return new XgtC(var, c);
            }
            else{
                if (!left){
                return new XltC(var, c);
                }
                return new XgteqC(var, c);
            }
	    
	}
    }
}
