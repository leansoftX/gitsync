import requests
from xml.etree import ElementTree as ET
import subprocess
import os
import shutil

# 下载XML文件
url = "https://raw.githubusercontent.com/Infineon/mtb-super-manifest/v2.X/mtb-super-manifest-fv2.xml"
response = requests.get(url)
xml_content = response.text

# 解析XML内容
root = ET.fromstring(xml_content)

# 清理无用的uri和空的manifests
def clean_manifests(root_element, manifest_tag):
    manifest_list = root_element.findall(f".//{manifest_tag}-list")
    for manifest_group in manifest_list:
        manifests = list(manifest_group)  # 获取所有子元素
        for manifest in manifests:
            uris = manifest.findall("uri")
            for uri in uris:
                if not uri.text.startswith("https://github.com/Infineon"):
                    manifest.remove(uri)
            if len(manifest.findall("uri")) == 0:  # 检查是否还有uri子元素
                manifest_group.remove(manifest)  # 从其父元素中删除

# 清理board-manifest, app-manifest, middleware-manifest
clean_manifests(root, "board-manifest")
clean_manifests(root, "app-manifest")
clean_manifests(root, "middleware-manifest")

# 将修改后的XML写入新文件前进行字符串替换
xml_str = ET.tostring(root, encoding='unicode')
xml_str = xml_str.replace("https://github.com", "https://mtbgit.infineon.cn")

tree = ET.ElementTree(ET.fromstring(xml_str))
modified_xml_path = "mtb-super-manifest-fv2-mirror.xml"
with open(modified_xml_path, "wb") as modified_file:
    tree.write(modified_file, encoding='utf-8', xml_declaration=False)

print("修改后的XML文件已保存")

# Git 操作
repo_url = "https://mtbgit.infineon.cn/Infineon/mtb-super-manifest"
repo_path = "mtb-super-manifest"

# 检查目录是否存在，如果存在则删除
if os.path.exists(repo_path):
    shutil.rmtree(repo_path)

# 克隆仓库
subprocess.run(["git", "clone", repo_url], check=True)

# 复制文件到仓库目录
destination_file_path = os.path.join(repo_path, modified_xml_path)
os.replace(modified_xml_path, destination_file_path)

# Git 添加、提交和推送
os.chdir(repo_path)
subprocess.run(["git", "add", modified_xml_path], check=True)
subprocess.run(["git", "commit", "-m", "Update mtb-super-manifest-fv2-mirror.xml"], check=True)
subprocess.run(["git", "push"], check=True)

print("Git操作完成，文件已更新和推送到远程仓库")
