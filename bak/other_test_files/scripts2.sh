mkdir _temp 
cd _temp

git clone --mirror "https://github.com/Infineon/TARGET_CYW943907AEVAL1F" 
cd TARGET_CYW943907AEVAL1F.git

git remote set-url --push origin "https://github-demo.devopshub.cn/Infineon/TARGET_CYW943907AEVAL1F"

git push --mirror

cd ../../
rm -rf _temp

