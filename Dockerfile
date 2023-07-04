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
    && apt-get install -y curl unzip

# Download and extract wstunnel
RUN if [ "$ARCH" = "amd64" ]; then \
        curl -L "$DOWNLOAD_URL" -o wstunnel; \
    else \
        curl -L "$DOWNLOAD_URL" -o wstunnel.zip \
        && unzip -j wstunnel.zip -d ./ \
        && rm wstunnel.zip; \
    fi \
    && chmod +x wstunnel

# Run wstunnel server
CMD ./wstunnel --server wss://127.0.0.1:443
