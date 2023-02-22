#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh

REPOSITORY=/home/ec2-user/app/step3
PROJECT_NAME=springboot2-webservice

echo "> Build 파일 복사"
echo "> cp $REPOSITORY/zip/*SNAPSHOT.jar $REPOSITORY/"

cp $REPOSITORY/zip/*SNAPSHOT.jar $REPOSITORY/

echo "> 새 어플리케이션 배포"
JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> $JAR_NAME 에 실행권한 추가"

chmod +x $JAR_NAME

echo "> $JAR_NAME 실행"

IDLE_PROFILE=$(find_idle_profile)

echo "> $JAR_NAME 를 profile=$IDLE_PROFILE 로 실행합니다."


# 2.4버전 이후 추가적인 config location 지정은 spring.config.additional-location으로 해야 함
# optional은 설정파일이 있을 수도, 없을수도 있을 때 아래 설정에서 optional로 설정 하였지만, 안줘도 된다.
nohup java -jar $JAR_NAME > $REPOSITORY/nohup.out --spring.config.location=optional:classpath:/application.yml --spring.config.additional-location=optional:classpath:/application-$IDLE_PROFILE.yml,optional:file:/home/ec2-user/app/application-oauth.yml,optional:file:/home/ec2-user/app/application-real-db.yml --spring.profiles.active=$IDLE_PROFILE 2>&1 &