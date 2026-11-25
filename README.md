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


# Host-specific installs

Each machine has its own entry in the flake, so things can be installed on one machine only:

- **System-wide packages and services:** `systems/<host>/default.nix` (e.g. `environment.systemPackages`).
- **User packages and programs (home-manager):** `home/hosts/<host>.nix`. Only `work` has one so far, it imports
  the shared `home/linux-common.nix` and is where work-only packages go. `tux` and `tuxollini` use `home/linux.nix`,
  which is `linux-common.nix` plus personal-only modules (Obsidian).
- **Something shared by all linux machines:** `home/linux-common.nix` or `systems/modules/`.
- **Just trying something out:** `nix shell nixpkgs#<package>` gives a temporary shell with it, nothing is
  written to the repo.

New files must be `git add`ed before the flake can see them. The sync scripts pick the entry matching the
machine's hostname, so no script changes are needed for a new host.

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

