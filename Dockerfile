FROM rclone/rclone:latest

# 复制配置文件（可选，如果用 ENV 则跳过）
COPY rclone.conf /config/rclone/

# 设置工作目录
WORKDIR /data

# 运行传输命令（替换源/目标路径）
CMD ["rclone", "copy", "pikpak:/MyFiles/", "onedrive:/Backup/", "--config", "/config/rclone/", "--progress", "--transfers", "4", "--bwlimit", "10M"]
