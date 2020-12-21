FROM ubuntu:focal

ENV COIN_NAME=litecoind
ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/opt

# Install dependencies
RUN apt-get update
RUN apt-get install --yes curl iproute2 gnupg2 sudo

# Add user
RUN useradd -s /bin/bash -d $HOME $COIN_NAME
RUN usermod -aG sudo $COIN_NAME
RUN echo "$COIN_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copy project files to WORKDIR
COPY . $HOME

# Fix permissions
RUN chown -Rv $COIN_NAME:$COIN_NAME $HOME
RUN chmod +x $HOME/*.sh

# Change the working directory
WORKDIR $HOME

# Set the user
USER $COIN_NAME

# Ru the entrypoint script
ENTRYPOINT ["/opt/entrypoint.sh"]

CMD ["sh"]