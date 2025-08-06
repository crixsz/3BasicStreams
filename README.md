# 3 Basic Streams - Dockerized

This project provides a simple, Dockerized setup for a basic streaming media server using Alist, qBittorrent, and Jellyfin.

## Prerequisites

-   [Docker](https://docs.docker.com/get-docker/)
-   [Docker Compose](https://docs.docker.com/compose/install/)

## Installation & Usage

**One-liner**
```bash
git clone -b testing https://github.com/crixsz/3BasicStreams.git && cd 3BasicStreams && chmod +x start.sh && ./start.sh
```


## Accessing Services

Once the containers are running, you can access the services at the following URLs:

-   **Alist:** `http://<your-server-ip>:5244`
-   **qBittorrent:** `http://<your-server-ip>:8080`
-   **Jellyfin:** `http://<your-server-ip>:8096`

## Directory Structure

-   `config/`: Stores the persistent configuration for Alist, qBittorrent, and Jellyfin.
-   `data/`: Stores all your media files.
    -   `Movie/`: Default media library for Jellyfin.
    -   `Files/`: Default file storage for Alist.
    -   `Torrents/`: Stores qBittorrent torrent files.
