# ADR 001: Debian over Arch

## Status
Accepted

## Context
NIDAN requires a reliable, secure, and long-term supported Linux foundation to build its custom operating system image (for T1 and T2 devices). We considered rolling release distributions like Arch Linux, but they introduce instability and frequent breaking changes that are unsuitable for resource-constrained, remote classroom environments.

## Decision
We will use **Debian 13 "trixie"** as the base for the NIDAN Linux image. 

## Consequences
- **Positive:** We gain access to Debian's LTS support, security lifecycle, and a stable Linux 6.12 LTS-series kernel. Debian also has broad architecture support, making future hardware transitions easier. We do not have to build a Linux distribution from scratch.
- **Negative:** Packages might be slightly older compared to rolling release distros, requiring backports if cutting-edge features are needed.
