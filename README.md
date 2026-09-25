# Multimedia server

This repository provisions a music server with Ansible. Docker Compose runs Navidrome and Caddy. Caddy handles HTTPS and proxies requests to Navidrome over a shared Docker network. An optional SFTP storage mount supplies the music library through rclone.

## Configuration

Copy the sample configuration, then fill in the values in the ignored file:

```sh
cp ansible/vars.yml.example ansible/vars.yml
```

`ansible/vars.yml` holds the server address, service domain, DNS zone, storage endpoint and credentials, and pinned storage SSH host key. It is excluded by `.gitignore`. Keep deployment keys outside this repository as well. The playbook reads the file directly; the inventory takes its connection address from `server_ip`.

The storage mount runs only when its host, username, and password are configured. When storage is absent, Navidrome uses a local music directory. If DNS management is enabled, configure the DNS zone and API token together. The token needs DNS read and write permissions.

## Local deployment

Install Ansible and the collections in `ansible/requirements.yml`, then run:

```sh
ansible-galaxy collection install -r ansible/requirements.yml
./deploy.sh
```

The script requires `ansible/vars.yml` and applies `ansible/site.yml`. Ensure your SSH key is authorized on the server before deploying. Ansible's inventory connects as root.

## Music storage

The storage role mounts a remote music directory read-only at `storage_box_mount_dir`. Navidrome reads it through a read-only container mount and keeps its application data in a separate Docker volume. The rclone service uses a bounded VFS read cache; it is not an offline library copy. The storage SSH host key comes from `vars.yml` and is checked by rclone.

To upload music from another machine, use an SFTP client or an independently configured rclone remote. The deployment repository does not store upload credentials.

## DNS and HTTPS

The DNS role updates records for configured service domains when `dns_zone` is set. `server_ip` supplies the A record target; `server_ipv6`, when set, supplies the AAAA target. Caddy obtains certificates for the configured service domain. Navidrome is reachable through Caddy and does not publish its container port on the host.

## GitHub Actions deployment

The workflow validates Ansible syntax and deploys on changes to deployment files in the main branches. Configure the `production` GitHub Environment with these values:

| Type | Name | Purpose |
| --- | --- | --- |
| Secret | `SSH_PRIVATE_KEY` | Authorized deployment key |
| Secret | `INFOMANIAK_API_TOKEN` | DNS API access |
| Secret | `STORAGE_BOX_PASSWORD` | Storage account password |
| Secret | `STORAGE_BOX_HOST_KEY` | Pinned storage SSH host key |
| Secret | `SERVER_IP` | Server address |
| Secret | `SERVER_IPV6` | Optional IPv6 DNS target |
| Secret | `DNS_ZONE` | DNS zone |
| Secret | `NAVIDROME_DOMAIN` | Service domain |
| Secret | `STORAGE_BOX_HOST` | Storage endpoint |
| Secret | `STORAGE_BOX_PORT` | Storage SSH port |
| Secret | `STORAGE_BOX_USERNAME` | Storage account |

The workflow creates `ansible/vars.yml` on the runner and removes it after deployment. These Environment values must be configured before a deployment; the repository contains no live defaults. The workflow also supports manual runs.
