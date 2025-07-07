$env:HOME="$HOME"
$env:XDG_CONFIG_HOME="$HOME\.config"
$env:XDG_CACHE_HOME=$env:TEMP
$env:VISUAL="vim"
$env:Path += ";C:\Program Files\Vim\vim91"
$env:Path += ";$HOME\AppData\Local\Vim\vim91"
$env:Path += ";C:\Program Files\Emacs\emacs-29.4\bin"
$env:Path += ";$HOME\AppData\Local\Emacs\bin"
$env:Path += ";$HOME\AppData\Local\Programs\Python\Launcher"

$env:Path = "$HOME\AppData\Local\dotnet;" + $env:Path
$env:DOTNET_ROOT="$HOME\AppData\Local\dotnet\"
$env:DOTNET_MULTILEVEL_LOOKUP=0

function prompt {"$ "}

function vim { 
	$external_vim = Get-Command -Type Application vim
	if ($MyInvocation.ExpectingInput) {
		$input | & $external_vim.Source -u $env:XDG_CONFIG_HOME/vim/vimrc --cmd "set packpath+=$env:XDG_CONFIG_HOME\vim" $args
	} else {
	& $external_vim.Source -u $env:XDG_CONFIG_HOME/vim/vimrc --cmd "set packpath+=$env:XDG_CONFIG_HOME\vim runtimepath+=$env:XDG_CONFIG_HOME\vim" $args
	}
}

function dotfiles { git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" $args }

function python { throw "Use py instead of python!" }

Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Chord Control+i -Function Complete
Set-PSReadLineOption -Colors @{
  Command            = "$([char]0x1b)[0m"
  Number             = "$([char]0x1b)[0m"
  Member             = "$([char]0x1b)[0m"
  Operator           = "$([char]0x1b)[0m"
  Type               = "$([char]0x1b)[0m"
  Variable           = "$([char]0x1b)[0m"
  Parameter          = "$([char]0x1b)[0m"
  ContinuationPrompt = "$([char]0x1b)[0m"
  Default            = "$([char]0x1b)[0m"
}
