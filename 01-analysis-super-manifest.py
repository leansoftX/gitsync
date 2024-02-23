import requests
from lxml import etree

# 新增：将要排除的组织全URL写进列表
excluded_orgs = ["https://github.com/CyberonEBU", "https://github.com/golioth", 
                 "https://github.com/memfault", "https://github.com/RutronikSystemSolutions",
                 "https://github.com/sensiml", "https://github.com/Altia-Marketing", "https://github.com/edgeimpulse", "https://github.com/espressif"]

def extract_uri(xml_content):
    root = etree.fromstring(xml_content)
    uri_tags = root.xpath('//uri')

    uris = []
    for uri in uri_tags:
        uris.append(uri.text)
    
    return uris

def extract_repo_uri(xml_content):
    root = etree.fromstring(xml_content)
    uri_tags = root.xpath('//board_uri | //uri')

    repo_uris = []
    for uri in uri_tags:
        repo_uris.append(uri.text)
    
    return repo_uris

def get_xml_from_url(url):
    response = requests.get(url)
    return response.content

# 新增：检查是否应排除该URL
def is_excluded(url, organizations):
    for org in organizations:
        if url.startswith(org):  # 用startswith方法替代'in'，增加精度
            return True
    return False

# 新增：替换仓库地址前缀的函数
def replace_repo_url_prefix(filename, old_prefix, new_prefix):
    with open(filename, 'r') as f:
        lines = f.readlines()
    with open(filename, 'w') as f:
        for line in lines:
            f.write(line.replace(old_prefix, new_prefix))

def main():
    url = "https://raw.githubusercontent.com/Infineon/mtb-super-manifest/v2.X/mtb-super-manifest-fv2.xml"
    xml_content = get_xml_from_url(url)
    uris = extract_uri(xml_content)

    url2="https://raw.githubusercontent.com/Infineon/mtb-super-manifest/v2.X/mtb-super-manifest.xml"
    xml_content2 = get_xml_from_url(url2)
    uris = uris + extract_uri(xml_content2)

    repo_uris_set = set()  
    for uri in uris:
        xml_content_level02 = get_xml_from_url(uri)
        repo_uris = extract_repo_uri(xml_content_level02)
        for repo_uri in repo_uris:
            # 修改了逻辑：如果URL没有被排除，才将其加入集合
            if not is_excluded(repo_uri, excluded_orgs):
                repo_uris_set.add(repo_uri)

    with open("repo_urls.txt", "w") as f:
        for repo_uri in repo_uris_set:  
            f.write(repo_uri + "\n")
    
    # 使用新的前缀替换"repo_urls.txt"中的旧前缀
    replace_repo_url_prefix("repo_urls.txt", "https://github.com/cypresssemiconductorco/", "https://github.com/Infineon/")

    print("提取并保存完成，数据已写入'repo_urls.txt'文件。")

if __name__ == "__main__":
    main()