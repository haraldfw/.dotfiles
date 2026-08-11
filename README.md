# NIXOS config

My personal configs across my systems.


# Setup/Installation

Setting up a new system:

1. Open a shell with git: `nix-shell -p git`
2. Pull repo
3. Copy one of the hosts in the `systems` dir.
4. Replace the contents of the `hardware-configuration.nix` file with the output of the command `nixos-generate-config --show-hardware-config`
5. Run for the first sync: `./scripts/setup-new-system.bash`

Future syncs are done with `./scripts/sync.bash`. This syncs both system-config and home-files. If you only wish to sync home-files use `./scripts/sync-user.bash`, this is faster but only syncs homefiles.


# Cleaning up old generations

After a while nix builds up a lot of trash, and old generations on nixos can take up a lot of space. When you know you have a stable config you should clean up old ones.

Show the currently available generations:
```
nix-env --list-generations
```

Delete generations older than 30 days:
```
sudo nix-collect-garbage --delete-older-than 30d
```

You also need to run a switch-command to write changes to boot.
```
./scripts/sync.bash
```


# Credits

I used the configs of [librephoenix](https://github.com/librephoenix/nixos-config) and [Frost-Phoenix](https://github.com/Frost-Phoenix/nixos-config) for inspiration. I tested none of their setups out of the box, but I have reused a lot of their concepts, and they were great to read for figuring out how some of nix' magic can be tamed.

I had a lot of issues with fonts when installing them through home-manager, so I ended up installing these system-wide.

