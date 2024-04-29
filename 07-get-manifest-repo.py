import requests
import xml.etree.ElementTree as ET

# URL of the XML file
url = "https://raw.githubusercontent.com/Infineon/mtb-super-manifest/v2.X/mtb-super-manifest-fv2.xml"

def get_github_repos(url):
    # Send a GET request to the URL
    response = requests.get(url)
    if response.status_code == 200:
        # Parse the XML from the response
        root = ET.fromstring(response.content)
        
        # Find all URI elements
        uris = root.findall('.//uri')
        
        # Set to store unique Infineon GitHub repository addresses
        infineon_repos = set()
        
        # Filter URIs that start with the GitHub Infineon prefix and add to set
        for uri in uris:
            uri_text = uri.text.strip()
            if uri_text.startswith("https://github.com/Infineon"):
                # Extract the repository address
                repo_address = '/'.join(uri_text.split('/')[:5])
                infineon_repos.add(repo_address)
        
        return list(infineon_repos)  # Convert set back to list for the output
    else:
        return None

# Get the list of Infineon GitHub repositories
repos = get_github_repos(url)
if repos:
    # Open the file in append mode to preserve existing content
    with open('repo_urls.txt', 'a') as file:
        for repo in repos:
            file.write(repo + '\n')
    print("Repository URLs have been appended to repo_urls.txt.")
else:
    print("Failed to retrieve or parse the XML.")
