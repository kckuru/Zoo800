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
# lt = 

# where:
# t is age
# lt is the length at age t
# k is the growth rate

##########
# cod
linf = 100
k = 0.4
t0 = -0.3
t = 0:20

lt = linf * (1 - exp(-k * (t - t0)))
lt

# salmon
linf = 70
k = 0.7
t0 = -0.2
t = 0:10

lt = linf * (1 - exp(-k * (t - t0)))
lt

# herring
linf = 20
k = 0.5
t0 = 0
t = 0:6

lt = linf * (1 - exp(-k * (t - t0)))
lt

#####################
# convert to function
size.at.age = function(linf, k, t0 = 0, t){
  lt = linf * (1 - exp(-k * (t - t0)))
  print(lt)
}


#########
# cod

linf = 100
k = 0.4
t0 = -0.3
t = 0:20

##########################
#  let's try a more complicated function to
# plot all growth curves on the same figure


linf = c(20, 70, 100)
k = c(0.4, 0.7, 0.5)
t0 = c(-0.3, -0.2, 0)
t = list(0:6, 0:10, 0:20)

multi.size.at.age = function(linf, k, t0, t){
  lt = linf[i] * (1 - exp(-k[i] * (t[[i]] - t0[i])))
  plot(t[[i]], lt, type = "l",
       xlim = c(0, max(unlist(t))),
       ylim = c(0, max(linf) + 10))
  
  for(i in 2:length(linf)){
    lt = linf[i] * (1 - exp(-k[i] * (t[[i]] - t0[i])))
    lines(t[[i]], lt)
  }
  
}

multi.size.at.age(linf, k, t0, t)







