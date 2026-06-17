# haos-app-shelfarr

A custom [Home Assistant](https://www.home-assistant.io/) add-on repository for
[Shelfarr](https://github.com/Pedro-Revez-Silva/shelfarr) — self-hosted ebook & audiobook
request and management for the *arr ecosystem.

## Add this repository

1. In Home Assistant, go to **Settings → Add-ons → Add-on Store**.
2. Open the **⋮** menu (top right) → **Repositories**.
3. Add the URL:

   ```
   https://github.com/ArgusLi/haos-app-shelfarr
   ```

4. The **Shelfarr** add-on will appear in the store. Install it (the image builds locally on
   first install, which can take a few minutes), then start it.

## Add-ons in this repository

| Add-on | Description |
| --- | --- |
| [Shelfarr](shelfarr/) | Ebook & audiobook request/management for the *arr ecosystem. |

See the [add-on documentation](shelfarr/DOCS.md) for configuration and first-run setup.

## Storage & access

- Database/app storage lives in the add-on's private config dir (included in HA backups).
- Audiobook/ebook/download libraries live under `/share/shelfarr/...` (configurable), so they
  are accessible to other add-ons and over Samba.
