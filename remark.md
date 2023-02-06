# 备注

## 订阅帐号

https://portal.azure.cn/#@infineon2023.partner.onmschina.cn/resource/subscriptions/f244e082-0e0f-4210-8d0d-beba7ef6d883/resourcegroups/github-poc/providers/Microsoft.Compute/virtualMachines/ghes-mooncake/overview


https://github-demo.devopshub.cn/

## 工具下载

https://softwaretools.infineon.com/tools/com.ifx.tb.tool.modustoolbox?_ga=2.208897946.92493469.1672812038-1362627265.1672812038&_gac=1.152265419.1672812038.CjwKCAiAwc-dBhA7EiwAxPRylDnij0nNOD_RYzQpFne1Qi3135zzyv_xqhiqDKFUDRtHK_4rRA8OBhoC37wQAvD_BwE

https://itoolspriv.infineon.com/itbhs/download/7ae147d5cd36493ea819658105579509/content

---------------------------
 Setup ModusToolbox™ 3.0.0.9369
---------------------------
This instance of the ModusToolbox™ installer detected that it is installed in a non-default location. For this instance of ModusToolbox™ to function properly, please set the following environment variable:



CY_TOOLS_PATHS = E:/work/project/infineon-gh-sync/ModusToolbox/tools_3.0/



