# --- Stage 1: Downloader (Dùng alpine để tải file tĩnh) ---
FROM alpine:latest AS downloader

# Cài đặt các công cụ cần thiết
RUN apk add --no-cache wget unzip

# Tạo thư mục và tải file frontend
WORKDIR /client-files
RUN wget -qO /tmp/client.zip https://github.com/mynaparrot/plugNmeet-client/releases/download/v2.1.7/plugnmeet-client.zip && \
    unzip -o /tmp/client.zip -d /client-files && \
    rm /tmp/client.zip

# Sửa config.js ngay trong stage tải
RUN echo "window.PLUGNMEET_SERVER_URL = 'https://api-meet.thanhnguyen.group';" > /client-files/config.js && \
    mkdir -p /client-files/assets/imgs && \
    echo "window.PLUGNMEET_SERVER_URL = 'https://api-meet.thanhnguyen.group';" > /client-files/assets/config.js

# Tải Logo
RUN wget -qO /client-files/assets/imgs/main-logo-dark.png 'https://raw.githubusercontent.com/nguyennhanduc-91/nextgen-meet-frontend/main/ivekit-meet-open-graph.png' || true && \
    wget -qO /client-files/assets/imgs/main-logo-light.png 'https://raw.githubusercontent.com/nguyennhanduc-91/nextgen-meet-frontend/main/ivekit-meet-open-graph.png' || true && \
    wget -qO /client-files/favicon.ico 'https://raw.githubusercontent.com/nguyennhanduc-91/nextgen-meet-frontend/main/ivekit-meet-open-graph.png' || true


# --- Stage 2: Final Image (plugnmeet-server) ---
FROM mynaparrot/plugnmeet-server:v2.1.6

# Copy 2 file cấu hình từ root Github vào container
COPY config.yaml /app/config.yaml
COPY nats-server.conf /app/nats-server.conf

# Copy toàn bộ file frontend tĩnh từ Stage 1 sang thư mục /app/client/dist
COPY --from=downloader /client-files /app/client/dist

# Khai báo working directory và command mặc định
WORKDIR /app
CMD ["plugnmeet-server", "-config", "/app/config.yaml"]
