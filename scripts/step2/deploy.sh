#!/bin/bash

REPOSITORY=/home/ec2-user/app/step2
PROJECT_NAME=springboot2-webservice

echo "> Build 파일 복사"

cp $REPOSITORY/zip/*SNAPSHOT.jar $REPOSITORY/

echo "> 현재 구동중인 애플리케이션 pid 확인"

# linux
CURRENT_PID=$(pgrep -fl springboot2-webservice | grep java | awk '{print $1}')

echo "현재 구동중인 어플리케이션 pid: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
    echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
    echo "> kill -15 $CURRENT_PID"
    kill -15 $CURRENT_PID
    sleep 5
fi

echo "> 새 어플리케이션 배포"

JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> $JAR_NAME 에 실행권한 추가"

chmod +x $JAR_NAME

echo "> $JAR_NAME 실행"

#nohup java -jar \
#    -Dspring.config.location=optional:classpath:/application.yml
#    -Dspring.config.additional-location=optional:classpath:/application-real.yml,optional:file:/home/ec2-user/app/application-oauth.yml,optional:file:/home/ec2-user/app/application-real-db.yml \
#    -Dspring.profiles.active=real \
#    $JAR_NAME > $REPOSITORY/nohup.out 2>&1 &

# 2.4버전 이후 추가적인 config location 지정은 spring.config.additional-location으로 해야 함
# optional은 설정파일이 있을 수도, 없을수도 있을 때 아래 설정에서 optional로 설정 하였지만, 안줘도 된다.
nohup java -jar $JAR_NAME > $REPOSITORY/nohup.out --spring.config.location=optional:classpath:/application.yml --spring.config.additional-location=optional:classpath:/application-real.yml,optional:file:/home/ec2-user/app/application-oauth.yml,optional:file:/home/ec2-user/app/application-real-db.yml --spring.profiles.active=real 2>&1 &