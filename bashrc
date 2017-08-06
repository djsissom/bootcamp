#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# .bashrc
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# User-specific ~/.bashrc, generalized for GNU/Linux and Apple OS X
# Excecuted by bash(1) for non-login shells
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Source external definitions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[ -r /etc/*bashrc ] && . /etc/*bashrc			# Global bash definitions
[ -r ~/.bash_colors ] && . ~/.bash_colors		# Human-readable color variables


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Determine local environment
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

case $( uname ) in
	( *[Ll]inux*	)
		case "$HOSTNAME" in
			( vmp*		) host='cluster';;	# Auto-detect whether we're running on the
			( vpac*		) host='astro';;	# ACCRE cluster or the VPAC network at
			( *			) host='linux';;	# Vanderbilt, and set options appropriately
		esac;;
	( *[Dd]arwin* ) host='osx';;
	( *						) echo 'running on unknown host' && return;;
esac


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Import packages
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if [[ $host == cluster ]]; then
	setpkgs -a gcc_compiler
	setpkgs -a intel_compiler
	setpkgs -a fftw2-mpich2_gcc_ether
	setpkgs -a mpich2_gcc_ether
	setpkgs -a gsl_gcc
	setpkgs -a gsl_intel
	setpkgs -a hdf5
	setpkgs -a valgrind
	setpkgs -a python
	setpkgs -a scipy
	setpkgs -a perl
	setpkgs -a idl-8.0
	setpkgs -a matlab
	setpkgs -a octave
	setpkgs -a R
	setpkgs -a ImageMagick
fi


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Path definitions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

case "$host" in
	( cluster )
		export PATH=/usr/local/supermongo/bin:$PATH		# Supermongo path
		export PATH=/usr/local/cuda/bin:$PATH			# Nvidia CUDA path
		export PATH=/usr/lpp/mmfs/bin:$PATH				# GPFS utilities path
		export PATH=~/local/bin:$PATH					# User-specific path
		export LD_LIBRARY_PATH=/usr/scheduler/torque/lib:$LD_LIBRARY_PATH
		export LD_LIBRARY_PATH=/usr/local/supermongo/lib:$LD_LIBRARY_PATH
		export LD_LIBRARY_PATH=/usr/local/python/lib:$LD_LIBRARY_PATH
		export LD_LIBRARY_PATH=/usr/local/cuda/lib:$LD_LIBRARY_PATH
		export PYTHONPATH=~/local/lib/python/site-packages:$PYTHONPATH
		export IDL_STARTUP=~/.idl/idl_startup.pro
		export IDL_PATH=+/home/sinham/utils/idl:$IDL_PATH
		export IDL_PATH=.:+/usr/local/idl/idl/lib:+/usr/local/idl/idl/:$IDL_PATH
		;;
	( astro		)
		export PATH=/usr/local/python64/bin:$PATH		# Python path (64 bit)
		export PATH=~/local/bin:$PATH					# User specific path
		export LD_LIBRARY_PATH=/usr/local/python64/lib:$LD_LIBRARY_PATH
		export PYTHONPATH=~/local/lib/python/latest/site-packages:$PYTHONPATH
		export PYTHONPATH=/usr/local/python64/lib/python*/site-packages:$PYTHONPATH
		source /usr/local/itt/idl80/idl/bin/idl_setup.bash
		export IDL_PATH=.:/home/sinham/psu/utils/idl/:+$IDL_DIR
		export IDL_STARTUP=~/.idl/idl_startup.pro
		;;
	( linux		)
		export PATH=~/Local/bin:$PATH					# User specific path
		export PYTHONPATH=~/Local/lib/python/latest/site-packages:$PYTHONPATH
		;;
	( osx			)
		export PATH=/opt/local/bin:/opt/local/sbin:$PATH	# Macports path
		export PATH=~/Local/bin:$PATH						# User specific path
		export PYTHONPATH=~/Local/lib/python/latest/site-packages:$PYTHONPATH
		;;
esac


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Bash behavior
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[ -z "$PS1" ] && return				# If not running interactively, exit here

export EDITOR=vim					# Use vim as default text editor
export HISTCONTROL=ignoreboth		# No duplicate or space-started lines in history
shopt -s histappend					# Append to the history file, don't overwrite it
shopt -s checkwinsize				# Update $LINES and $COLUMNS after each command


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Enable advanced tab-completion
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Define file paths for tab-completion scripts
case "$host" in 
	( cluster | astro )
		bash_completion_path=/usr/share/bash-completion/bash_completion
		git_completion_path=/etc/bash_completion.d/git
		;;
	( linux )
		bash_completion_path=/usr/share/bash-completion/bash_completion
		git_completion_path=/usr/share/git/completion/git-prompt.sh
		;;
	( osx )
		bash_completion_path=/opt/local/etc/bash_completion
		git_completion_path=/opt/local/etc/bash_completion.d/git
		;;
esac

# Source bash_completion script if available; otherwise, set completion manually
if [ -r "$bash_completion_path" ]; then
	. "$bash_completion_path"			# Source global definition file
elif [ -r ~/.bash_completion ]; then
	. ~/.bash_completion				# Look in ~ if global file doesn't exist
else
	complete -cf sudo					# Bash auto-completion after sudo
	complete -cf man					# Bash auto-completion after man
fi

# Enable bash tab completion for git commands, if available
if [ -r "$git_completion_path" ]; then
	. "$git_completion_path"
	git_prompt=yes						# This and the following enable the git prompt
	export GIT_PS1_SHOWDIRTYSTATE=1
	export GIT_PS1_SHOWSTASHSTATE=1
	export GIT_PS1_SHOWUNTRACKEDFILES=1
	export GIT_PS1_SHOWUPSTREAM="auto"
fi


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Set up a fancy prompt and window title, if available
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Use a colored prompt, if available
[ -t 1 ] && [ -n $(tput colors) ] && [ $(tput colors) -ge 8 ] && color_prompt=yes

# Choose username/hostname color based on whether or not we are the root user
UserColor="$Cyan"
[ $UID == "0" ] && UserColor="$Red"

# Set prompt options based on capabilities
if [[ "$color_prompt" == yes && "$git_prompt" == yes ]]; then
	PS1='['${UserColor}'\u@\h'${Color_Off}':'${Blue}'\w'${Green}'$(__git_ps1 " (git-%s) ")'${Color_Off}']\$ '
elif [[ "$color_prompt" == yes ]]; then
	PS1="[${UserColor}\u@\h${Color_Off}:${Blue}\w${Color_Off}]\\$ "
elif [[ "$git_prompt" == yes ]]; then
	PS1='[\u@\h:\w$(__git_ps1 " (git-%s) ")]\$ '
else
	PS1='[\u@\h:\w]\$ '
fi

# If this is an xterm, set the title to user@host:dir
case "$TERM" in
	( xterm* | rxvt*	) xterm_title="\[\e]0;\u@\h : \w\a\]" ;;
	( *								) xterm_title= ;;
esac
PS1="${xterm_title}${PS1}"


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Alias definitions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# general usage
alias u='cd ..'
alias back='cd "$OLDPWD"'
#alias ls='ls --group-directories-first'
alias ll='ls -lh'
alias la='ls -A'
alias list='ls -lhA'
alias tree='tree -Chug'
alias truecrypt='truecrypt -t'

echo "Don't forget to practice safe rm'ing..."
# add some safer aliases here:

# extra fun stuff
alias blah='while true; do head -c8 /dev/urandom; sleep 0.10; done | hexdump -C'
alias engage='play -n -c2 synth whitenoise lowpass -1 120 lowpass -1 120 lowpass -1 120 gain +14'
alias batch-unzip='for i in *.zip; do newdir="$i:gs/.zip/"; mkdir "$newdir"; unzip -d "$newdir" "$i"; done'
alias merge_pdfs='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=merged.pdf'
alias watch_traffic="bmon -p eth0 -b -o curses:'bgchar= '"
alias weather="curl http://wttr.in/Nashville"

# enable color support
if [ -x /usr/bin/dircolors ]; then
	eval "`dircolors -b`"
	#alias ls='ls --color=auto --group-directories-first'
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# host-specific aliases
case "$host" in
	( cluster )
		alias open='gnome-open'
		alias freenodes="pbsnodes | grep 'opteron' -A3 -B3	| grep 'state = free' -A2 -B1 | less"
		alias qm="qstat -a | grep $USER"
		alias get_gpu_node="qsub -I -W group_list=nbody_gpu -l nodes=1:ppn=1:gpus=1 -l pmem=1000mb -l mem=1000mb -l walltime=3:00:00"
		alias checkrun="showq | grep $USER | tail -n 1 | awk '{print $1}' | xargs qcat"
		alias usage='mmlsquota --block-size auto'
		;;
	( astro		)
		alias open='kde-open'
		export VUSPACEHOST=`echo $USER | cut -b 1`
		alias mountvuspace="/sbin/mount.cifs //vuspace-$VUSPACEHOST/user ~/vuspace -o username=$USER"
		alias umountvuspace="/sbin/umount.cifs ~/vuspace"
		;;
	( linux		)
		alias open='kde-open'
		alias ssh='eval $(/usr/bin/keychain --eval --agents ssh --quick --quiet --timeout 480 ~/.ssh/id_rsa) && ssh'
		alias scp='eval $(/usr/bin/keychain --eval --agents ssh --quick --quiet --timeout 480 ~/.ssh/id_rsa) && scp'
		;;
	( osx			)
		alias ls='ls -G'
		alias top='top -o cpu'
		alias ssh='if [[ `ssh-add -l` == "The agent has no identities." ]]; then ssh-add -t 28800; fi && ssh'
		alias scp='if [[ `ssh-add -l` == "The agent has no identities." ]]; then ssh-add -t 28800; fi && scp'
		;;
esac


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Program-specific settings and fixes
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# User-defined functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Enable user-passable growl notifications
case "$host" in
	( osx )
		growl() { echo -e $'\e]9;'${1}'\007' ; return ; }
		;;
esac


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# End
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
