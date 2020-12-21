FROM ubuntu:focal

ENV COIN_NAME=litecoind
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update
RUN apt-get install --yes curl iproute2 gnupg2 sudo

# Add user
RUN useradd -ms /bin/bash $COIN_NAME
RUN usermod -aG sudo $COIN_NAME
RUN echo "$COIN_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copy project files to WORKDIR
COPY . /home/$COIN_NAME

# Fix permissions
RUN chown -R $COIN_NAME:$COIN_NAME /home/$COIN_NAME/*
RUN chmod +x /home/$COIN_NAME/*.sh

# Change the working directory
WORKDIR /home/$COIN_NAME

# Set the user
USER $COIN_NAME

# Add volumes
VOLUME ["/home/$COIN_NAME/coins"]

# Ru the entrypoint script
ENTRYPOINT ["./entrypoint.sh"]

CMD ["sh"]