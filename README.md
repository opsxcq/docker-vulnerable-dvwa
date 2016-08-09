# Damn Vulnerable Web Application Docker container

Just a DVWA container for docker

## Build

docker build -t dvwa .

## Run

docker run -d -p 80:80 -p 3306:3306 dvwa
