echo on
gh api -H "Accept: application/vnd.github+json" --hostname github-demo.devopshub.cn /orgs/Infineon
echo %errorlevel%
