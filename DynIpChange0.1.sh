#!/bin/sh
#Shell script to detect external IP, check if it's different than the previous IP, and email someone if it is different. 
#Written by Brian Woestehoff, June 2012
#brianwoestehoff@gmail.com
#This should be run on a schedule with a separate launchd script.

#variables
ASSETS=/usr/sbin/DynIpChange
[ -d $ASSETS ] || mkdir /usr/sbin/DynIpChange/  
[ -e $ASSETS/Previous_IP ] || touch $ASSETS/Previous_IP
[ -e $ASSETS/Current_IP ] || touch $ASSETS/Current_IP
[ -e $ASSETS/mailmessage ] || touch $ASSETS/mailmessage
MAILME=$ASSETS/mailmessage
ADMIN1=you@youremail.com
CURRENT=`cat $ASSETS/Current_IP`
PREVIOUS=`cat $ASSETS/Previous_IP` 


echo "This email is a test of your Dynamic IP Change script. The next time you get an email like this, it means your IP has changed!">$ASSETS/Previous_IP

#Get IP and overwrite $ASSETS/Current_IP with it
curl http://checkip.dyndns.org/ 2>/dev/null | ruby -pe '$_=$_.scan(/\d+\.\d+\.\d+\.\d+/)' >$ASSETS/Current_IP

if [ "$CURRENT" != "$PREVIOUS" ];

then
	echo "From: IP Address Change Notice <you@yourdomain.com>" >$MAILME
	echo "To: $ADMIN1" >>$MAILME
	#echo "CC: $ADMIN2" >>$MAILME --uncomment if using second email address.
	echo "Subject: IP Address Change Notice" - `date +%Y:%m:%d` >>$MAILME
	echo "Current IP is `cat $ASSETS/Current_IP`" >>$MAILME
cat $ASSETS/mailmessage|sendmail -t

fi

#Replace previous with IP address from current.
cat $ASSETS/Current_IP >$ASSETS/Previous_IP

exit 