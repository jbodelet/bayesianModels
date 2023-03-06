data {
  int<lower=1> n;
  int<lower=1> p;
  int<lower=1> d;
  matrix[n,p] y;
  matrix[n,p] x;
  vector[n] M;
  matrix[n,d] C;
}


parameters {
  // parameters outcome:
  vector[p] delta; // direct effects  x->y
  vector[p] a;  // x -> M
  vector[p] b;  // M -> y
  matrix[d,p] alpha_y;
  vector[d] alpha_m;
  real<lower=0> sigma_y[p];
  real<lower=0> sigma_m;
  // hyperparameters:
  real mu_delta;
  real mu_a;
  real mu_b;
  real<lower=0> sigma_a;
  real<lower=0> sigma_b;
  real<lower=0> sigma_delta;
}

model {
  // direct effect:
  delta ~ normal(mu_delta, sigma_delta);
  mu_delta ~ normal(0, 10);
  sigma_delta ~ lognormal(1,1);
  // M -> y:
  b ~ normal(mu_b, sigma_b);
  mu_b ~ normal(0, 10);
  sigma_b ~ lognormal(1,1);
  // x -> M:
  a ~ normal(mu_a, sigma_a);
  mu_a ~ normal(0, 10);
  sigma_a ~ lognormal(1,1);
  // constants:
  for(j in 1:p )
    alpha_y[,j] ~ normal(0, 10);
  alpha_m ~ normal(0, 10);
  // variances:
  sigma_y ~ lognormal(1,1);
  sigma_m ~ lognormal(1,1);
  //The likelihood
  for(j in 1:p )
    y[,j] ~ normal( x[,j] * delta[j] + M * b[j] + C * alpha_y[,j], sigma_y[j] );
  M ~ normal( x * a + C * alpha_m, sigma_m );
}

generated quantities {
  vector[p] ACME = a .* b; // indirect effect
  vector[p] total_effect = ACME + delta;
  vector[p] prop_mediated = ACME ./ total_effect;
}



