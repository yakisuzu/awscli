@echo off
pushd %~dp0

set SERVICE_NAME=awscli
set IMAGE_TAG=latest

set TMP_AWS_ACCESS_KEY=%~1
set TMP_AWS_SECRET_KEY=%~2
set TMP_AWS_REGION=%~3
set TMP_NO_CACHE=%~4

if "%TMP_AWS_ACCESS_KEY%" == "" (
    echo Require AWS_ACCESS_KEY_ID >&2
    popd & exit /b
)
if "%TMP_AWS_SECRET_KEY%" == "" (
    echo Require AWS_SECRET_ACCESS_KEY >&2
    popd & exit /b
)
if "%TMP_AWS_REGION%" == "" (
    echo Require AWS_DEFAULT_REGION >&2
    popd & exit /b
)
if "%TMP_NO_CACHE%" == "" (
    set TMP_NO_CACHE="false"
) else (
    set TMP_NO_CACHE="true"
)

echo.
echo [docker build start]
docker build --no-cache=%TMP_NO_CACHE% -t %SERVICE_NAME%:%IMAGE_TAG% .

echo.
echo [docker run start]
set MOUNT_HOST_DIR=%USERPROFILE%
set MOUNT_DOCKER_DIR=/mnt/hosthome
set TMP_MOUNT=%MOUNT_HOST_DIR%:%MOUNT_DOCKER_DIR%
echo run image=%SERVICE_NAME%:%IMAGE_TAG% mount=%TMP_MOUNT%

echo.
docker run --rm^
 -e AWS_ACCESS_KEY_ID=%TMP_AWS_ACCESS_KEY%^
 -e AWS_SECRET_ACCESS_KEY=%TMP_AWS_SECRET_KEY%^
 -e AWS_DEFAULT_REGION=%TMP_AWS_REGION%^
 -v %TMP_MOUNT%^
 -it %SERVICE_NAME%:%IMAGE_TAG%

popd & exit /b
