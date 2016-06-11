#!/usr/bin/env bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

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

export PATH=/bin:/usr/bin:${PATH}


echo "Done."