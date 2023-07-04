FROM ubuntu

# Determine machine architecture
RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then \
        DOWNLOAD_URL="https://github.com/erebe/wstunnel/releases/download/v5.0/wstunnel-linux-x64"; \
    else \
        DOWNLOAD_URL="https://github.com/erebe/wstunnel/releases/download/v5.0/wstunnel-linux-aarch64.zip"; \
    fi

# Install necessary packages
RUN apt-get update \
    && apt-get install -y wget unzip

# Download and extract wstunnel
RUN if [ "$ARCH" = "amd64" ]; then \
        wget "$DOWNLOAD_URL" -O wstunnel; \
    else \
        wget "$DOWNLOAD_URL" -O wstunnel.zip \
        && unzip wstunnel.zip \
        && rm wstunnel.zip; \
    fi \
    && chmod +x wstunnel

# Run wstunnel server
CMD ./wstunnel --server ws://0.0.0.0:443
