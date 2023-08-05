#!/bin/sh

progress_bar() {
  duration="$1"
  bar_length=55
  sleep_duration=$(echo "$duration / $bar_length" | bc)

  i=0
  while [ "$i" -le "$bar_length" ]; do
    printf "\r["

    j=0
    while [ "$j" -lt "$i" ]; do
      printf "="
      j=$((j+1))
    done

    printf ">"

    j=$((i+1))
    while [ "$j" -lt "$bar_length" ]; do
      printf " "
      j=$((j+1))
    done

    printf "] %d%%" "$((i*100/bar_length))"

    sleep "$sleep_duration"
    i=$((i+1))
  done

  printf "\n"
}


INSTANCENAME=tomcat

INSTANCETYPE=t2.micro

AMI_ID=ami-00f898fc5c0fb69d1

ZONE=subnet-04af86a9c1fe173cf

COUNTS=1

INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --count $COUNTS --instance-type $INSTANCETYPE --key-name filinta --security-group-ids sg-095f8a5309d27ce0b --subnet-id $ZONE --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value='$INSTANCENAME'}]' --query 'Instances[0].InstanceId'  --output text)

echo "Creating $INSTANCENAME server"

progress_bar 55

echo "$INSTANCENAME Server Created Successfully!"


PUBLICIP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[].Instances[].PublicIpAddress' | cut -d "[" -f2 | cut -d "]" -f1 | tr -d '" ')

PCLINE="[$INSTANCENAME]
$PUBLICIP ansible_user=ec2-user"

PHLINE="[$INSTANCENAME]\n\n$PUBLICIP ansible_user=ec2-user"

PATH1="/var/lib/jenkins/workspace/$INSTANCENAME"
PATH2="/root/.jenkins/workspace/$INSTANCENAME"

if [ "$(echo "$PWD")" = "$PATH1" ]; then
  echo "$PCLINE" > hosts
elif [ "$(echo "$PWD")" = "$PATH2" ]; then
  echo "$PCLINE" > hosts
else
  echo "$PHLINE" > hosts
fi
