# Server Setup

This repo contains bash scripts for setting up a new Ubuntu server. The scripts are idempotent and can be ran individually or all at once using the `setup.sh` script (recommended).

Included scripts:

- `configure-firewall.sh` - configures the `ufw` firewall to rate limit SSH connections and allow HTTP/HTTPS connections.

- `create-user.sh` - creates a new, non-root user with sudo privileges. The username is taken from the `.env` file.

## Usage

1. Copy the `.env.example` file to `.env` and fill in the values.

```sh
cp .env.example .env
```

2. Run the setup script.

```sh
bash setup.sh
```

3. The server is now set up and ready to use!

## Notes

- It is assumed that the server is already set up for SSH connections. This is usually done via the hosting provider on server creation.
- Scripts must be ran as the root user.
- Last tested on `Ubuntu 20.04.1 LTS`.
