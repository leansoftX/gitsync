# 操作手册


### 工具下载：

1. github cli 

https://github.com/cli/cli#installation

2. python3.9 && pip3


3. git 2.35.1

### 登陆认证：

gh auth login --hostname mtbgit.infineon.cn

### 使用说明：

1. python3.9 01-analysis-super-manifest.py
2. nohup python3.9 02-analysis-submodules.py > output_analysis-submodules.log 2>&1 &
3. nohup python3.9 03-sync-repos.py > output_sync-repos.log 2>&1 &
4. nohup python3.9 04-sync-mannual-repos.py > output_sync-mannual-repos.log 2>&1 &
