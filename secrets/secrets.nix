let
  dsluijk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICPboZ99kJlrtxjdkUSmvVbgLicyEXrS4PGmXKBs7ptp me@dany.dev";
  users = [dsluijk];

  odin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvl77vMSCzpGgMC6OCc2L8HluflBaHcrJKSHHm7/iMV";
  paradise = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDaDZQr1pggZj1l9HjYXVhRljP7QiEVUNN2YJR/I2UiT";
  hermes = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII5z1HuhFqnAgyng/XQATEeFvssP14d45vFNY411McBi";
  systems = [odin paradise hermes];
in {
  "wireless.age".publicKeys = [odin hermes] ++ users;
  "authentik.age".publicKeys = [paradise] ++ users;
  "immich.age".publicKeys = [paradise] ++ users;
  "mealie.age".publicKeys = [paradise] ++ users;

  "outline/oidc.age".publicKeys = [paradise] ++ users;
  "outline/smtp.age".publicKeys = [paradise] ++ users;

  "headscale/oidc.age".publicKeys = [paradise] ++ users;
}
