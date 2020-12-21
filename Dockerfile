FROM ubuntu:focal

ENV COIN_NAME=litecoind

# Copy project files to WORKDIR
COPY . /opt

# Fix permissions
RUN chmod +x /opt/*.sh

# Change the working directory
WORKDIR /opt

# Ru the entrypoint script
ENTRYPOINT ["/opt/entrypoint.sh"]

CMD ["sh"]