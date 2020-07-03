#!/bin/bash
set -aux -o pipefail

function enableTestingInFile {
	echo "Setting \$isTest in $1"
	
	cat $1 |sed 's#isTest = 0#isTest = 1#g' > $1__
	mv -f $1__ $1
}

export -f enableTestingInFile

find . -name "*.ale" -exec rm {} \;
find . -name "*.alc" -exec bash -c 'enableTestingInFile "$@"' bash {} \;
