# Vim Extrovert

Are you ever working on a file and want to share it with someone you
work with, and you need to open up GitHub, navigate to the file,
copy the URL, and send it to someone on your team?

Maybe you're sharing your screen and your vim setup is scaring your
coworkers, so you need to open up the file in GitHub, and have to
navigate to GitHub and find the file.

###### Well not anymore!

`vim-extrovert` allows you to copy the file URL to the clipboard, or
open it in your browser right away to avoid these tedious steps.

### Support

This plugin has support for **GitHub**, **GitLab**, and **BitBucket**.

## Installation

#### VimPlug

```
Plug 'cd-4/vim-extrovert'
```

### Commands

Command | Description
--- | ---
CopyGitUrl | Copys the URL to the current file and line number into your clipboard
CopyGitFileUrl | Copys the URL to the current file (no line number) into your clipboard
OpenGitUrl | Opens the URL to the current file and line number in your browser
OpenGitFileUrl | Opens the URL to the current file (no line number) in your browser

## Usage

### Customization

#### Opening URLs (Mandatory for Windows Users!)

If you do not want to use the default open commands (`open` for max/linux),
you can set `g:vim_extrovert_open_command = COMMAND`, where `COMMAND`
is something that will open the URL with a command like so:

```
COMMAND 'https://github.com/myorg/myrepo/blob/main/path/to/file'
```

###### Windows Users

You can set this to something like `Start-Process chrome.exe` for this to work.

#### Copying to Clipboard (Mandatory for Linux Users!)

If you do not want to use the default clipboard commands, (`pbcopy` for mac,
`clip` for windows), you can set `g:vim_extrovert_clipboard = CLIPBOARD`, where
`CLIPBOARD` is something that will copy to your clipboard like so:

```
echo "UrlToCopy" | CLIPBOARD
```

##### Linux Users

If you have `xclip` installed, this should work out of the box, but
otherwise you will have to set this to something else.

