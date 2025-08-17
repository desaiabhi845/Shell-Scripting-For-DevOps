#!/bin/bash

<< task
Deploy a Django app
and handle the code for errors
task

code_clone() {
	echo "Cloning the Django app..."
	git clone https://github.com/desaiabhi845/django-notes-app.git

}

install_requirements() {
	echo "Installing dependencies"
	sudo apt-get install docker.io nginx -y
}

required_restart() {
	sudo chown $USER ///var/run/docker.sock
	sudo systemctl enable docker
	sudo systemctl enable nginx
	sudo systemctl restart docker
}

deploy() {
	docker build -t notes-app .
	#docker run -d -p 8000:8000 notes-app:latest
	docker -compose up -d
}

echo "*********** DEPLOYMENT STARTED ************"

if ! code_clone; then
	echo "the code directory already exists"
	cd django-notes-app
fi

if ! install_requirements; then
	echo "Installation failed"
	exit 1
fi	

if ! required_restart; then
	echo "System fault identified"
	exit 1
fi

if ! deploy; then
	echo "deployment failed, mailing to admin"
	exit 1
        #sendmail
fi

echo "*********** DEPLOYMENT DONE ************"
