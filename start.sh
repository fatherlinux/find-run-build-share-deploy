#!/usr/bin/env sh

# Author: Scott McCarty <scott.mccarty@gmail.com>
# Twitter: @fatherlinux
# Date: 10/16/2019
# Description: Demonstrate the process of finding, running, building, sharing, and deploying containers with freely 
# distributable tools like Podman and Red Hat Universal Base Image.
 
# Setting up some colors for helping read the demo output.
# Comment out any of the below to turn off that color.
bold=$(tput bold)
cyan=$(tput setaf 6)
reset=$(tput sgr0)

read_color() {
    read -p "${bold}$1${reset}"
}

echo_color() {
    echo "${cyan}$1${reset}"
}

setup() {
	echo_color "Setting up"
}

intro() {
    read -p "Finding, running, building, sharing, and deploying containers with freely distributable tools like Podman and Red Hat Universal Base Image"
    echo
}

find_containers() {
	echo
	echo_color "A good artist is a good thief, so let's see if we can find a good container base image"
	echo
	read_color "podman search registry.access.redhat.com/ubi8"
	podman search registry.access.redhat.com/ubi8

	echo
	echo_color "So, podman found these, but how do we know they are any good?"
	echo
	read_color "Go look at http://access.redhat.com/containers"
}

run_containers() {
	echo
	echo_color "OK, so we trust these container images. Let's run one"
	echo
	read_color "podman run -it ubi8 bash"
	podman run -it ubi8 bash
}

build_containers() {
	echo
	echo_color "Trusted base images are great, but you can't do much with a base image. You need to add value"
	echo_color "So, let's install some packages"
	echo
	read_color "podman build -t quay.io/fatherlinux/ubi8-sharing -f Dockerfile"
	podman build -t quay.io/fatherlinux/ubi8-sharing -f Dockerfile

	echo
	echo_color "Let's verify that the image is built and saved locally"
	echo
	read_color "podman images"
	podman images

}

share_containers() {
	echo
	echo_color "Now, let's push the image out to quay.io"
	echo
	read_color "podman push quay.io/fatherlinux/ubi8-sharing"
	podman push quay.io/fatherlinux/ubi8-sharing
}

deploy_containers() {

	# Simple Use Case
	echo
	read_color "Once we have shared some container images, how do we deploy them in production?"
	read_color "There are often scalibility, and high availability requirements right?"
	read_color "We need to get to an enterpise Kubernetes platform like OpenShift"
	read_color "But, how do we get from Podman to Kubernetes?"
	read_color "Easy, with a feature called 'podman generate kube'"

	echo
	echo_color "First, lets run a container with podman"
	echo
	read_color "podman run -id quay.io/fatherlinux/ubi8-sharing bash"
	podman run --name tron -id quay.io/fatherlinux/ubi8-sharing bash

	echo
	echo_color "Verify that the new container is running"
	echo
	read_color "podman ps"
	podman ps

	echo
	echo_color "Now, generate some Kubernetes yaml from the running container"
	echo
	read_color "podman generate kube tron > tron.yaml"
	podman generate kube tron > tron.yaml

	echo
	echo_color "Inspect the yaml created. This can be used by Kubernetes"
	echo
	read_color "vim tron.yaml"
	vim tron.yaml

	echo
	echo_color "Now, run this inside of a miniature OpenShift instance called CodeReady Containers. Connect to CRC and create a new project"
	echo
	read_color "oc new-project tron"
	oc new-project tron

	echo
	echo_color "Ensure the project was created"
	echo
	read_color "oc get projects"
	oc get projects

	echo
	echo_color "Use the pod definition created by podman with Kubernetes"
	echo
	read_color "oc create -f tron.yaml"
	oc create -f tron.yaml

	echo
	echo_color "Now, verify that it's being created"
	echo
	read_color "oc get pods -w"
	oc get pods -w
	read_color "oc describe pod tron"
	oc describe pod tron
	read_color "oc get pods"
	oc get pods

	echo
	read_color "Now, let's try a more advanced use case"

	# Advanced Use Case
	echo
	echo_color "Let's use podman to create a pod. A Recognizer is a large, hovering vehicle with a central cockpit which are used on the grid"
	echo
	read_color "podman pod create --publish 8080:80 -n recognizer"
	podman pod create --publish 8080:80 -n recognizer

	echo
	echo_color "Now, let's add Flynn to the Recognizer so that he can track down the stolen video game code"
	echo
	read_color "podman run -id --pod recognizer --name flynn ubi8"
	podman run -id --pod recognizer --name flynn ubi8

	echo
	echo_color "Now, let's add Bit to the Recognizer so that he's not alone"
	echo
	read_color "podman run -id --pod recognizer --name bit ubi8"
	podman run -id --pod recognizer --name bit ubi8

	echo
	echo_color "Now let's make sure the recognizer exists"
	echo
	read_color "podman pod list --ns --ctr-names"
	podman pod list --ns --ctr-names

	echo
	echo_color "Make sure Flynna and Bit are in the Recognizer pod"
	echo
	read_color "podman pod inspect recognizer"
	podman pod inspect recognizer
	read_color "podman ps"
	podman ps

	echo
	echo_color "Generate kubernetes yaml"
	echo
	read_color "podman generate kube -s recognizer > recognizer.yaml"
	podman generate kube -s recognizer > recognizer.yaml

	echo
	echo_color "Inspect the yaml created. Notice that it's more advanced."
	echo
	read_color "vim recognizer.yaml"
	vim recognizer.yaml

	echo
	echo_color "Create a new OpenShift project in CRC"
	echo
	read_color "oc new-project tron-legacy"
	oc new-project tron-legacy
	read_color "oc get projects"
	oc get projects

	echo
	echo_color "Use the pod definition created by podman with Kubernetes"
	echo
	read_color "oc create -f recognizer.yaml"
	oc create -f recognizer.yaml

	echo
	echo_color "Now, verify that it's being created"
	echo
	read_color "oc get pods -w"
	oc get pods -w
	read_color "oc describe pod recognizer"
	oc describe pod recognizer
	read_color "oc get pods"
	oc get pods
	read_color "oc get svc"
	oc get svc
}

pause() {
    echo
    read -p "Enter to continue"
    clear
}

clean_images_and_containers() {

	echo
	read_color "podman kill -a"
	podman kill -a
	echo
	read_color "podman rm -a"
	podman rm -a
	echo
	read_color "Now, let's clean up the containers and pods"
	echo
	read_color "podman pod kill -a"
	podman pod kill -a
	echo
	read_color "podman pod rm -a"
	podman pod rm -a
	echo
	read_color "oc delete project tron"
	oc delete project tron
	echo
	read_color "oc delete project tron-legacy"
	oc delete project tron-legacy
}

setup
intro
find_containers
run_containers
build_containers
share_containers
deploy_containers
clean_images_and_containers

echo
read -p "End of Demo!!!"
echo
echo "Thank you!"

