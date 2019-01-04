#!/bin/bash

echo $$ > /var/run/cpumem.pid

function Sendmail(){
sleep 1;
echo "ehlo email.com.br";
sleep 1;
echo "MAIL FROM: <no-reply@test.com.br>";
sleep 1;
echo "RCPT TO: <email@teste.com.br>";
sleep 1;
echo "DATA";
sleep 2;
echo "Subject: $(date '+%Y-%m-%d') ALERT!
Mime-Version: 1.0;
Content-Type: text/html; charset="ISO-8859-1";
Content-Transfer-Encoding: 7bit;

<html>
<body>
<h2> ALERT! </h2>

ALERT!

</body>
</html>

";
sleep 1;
echo ".";
sleep 1;
echo '^]';
echo "quit";
}

criticalCpu="650"
criticalMemory="9000"

while true; do
	MEMORY=$(free -m | awk 'NR==2{printf "%.2f\t\t", $3*100/$2 }' | tr -d '.')
	CPU=$(top -bn1 | grep load | awk '{printf "%.2f\t\t\n", $(NF-2)}' | tr -d '.')

	if [ $CPU -ge $criticalCpu ] || [ $MEMORY -ge $criticalMemory ]; then
   		echo "CPU ou Memoria ALTO REINICIAR CONTAINER"
		docker restart container
		Sendmail | telnet smtp-relay.gmail.com 587
		sleep 120
	else
		echo "CPU NORMAL $CPU Memoria NORMAL $MEMORY"
		sleep 30
	fi
done

