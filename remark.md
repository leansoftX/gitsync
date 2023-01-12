# 备注

## 订阅帐号

https://portal.azure.cn/#@infineon2023.partner.onmschina.cn/resource/subscriptions/f244e082-0e0f-4210-8d0d-beba7ef6d883/resourcegroups/github-poc/providers/Microsoft.Compute/virtualMachines/ghes-mooncake/overview

Test@infineon2023.partner.onmschina.cn
Jan032023

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

全部权限TOKEN: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

gh auth login 
gh auth login --hostname github-demo.devopshub.cn
export GH_HOST=<hostname>
export GH_ENTERPRISE_TOKEN=<access-token>
gh auth login --hostname github-demo.devopshub.cn --with-token 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
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