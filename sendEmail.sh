#!/bin/bash
export PGPASSWORD='PASSWORD'

function mail(){
sleep 1;
echo "ehlo softbox.com.br";
sleep 1;
echo "MAIL FROM: <email@domain.com>";
sleep 1;
echo "RCPT TO: <email@domain.com>";
sleep 1;
echo "DATA";
sleep 2;
echo "Subject: $(date '+%Y-%m-%d') SUBJECT
Mime-Version: 1.0;
Content-Type: text/html; charset="ISO-8859-1";
Content-Transfer-Encoding: 7bit;

<html>
<body>
<h2> Result of select </h2>

$(psql -U postgres -d catman -H -c "select * from table where month_name='December';")

</body>
</html>



";
sleep 1;
echo ".";
sleep 1;
echo '^]';
echo "quit";
}

mail | telnet smtp-relay.gmail.com 587

