# --- Setup: load base parallel, read data --------------------------------

library(parallel) # built-in; no install needed
library(here) 

fish <- read.csv(here("fish_bootstrap_parallel_computing.csv")) # changed pathway

# Filter to Lake Erie only
fish <- subset(fish, Lake == "Erie")
species <- unique(fish$Species)   # list of species in Lake Erie

# --- Bootstrap function (mean weight, not length) -------------------------
boot_mean_weight <- function(species_name, n_boot = 10000, sample_size = 200) {
  # Pull the Weight_g vector for this species
  x <- fish$Weight_g[fish$Species == species_name]
  
  # Do n_boot resamples WITH replacement; compute the mean each time
  means <- replicate(n_boot, mean(sample(x, size = sample_size, replace = TRUE)))
  
  # Return the average of those bootstrap means
  mean(means)
}


# --- SERIAL version -------------------------------------------------------
t_serial <- system.time({
  res_serial <- lapply(
    species,
    boot_mean_weight,
    n_boot = 10000,
    sample_size = 200
  )
})
# names(res_serial) <- species

# --- PARALLEL version -----------------------------------------------------
n_cores <- max(1, detectCores() - 1)    # use all but one core
cl <- makeCluster(n_cores)

clusterSetRNGStream(cl, iseed = 123)    # reproducible results
clusterExport(cl, varlist = c("fish", "boot_mean_weight", "species"), envir = environment())

t_parallel <- system.time({
  res_parallel <- parLapply(
    cl,
    species,
    boot_mean_weight,
    n_boot = 10000,
    sample_size = 200
  )
})
# names(res_parallel) <- species

stopCluster(cl)


# --- Compare runtimes & show speedup --------------------------------------

elapsed_serial   <- unname(t_serial["elapsed"])
elapsed_parallel <- unname(t_parallel["elapsed"])
speedup <- elapsed_serial / elapsed_parallel

cat("Serial elapsed (s):   ", round(elapsed_serial, 3), "\n")
cat("Parallel elapsed (s): ", round(elapsed_parallel, 3), " using ", n_cores, " cores\n", sep = "")
cat("Speedup:               ", round(speedup, 2), "x\n", sep = "")
