# 1.21.1 Tiny Prism instance

This repository contains the shared, reproducible parts of the Prism Launcher
instance: its Minecraft/NeoForge manifest, mods, shared mod configuration,
default configuration, resource packs, and shader packs.

Worlds, server lists, account/session data, command and recipe histories,
screenshots, logs, crash reports, caches, machine-specific Java settings, and
other runtime files stay local and are intentionally ignored.

## Install

1. Clone this repository into your Prism Launcher `instances` directory.
2. Copy `instance.cfg.example` to `instance.cfg` in the cloned directory.
3. Refresh or restart Prism Launcher, then launch the instance.

On Windows PowerShell, step 2 is:

```powershell
Copy-Item instance.cfg.example instance.cfg
```

On Linux or macOS:

```sh
cp instance.cfg.example instance.cfg
```

Prism will fill the local `instance.cfg` with machine-specific values. Because
that file is ignored, launcher activity will not leak personal details or make
normal pulls conflict.

## Update

Close Minecraft, open a terminal in this instance directory, and run:

```sh
git pull --ff-only
```

Shared files under `minecraft/config` are versioned intentionally. If a mod
rewrites one locally, review or discard that change before pulling.
