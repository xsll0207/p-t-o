FROM rclone/rclone:latest

# 设置工作目录
WORKDIR /data

# 动态创建 rclone 配置并执行传输（使用环境变量）
CMD ["sh", "-c", "
  # 创建 PikPak 配置
  rclone config create pikpak pikpak user=$$RCLONE_PIKPAK_USER pass=$$RCLONE_PIKPAK_PASS &&

  # 创建 OneDrive 配置（需替换为你的 token；先本地生成 token 后填入 ENV）
  rclone config create onedrive onedrive client_id=$$RCLONE_ONEDRIVE_CLIENT_ID client_secret=$$RCLONE_ONEDRIVE_CLIENT_SECRET token=$$RCLONE_ONEDRIVE_TOKEN &&

  # 执行复制（替换源/目标路径）
  rclone copy pikpak:/MyFiles/ onedrive:/Backup/ --progress --transfers 4 --bwlimit 10M
"]
