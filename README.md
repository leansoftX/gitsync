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


### 批量手工执行：

chmod +x 00-run-scripts.sh
nohup ./00-run_repo_sync.sh > output.log 2>&1 &

### 设置定时任务

0 0 * * * cd /root/leansoft/gitsync && nohup ./00-run_repo_sync.sh > sync_$(date +\%Y\%m\%d\%H\%M\%S).log 2>&1
0 12 * * * cd /root/leansoft/gitsync && nohup ./00-run_repo_sync.sh > sync_$(date +\%Y\%m\%d\%H\%M\%S).log 2>&1


