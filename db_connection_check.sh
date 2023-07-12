#!/bin/bash
export PGPASSWORD=YOUR_PASSWORD

recipient=PROVIDE_EMAIL_ADDRESS

check_postgres_connection() {
    psql -h DB_HOST -p PORT -U USER -d DATABASE -c "SELECT 1;" >/dev/null 2>&1
    return $?
}

logout_postgres() {
  psql -h DB_HOST -p PORT -U USER -d DATABASE -c '\q'
}
if check_postgres_connection; then
    echo "Connection established."
    logout_postgres
else
    echo "Cannot connect to database. Sending a notification"

    message=$(cat <<EOF
From: USER@SERVER
To: $recipient
Subject: YOUR_SUBJECT
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Connection issue</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f5f5f5;
    }
    .container {
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
      background-color: #ffffff;
      border-radius: 5px;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }
    h1 {
      color: #19A7CE;
    }
    p {
      color: #333333;
    }
    .button {
      display: inline-block;
      margin-top: 20px;
      padding: 10px 20px;
      background-color: #19A7CE;
      color: #ffffff;
      text-decoration: none;
      border-radius: 3px;
    }
    .footer {
      margin-top: 20px;
      font-size: 12px;
      color: #999999;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Cannot connect to database</h1>
    Dear Team,</br>
    Server <b>SERVER_NAME</b> cannot connect to database <b>DB_HOST:PORT</b> </br></br>
    Details: </br>
    IP address of SERVER_NAME: <b>IP_ADDRESS</b>
  </br>
     IP address of DB_HOST: <b>IP_ADDRESS</b></br>
     Environment: <b>ENV</b></br>
    <div class="footer">
      <p>The message has been generated automatically. Do not respond.</p>
    </div>
  </div>
</body>
</html>
EOF
)
    echo "$message" | sendmail -t
fi
