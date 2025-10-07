FROM rclone/rclone:latest

# 覆盖默认 ENTRYPOINT，让 CMD 能用 sh 执行
ENTRYPOINT []

# 设置工作目录
WORKDIR /data

# 动态创建配置并执行传输（用 sh -c 执行 rclone 命令）
CMD ["sh", "-c", "rclone config create pikpak pikpak user=$$RCLONE_PIKPAK_USER pass=$$RCLONE_PIKPAK_PASS && rclone config create onedrive onedrive client_id=$$RCLONE_ONEDRIVE_CLIENT_ID client_secret=$$RCLONE_ONEDRIVE_CLIENT_SECRET tenant=$$RCLONE_ONEDRIVE_TENANT token=$$RCLONE_ONEDRIVE_TOKEN drive_id=$$RCLONE_ONEDRIVE_DRIVE_ID drive_type=$$RCLONE_ONEDRIVE_DRIVE_TYPE && rclone copy pikpak:/MyFiles/ onedrive:/Backup/ --progress --transfers 4 --bwlimit 10M --max-transfer 100G"]
