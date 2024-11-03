# ATM: This is a Working Debian 12 Instance and Bitcoin v27

This has been forked and updated/edited to meet my needs. Your needs may be different. This is not entirely my work, but I have expanded upon it to create a working instance for myself. You are free to edit and make changes as long as you follow the original creator's license.

This is my first Docker Hub Image:
```bash
docker pull bmmbmm01/bitcoin-core-gui:27.0-debian12
```

Otherwise make it yourself from this Repo:
```bash
git clone https://github.com/bmartino1/Docker-Bitcoin-Core-GUI.git
cd Docker-Bitcoin-Core-GUI
docker build -t bitcoin-core-gui:27.0-debian12 .
```
Then:
```bash
docker run -d --name=bitcoin-core-gui -p 5800:5800 -v /YourHostPath:/config bitcoin-core-gui:27.0-debian12
```

Then go to your Docker IP:5800 to see the VNC web UI and watch your v27 Bitcoin wallet/node sync.

# Docker - Bitcoin Core GUI Client

Run the Bitcoin Core GUI wallet in a Docker container, accessible via a web browser and VNC. Built over the [jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui) image (Debian 12 version).

## Getting Started Docker run commands options

```bash
docker volume create --name=bitcoin-data
docker run -d --name=bitcoin-core-gui -p 5800:5800 -v bitcoin-data:/config davidlor/bitcoin-core-gui
```

Open your browser and go to `localhost:5800`. You should see the Bitcoin Core GUI application running!

**On the first run, the Welcome window will open, where you will be prompted for the data location!
You should set it to somewhere inside `/config`** (by default, it is set to `/config/.bitcoin`).

## Volume (Persistence)

The Bitcoin Core data directory is set to `/config/.bitcoin` by default. A volume is created for `/config`,
but you might want to mount the `/config/.bitcoin` directory on another volume or bind mount.

You can even mount subdirectories of the Bitcoin data directory. These are the most important:
- `/config/.bitcoin/blocks` for the blockchain
- `/config/.bitcoin/wallet.dat` for your wallet
- `/config/.bitcoin/bitcoin.conf` for the client configuration
- `/config/xdg/config/Bitcoin/Bitcoin-Qt.conf` for the frontend (bitcoin-qt) configuration

_The `/config` directory is used by the [base image for persisting settings](https://github.com/jlesage/docker-baseimage-gui#config-directory)
of the image tools and the application running. We set it as the HOME directory, so this results in bitcoin-qt
setting the data directory to `/config/.bitcoin` by default._

## Other Settings

Please refer to the [documentation of the base image](https://github.com/jlesage/docker-baseimage-gui) for
VNC/web UI related settings, such as securing the connection and other configurations.

## Running the Container

To start the container, use the following command:

```bash
# Run the container
docker run -d --name bitcoin-core-gui bitcoin-core-gui:27.0-debian12
```
