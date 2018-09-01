To run the software in this directory type:
>>dosoftmaxnpboot

The plot generated as a result of "dosoftmaxnpboot"
compares the following:
(1) Estimate parameters on training data and compute
model-fit from those parameters and the training data.

(2) Estimate parameters on training data and compute
model-fit from those parameters and the test data

(3) Estimate parameters on training data and estimate
model-fit on a test data set without using test data
by using the Empirical Risk Information Criterion.
=====================================================
Your project assignment must be submitted as a group
assignment. Please submit the names of your group
members via email. Make sure at least one person in your
group has some experience with MATLAB. Make sure at least
one person in your group is good at taking derivatives.

The project is due the last day of class and should be a
folder which is zipped up and contains the following 4 items:

ITEM 1: Submit your derivation as a PDF file using either
the Word Equation Editor or LATEX to derive the gradient
and Hessian of the objective function in "objfunction.m"

ITEM 2: 
Submit your updates to the file:
"gradobjfunction.m" (this is roughly about 8 lines of MATLAB code)
HINT: Please see the other directories for how to do this for
the linear regression and logistic regression cases.

ITEM 3:
Submit your updates to the file:
"hessobjfunction.m" (this is roughly about 10 lines of MATLAB code)
HINT: Please see the other directories for how to do this for
the linear regression and logistic regression cases.

ITEM 4:
The Graph that is produced by the program when you run the program
and a short 2-5 sentence paragraph providing your interpretation of
how this graph helps us evaluate the generalization error formula
provided by the Empirical Risk Information Criterion.