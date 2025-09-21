# NIXOS config
Scripts to sync and configure in `/scripts`.

Leaving files in this repo as user-level access is a secutiry risk btw. Hardening can be done by `chown`-ing the entire repo to root. Though then you would have to sync as `sudo` or root. Maybe I will make some functionality for this in the future.

# Setup/Installation
Installation instructions will be added the next time I need to set up a PC and have to figure it out.

I suspect it will be something like this:
1. Open a shell with git: `nix-shell -p git`
2. Pull repo
3. Change username and hostname where it applies (hostname `tux` and username `haraldfw`)
4. Sync: `./scripts/sync.bash`

# Credits
I used the configs of [librephoenix](https://github.com/librephoenix/nixos-config) and [Frost-Phoenix](https://github.com/Frost-Phoenix/nixos-config) for inspiration. I tested none of their setups out of the box, but I have reused a lot of their concepts, and they were great to read for figuring out how some of nix' magic can be tamed.

I had a lot of issues with fonts, so I ended up installing these system-wide.
