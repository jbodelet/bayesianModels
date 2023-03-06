#' Mediation
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
#' a <- 1
#' b <- 2
#' M <- z * a + rnorm(n)
#' delta <- 2
#' y <- delta * z + b * M + rnorm(n)
#' fit <- MVmediation(y, z, M, warmup = 2000, iter = 4000, chains = 4)
mediation <- function(y, x, M, covariates = NULL, ... ){
  C <- cbind( rep(1, length(y) ), covariates ) # add a column of ones for the intercept
  dat <- list( n = length(y), d = ncol(C), y = y, x = x, M = M, C = C )
  fileName <- "mediation.stan"
  stanFile <- system.file("stan", fileName, package = "bayesianModels")
  fit <- rstan::stan( file = stanFile, data = dat, ...)
}


#' Multivariate Mediation
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
#' p <- 3
#' z <- matrix( rnorm(n*p), ncol = p )
#' a <- c(1,2,3)
#' b <- c(0,2,1)
#' M <- c(z %*% a + rnorm(n))
#' delta <- c(2,1,3)
#' y <- sapply( 1:p, function(j) delta[j] * z[, j] + b[j] * M + rnorm(n) )
#' fit <- MVmediation(y, z, M, warmup = 2000, iter = 4000, chains = 4)
MVmediation <- function(y, x, M, covariates = NULL, ... ){
  C <- cbind( rep(1, nrow(y) ), covariates ) # add a column of ones for the intercept
  dat <- list( n = nrow(y), p = ncol(y), d = ncol(C), y = y, x = x, M = M, C = C )
  fileName <- "MVmediation.stan"
  stanFile <- system.file("stan", fileName, package = "bayesianModels")
  fit <- rstan::stan( file = stanFile, data = dat, ...)
}


