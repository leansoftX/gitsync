mkdir _temp 
cd _temp

git clone --mirror "https://github.com/edgeimpulse/mtb-example-edgeimpulse-continuous-motion" 
cd mtb-example-edgeimpulse-continuous-motion

git remote set-url --push origin "https://github-demo.devopshub.cn/edgeimpulse/mtb-example-edgeimpulse-continuous-motion"

git push --mirror

cd ../../
rm -rf _temp

