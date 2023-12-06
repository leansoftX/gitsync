import subprocess
import shutil
import os
import configparser
import time

def clone_and_check_submodules():
    # 读取txt里的git仓库列表
    with open('repo_urls.txt', 'r') as f:
        repos = f.readlines()
        
    with open('submodules.txt', 'w') as f_sub:
        # 逐个克隆仓库
        for repo in repos:
            try:
                repo = repo.strip()
                clone_command = f'git clone {repo}'
                subprocess.run(clone_command.split())  # 克隆仓库

                # 获取仓库名，用于进入对应目录
                repo_name = repo.split('/')[-1].replace('.git', '')
                submodule_command = f'git -C {repo_name} submodule status'
                result = subprocess.run(submodule_command.split(), stdout=subprocess.PIPE)

                # 检查结果，如果有submodule则存在输出
                if result.stdout:
                    # Parse submodules from .gitmodules file
                    config = configparser.ConfigParser()
                    config.read(os.path.join(repo_name, '.gitmodules'))

                    # 取出所有的submodules的url
                    for section in config.sections():
                        submodule_repo = config[section]['url']
                        f_sub.write(submodule_repo + '\n')


                # 删除克隆的存储库
                shutil.rmtree(repo_name)

            except Exception as e:
                print(f"Error processing repo {repo}: {e}")

def main():
    clone_and_check_submodules()

if __name__ == "__main__":
    main()