
" script encoding
scriptencoding utf-8

" load control
if !exists('g:loaded_vim_extrovert')
    finish
endif

let g:loaded_vim_extrovert = 1

let s:save_cpo = &cpo
set cpo&vim



" Examples:
"   GitHub:
"   https://github.com/cd-4/git-browser.git
"   git@github.com:cd-4/git-browser.git
"       Link:
"       https://github.com/flyer-org/recipe-book/blob/main/backend/tests/Backend.get.test.mo#L3
"
"   GitLab:
"   https://gitlab.com/cd-4-test/tet-project.git
"   git@gitlab.com:cd-4-test/tet-project.git
"       Link:
"       https://gitlab.com/cd-4-test/tet-project/-/blob/main/TestFile#L2
"
"   BitBucket:
"   https://charlie-test-admin@bitbucket.org/charlie-test/test-repo.git
"   git@bitbucket.org:charlie-test/test-repo.git
"       Link:
"       https://bitbucket.org/charlie-test/test-repo/src/18b58c304266df2215e5bc5879a8c0c1e4bff708/.gitignore#lines-3

function GetTopLevelGitPath()
    return trim(system("git rev-parse --show-toplevel"))
endfunction

function GetGitBranch()
    return trim(system("git rev-parse --abbrev-ref HEAD"))
endfunction

function GetOriginUrl()
    let file_path = GetTopLevelGitPath()
    let current_dir = trim(system("pwd"))
    let res = system("cd " . file_path)
    let response = trim(system("git config --get remote.origin.url"))
    let res = system("cd " . current_dir)
    return response
endfunction

function OriginUrl()
    echom GetOriginUrl()
endfunction

function IsInGitRepository(origin_url)
    let result = trim(a:origin_url) != ""
    return result
endfunction

function GetOriginUrlSection(origin_url, index)
    let url_pieces = split(a:origin_url, "/")
    return url_pieces[a:index]
endfunction

function GetRelativeFilePath()
    let full_file_path = expand('%:p')
    let top_level_path = GetTopLevelGitPath()
    let relative_path = full_file_path[len(top_level_path):]
    return relative_path
endfunction

function IsGitHubRepository(origin_url)
    return stridx(a:origin_url, "github.com") != -1
endfunction

function IsGitLabRepository(origin_url)
    return stridx(a:origin_url, "gitlab.com") != -1
endfunction

function IsBitBucketRepository(origin_url)
    return stridx(a:origin_url, "bitbucket.org") != -1
endfunction

function GetGitHubRepoOwner(origin_url)
    if stridx(a:origin_url, "git@") != -1
        " SSH
        return split(GetOriginUrlSection(a:origin_url, -2), ":")[1]
    else
        " HTTPS
        return GetOriginUrlSection(a:origin_url, -2)
    endif
endfunction

function GetBitBucketRepoOwner(origin_url)
    if stridx(a:origin_url, "git@") != -1
        " SSH
        return split(GetOriginUrlSection(a:origin_url, -2), ":")[1]
    else
        " HTTPS
        return GetOriginUrlSection(a:origin_url, -2)
    endif
endfunction

function GetGitUrl(get_line_number)
    let git_branch = GetGitBranch()
    let origin_url = GetOriginUrl()
    let repo_name = split(GetRepoName(origin_url), '\.')[0]
    let line_no = line(".")
    if IsGitHubRepository(origin_url)
        let repo_owner = GetGitHubRepoOwner(origin_url)
        let relative_file_path = GetRelativeFilePath()
        let git_url = "http://github.com/" . repo_owner .
                    \ "/" . repo_name .
                    \ "/blob/" . git_branch . relative_file_path
        if a:get_line_number
            let git_url = git_url . "#L" . line_no
        endif
        return git_url
    elseif IsGitLabRepository(origin_url)
        echom "GitLab"
    elseif IsBitBucketRepository(origin_url)
        let repo_owner = GetGitHubRepoOwner(origin_url)
        let relative_file_path = GetRelativeFilePath()
        let git_hash = GetGitHash()
        let bitbucket_url = "https://bitbucket.org/" . repo_owner .
                    \ "/" . repo_name . "/src/" . git_hash .
                    \ relative_file_path
        if a:get_line_number
            let bitbucket_url = bitbucket_url . "#lines-" . line_no
        endif
        return bitbucket_url
    else
        echom "Unrecognized git origin"
    endif
endfunction

function GetRepoName(origin_url)
    return GetOriginUrlSection(a:origin_url, -1)
endfunction

function GetOpenCommand()
    if exists("g:vim_extrovert_open_command")
        return g:vim_extrovert_open_command
    endif

    let os = GetOS()
    if os == "windows"
        return "Start-Process chrome.exe"
    else
        return "open"
    endif
endfunction

function LinuxHasXClip()
    if filereadable(trim(system("which xclip")))
        return 1
    endif
    return 0
endfunction

function GetGitHash()
    return  trim(system("git rev-parse HEAD"))
endfunction

function GetClipboardPiper()
    if exists("g:vim_extrovert_clipboard")
        return g:vim_extrovert_clipboard
    endif

    let os = GetOS()
    if os == "mac"
        " (Preinstalled)
        return "pbcopy"
    elseif os == "linux"
        if LinuxHasXClip()
            return "xclip -selection clipboard"
        endif
        echo "No ClipBoard program found. Set g:vim_extrovert_clipboard to set"
        return ""
    else
        " Windows (Preinstalled)
        return "clip"
    endif
endfunction

function CopyText(text)
    let copy_command = GetClipboardPiper()
    call system("echo " . a:text . " | " . copy_command)
endfunction

function OpenUrl(url)
    let open_command = GetOpenCommand()
    call system(open_command . " " . a:url)
endfunction

function extrovert#CopyGitUrl()
    let git_url = GetGitUrl(1)
    call CopyText(git_url)
endfunction

function extrovert#CopyGitFileUrl()
    let git_url = GetGitUrl(0)
    call CopyText(git_url)
endfunction

function extrovert#OpenGitUrl()
    let git_url = GetGitUrl(1)
    call OpenUrl(git_url)
endfunction

function extrovert#OpenGitFileUrl()
    let git_url = GetGitUrl(0)
    call OpenUrl(git_url)
endfunction

function GetOS()
    let uname_value = trim(system("uname -s"))
    if uname_value == "Darwin"
        return "mac"
    elseif uname_value == "Linux"
        return "linux"
    else
        return "windows"
    endif
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
