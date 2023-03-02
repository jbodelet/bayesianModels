data {
  int<lower=1> n;
  int<lower=1> J;
  int<lower=1> d;
  vector[n] y;
  matrix[n,J] x;
  vector[n] M;
  matrix[n,d] C;
}


parameters {
  real delta;
  simplex[J] weights;
  vector[d] alpha;
  real a;
  real b;
  real<lower=0> sigma;
}

model {
  // the priors 
  delta ~ normal(0, 10);
  a ~ normal(0, 10);
  b ~ normal(0, 10);
  weights ~ dirichlet( rep_vector( 1.0/J, J ) );
  sigma ~ lognormal(1,1);
  for ( j in 1:d )
    alpha[j] ~ normal(0, 1);
  //The likelihood
  for (i in 1:n)
    y[i] ~ normal( delta * x[i] * weights + M[i] * b + C[i] * alpha, sigma );
  M ~ normal( delta * x[i] * weights + M[i] * b + C[i] * alpha, sigma )
}




