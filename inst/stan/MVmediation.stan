data {
  int<lower=1> n;
  int<lower=1> p;
  int<lower=1> d;
  matrix[n,p] y;
  vector[n] x;
  vector[n] M;
  matrix[n,d] C;
}


parameters {
  // parameters outcome:
  vector[p] delta; // direct effects
  real mu_delta;
  real<lower=0> sigma_delta;
  vector[p] b;
  real mu_b;
  real<lower=0> sigma_b;
  matrix[d,p] alpha_y;
  real<lower=0> sigma_y[p];
  // parameters outcome:
  real a;
  vector[d] alpha_m;  
  real<lower=0> sigma_m;
}

model {
  // direct effect:
  delta ~ normal(mu_delta, sigma_delta);
  mu_delta ~ normal(0, 10);
  sigma_delta ~ lognormal(1,1);
  // mediator effect:
  b ~ normal(mu_b, sigma_b);
  mu_b ~ normal(0, 10);
  sigma_b ~ lognormal(1,1);
  // others:
  for(j in 1:p )
    alpha_y[,j] ~ normal(0, 10);
  sigma_y ~ lognormal(1,1);
  // priors for the mediator model: 
  a ~ normal(0, 10);
  alpha_m ~ normal(0, 10);
  sigma_m ~ lognormal(1,1);
  //The likelihood
  for(j in 1:p )
    y[,j] ~ normal( x * delta[j] + M * b[j] + C * alpha_y[,j], sigma_y[j] );
  M ~ normal( a * x + C * alpha_m, sigma_m );
}

generated quantities {
  vector[p] ACME = a * b; // indirect effect
  vector[p] total_effect = ACME + delta;
  vector[p] prop_mediated = ACME ./ total_effect;
}



