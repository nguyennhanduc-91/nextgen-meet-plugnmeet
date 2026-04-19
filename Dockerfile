# Sử dụng base image là plugnmeet-server chuẩn của hãng
FROM mynaparrot/plugnmeet-server:v2.1.6

# Cài đặt các công cụ cần thiết để tải file
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

# Tải và giải nén Frontend tĩnh vào thư mục /app/client/dist
RUN mkdir -p /app/client/dist && \
    wget -qO /tmp/client.zip https://github.com/mynaparrot/plugNmeet-client/releases/download/v2.1.7/plugnmeet-client.zip && \
    unzip -o /tmp/client.zip -d /app/client/dist && \
    rm /tmp/client.zip

# Copy 2 file cấu hình từ repo của bạn vào thư mục /app
COPY config.yaml /app/config.yaml
COPY nats-server.conf /app/nats-server.conf

# Cập nhật config.js cho Frontend
RUN echo "window.PLUGNMEET_SERVER_URL = 'https://api-meet.thanhnguyen.group';" > /app/client/dist/config.js && \
    mkdir -p /app/client/dist/assets/imgs && \
    echo "window.PLUGNMEET_SERVER_URL = 'https://api-meet.thanhnguyen.group';" > /app/client/dist/assets/config.js

# Copy logo tuỳ chỉnh
RUN wget -qO /app/client/dist/assets/imgs/main-logo-dark.png 'https://raw.githubusercontent.com/nguyennhanduc-91/nextgen-meet-frontend/main/ivekit-meet-open-graph.png' || true && \
    wget -qO /app/client/dist/assets/imgs/main-logo-light.png 'https://raw.githubusercontent.com/nguyennhanduc-91/nextgen-meet-frontend/main/ivekit-meet-open-graph.png' || true && \
    wget -qO /app/client/dist/favicon.ico 'https://raw.githubusercontent.com/nguyennhanduc-91/nextgen-meet-frontend/main/ivekit-meet-open-graph.png' || true

# Đặt thư mục làm việc và lệnh khởi động mặc định
WORKDIR /app
CMD ["plugnmeet-server", "-config", "/app/config.yaml"]
