# Lấy bản build sẵn mới nhất của hãng
FROM mynaparrot/plugnmeet-server:latest

WORKDIR /app

# Copy file cấu hình của bạn từ GitHub vào trong Container
COPY config.yaml .

EXPOSE 3000

# Chạy server với file cấu hình của bạn
CMD ["./plugnmeet-server", "-config", "config.yaml"]
