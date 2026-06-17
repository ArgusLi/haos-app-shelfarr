# Shelfarr

[Shelfarr](https://github.com/Pedro-Revez-Silva/shelfarr) is a self-hosted ebook & audiobook
request and management system for the *arr ecosystem. This add-on wraps the official Shelfarr
container, adds Home Assistant integration, and stores its data on your HA instance.

## Installation

1. Add this repository to Home Assistant: **Settings → Add-ons → Add-on Store → ⋮ → Repositories**,
   then paste the repository URL (`https://github.com/ArgusLi/haos-app-shelfarr`).
2. Install **Shelfarr** from the store. The image is built locally on first install, so the
   initial install can take several minutes.
3. (Optional) Adjust the options below.
4. Start the add-on and open the web UI.

## Configuration options

| Option | Default | Description |
| --- | --- | --- |
| `PUID` | `0` | User ID that Shelfarr runs as. `0` (root) lets it write to root-owned `/share`. |
| `PGID` | `0` | Group ID that Shelfarr runs as. |
| `TZ` | `UTC` | Timezone (e.g. `Europe/Lisbon`, `America/New_York`). |
| `RAILS_MASTER_KEY` | _(empty)_ | Optional 64-char hex encryption key. Leave empty to let Shelfarr auto-generate and persist one in storage. |
| `audiobooks_path` | `/share/shelfarr/audiobooks` | Where audiobooks are written. Exposed to Shelfarr as `/audiobooks`. |
| `ebooks_path` | `/share/shelfarr/ebooks` | Where ebooks are written. Exposed to Shelfarr as `/ebooks`. |
| `downloads_path` | `/share/shelfarr/downloads` | Download client completed-items folder. Exposed to Shelfarr as `/downloads`. |

### Where data lives

- **Database & app storage** are kept in the add-on's private config directory (`/config/storage`
  inside the container, symlinked to `/rails/storage`). This is included in Home Assistant backups.
- **Libraries** (audiobooks, ebooks, downloads) live under `/share/shelfarr/...` by default so they
  are browsable over Samba and shareable with other add-ons. Change the paths with the options above.

## First-run setup

1. After starting, open the web UI via the **OPEN WEB UI** button (or `http://<HA-host>:5056`).
2. **Register the first user** — this account automatically becomes the admin.
3. In **Admin → Settings**, configure:
   - **Indexers** (Prowlarr / Jackett / NZBHydra2 API credentials).
   - **Download clients** (qBittorrent / Deluge / Transmission / SABnzbd / NZBGet).
   - **Output paths** — point audiobooks/ebooks/downloads at `/audiobooks`, `/ebooks`,
     `/downloads` (these map to the `*_path` options above).
   - Optional Audiobookshelf integration, notifications, and OIDC/SSO.

## Notes

- Web access is via the mapped port `5056` (container port `80`). Ingress is not used.
- Health is checked by Shelfarr at `GET /up`.
