def compare_files(file1, file2):
    # 初始化列表
    github_repos_tobe_sync = []

    # 异常处理
    try:
        # 打开并读取第一个文件
        with open(file1, 'r') as repo_file:
            data = repo_file.readlines()
            github_repos_tobe_sync.extend(data)

        # 打开并读取第二个文件
        with open(file2, 'r') as submodule_file:
            data = submodule_file.readlines()
            github_repos_tobe_sync.extend(data)

        # 打开并读取'goden.txt'文件
        with open('golden_file.txt', 'r') as goden:
            goden_data = goden.readlines()

        # 将读取的数据转换为一个集合，以便于查找
        goden_set = set(goden_data)

        # 初始化列表来存储不存在于'goden.txt'中的行
        not_in_goden = []

        # 检查每一行是否在'goden.txt'中
        for line in github_repos_tobe_sync:
            # 忽略仓库列表
            if line.startswith('https://github.com/Infineon') or line.startswith('https://github.com/cypresssemiconductorco'):
                continue
            if line not in goden_set:
                not_in_goden.append(line)

        # 将不存在于'goden.txt'中的所有行写入到'not_in_goden.txt'文件中
        with open('not_in_goden.txt', 'w') as out_file:
            for line in not_in_goden:
                out_file.write(line)

    except Exception as e:
        print(f"There was a problem: {str(e)}")

# 测试函数
compare_files('repo_urls.txt', 'submodules.txt')