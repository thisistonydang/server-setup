# Server Setup (for self-hosting web applications)

Setting up and securing a new server for self-hosting web applications can be a daunting task. This repo contains bash scripts for automating the process!

The scripts in this repo are intended to set up and secure a new Ubuntu server for self-hosting web applications. Running the `setup.sh` script from the repo's root will copy the server's configuration variables (defined in the `.env` file) to the server and run all the following setup scripts:

- `configure-firewall.sh` - Configures the `ufw` firewall to rate limit SSH connections and allow HTTP/HTTPS connections.

- `configure-ssh.sh` - Disables password authentication and only allow connections via SSH keys.

- `create-user.sh` - Creates a new, non-root user with their own home directory, bash shell, and sudo privileges. The username is taken from the `.env` file.

- `install-fail2ban.sh` - Installs and configures `fail2ban` to block brute force SSH attacks.

- `install-lazy-vim.sh` - Installs the base LazyVim requirements and clones the starter configuration to the root and non-root user's home directories.

- `install-zsh.sh` - Installs ZSH and sets it as the default shell for the non-root user. Also copies the `.zshrc` and `.gitconfig` files from the [dotfiles repo](https://github.com/thisistonydang/dotfiles) to the non-root user's home directory. This is optional and can be customized by setting the `DOTFILES_REPO` variable in the `.env` file or skipped entirely by setting it to an empty string (e.g. `DOTFILES_REPO=""`).

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

3. The server is set up and ready to use! You can connect to the server with:

```sh
ssh ${YOUR_USERNAME}@${YOUR_SERVER_IP}
```

## Notes

- It is assumed that the server is already set up for SSH connections. This is usually done via the hosting provider on server creation. See [SSH Key Creation](#ssh-key-creation) section below if you need to do this manually.
- Scripts must be ran as the root user to avoid needing to enter a password for sudo.
- Last tested on `Ubuntu 20.04.1 LTS`.

## Verification

To verify that password authentication is disabled, you can try signing in without SSH keys.

```sh
ssh ${YOUR_USERNAME}@${YOUR_SERVER_IP} -o PubkeyAuthentication=no
```

You should see a message like this:

```sh
Permission denied (publickey).
```

## SSH Key Creation

If you need to create a new SSH key pair, run the [ssh-keygen](https://www.ssh.com/academy/ssh/keygen) command:

```sh
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "${your_email@example.com}"
```

Optionally, you can add the public key to the server manually if your hosting provider does not support adding SSH keys to the server during creation. Run the [ssh-copy-id](https://www.ssh.com/academy/ssh/copy-id) command:

```sh
ssh-copy-id -i ~/.ssh/id_ed25519.pub root@${YOUR_SERVER_IP}
```

## Using a Custom Name for SSH

To connect to your server with a custom domain name, add an `A` record to your DNS records that points your custom domain to your server's IP address.

For example, if your custom domain name is `example.com` and your server's IP address is `123.456.789.0`, you would add the following `A` record to your DNS records.

| Type | Name        | Content       |
| ---- | ----------- | ------------- |
| A    | example.com | 123.456.789.0 |

After DNS propagation, you can connect to your server using the custom domain:

```sh
ssh ${YOUR_USERNAME}@${example.com}
```

To further simplify the connection process, you can add the following to your `~/.ssh/config` file:

```sh
Host ${ANY_NAME_YOU_WANT}
    HostName ${example.com}
    User ${YOUR_USERNAME}
    IdentityFile ~/.ssh/id_ed25519
```

You can now connect using a custom name like this:

```sh
ssh ${ANY_NAME_YOU_WANT}
```