Note that if you run other instances of ModusToolbox™, you must either disable this variable, or change it as appropriate. Refer to the installation guide (https://www.cypress.com/ModusToolboxInstallGuide) for more information.
---------------------------
确定   
---------------------------

## 测试相关设置
https://github-demo.devopshub.cn/
git config --system url."https://ghproxy.com/https://github.com".insteadOf https://github.com
git config --system --remove-section url."https://ghproxy.com/https://github.com"

git config --system url."https://github-demo.devopshub.cn".insteadOf https://github.com
git config --system --remove-section url."https://github-demo.devopshub.cn"
git config --system --list

git config --system url."https://github-demo.devopshub.cn".insteadOf https://github.com

 export CyRemoteManifestOverride=https://itools.infineon.cn/mtb/manifests/mtb-super-manifest-fv2.xml

## 仓库列表
这是刚刚弄好的列表，urls.txt里面包含的是主要的仓库列表，submodules.txt里面包含的是主仓库里面的所有子模块的列表（其实也是一个git仓库）

## 脚本

### 读取url

@echo off
setlocal enabledelayedexpansion
for /f %%i in (urls.txt) do (
set line=%%i
echo url=!line!
)

pause

### github cli 

https://cli.github.com/manual/
https://github.com/cli/cli#installation

winget install --id GitHub.cli

#### 登陆



gh auth login 
gh auth login --hostname github-demo.devopshub.cn
export GH_HOST=<hostname>
export GH_ENTERPRISE_TOKEN=<access-token>
gh auth login --hostname github-demo.devopshub.cn --with-token [token]
gh auth refresh -h github-demo.devopshub.cn -s site_admin
gh auth login --hostname github-demo.devopshub.cn -s site_admin
gh auth logout --hostname github-demo.devopshub.cn
gh auth status -t

#### git clone 登陆

git clone https://github-demo.devopshub.cn/localadmin/localadmin.git
在登陆弹出框中选择token/pat登陆，把github cli 登陆时的token输入进去即可，这样后面脚本执行同步时就可以push了

##### 登陆失败

C:\Users\localadmin>gh api -H "Accept: application/vnd.github+json" --hostname github-demo.devopshub.cn /orgs/infintestorg1
To get started with GitHub CLI, please run:  gh auth login
Alternatively, populate the GH_TOKEN environment variable with a GitHub API authentication token.

C:\Users\localadmin>echo %errorlevel%
4

#### 机构查询和创建

gh api \
  -H "Accept: application/vnd.github+json" \
  --hostname HOSTNAME \
  /organizations

gh api -H "Accept: application/vnd.github+json" /organizations

gh api \
  -H "Accept: application/vnd.github+json" \
  --hostname HOSTNAME \
  /orgs/ORG

gh api -H "Accept: application/vnd.github+json" --hostname github-demo.devopshub.cn /orgs/infintestorg1

```json
Not Found (HTTP 404)
{
  "message": "Not Found",
  "documentation_url": "https://docs.github.com/enterprise-server@3.7/rest/reference/orgs#get-an-organization"
}
gh: Not Found (HTTP 404)
gh: This API operation needs the "admin:org" scope. To request it, run:  gh auth refresh -h github-demo.devopshub.cn -s admin:org
```

gh api --method POST -H "Accept: application/vnd.github+json" /admin/organizations --hostname github-demo.devopshub.cn -f login='infintestorg1' -f profile_name='cli test.' -f admin='localadmin'
gh api --method POST -H "Accept: application/vnd.github+json" /admin/organizations --hostname github-demo.devopshub.cn -f login='Infineon' -f profile_name='Infineon' -f admin='localadmin'
```json
{
  "login": "infintestorg1",
  "id": 4,
  "node_id": "MDEyOk9yZ2FuaXphdGlvbjQ=",
  "url": "https://github-demo.devopshub.cn/api/v3/orgs/infintestorg1",
  "repos_url": "https://github-demo.devopshub.cn/api/v3/orgs/infintestorg1/repos",
  "events_url": "https://github-demo.devopshub.cn/api/v3/orgs/infintestorg1/events",
  "hooks_url": "https://github-demo.devopshub.cn/api/v3/orgs/infintestorg1/hooks",
  "issues_url": "https://github-demo.devopshub.cn/api/v3/orgs/infintestorg1/issues",
  "members_url": "https://github-demo.devopshub.cn/api/v3/orgs/infintestorg1/members{/member}",
  "public_members_url": "https://github-demo.devopshub.cn/api/v3/orgs/infintestorg1/public_members{/member}",
  "avatar_url": "https://github-demo.devopshub.cn/avatars/u/4?",
  "description": null
}
```

#### 仓库查询和创建

gh api \
  -H "Accept: application/vnd.github+json" \
  --hostname HOSTNAME \
  /repos/OWNER/REPO

gh api -H "Accept: application/vnd.github+json" --hostname github-demo.devopshub.cn '/repos/localadmin/localadmin'
gh api -H "Accept: application/vnd.github+json" --hostname github-demo.devopshub.cn /repos/Infineon/cce-mtb-psoc6-dps3101

```json
{
  "message": "Not Found",
  "documentation_url": "https://docs.github.com/enterprise-server@3.7/rest/reference/repos#get-a-repository"
}
gh: Not Found (HTTP 404)
```

```
Post "https://github-demo.devopshub.cn/api/v3/admin/organizations": dial tcp 163.228.225.242:443: connectex: A connection attempt failed because the connected party did not properly respond after a period of time, or established connection failed because connected host has failed to respond.
```

gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  --hostname HOSTNAME \
  /orgs/ORG/repos \
  -f name='Hello-World' \
 -f description='This is your first repository' \
 -f homepage='https://github.com' \
 -F private=false \
 -F has_issues=true \
 -F has_projects=true \
 -F has_wiki=true 

gh api --method POST -H "Accept: application/vnd.github+json" --hostname github-demo.devopshub.cn /orgs/infintestorg1/repos -f name='demo_repo1'

```json
{
  "id": 2,
  "node_id": "MDEwOlJlcG9zaXRvcnky",
  "name": "demo_repo1",
  "full_name": "infintestorg1/demo_repo1",
  "private": false,
  "owner": {
    "login": "infintestorg1",
    "id": 4,
    "node_id": "MDEyOk9yZ2FuaXphdGlvbjQ=",
    "avatar_url": "https://github-demo.devopshub.cn/avatars/u/4?",
    "gravatar_id": "",
    "url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1",
    "html_url": "https://github-demo.devopshub.cn/infintestorg1",
    "followers_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/followers",
    "following_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/following{/other_user}",
    "gists_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/gists{/gist_id}",
    "starred_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/starred{/owner}{/repo}",
    "subscriptions_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/subscriptions",
    "organizations_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/orgs",
    "repos_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/repos",
    "events_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/events{/privacy}",
    "received_events_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/received_events",
    "type": "Organization",
    "site_admin": false
  },
  "html_url": "https://github-demo.devopshub.cn/infintestorg1/demo_repo1",
  "description": null,
  "fork": false,
  "url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1",
  "forks_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/forks",
  "keys_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/keys{/key_id}",
  "collaborators_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/collaborators{/collaborator}",
  "teams_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/teams",
  "hooks_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/hooks",
  "issue_events_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/issues/events{/number}",
  "events_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/events",
  "assignees_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/assignees{/user}",
  "branches_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/branches{/branch}",
  "tags_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/tags",
  "blobs_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/git/blobs{/sha}",
  "git_tags_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/git/tags{/sha}",
  "git_refs_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/git/refs{/sha}",
  "trees_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/git/trees{/sha}",
  "statuses_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/statuses/{sha}",
  "languages_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/languages",
  "stargazers_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/stargazers",
  "contributors_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/contributors",
  "subscribers_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/subscribers",
  "subscription_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/subscription",
  "commits_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/commits{/sha}",
  "git_commits_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/git/commits{/sha}",
  "comments_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/comments{/number}",
  "issue_comment_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/issues/comments{/number}",
  "contents_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/contents/{+path}",
  "compare_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/compare/{base}...{head}",
  "merges_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/merges",
  "archive_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/{archive_format}{/ref}",
  "downloads_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/downloads",
  "issues_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/issues{/number}",
  "pulls_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/pulls{/number}",
  "milestones_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/milestones{/number}",
  "notifications_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/notifications{?since,all,participating}",
  "labels_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/labels{/name}",
  "releases_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/releases{/id}",
  "deployments_url": "https://github-demo.devopshub.cn/api/v3/repos/infintestorg1/demo_repo1/deployments",
  "created_at": "2023-01-05T07:20:49Z",
  "updated_at": "2023-01-05T07:20:49Z",
  "pushed_at": "2023-01-05T07:20:49Z",
  "git_url": "git://github-demo.devopshub.cn/infintestorg1/demo_repo1.git",
  "ssh_url": "git@github-demo.devopshub.cn:infintestorg1/demo_repo1.git",
  "clone_url": "https://github-demo.devopshub.cn/infintestorg1/demo_repo1.git",
  "svn_url": "https://github-demo.devopshub.cn/infintestorg1/demo_repo1",
  "homepage": null,
  "size": 0,
  "stargazers_count": 0,
  "watchers_count": 0,
  "language": null,
  "has_issues": true,
  "has_projects": true,
  "has_downloads": true,
  "has_wiki": true,
  "has_pages": false,
  "forks_count": 0,
  "mirror_url": null,
  "archived": false,
  "disabled": false,
  "open_issues_count": 0,
  "license": null,
  "allow_forking": true,
  "is_template": false,
  "web_commit_signoff_required": false,
  "topics": [],
  "visibility": "public",
  "forks": 0,
  "open_issues": 0,
  "watchers": 0,
  "default_branch": "main",
  "permissions": {
    "admin": true,
    "maintain": true,
    "push": true,
    "triage": true,
    "pull": true
  },
  "allow_squash_merge": true,
  "allow_merge_commit": true,
  "allow_rebase_merge": true,
  "allow_auto_merge": false,
  "delete_branch_on_merge": false,
  "allow_update_branch": false,
  "use_squash_pr_title_as_default": false,
  "squash_merge_commit_message": "COMMIT_MESSAGES",
  "squash_merge_commit_title": "COMMIT_OR_PR_TITLE",
  "merge_commit_message": "PR_TITLE",
  "merge_commit_title": "MERGE_MESSAGE",
  "organization": {
    "login": "infintestorg1",
    "id": 4,
    "node_id": "MDEyOk9yZ2FuaXphdGlvbjQ=",
    "avatar_url": "https://github-demo.devopshub.cn/avatars/u/4?",
    "gravatar_id": "",
    "url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1",
    "html_url": "https://github-demo.devopshub.cn/infintestorg1",
    "followers_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/followers",
    "following_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/following{/other_user}",
    "gists_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/gists{/gist_id}",
    "starred_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/starred{/owner}{/repo}",
    "subscriptions_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/subscriptions",
    "organizations_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/orgs",
    "repos_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/repos",
    "events_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/events{/privacy}",
    "received_events_url": "https://github-demo.devopshub.cn/api/v3/users/infintestorg1/received_events",
    "type": "Organization",
    "site_admin": false
  },
  "network_count": 0,
  "subscribers_count": 0
}
```


### 同步脚本

@echo off
mkdir _temp
mkdir logs
cd _temp

set ghe=https://github-demo.devopshub.cn
set url=https://github.com/Infineon/TARGET_CYW943907AEVAL1F

for /f "tokens=1,2,3,4,5,* delims=/" %%a in ("%url%") do (

	set schema=%%a
	set domain=%%b
	set org=%%c
	set repo=%%d
)

echo vars:%schema%,%domain%,%org%,%repo%
pause

git clone --mirror "%url%" %repo%
cd %repo%

git remote set-url --push origin "%ghe%/%org%/%repo%"

git push --mirror

cd ..
rmdir /s/q %repo%

pause



### 仓库创建

gh api -H "Accept: application/vnd.github+json" --hostname github-demo.devopshub.cn /orgs/infintestorg1

gh api --method POST -H "Accept: application/vnd.github+json" /admin/organizations --hostname github-demo.devopshub.cn -f login='infintestorg1' -f profile_name='cli test.' -f admin='localadmin'

gh api --method POST -H 'Accept: application/vnd.github+json' /admin/organizations --hostname github-demo.devopshub.cn -f login='infintestorg1' -f profile_name='cli test.' -f admin='localadmin'

## 问题
https://git.savannah.nongnu.org/git/lwip 有同步
ssh://git@gitlab.espressif.cn:27227/igrokhotkov/newlib_xtensa-2.2.0.git 未同步

缺的：
https://github.com/nodejs/http-parser.git
https://github-demo.devopshub.cn/nodejs/http-parser.git

增量：
https://github.com/cypresssemiconductorco/mtb-example-btsdk-ble-alert-server 是这个地址自动跳到了： https://github.com/Infineon/mtb-example-btsdk-ble-alert-server

v2 urls:
没了的：
https://github.com/cypresssemiconductorco/mtb-example-btsdk-hid-dual-mode-keyboard
https://github.com/cypresssemiconductorco/mtb-examples-CYW920819EVB-02-btsdk-hid
https://github.com/cypresssemiconductorco/mtb-examples-CYW920819REF-KB-01-btsdk-hid
https://github.com/cypresssemiconductorco/TARGET_CYW920819REF-KB-01
https://github.com/cypresssemiconductorco/mtb-example-anycloud-ble-wifi-onboarding
https://github.com/cypresssemiconductorco/mtb-example-anycloud-ble-battery-server
https://github.com/cypresssemiconductorco/mtb-example-anycloud-ble-capsense-buttons-slider
https://github.com/cypresssemiconductorco/mtb-example-anycloud-offload-tcp-keepalive
https://github.com/cypresssemiconductorco/mtb-example-psoc6-adc-basic
https://github.com/cypresssemiconductorco/mtb-example-anycloud-wifi-web-server
https://github.com/cypresssemiconductorco/mtb-example-anycloud-ble-wifi-gateway
https://github.com/Infineon/mtb-example-lz4-demo
https://github.com/Infineon/mtb-example-btsdk-low-power-20819
https://github.com/Infineon/mtb-example-btstack-freertos-mesh-switch-dimmer
https://github.com/Infineon/mtb-example-btstack-freertos-mesh-light-dimmable
https://github.com/Infineon/mtb-example-usb-device-hid-generic
https://github.com/Infineon/mtb-example-usb-device-suspend
https://github.com/Infineon/mtb-example-usb-device-msc-filesystem-freertos
https://github.com/Infineon/mtb-example-usb-host-cdc-echo
https://github.com/Infineon/mtb-example-usb-device-cdc-echo
https://github.com/Infineon/mtb-example-usb-device-hid-mouse
https://github.com/Infineon/mtb-example-audio-streaming
https://github.com/cypresssemiconductorco/mtb-example-psoc6-i2c-master
https://github.com/cypresssemiconductorco/mtb-example-psoc6-spi-master
https://github.com/cypresssemiconductorco/mtb-example-psoc6-qspi-readwrite
https://github.com/cypresssemiconductorco/mtb-example-psoc6-wdt
https://github.com/cypresssemiconductorco/mtb-example-anycloud-secure-tcp-client
https://github.com/cypresssemiconductorco/mtb-example-psoc6-i2c-master
https://github.com/cypresssemiconductorco/mtb-example-psoc6-spi-master
https://github.com/cypresssemiconductorco/mtb-example-psoc6-qspi-readwrite
https://github.com/cypresssemiconductorco/mtb-example-psoc6-wdt
https://github.com/cypresssemiconductorco/mtb-example-anycloud-secure-tcp-client


### 脚本中要完善的

去重
只处理https://github开头的

### 读取xml url

#### 解析xml获取url

xml文件：
https://itools.infineon.cn/mtb/manifests/
https://itools.infineon.cn/mtb/manifests/mtb-super-manifest.zip



xml节点：
<uri>https://github.com/Infineon/cce-mtb-psoc6-dps310</uri>
<board_uri>https://github.com/cypresssemiconductorco/TARGET_CY8CKIT-062-BLE</board_uri>

#### 读取子仓库

gh api -H "Accept: application/vnd.github+json" --hostname github-demo.devopshub.cn /repos/localadmin/localadmin/contents/

gh api -H "Accept: application/vnd.github+json" --hostname github-demo.devopshub.cn /repos/Infineon/mtb-example-hal-adc-basic/contents/

gh api -H "Accept: application/vnd.github+json" --hostname github-demo.devopshub.cn /repos/localadmin/localadmin/git/trees/TREE_SHA

gh api -H "Accept: application/vnd.github+json" --hostname github.com /repos/ONLYOFFICE/DocumentServer/contents/

https://github.com/ONLYOFFICE/DocumentServer

gh api -H "Accept: application/vnd.github+json" --hostname github-demo.devopshub.cn /repos/aws/aws-iot-device-sdk-embedded-C/contents/

gh api -H "Accept: application/vnd.github+json" --hostname github-demo.devopshub.cn /repos/aws/aws-iot-device-sdk-embedded-C/contents/.gitmodules
```
W3N1Ym1vZHVsZSAibGlicmFyaWVzLzNyZHBhcnR5L0NNb2NrIl0KCXBhdGggPSBsaWJyYXJpZXMvM3JkcGFydHkvQ01vY2sKCXVybCA9IGh0dHBzOi8vZ2l0aHViLmNvbS9UaHJvd1RoZVN3aXRjaC9DTW9jawpbc3VibW9kdWxlICJsaWJyYXJpZXMvc3RhbmRhcmQvY29yZU1RVFQiXQoJcGF0aCA9IGxpYnJhcmllcy9zdGFuZGFyZC9jb3JlTVFUVAoJYnJhbmNoID0gbWFpbgoJdXJsID0gaHR0cHM6Ly9naXRodWIuY29tL0ZyZWVSVE9TL2NvcmVNUVRULmdpdApbc3VibW9kdWxlICJsaWJyYXJpZXMvc3RhbmRhcmQvY29yZUhUVFAiXQoJcGF0aCA9IGxpYnJhcmllcy9zdGFuZGFyZC9jb3JlSFRUUAoJYnJhbmNoID0gbWFpbgoJdXJsID0gaHR0cHM6Ly9naXRodWIuY29tL0ZyZWVSVE9TL2NvcmVIVFRQLmdpdApbc3VibW9kdWxlICJsaWJyYXJpZXMvc3RhbmRhcmQvY29yZUpTT04iXQoJcGF0aCA9IGxpYnJhcmllcy9zdGFuZGFyZC9jb3JlSlNPTgoJYnJhbmNoID0gbWFpbgoJdXJsID0gaHR0cHM6Ly9naXRodWIuY29tL0ZyZWVSVE9TL2NvcmVKU09OLmdpdApbc3VibW9kdWxlICJsaWJyYXJpZXMvYXdzL2RldmljZS1zaGFkb3ctZm9yLWF3cy1pb3QtZW1iZWRkZWQtc2RrIl0KCXBhdGggPSBsaWJyYXJpZXMvYXdzL2RldmljZS1zaGFkb3ctZm9yLWF3cy1pb3QtZW1iZWRkZWQtc2RrCglicmFuY2ggPSBtYWluCgl1cmwgPSBodHRwczovL2dpdGh1Yi5jb20vYXdzL2RldmljZS1zaGFkb3ctZm9yLWF3cy1pb3QtZW1iZWRkZWQtc2RrLmdpdApbc3VibW9kdWxlICJsaWJyYXJpZXMvYXdzL2pvYnMtZm9yLWF3cy1pb3QtZW1iZWRkZWQtc2RrIl0KCXBhdGggPSBsaWJyYXJpZXMvYXdzL2pvYnMtZm9yLWF3cy1pb3QtZW1iZWRkZWQtc2RrCglicmFuY2ggPSBtYWluCgl1cmwgPSBodHRwczovL2dpdGh1Yi5jb20vYXdzL2pvYnMtZm9yLWF3cy1pb3QtZW1iZWRkZWQtc2RrLmdpdApbc3VibW9kdWxlICJsaWJyYXJpZXMvYXdzL2RldmljZS1kZWZlbmRlci1mb3ItYXdzLWlvdC1lbWJlZGRlZC1zZGsiXQoJcGF0aCA9IGxpYnJhcmllcy9hd3MvZGV2aWNlLWRlZmVuZGVyLWZvci1hd3MtaW90LWVtYmVkZGVkLXNkawoJYnJhbmNoID0gbWFpbgoJdXJsID0gaHR0cHM6Ly9naXRodWIuY29tL2F3cy9kZXZpY2UtZGVmZW5kZXItZm9yLWF3cy1pb3QtZW1iZWRkZWQtc2RrLmdpdApbc3VibW9kdWxlICJsaWJyYXJpZXMvc3RhbmRhcmQvY29yZVBLQ1MxMSJdCglwYXRoID0gbGlicmFyaWVzL3N0YW5kYXJkL2NvcmVQS0NTMTEKCWJyYW5jaCA9IG1haW4KCXVybCA9IGh0dHBzOi8vZ2l0aHViLmNvbS9GcmVlUlRPUy9jb3JlUEtDUzExLmdpdApbc3VibW9kdWxlICJsaWJyYXJpZXMvc3RhbmRhcmQvYmFja29mZkFsZ29yaXRobSJdCglwYXRoID0gbGlicmFyaWVzL3N0YW5kYXJkL2JhY2tvZmZBbGdvcml0aG0KCWJyYW5jaCA9IG1haW4KCXVybCA9IGh0dHBzOi8vZ2l0aHViLmNvbS9GcmVlUlRPUy9iYWNrb2ZmQWxnb3JpdGhtLmdpdApbc3VibW9kdWxlICJsaWJyYXJpZXMvYXdzL290YS1mb3ItYXdzLWlvdC1lbWJlZGRlZC1zZGsiXQoJcGF0aCA9IGxpYnJhcmllcy9hd3Mvb3RhLWZvci1hd3MtaW90LWVtYmVkZGVkLXNkawoJYnJhbmNoID0gbWFpbgoJdXJsID0gaHR0cHM6Ly9naXRodWIuY29tL2F3cy9vdGEtZm9yLWF3cy1pb3QtZW1iZWRkZWQtc2RrLmdpdApbc3VibW9kdWxlICJkZW1vcy9qb2JzL2pvYnNfZGVtb19tb3NxdWl0dG8vbGlibW9zcXVpdHRvIl0KCXBhdGggPSBkZW1vcy9qb2JzL2pvYnNfZGVtb19tb3NxdWl0dG8vbGlibW9zcXVpdHRvCgl1cmwgPSBodHRwczovL2dpdGh1Yi5jb20vZWNsaXBzZS9tb3NxdWl0dG8uZ2l0CltzdWJtb2R1bGUgImxpYnJhcmllcy9hd3MvZmxlZXQtcHJvdmlzaW9uaW5nLWZvci1hd3MtaW90LWVtYmVkZGVkLXNkayJdCglwYXRoID0gbGlicmFyaWVzL2F3cy9mbGeWNib3IKCXVybCA9IGh0dHBzOi8vZ2l0aHViLmNvbS9pbnRlbC90aW55Y2Jvcgpbc3VibW9kdWxlICJsaWJyYXJpZXMvYXdzL3NpZ3Y0LWZvci1hd3MtaW90LWVtYmVkZGVkLXNkayJdCglwYXRoID0gbGlicmFyaWVzL2F3cy9zaWd2NC1mb3ItYXdzLWlvdC1lbWJlZGRlZC1zZGsKCXVybCA9IGh0dHBzOi8vZ2l0aHViLmNvbS9hd3MvU2lnVjQtZm9yLUFXUy1Jb1QtZW1iZWRkZWQtc2RrLmdpdApbc3VibW9kdWxlICJsaWJyYXJpZXMvM3JkcGFydHkvbWJlZHRscyJdCglwYXRoID0gbGlicmFyaWVzLzNyZHBhcnR5L21iZWR0bHMKCXVybCA9IGh0dHBzOi8vZ2l0aHViLmNvbS9BUk1tYmVkL21iZWR0bHMK
```

https://github.com/aws/aws-iot-device-sdk-embedded-C

### 思路

下载zip包、解压、解析xml、获取url、保存url、读取url content获取子仓库、保存子仓库、、

木头明:
@云开春雷 在确认一下，子子里面的仓库还会有子仓库吗？要不要考虑多层镶套的情况

云开春雷:
理论上会存在的，espressif提供的就存在这种情况。似乎还存在环路的情况，但哪个库引起的还不确定

木头明:
还就是还是要考虑，而且还要考虑循环套用时要退出，要不就死循环了


https://www.pstips.net/loading-and-processing-xml-files.html

## 定时任务脚本
#脚本中调用的zabbix.ps1 的作用是Get-Content zabbix配置文内容并out-file到另一个文件。完全可以当作备份。

$action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"  -Argument "-file C:\Users\shi001admin\Desktop\zabbix.ps1" 
#3分钟执行一次，无期限运行。
$trigger = New-ScheduledTaskTrigger -Once -At (get-date) -RepetitionInterval (New-TimeSpan -Minutes 3) -RepetitionDuration ([System.TimeSpan]::MaxValue)
#电源选型设置
$setting = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd
#S4U：不管用户是否登录都要运行
$principal = New-ScheduledTaskPrincipal -UserId shi001admin -LogonType S4U
$name = New-ScheduledTask -Action $action -Trigger  $trigger   -Settings $setting  -Principal $principal

Register-ScheduledTask -TaskName  "testtask" -InputObject $name 
