# My NixOS Configuration

This is a (rather pathetic) first attempt at using the Nix* ecosystem to set up an IaaC environment for my particular configurations.

## What are Hosts, Roles and Abilities?

There are multiple systems that this configuration defines. Each of those is a host.

Each host fulfills different roles in my infrastructure. Sometimes just one, but maybe more than one at a time.

Each of those roles can only be fulfilled only if the host has certain abilitites.
Abilities don't depend on a role, some are stand-alone.

Example:

> Suppose there is an SBC called "saw", which should act as a security monitoring server.
>
> This would require it to be able to
> - provide the cctv-interface
> - connect to smart door-locks
> - have a  

This segmentation of configuration is an attempt at creating a granularly configurable setup with hopefully little duplicate code.