let
  dsluijk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICPboZ99kJlrtxjdkUSmvVbgLicyEXrS4PGmXKBs7ptp me@dany.dev";
  users = [ dsluijk ];

  odin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvl77vMSCzpGgMC6OCc2L8HluflBaHcrJKSHHm7/iMV";
  systems = [ odin ];
in
{
  "wireless.age".publicKeys = systems ++ users;
}
