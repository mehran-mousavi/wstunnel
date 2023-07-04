FROM ubuntu

# Determine machine architecture
RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then \
        DOWNLOAD_URL="https://objects.githubusercontent.com/github-production-release-asset-2e65be/58835703/1799a1c2-6b77-4e6a-b6b7-c124c5e932f0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20230704%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230704T012843Z&X-Amz-Expires=300&X-Amz-Signature=fc4992f553e2a1aca5dfb0575312f6626418ab27c50eef7337730f48404d6cdf&X-Amz-SignedHeaders=host&actor_id=26494853&key_id=0&repo_id=58835703&response-content-disposition=attachment%3B%20filename%3Dwstunnel-linux-x64&response-content-type=application%2Foctet-stream"; \
    else \
        DOWNLOAD_URL="https://objects.githubusercontent.com/github-production-release-asset-2e65be/58835703/0baa6486-e575-472b-af3c-82771fb310f2?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20230704%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230704T012923Z&X-Amz-Expires=300&X-Amz-Signature=a8b99faa1c2bcc4bd3c0663a31be23dd6d6301ac1b4eb7531f2145bfbc236870&X-Amz-SignedHeaders=host&actor_id=26494853&key_id=0&repo_id=58835703&response-content-disposition=attachment%3B%20filename%3Dwstunnel-linux-aarch64.zip&response-content-type=application%2Foctet-stream"; \
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
