# Shelfarr add-on

Self-hosted ebook & audiobook request/management for the \*arr ecosystem, packaged as a
Home Assistant OS add-on. It wraps the official
[`ghcr.io/pedro-revez-silva/shelfarr`](https://github.com/Pedro-Revez-Silva/shelfarr) image,
keeps its SQLite database in the add-on's backed-up config storage, and writes libraries to
`/share/shelfarr/...` so they are browsable over Samba.

See [DOCS.md](DOCS.md) for installation, configuration options, and first-run setup.
