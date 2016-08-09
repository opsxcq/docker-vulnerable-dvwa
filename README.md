# Damn Vulnerable Web Application Docker container

Just a DVWA container for docker

## Build

docker build -t dvwa:1.9 .

## Run

docker run -d -p 80:80 -p 3306:3306 dvwa:1.9
