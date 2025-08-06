# 3 Basic Streams - Dockerized

This project provides a simple, Dockerized setup for a basic streaming media server using Alist, qBittorrent, Jellyfin, and yt-archive.

## Prerequisites

-   [Docker](https://docs.docker.com/get-docker/)
-   [Docker Compose](https://docs.docker.com/compose/install/)

## Installation & Usage

1.  **Clone the repository:**
    ```bash
    git clone -b testing https://github.com/crixsz/3BasicStreams.git
    cd 3BasicStreams
    ```

2.  **(Optional) Customize your cookie:**
    If you plan to use `ytarchive` for members-only streams, place your `cookies.txt` file in the `./files/` directory.

3.  **Start the services:**
    Run the `start.sh` script to build the `ytarchive` image and launch all the services.
    ```bash
    chmod +x start.sh
    ./start.sh
    ```

## Accessing Services

Once the containers are running, you can access the services at the following URLs:

-   **Alist:** `http://<your-server-ip>:5244`
-   **qBittorrent:** `http://<your-server-ip>:8080`
-   **Jellyfin:** `http://<your-server-ip>:8096`

## Using yt-archive

To download a YouTube live stream, you can use the provided `ytcookie` helper script or run `ytarchive` directly.

-   **Using the helper script (prompts for URL):**
    ```bash
    docker compose run --rm ytarchive ytcookie
    ```

-   **Running `ytarchive` directly:**
    ```bash
    docker compose run --rm ytarchive -o "/data/%(title)s.%(ext)s" <video-url>
    ```
    Downloaded videos will be saved to the `./data/Archive` directory on your host machine.

## Directory Structure

-   `config/`: Stores the persistent configuration for Alist, qBittorrent, and Jellyfin.
-   `data/`: Stores all your media files.
    -   `Archive/`: Default location for `ytarchive` downloads.
    -   `Movie/`: Default media library for Jellyfin.
    -   `Files/`: Default file storage for Alist.
    -   `Torrents/`: Stores qBittorrent torrent files.
-   `files/`: Contains your `cookie.txt` and the `ytcookie` helper script.