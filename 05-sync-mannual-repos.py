import os
import subprocess
import datetime
from urllib.parse import urlparse
import shutil


def run_command(command):
    return subprocess.run(command, stdout=subprocess.PIPE, shell=True, check=True).stdout.decode('utf-8')


def write_log(file, message):
    print(message)
    with open(file, 'a') as f:
        f.write(message + "\n")


def sync_github(file):
    # 创建目录
    for dir in ["_temp", "_temp/_logs"]:
        os.makedirs(dir, exist_ok=True)

    now_time = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%sss")
    sync_log_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "_temp/_logs", "sync-" + now_time + ".log")
    file_path = file
    ghe = "mtbgit.infineon.cn"
    ghe_admin = "localadmin"
    error_repos = []

    write_log(sync_log_path, "---DEBUG---, {}, sync start".format(now_time))
    if os.path.isfile(file_path):
        os.chdir("_temp")
        with open(file_path) as f:
            urls = f.read().splitlines()

        all_repo_count = len(urls)

        write_log(sync_log_path, "---DEBUG---,Find {} Repos need sync.".format(all_repo_count))

        for url in urls:
            try:
                time = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%sss")
                write_log(sync_log_path, "---DEBUG---, {}, Start handle url: {}".format(time, url))

                parse_result = urlparse(url)
                schema, domain, org, repo = parse_result.scheme, parse_result.netloc, parse_result.path.split('/')[1], parse_result.path.split('/')[2]
                write_log(sync_log_path, "---DEBUG---, splitUrl: {}, {}, {}, {}".format(schema, domain, org, repo))
                try:
                    org_check = run_command('gh api -H "Accept: application/vnd.github+json" --hostname {} /orgs/{}'.format(ghe, org))
                except Exception as e:
                    org_check={}
                write_log(sync_log_path, "---DEBUG---, {} check end, result: \n {}".format(org, org_check))

                org_ready = "node_id" in org_check

                if not org_ready:
                    org_create = run_command('gh api --method POST -H "Accept: application/vnd.github+json" /admin/organizations --hostname {} -f login="{}" -f profile_name="{}" -f admin="{}"'.format(ghe, org, org, ghe_admin))
                    write_log(sync_log_path, "---DEBUG---, {} create end, result: \n {}".format(org, org_create))
                    org_ready = "node_id" in org_create
                
                if org_ready:
                    try:
                        repo_check = run_command('gh api -H "Accept: application/vnd.github+json" --hostname {} /repos/{}/{}'.format(ghe, org, repo))
                        print(repo_check)
                    except Exception as e:
                        repo_check = {}
                    write_log(sync_log_path, "---DEBUG---, check is repo exist end, is not is start for create repo.".format(repo_check))
    
                    repo_ready = "node_id" in repo_check

                    if not repo_ready:
                        print(repo_ready);
                        repo_create = run_command('gh api --method POST -H "Accept: application/vnd.github+json" --hostname {} /orgs/{}/repos -f name="{}"'.format(ghe, org, repo))
                        write_log(sync_log_path, "---DEBUG--- {} create end, result: \n {}".format(repo, repo_create))
                        repo_ready = "node_id" in repo_create
                else:
                    repo_ready = False

                if org_ready and repo_ready:
                    write_log(sync_log_path, "---DEBUG---, Clone Code from {}".format(url))
                    git_clone = run_command('git clone --mirror "{}" {}'.format(url, repo))

                    # if clone ok,will create repo dir
                    if os.path.isdir(repo):
                        os.chdir(repo)
                        write_log(sync_log_path, "---DEBUG--- modify push url to github Enterprise:{}".format(ghe))
                        run_command('git remote set-url --push origin "https://{}/{}/{}"'.format(ghe, org, repo))
                        write_log(sync_log_path, "---DEBUG---,start push to host:{} with arg: --mirror".format(ghe))
                        run_command('git push --mirror')
                        write_log(sync_log_path, "---DEBUG---,push End. clear repo file")
                        os.chdir("..")
                        shutil.rmtree(repo, ignore_errors=True)  
                    else:
                        write_log(sync_log_path, "---DEBUG---, Clone {} Fail.".format(url))
                else:
                    error_repos.append(url)
                
                org_ready = False
                repo_ready = False

                time = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%sss")
                write_log(sync_log_path, "---DEBUG---, {}, url: {} handle End.".format(time, url))

            except Exception as e:
                write_log(sync_log_path, "---ERROR---, an exception occurred: {}".format(str(e)))
    else:
        write_log(sync_log_path, "---DEBUG---,ERROR: file {} not exists.".format(file_path))

    now_time = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%sss")
    error_repos_log_path = os.path.join("_temp/_logs", "errorRepos-" + now_time + ".log")

    write_log(sync_log_path, "--DEBUG---, {}, sync end".format(now_time))

    write_log(sync_log_path, "---DEBUG---,log file saved to: {}".format(sync_log_path))

    error_repo_count = len(error_repos)

    if error_repo_count != 0:
        with open(error_repos_log_path, 'a') as f:
            for repo in error_repos:
                f.write("{}\n".format(repo))

        write_log(sync_log_path, "---DEBUG---,sync {} error repos saved to: {}".format(error_repo_count, error_repos_log_path))
    else:
        write_log(sync_log_path, "---DEBUG---,All {} Repos Sync Succeed.".format(all_repo_count))

    os.chdir(os.path.dirname(os.path.abspath(__file__)))


def main():
    mannual_file=os.path.join(os.path.dirname(os.path.abspath(__file__)), "mannual_repos.txt")
    sync_github(mannual_file)


if __name__ == "__main__":
    main()