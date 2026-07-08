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

1. After starting, open the web UI from the **Home Assistant sidebar** (ingress), via the
   add-on's **OPEN WEB UI** button, or directly at `http://<HA-host>:5056/shelfarr/`.
2. **Register the first user** — this account automatically becomes the admin.
3. In **Admin → Settings**, configure:
   - **Indexers** (Prowlarr / Jackett / NZBHydra2 API credentials).
   - **Download clients** (qBittorrent / Deluge / Transmission / SABnzbd / NZBGet).
   - **Output paths** — point audiobooks/ebooks/downloads at `/audiobooks`, `/ebooks`,
     `/downloads` (these map to the `*_path` options above).
   - Optional Audiobookshelf integration, notifications, and OIDC/SSO.

## Web access (ingress + direct port)

This add-on supports both:

- **Ingress** (recommended): open Shelfarr from the HA sidebar — no port needed, authenticated
  by Home Assistant. An nginx layer serves Shelfarr under a fixed base path (`/shelfarr`) and
  rewrites it onto HA's dynamic ingress path, including live (websocket) updates.
- **Direct port `5056`** (fallback): reachable at `http://<HA-host>:5056/shelfarr/`. Note the
  app now lives under `/shelfarr/`, so the bare `http://<HA-host>:5056/` will 404 — use the
  WebUI link, which points at the correct path.

## Notes

- Because Shelfarr serves under `/shelfarr`, health is checked at `GET /shelfarr/up`.
- ActionCable request-forgery protection is disabled so live updates work through the ingress
  proxy; the connection is still protected by Home Assistant authentication.

### Notification deep-links and ingress

Links that Shelfarr sends to **external** services (Discord / Telegram / webhook notifications
that link back to a specific request) do **not** work reliably when Shelfarr is opened through
**ingress**. Home Assistant's ingress URL uses a per-session token
(`/api/hassio_ingress/<token>/…`) that rotates and is only valid inside the HA session, so it
cannot be baked into a link that opens from an external app. This is a limitation of ingress
itself, not something the add-on can work around.

If you rely on clickable links in notifications, access Shelfarr via the **direct port**
(`http://<HA-host>:5056/shelfarr/`), which is a stable URL, and Shelfarr will generate links
against it. In-app notifications and the UI are unaffected — only outbound links to external
chat/webhook services are impacted.
