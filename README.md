# NixOS configuration

I use this configuration in all my Linux boxes.

## Usage

- Clone this repo.
- Unlock the private files with `git-crypt unlock`.
- Keep a copy of your existing `private/boot.nix`, `private/filesystems.nix`, `private/hardware.nix` and `private/networking.nix`, if any.
- Copy the files in your repository to your `/etc/nixos`.
- Replace or adapt `/etc/nixos/private/boot.nix`, `/etc/nixos/private/filesystems.nix`, `/etc/nixos/private/hardware.nix` and `/etc/nixos/private/networking.nix`.
- Rebuild NixOS as usual: `nixos-rebuild switch`.

## Initial setup

- For crypt/encrypting files, I'm using crohr's Docker image. Here's the script I use.
  #!/bin/bash -e
  
  if [ "${1}" == "clean" ]; then
    exit 0;
  else
    docker run -it -v $(pwd):/repo -v ~/.gnupg:/root/.gnupg -w /repo crohr/git-crypt git-crypt "$@"
  fi

- This repo assumes a `git-crypt` executable under `/usr/local/bin`, no make sure the above script
exists in that location.

## Committing changes

After any change in NixOS configuration (anywhere else but in `private` or `packages/private` folders):

- Copy the files back to your local repository,
- Commit the changes,
- Run `git-crypt lock`,
- Push the changes,
- Run `git-crypt unlock` again.
