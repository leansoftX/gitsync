import requests
from xml.etree import ElementTree as ET

# 下载XML文件
url = "https://raw.githubusercontent.com/Infineon/mtb-super-manifest/v2.X/mtb-super-manifest-fv2.xml"
response = requests.get(url)
xml_content = response.text

# 解析XML内容
root = ET.fromstring(xml_content)

# 遍历所有<uri>节点并根据条件删除
prefix = "https://github.com/Infineon"
# 因为我们正在删除节点，所以我们需要遍历所有的父节点
for parent in root.findall(".//board-manifest"):
    uris = parent.findall("uri")
    for uri in uris:
        if not uri.text.startswith(prefix):
            parent.remove(uri)

for parent in root.findall(".//app-manifest"):
    uris = parent.findall("uri")
    for uri in uris:
        if not uri.text.startswith(prefix):
            parent.remove(uri)

for parent in root.findall(".//middleware-manifest"):
    uris = parent.findall("uri")
    for uri in uris:
        if not uri.text.startswith(prefix):
            parent.remove(uri)

# 将修改后的XML写入新文件
tree = ET.ElementTree(root)
with open("mtb-super-manifest-fv2-mirror.xml", "wb") as modified_file:
    tree.write(modified_file, encoding='utf-8', xml_declaration=True)

print("修改后的XML文件已保存为 'mtb-super-manifest-fv2-mirror.xml'")
