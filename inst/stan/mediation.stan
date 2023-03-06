data {
  int<lower=1> n;
  int<lower=1> d;
  vector[n] y;
  vector[n] x;
  vector[n] M;
  matrix[n,d] C;
}


parameters {
  real a;
  real b;
  real delta; // direct effect
  vector[d] alpha_y;
  vector[d] alpha_m;  
  real<lower=0> sigma_y;
  real<lower=0> sigma_m;
}

model {
  // the priors 
  delta ~ normal(0, 10);
  a ~ normal(0, 10);
  b ~ normal(0, 10);
  alpha_y ~ normal(0, 10);
  alpha_m ~ normal(0, 10);
  sigma_y ~ lognormal(1,1);
  sigma_m ~ lognormal(1,1);
  //The likelihood
  y ~ normal( x * delta + M * b + C * alpha_y, sigma_y );
  M ~ normal( a * x + C * alpha_m, sigma_m );
}

generated quantities {
  real ACME = a * b; // indirect effect
  real total_effect = ACME + delta;
  real prop_mediated = ACME / total_effect;
}



