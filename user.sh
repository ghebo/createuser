#/bin/bash

_USERNAME=$1
_LOGFILE=/var/log/adduser.log
_STATUS=ERROR
_COMPANY_NAME=MyCompany

gooduserlog(){
	_USERNAME=$1
	_STATUS=GOOD
	_MESSAGE="SUCCESS | User ${_USERNAME} was created successfully"
	echo "${_MESSAGE}"
	echo "`date +"%d.%m.%Y %T"` ---> ${_MESSAGE}" >> ${_LOGFILE}
	exit
}
clear
echo "`date +"%d.%m.%Y %T"` ---> Script was run with argument $1" >> ${_LOGFILE}

while [ ${_STATUS} == ERROR ]
do
if [[ `cat /etc/passwd | cut -d ':' -f 1 | grep ^${_USERNAME}$ | wc -l` -gt 0 ]]
	then
		_MESSAGE="WARNING | Username - ${_USERNAME} already exists "
		_STATUS=ERROR

elif [[ ${#_USERNAME} -lt 4 ]]
	then
		_MESSAGE="WARNING | Username - ${_USERNAME} - Username is too short (min 4) "
		_STATUS=ERROR
elif [[ ${_USERNAME} == *"."* ]]
	then
	        _MESSAGE="WARNING | Username - ${_USERNAME} - Username contains '.' "
	        _STATUS=ERROR
else
	gooduserlog ${_USERNAME}
fi

echo "${_MESSAGE}"

_RANDOMNAME=${_COMPANY_NAME}$((10000 + RANDOM % 99999))

echo "Use ${_RANDOMNAME} ? "
read -t 10 -p "Y - yes, N - no, Q - quit    : " _PROMPT
_PROMPT=`echo "${_PROMPT}" | tr '/a-z/' '/A-Z/'`

case ${_PROMPT} in
	Y) _USERNAME=${_RANDOMNAME}
	   gooduserlog ${_USERNAME}
        ;;
	N) read -t 10 -p "Enter another username: " _USERNAME
	   _STATUS=ERROR
        ;;
	Q) read -t 10 -p "Press ENTER to exit"
	   exit
	;;
	*) read -t 10 -p "Y - yes, N - no, Q - quit    : " _PROMPT    
	;;
esac

done
