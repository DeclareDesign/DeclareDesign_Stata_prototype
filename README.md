# MATA
MATA 'under the hood' code for STATA version

**Goals**: This repo will contain 'proof of concept' code which will show how key features of DeclareDesign might work in `STATA`. The goal is to address the four topics below and then move on to a final product which can be reviewed by the STATA journal, etc. 

1. How can a “design” be declared

- write a program yourself, using our helpers, and then we can help diagnose it
- a web site helps you write the program
- a function called declare_design (first step) (second step)
- take a bunch of do files

2. How can we run the design? run program once?

3. How can we diagnose the design

- diagnose_design program that takes a

4. What kind of helpers are needed to execute designs

- randomizr is first
- need a switching equation
- how can hierarchical data be created like fabricatr?

**Approach**: The approach will be written primarily in `MATA`; once a sufficient set of classes and functions is written to accomplish `DeclareDesign`'s core functionality, these codes will integrated as far as possible with `STATA`, such that users are not expected to learn `MATA` (unless perhaps they are interested in some very advanced feature).


