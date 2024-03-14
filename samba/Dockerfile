FROM ubuntu:latest

# Install Samba and jq for JSON parsing
RUN apt-get update && apt-get install -y samba jq \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/lib/samba/private

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose the ports
EXPOSE 137/udp 138/udp 139 445

# Set the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Run ("d" for debug-level)
CMD ["smbd", "--foreground", "--debug-stdout", "--no-process-group", "d", "1"]