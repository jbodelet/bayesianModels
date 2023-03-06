#' DISCRETE RELEVANT LIFE COURSE MODEL
#' 
#' Estimate Madathil's regression model
#' y_i = delta X_ij * weights_j + C_i' alpha + eps_i
#' 
#' @param y  The output vector.
#' @param x The treatment variable.
#' @param M The mediator.
#' @param Covariates A matrix of covariates.
#' @param ... Optional parameters to pass to the stan function.
#' @return A rstan object. delta is the direct effect.
#' @export
#' @examples 
#' n <- 200
#' z <- rnorm(n)
#' M <- z + rnorm(n)
#' y <- 2 * z + 2 * M + rnorm(n)
#' fit <- mediation(y, z, M, warmup = 2000, iter = 4000, chains = 4)
mediation <- function(y, x, M, covariates = NULL, ... ){
  C <- cbind( rep(1, length(y) ), covariates ) # add a column of ones for the intercept
  dat <- list( n = length(y), d = ncol(C), y = y, x = x, M = M, C = C )
  fileName <- "mediation.stan"
  stanFile <- system.file("stan", fileName, package = "bayesianModels")
  fit <- rstan::stan( file = stanFile, data = dat, ...)
}



