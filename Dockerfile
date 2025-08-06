FROM debian:bullseye-slim

# Install dependencies
RUN apt-get update && apt-get install -y ffmpeg wget unzip && rm -rf /var/lib/apt/lists/*

# Install ytarchive
RUN wget https://github.com/Kethsar/ytarchive/releases/download/v0.5.0/ytarchive_linux_amd64.zip && \
    unzip ytarchive_linux_amd64.zip && \
    rm -rf ytarchive_linux_amd64.zip && \
    chmod +x ytarchive && \
    mv ytarchive /usr/local/bin

# Copy cookie files
COPY files/ytcookie /usr/local/bin/ytcookie
COPY files/cookie.txt /root/cookie.txt

# Make it executable
RUN chmod +x /usr/local/bin/ytcookie

# Set the working directory
WORKDIR /data

# Set the entrypoint
ENTRYPOINT ["ytarchive"]

