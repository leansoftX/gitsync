import requests
from lxml import etree

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

def main():
    url = "https://raw.githubusercontent.com/Infineon/mtb-super-manifest/v2.X/mtb-super-manifest-fv2.xml"
    xml_content = get_xml_from_url(url)
    uris = extract_uri(xml_content)

    url2="https://raw.githubusercontent.com/Infineon/mtb-super-manifest/v2.X/mtb-super-manifest.xml"
    xml_content2 = get_xml_from_url(url2)
    uris = uris+extract_uri(xml_content2)

    with open("repo_urls.txt", "w") as f:
        for uri in uris:
            xml_content_level02 = get_xml_from_url(uri)
            repo_uris = extract_repo_uri(xml_content_level02)
            for repo_uri in repo_uris:
                f.write(repo_uri + "\n")
        print("提取并保存完成，数据已写入'output.txt'文件。")


if __name__ == "__main__":
    main()