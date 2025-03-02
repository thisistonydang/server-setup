# Self-Hosted Server Setup

Setting up and securing a new server for self-hosting web applications can be a daunting task. This repo contains bash scripts for automating the process!

The scripts in this repo are intended to set up and secure a new Ubuntu server for self-hosting web applications. Running the `setup.sh` script from the repo's root will copy the server's configuration variables (defined in the `.env` file) to the server and run all the following setup scripts:

- `configure-firewall.sh` - Configures the `ufw` firewall to rate limit SSH connections and allow HTTP/HTTPS connections.

- `configure-ssh.sh` - Disables password authentication and only allow connections via SSH keys.

- `create-user.sh` - Creates a new, non-root user with their own home directory, bash shell, and sudo privileges. The username is taken from the `.env` file.

- `upgrade-packages.sh` - Upgrades all installed packages and reboots the server.

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

- It is assumed that the server is already set up for SSH connections. This is usually done via the hosting provider on server creation. See [SSH Key Creation](#ssh-key-creation) section below if you need to do this manually.
- Scripts must be ran as the root user to avoid needing to enter a password for sudo.
- Last tested on `Ubuntu 20.04.1 LTS`.

## SSH Key Creation

If you need to create a new SSH key pair, run the [ssh-keygen](https://www.ssh.com/academy/ssh/keygen) command:

```sh
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "${your_email@example.com}"
```

Optionally, you can add the public key to the server manually if your hosting provider does not support adding SSH keys to the server during creation. Run the [ssh-copy-id](https://www.ssh.com/academy/ssh/copy-id) command:

```sh
ssh-copy-id -i ~/.ssh/id_ed25519.pub root@${YOUR_SERVER_IP}
```
