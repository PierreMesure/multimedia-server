# Infrastructure specification

## Deployment model

Ansible provisions a Linux server and deploys Docker Compose services. The inventory resolves the SSH target from `server_ip` in the ignored `ansible/vars.yml`. All installation-specific addresses, domains, account names, and credentials belong in that file or in the deployment environment.

## Services

| Component | Purpose | Exposure | Persistent data |
| --- | --- | --- | --- |
| Caddy | HTTPS reverse proxy | Web ports on the host | Certificate and configuration volumes |
| Navidrome | Music streaming | Shared Docker network through Caddy | Application data volume; read-only music mount |
| rclone | Optional SFTP music mount | Outbound storage connection | Bounded VFS read cache |

The storage role pins the remote SSH host key. Navidrome's music directory is read-only inside its container. The playbook manages DNS A records and optional AAAA records through the configured provider.

## Security and operations

The common role installs firewall and intrusion prevention packages. SSH access uses a deployment key. Ansible templates any service secrets to restricted files on the server. Review host firewall rules, SSH settings, and key rotation as separate operational tasks; the playbook does not currently enforce all of those settings.
