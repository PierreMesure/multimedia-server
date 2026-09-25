# Changelog

## Unreleased

- Removed installation-specific addresses, domains, account identifiers, and storage host key from shareable files.
- Changed the inventory to read the server address from the ignored configuration file.
- Removed Navidrome's direct host port publication; Caddy continues to proxy it through Docker networking.
- Made CI deployment require Environment values instead of embedding defaults.

## 2026-09-25

- Pinned the rclone release and storage SSH host key to improve mount reliability.
- Bounded the VFS read cache while keeping the music library on remote storage.

## 2026-09-24

- Added Ansible provisioning roles for base packages, Docker, DNS, and music storage.
- Added Docker Compose templates for Caddy and Navidrome.
- Added local and GitHub Actions deployment paths.
