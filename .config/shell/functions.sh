# shellcheck shell=sh

cd() { echo "Use pushd!"; }

pwd() { echo "Use dirs [-v]"; }

man() {
	case $1 in 
		-* | [1-9]* | n)
			command man "$@"
			;;
		*)
			echo "Specify section"
			return 1
	esac
}

git() {
	if [ "$1" = "--git-dir" ]; then
		_git_dir="$2"
		shift 2
	fi
	if [ "$1" = "--work-tree" ]; then
		_work_tree="$2"
		shift 2
	fi

	if [ "$1" = "checkout" ]; then
		echo "Use"
		echo " - git checkout-index -fu"
		echo " - git read-tree --cached -u"
	elif [ "$1" = "reset" ]; then
		echo "Use"
		echo " - git read-tree -mu"
		echo " - git read-tree -m"
		echo " - git update-index --add --remove \
--cacheinfo 100644 sha1 filename"
	elif [ "$1" = "status" ] && [ $# = 1 ]; then
		echo "Use"
		echo " - git diff-index --cached HEAD"
		echo " - git diff-files"
		echo " - git ls-files --exclude-standard -o"
		echo " - git status -bs"
	elif [ "$1" = "log" ]; then
		echo "Use"
		echo " - git rev-list HEAD"
	else
		if [ -n "${_git_dir}" ]; then
			set -- --git-dir "${_git_dir}" "$@"
		fi
		if [ -n "${_work_tree}" ]; then
			set -- --work-tree "${_work_tree}" "$@"
		fi
		unset _git_dir _work_tree
		command git "$@"
		return $?
	fi
	return 1
}

print_goodbye() {
	set -- \
		--modified \
		--others \
		--exclude-standard \
		--directory \
		--no-empty-directory
	# shellcheck disable=SC2016
	if [ -z "${TMUX}" ] && {
		[ -n "$(dotfiles ls-files  "$@" || true)" ] ||
		! dotfiles submodule foreach '[ -z "$(git ls-files '"$*"')" ]' \
		>/dev/null 2>/dev/null;
	}; then
		echo "In dotfiles:"
		dotfiles status -s
		dotfiles submodule foreach 'git status -s'
		read -r var
		echo "${var}"
		unset var
	fi
}
