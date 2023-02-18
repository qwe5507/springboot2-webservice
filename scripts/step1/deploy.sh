#!/bin/bash

REPOSITORY=/home/ec2-user/app/step1
PROJECT_NAME=springboot2-webservice

cd $REPOSITORY/$PROJECT_NAME

echo "> Git Pull"

git pull

echo "> 프로젝트 Build 시작"

./gradlew build

echo "> step1 디렉토리 이동"

cd $REPOSITORY

echo "> Build 파일복사"

cp $REPOSITORY/$PROJECT_NAME/build/libs/*SNAPSHOT.jar $REPOSITORY/

echo "> 현재 구동중인 애플리케이션 pid 확인"

CURRENT_PID=$(pgrep -f ${PROJECT_NAME}*SNAPSHOT.jar)

echo "현재 구동 중인 애플리케이션 pid: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
        echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
        echo "> kill -15 $CURRENT_PID"
        kill -15 $CURRENT_PID
        sleep 5
fi

echo "> 새 애플리케이션 배포"

JAR_NAME=$(ls -tr $REPOSITORY/ | grep SNAPSHOT.jar | tail -n 1)

echo "> JAR Name : $JAR_NAME"
# 2.4버전 이후 추가적인 config location 지정은 spring.config.additional-location으로 해야 함
# optional은 설정파일이 있을 수도, 없을수도 있을 때 아래 설정에서 optional로 설정 하였지만, 안줘도 된다.
nohup java -jar $REPOSITORY/$JAR_NAME --spring.config.location=optional:classpath:/application.yml --spring.config.additional-location=optional:classpath:/application-real.yml,optional:file:/home/ec2-user/app/application-oauth.yml,optional:file:/home/ec2-user/app/application-real-db.yml --spring.profiles.active=real 2>&1 &