############################################
###### Lecture Notes 9/23 - Functions ######
############################################


## The expression function can be used for Greek letters 
# Example: expression(Delta == 1)

## Useful sources for plotting
# --- A Compendium of Clean Graphs in R --- #
# --- The R Graph Gallery --- #

# The generic structure of a function:
any.function <- function(arg1, arg2, arg3...){
  some instructions
}

# You can see the source code for any function by using lm
View(lm)
View(sort)

# the von Betalanffy growth equation
# is commonly used in fisheries
# to model size at a given age

# it's basic form is:
# lt = linf * (1 - exp(-k * (t - t0)))

# where:
# t is age
# lt is the length at age t
# k is the growth rate











