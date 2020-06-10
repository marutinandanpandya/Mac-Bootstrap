#!/usr/bin/env bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew bundle

docker-machine create --driver virtualbox default
docker-machine env default
docker-machine stop default

xcode-select --install
xcrun simctl delete unavailable



FILES=(.aliases .bashrc .profile .bash_logout .bash_profile .bash_prompt .extra .functions .gitconfig .vimrc .gemrc)

for i in "${FILES[@]}"
do
	FILE=${i}
	PATH=${BASE_DIR}/${FILE}
	HOME_PATH=${HOME}/${FILE}
	echo "Mapping ${PATH} to ${HOME_PATH}"
	/bin/rm -Rf ${HOME_PATH}
	/bin/ln -s ${PATH} ${HOME_PATH}
done

echo "Done."