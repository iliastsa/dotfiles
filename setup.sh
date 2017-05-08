#!/bin/zsh

# First, **make sure** all the softwares have been installed.
#	* zsh
#	* tmux
#	* vim
#	* git
#   * nvim
HOME=${HOME}
PWD=`pwd`
OH_MY_ZSH=${HOME}"/.oh-my-zsh"
VIM=${HOME}"/.vim"

# Pre check
check_software_exist(){
	softwares=("zsh" "tmux" "vim" "git" "nvim")
	for sw in "${softwares[@]}"
	do
		# Notice the semicolon
		type ${sw} > /dev/null 2>&1 || 
			{ echo "ERROR: **${sw}** is not installed!"; exit 1; }
	done
}

create_symlinks(){
	dotfiles=(".zshrc" ".tmux.conf" ".vimrc" ".gitconfig" ".config/nvim/init.vim")
	echo "IM HEREEEE `pwd`"
	for dotfile in "${dotfiles[@]}"
	do
		ln -sf ${PWD}/${dotfile} ${HOME}/${dotfile}
		echo "Create symlink ${HOME}/${dotfile}"
    done
}

install_oh_my_zsh(){
	if [ -d "${OH_MY_ZSH}"  ]; then
		cd "${OH_MY_ZSH}"
		echo "Change directory to `pwd`"
		echo "${OH_MY_ZSH} exists. Git pull to update..."
		git pull
		cd - > /dev/null 2>&1
		echo "Change directory back to `pwd`"
	else
		echo "${OH_MY_ZSH} not exists. Install..."
		#git clone git@github.com:robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh
		#wget --no-check-certificate http://install.ohmyz.sh -O - | sh
		git clone https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh
	fi
}

# Vim install `Vundle` and plugins

config_zsh(){
	echo "Create symlink ${HOME}/.common"
	ln -sf ${PWD}/.common ${HOME}/.common
	echo "Create symlink ${HOME}/tools"
	ln -sf ${PWD}/tools ${HOME}/tools
	# TODO: See ~/.oh-my-zsh/custom/
	chsh -s `which zsh` # TODO: If zsh is an alias?
	source ${HOME}/.zshrc
}

config_tmux(){
	echo "Create symlink ${HOME}/.tmux.sh"
	ln -sf ${PWD}/.tmux.sh ${HOME}/.tmux.sh # TODO, use alise?
}

config_pathogen(){
    cd ${VIM}
    echo "Downloading pathogen"
    if [ -d bundle  ]; then
		echo "Pathogen exists. Git pull to update..."
	else
		echo "Installing pathogen.."
        mkdir -p ${VIM}/autoload ${VIM}/bundle && \
            curl -LSso ${VIM}/autoload/pathogen.vim https://tpo.pe/pathogen.vim
	fi

}

config_vimAddons(){
    echo "Change directory to ~/.vim/bundle"
    cd ${VIM}/bundle
    #Syntastic
    echo "Downloading syntastic"
    if [ -d syntastic  ]; then
		cd syntastic
		echo "Change directory to `pwd`"
		echo "syntastic exists. Git pull to update..."
		git pull
		cd - > /dev/null 2>&1
		echo "Change directory back to `pwd`"
	else
		echo "syntastic doesn't exists. Installing..."
		git clone --depth=1 https://github.com/vim-syntastic/syntastic.git ${VIM}/bundle/syntastic
	fi
    #nerdtree
    echo "Downloading nerdtree"
    if [ -d nerdtree  ]; then
		cd nerdtree
		echo "Change directory to `pwd`"
		echo "NerdTree exists. Git pull to update..."
		git pull
		cd - > /dev/null 2>&1
		echo "Change directory back to `pwd`"
	else
		echo "NerdTree doesn't exists. Installing..."
		git clone https://github.com/scrooloose/nerdtree.git ${VIM}/bundle/nerdtree
	fi
    #lighline
    echo "Downloading lighline"
    if [ -d lightline.vim  ]; then
		cd lightline.vim
		echo "Change directory to `pwd`"
		echo "lightline exists. Git pull to update..."
		git pull
		cd - > /dev/null 2>&1
		echo "Change directory back to `pwd`"
	else
		echo "lightline doesn't exists. Installing..."
		git clone https://github.com/itchyny/lightline.vim ${VIM}/bundle/lightline.vim
	fi
}

config_nvim(){
    if [ -d .config/nvim/init.vim ]; then
        echo "Nvim is already configured"
    else
        echo "Creating init.vim"
        mkdir .config/nvim
        touch .config/nvim/init.vim
    fi
}

main(){
    check_software_exist
    install_oh_my_zsh
    config_nvim
    create_symlinks
    config_zsh
    config_tmux
    config_pathogen
    config_vimAddons
}

main

echo "[SETUP OK]"
