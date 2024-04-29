#!/bin/bash

rm repo_urls.txt
rm submodules.txt
python3.9 01.01-update-mtp-super-manifest-fv2.py
python3.9 01.02-get-manifest-repo.py
python3.9 01.03-analysis-super-manifest.py
[root@localhost gitsync]# vi 00-run_repo_sync.sh 
[root@localhost gitsync]# clear
[root@localhost gitsync]# cat 00-run_repo_sync.sh 
#!/bin/bash

rm repo_urls.txt
rm submodules.txt
python3.9 01.01-update-mtp-super-manifest-fv2.py
python3.9 01.02-get-manifest-repo.py
python3.9 01.03-analysis-super-manifest.py
python3.9 02-analysis-submodules.py
python3.9 02.01-check-repo.py

if [[ -s not_in_golden.txt ]]
then 
    echo "not_in_golden.txt is not empty. Skipping the next 3 script executions."
    python3.9 botmsg.py
else 
    python3.9 03-sync-repos.py
    python3.9 04-sync-submodules.py
    python3.9 05-sync-mannual-repos.py
fi
