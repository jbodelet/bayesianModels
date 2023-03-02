#' DISCRETE RELEVANT LIFE COURSE MODEL
#' 
#' Estimate Madathil's regression model
#' y_i = delta X_ij * weights_j + C_i' alpha + eps_i
#' 
#' @param y  The output vector.
#' @param M The mediator.
#' @param x The treatment variable.
#' @param Covariates A matrix of covariates.
#' @param ... Optional parameters to pass to the stan function.
#' @return An list containing estimates for mediation.
#' @export
mediation <- function(y, x, M, covariates = NULL, ... ){
  C <- cbind( rep(1, length(y) ), covariates ) # add a column of ones for the intercept
  dat <- list( n = length(y), d = ncol(C), y = y, x = x, M = M, C = C )
  fileName <- "mediation.stan"
  stanFile <- system.file("stan", fileName, package = "fRLM")
  fit <- rstan::stan( file = stanFile, data = dat, ...)
}



