FROM rclone/rclone:latest

# 设置工作目录
WORKDIR /data

# 动态创建配置并执行传输（单行 CMD，避免解析错误）
CMD ["sh", "-c", "rclone config create pikpak pikpak user=$$RCLONE_PIKPAK_USER pass=$$RCLONE_PIKPAK_PASS && rclone config create onedrive onedrive client_id=$$RCLONE_ONEDRIVE_CLIENT_ID client_secret=$$RCLONE_ONEDRIVE_CLIENT_SECRET tenant=$$RCLONE_ONEDRIVE_TENANT token=$$RCLONE_ONEDRIVE_TOKEN drive_id=$$RCLONE_ONEDRIVE_DRIVE_ID drive_type=$$RCLONE_ONEDRIVE_DRIVE_TYPE && rclone copy pikpak:/MyFiles/ onedrive:/Backup/ --progress --transfers 4 --bwlimit 10M"]
