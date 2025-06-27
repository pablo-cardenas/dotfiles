$env:HOME="$HOME"
$env:XDG_CONFIG_HOME="$HOME\.config"
$env:XDG_CACHE_HOME=$env:TEMP
$env:VISUAL="vim"
$env:Path += ";C:\Program Files\Vim\vim91"
$env:Path += ";C:\Program Files\Emacs\emacs-29.4\bin"
$env:Path += ";C:\Program Files\Tesseract-OCR"
$env:Path = "$HOME\AppData\Local\Programs\Python\Python312;" + $env:Path
$env:OPENCV_SAMPLES_DATA_PATH = "$HOME\Documents\dev\opencv"

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

Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Chord Control+i -Function Complete
