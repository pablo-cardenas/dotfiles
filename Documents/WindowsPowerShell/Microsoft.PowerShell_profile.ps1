$env:HOME="$HOME"
$env:XDG_CONFIG_HOME="$HOME\.config"
$env:VISUAL="vim"
$env:Path += ";C:\Program Files\Vim\vim91"
$env:Path += ";C:\Program Files\Emacs\emacs-29.4\bin"

function prompt {"$ "}

function vim { 
	$external_vim = Get-Command -Type Application vim
	if ($MyInvocation.ExpectingInput) {
		$input | & $external_vim.Source -u $env:XDG_CONFIG_HOME/vim/vimrc --cmd "set packpath+=$env:XDG_CONFIG_HOME\vim" $args
	} else {
	& $external_vim.Source -u $env:XDG_CONFIG_HOME/vim/vimrc --cmd "set packpath+=$env:XDG_CONFIG_HOME\vim" $args 
	}
}

function dotfiles { git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" $args }

Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Chord Control+i -Function Complete
