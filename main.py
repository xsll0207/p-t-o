import os
import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

# --- 环境变量读取 ---
PIKPAK_URL = os.getenv("PIKPAK_WEBDAV_URL", "https://dav.mypikpak.com/dav")
PIKPAK_USER = os.getenv("PIKPAK_USERNAME")
PIKPAK_PASS = os.getenv("PIKPAK_PASSWORD")
ONEDRIVE_TOKEN = os.getenv("ONEDRIVE_ACCESS_TOKEN")

# --- 下载 PikPak 文件 ---
def download_from_pikpak(file_path):
    full_url = f"{PIKPAK_URL}/{file_path}"
    print(f"[INFO] 从 PikPak 下载: {full_url}")
    resp = requests.get(full_url, auth=(PIKPAK_USER, PIKPAK_PASS), stream=True)
    resp.raise_for_status()
    return resp.raw  # 返回文件流对象

# --- 上传到 OneDrive ---
def upload_to_onedrive(file_stream, target_path):
    url = f"https://graph.microsoft.com/v1.0/me/drive/root:/{target_path}:/content"
    headers = {
        "Authorization": f"Bearer {ONEDRIVE_TOKEN}",
        "Content-Type": "application/octet-stream"
    }
    print(f"[INFO] 上传到 OneDrive: {target_path}")
    resp = requests.put(url, headers=headers, data=file_stream)
    resp.raise_for_status()
    return resp.json()

# --- 主迁移逻辑 ---
def migrate_file(pikpak_file, onedrive_path):
    stream = download_from_pikpak(pikpak_file)
    result = upload_to_onedrive(stream, onedrive_path)
    return result

# --- 提供 API 接口 ---
@app.route('/migrate', methods=['POST'])
def migrate():
    data = request.json
    pikpak_file = data.get("pikpak_file")
    onedrive_path = data.get("onedrive_path")

    if not pikpak_file or not onedrive_path:
        return jsonify({"error": "缺少参数 pikpak_file 或 onedrive_path"}), 400

    try:
        result = migrate_file(pikpak_file, onedrive_path)
        return jsonify({"status": "success", "onedrive_result": result})
    except Exception as e:
        return jsonify({"status": "failed", "error": str(e)}), 500

@app.route('/')
def index():
    return "PikPak → OneDrive 文件迁移服务正在运行。POST /migrate 即可开始传输。"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", 8080)))
