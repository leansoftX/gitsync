if (!(Test-Path "_temp")) {
    mkdir _temp
}
cd _temp

if (!(Test-Path "_logs")) {
    mkdir _logs
}

$nowTime = get-date -format "yyyy-MM-dd_HH-mm-sss"
$synclogPath = $PSScriptRoot+"\_temp\_logs\sync-"+$nowTime+".log"

Write-Output "---DEBUG---,$nowTime,sync start" | Out-File -FilePath $synclogPath -Append
type $synclogPath -Last 2

$file="$PSScriptRoot\urls-all-test-2url.txt"
$ghe="github-demo.devopshub.cn"
$gheadmin="localadmin"
$orgReady=$false
$repoReady=$false
[string[]]$errorRepos=@()
 
if (Test-Path $file) {
    Write-Output "---DEBUG---,Find file $file`n" | Out-File -FilePath $synclogPath -Append 
    type $synclogPath -Last 2
    [string[]]$urls = Get-Content -Path $file
    $AllRepoCount = ($urls.Count)
    Write-Output "`n---DEBUG---,Find $AllRepoCount Repos need sync."  | Out-File -FilePath $synclogPath -Append
    type $synclogPath -Last 2

    foreach($item in $urls)
    {
        $time = (get-date -format "yyyy-MM-dd_HH-mm-sss")
        Write-Output "`n---DEBUG---,$time,Start handle url:$item"  | Out-File -FilePath $synclogPath -Append
        type $synclogPath -Last 2
        [string]$url = $item
        [string[]]$splitUrl = $url.Split("/")
        
        $schema=$splitUrl[0]
        $domain=$splitUrl[2]
        $org=$splitUrl[3]
        $repo=$splitUrl[4]
        Write-Output "`n---DEBUG---,splitUrl:$schema,$domain,$org,$repo"  | Out-File -FilePath $synclogPath -Append
        type $synclogPath -Last 2
        ## pause

        Write-Output "`n---DEBUG---,check is org exists start" | Out-File -FilePath $synclogPath -Append
        type $synclogPath -Last 2

        [string]$orgCheck=(gh api -H "Accept: application/vnd.github+json" --hostname $ghe /orgs/$org)
        Write-Output "`n---DEBUG---, $org check end,result:`n $orgCheck"  | Out-File -FilePath $synclogPath -Append
        type $synclogPath -Last 2

        if ($orgCheck.Contains("node_id")) {
            Write-Output "`n---DEBUG---,org exists"  | Out-File -FilePath $synclogPath -Append
            type $synclogPath -Last 2
            $orgReady=$true          
        }
        else {
            Write-Output "`n---DEBUG---, $org not exist,create start." | Out-File -FilePath $synclogPath -Append
            type $synclogPath -Last 2
            [string]$orgCreate=(gh api --method POST -H "Accept: application/vnd.github+json" /admin/organizations --hostname $ghe -f login="$org" -f profile_name="$org" -f admin="$gheadmin")
            Write-Output "`n---DEBUG---,$org create end,result:`n $orgCreate" | Out-File -FilePath $synclogPath -Append
            type $synclogPath -Last 2

            if ($orgCreate.Contains("node_id")) {
                Write-Output "`n---DEBUG---, org:$org created." | Out-File -FilePath $synclogPath -Append
                type $synclogPath -Last 2
                $orgReady=$true
            }
            else {
                Write-Output "`n---DEBUG---, Org $org Create Failed. Will Enter Next url handle." | Out-File -FilePath $synclogPath -Append
                type $synclogPath -Last 2
                $orgReady=$false
            }
        }

        if ($orgReady) {
            Write-Output "`n---DEBUG---, start check is repo exists." | Out-File -FilePath $synclogPath -Append
            type $synclogPath -Last 2

            [string]$repoCheck=(gh api -H "Accept: application/vnd.github+json" --hostname $ghe /repos/$org/$repo)
            Write-Output "`n---DEBUG---,check is repo exist end,result:`n $repoCheck" | Out-File -FilePath $synclogPath -Append
            type $synclogPath -Last 2

            if ($repoCheck.Contains("node_id")) {
                Write-Output "`n---DEBUG---, repo exists (Update Exists Repo)."  | Out-File -FilePath $synclogPath -Append
                type $synclogPath -Last 2
                $repoReady=$true
            }
            else {
                Write-Output "`n---DEBUG---, create repo $repo start"  | Out-File -FilePath $synclogPath -Append
                type $synclogPath -Last 2
                [string]$repoCreate=(gh api --method POST -H "Accept: application/vnd.github+json" --hostname $ghe /orgs/$org/repos -f name="$repo")
                Write-Output "`n---DEBUG--- $repo create end, result:`n $repoCreate"  | Out-File -FilePath $synclogPath -Append
                type $synclogPath -Last 2

                if ($repoCreate.Contains("node_id")) {
                    Write-Output "`n---DEBUG---, Ready For Clone Code."  | Out-File -FilePath $synclogPath -Append
                    type $synclogPath -Last 2
                    $repoReady=$true
                }
                else {
                    Write-Output "`n---DEBUG---, Repo Create Failed. Will Enter Next url handle."  | Out-File -FilePath $synclogPath -Append
                    type $synclogPath -Last 2
                    $repoReady=$false
                }
            }
        }
        else {
            Write-Output "`n---DEBUG---, Org Create Failed. Enter Next url handle."  | Out-File -FilePath $synclogPath -Append
            type $synclogPath -Last 2
            $repoReady=$false
        }

        if($orgReady -and $repoReady) {
            Write-Output "`n---DEBUG---, Clone Code from $url"  | Out-File -FilePath $synclogPath -Append
            type $synclogPath -Last 2
            ## mkdir $repo            
            $gitClone=(git clone --mirror "$url" $repo) 

            ## if clone ok,will create repo dir
            if (Test-Path $repo) {
                cd $repo
                Write-Output "`n---DEBUG--- modify push url to github Enterprise:$ghe"  | Out-File -FilePath $synclogPath -Append
                type $synclogPath -Last 2
                git remote set-url --push origin "https://$ghe/$org/$repo"

                Write-Output "`n---DEBUG---,start push to host:$ghe with arg: --mirror"  | Out-File -FilePath $synclogPath -Append
                type $synclogPath -Last 2
                git push --mirror

                Write-Output "`n---DEBUG---,push End. clear repo file"  | Out-File -FilePath $synclogPath -Append
                type $synclogPath -Last 2
                cd ..
                ## rmdir $repo -Force -Recurse
            }
            else {
                Write-Output "`n---DEBUG---, Clone $url Fail."  | Out-File -FilePath $synclogPath -Append
                type $synclogPath -Last 2
            }
        }
        else {
            $errorRepos+=$url
        }

        ## reset for next loop
        $orgReady=$false 
        $repoReady=$false

        $time = (get-date -format "yyyy-MM-dd_HH-mm-sss")
        Write-Output "`n---DEBUG---,$time,url:$url handle End."  | Out-File -FilePath $synclogPath -Append
        type $synclogPath -Last 2
        ## pause
    } 
}
else {
    Write-Output "`n---DEBUG---,ERROR: file urls.txt not exists." | Out-File -FilePath $synclogPath -Append
    type $synclogPath -Last 2
}

$nowTime = get-date -format "yyyy-MM-dd_HH-mm-sss"
$errorReposlogPath = $PSScriptRoot+"\_temp\_logs\errorRepos-"+$nowTime+".log"

Write-Output "`n--DEBUG---, $nowTime,sync end" | Out-File -FilePath $synclogPath -Append
type $synclogPath -Last 2

Write-Output "`n---DEBUG---,log file saved to: $synclogPath" | Out-File -FilePath $synclogPath -Append
type $synclogPath -Last 2

$errorRepoCount = ($errorRepos.Count)

if($errorRepoCount -ne 0) {
    Write-Output $errorRepos | Out-File -FilePath $errorReposlogPath -Append
    
    Write-Output "`n---DEBUG---,sync $errorRepoCount error repos saved to: $errorReposlogPath" | Out-File -FilePath $synclogPath -Append
    type $synclogPath -Last 2
}
else {
    Write-Output "`n---DEBUG---,All $AllRepoCount Repos Sync Succeed." | Out-File -FilePath $synclogPath -Append
    type $synclogPath -Last 2
}

cd ..
