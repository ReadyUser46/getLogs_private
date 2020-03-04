#!/bin/bash
#format terminal
#----------------------------------
green_light='\033[1;32m'
RED='\033[0;31m'
yellow='\033[1;33m'
NC='\033[0m' # No Color
#ght Renaming File...${NC}"printf "I ${RED}love${NC} Stack Overflow\n"
#----------------------------------

echo  -e "$RED *******************************************************************"
echo  -e "*                                                                 *"
echo  -e "*                                                                 *"
echo  -e "*                 @Author: Sergio Caballero                       *"
echo  -e "*                                                                 *"
echo  -e "*                                                                 *"
echo  -e "******************************************************************* ${NC}"


#INTRODUCE THE PATH FOR YOUR SESSIONS FOLDER.
path="/drives/c/Users/caballes/Tmp-SCA/Daily-Records/"

#For choosing a folder placed in a shared server, change the letter 'c'. For example
#path="/drives/y/SWQA Department - PROJECTS/9. TATOOINE/Doubts/TMP/Image/Lars/"

if [ ! -d "$path" ]
then
	mkdir $path
fi

cd "$path"
echo -e "$yellow Your folder is: $(pwd) ${NC}"



#			*****************************
#                       *		            *
#                       *          Inputs           *
#                       *                           *
#                       *****************************

today=$(date +20%y-%m-%d)

echo -e "$green_light Last IP digits (XXXX): ${NC}"
read ip_digits
#ip_final="15.83.6.5"
ip_final="15.83.${ip_digits:0:2}.${ip_digits:2}"
if [[ $ip_digits ]] && [ $ip_digits -eq $ip_digits 2>/dev/null ]; then
 
 echo -e "$green_light Session: ${NC}"
 read sessionNumber
 echo -e "$yellow Checking your session number. Connecting... ${NC}"
 currentSessionString=$(ssh -q root@$ip_final 'grep mapped /tmp/printer.log')
 currentSessionNumber="${currentSessionString:30:4}"
 
 if [ $sessionNumber -ge $currentSessionNumber ]; then
 	echo -e "$RED Your session number: $sessionNumber is equal or bigger than current session: $currentSessionNumber ${NC}"
	echo -e "$RED Impossible to retrieve package. ${NC}"
	exit 1
 fi

 echo -e "$yellow Valid session number! ${NC}"


#                       *****************************
#                       *                           *
#                       *       Device names        *
#                       *                           *
#                       *****************************

case $ip_final in
        15.83.18.11)
	deviceName="Device"
	;;

	15.83.19.165)
	deviceName="Device"
	;;

	15.83.20.2)
	deviceName="Device"
	;;

	15.83.18.239)
	deviceName="Device"
	;;

	15.83.6.5)
	deviceName="Device"
	;;
esac

#                       *****************************
#                       *                           *
#                       *         Connection        *
#                       *                           *
#                       *****************************


 echo -e "$green_light Connecting to target $ip_final${NC}"
 echo -e "$green_light Excluding files : ThermoCamera*.log${NC}"
 rsync -qavr -e ssh --exclude='ThermoCamera*.log' root@$ip_final:/tmp/SESSION.$sessionNumber.LOGS/ $sessionNumber
 echo -e "$green_light Downloading finished${NC}"


#                       *****************************
#                       *                           *
#                       *      Format package       *
#                       *                           *
#                       *****************************


 echo -e "$green_light Renaming File...${NC}"
 renamed_file=${today}_$deviceName-SESSION.$sessionNumber
 mv $sessionNumber $renamed_file 
 echo -e "$green_light File = ${NC} ${renamed_file}"

 echo -e "$green_light Compressing folder into a package .tar.gz${NC}"
 tar -zcvf ${today}_$deviceName-SESSION.$sessionNumber.tar.gz $renamed_file/
 echo -e "$green_light Compressing finished${NC}"

 echo -e "$green_light Cleaning Up directory${NC}"
 #delete the folder and doesn't ask for confirmation
 rm -rf $renamed_file

 

#                       *****************************
#                       *                           *
#                       *       Moving package      *
#                       *                           *
#                       *****************************

 echo -e "$green_light Crating new directory file and moving package... ${NC}"
 package=${today}_$deviceName-SESSION.$sessionNumber.tar.gz
 package_year=$(date +20%y)
 package_month=$(date +%m)
 package_day=$(date +%d)

 #path3 = month
 case $package_month in
	01)
	path3="1-Enero"
	;;

	02)
	path3="2-Febrero"
	;;

	03)
	path3="3-Marzo"
	;;

	04)
	path3="4-Abril"
	;;

	05)
	path3="5-Mayo"
	;;

	06)
	path3="6-Junio"
	;;
	
	07)
	path3="7-Julio"
	;;

	08)
	path3="8-Agosto"
	;;
	
	09)
	path3="9-Septiembre"
	;;

	10)
	path3="10-Octubre"
	;;
	
	11)
	path3="11-Noviembre"
	;;

	12)
	path3="12-Diciembre"
	;;

 esac	

 if [ ! -d "$path/$package_year" ]; then
     mkdir "$path"/"$package_year"
 fi

 if [ ! -d "$path/$package_year/$path3" ]; then
        mkdir "$path"/"$package_year"/"$path3"
 fi

 if [ ! -d "$path/$package_year/$path3/$today" ]; then
	mkdir "$path"/"$package_year"/"$path3"/"$today"
 fi

 echo -e "$green_light Opening session directory... ${NC}"
 mv "$path"/$package "$path"/$package_year/$path3/$today
 cygstart "$path"/$package_year/$path3/$today 
 

else

        echo -e "$green_light You must introduce a number. ${NC}"
	exit 1
fi		








