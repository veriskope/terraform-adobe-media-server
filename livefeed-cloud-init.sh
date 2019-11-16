#!/usr/bin/env bash
echo "add public keys to authorized_keys"

read -r -d '' public_keys <<'EOF'
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1Te88nbLhOWlvjPJ8Ig4ZnNcfBrCb6Q5OaKOEhvaJ/xNm6ZjqcAo4tF0UklTyLAFwAb08E9ibE2lyu7BEq307q8v7yyu6n/L8riJraEVltLre+ZWBRCCZkts/EhnFjiRxSJ+3rZXLxAGCDStHC6X1dlZu9d50KH/GDBXEBYMCsMUdWd57DFLHZALg0CpSlkNCijzdD1mxjRu9bh7HfXYE9421UzswfPyuPC5bUM1uctYhD4muDq4PHmw2VpCSHVRuSmDUeTVPpg/PI4YJ7zBxIdu32hB2CaG6VMRWDUX7dDR1tjtK3jDuC8OOhAB9Fl6nv7Grp9GPQzKfP5SsAIxv jgrevich
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDpJR60jRCwIWLylRj1NPweE9r6KB4W6Nvh2VSgpt64mJrNNBITpaN7EJt6TTHVJzVfGjdZdrc34mJEH9Jh8xzFH51IlIjcPoq4FgtU2D1fyWL8KL+TpmXefcHeQYGkJv5qBf1Glg8laEjgCZ+7j//Jqm9Brg2tKULkDVxy8S/kD7dfh4VWFa7mKfgAZfnEwSW0FYHB9bhTDUJQGR6sHcN057ACFxO1JZbB6be/OssgKrzhJGaVyFJuKUwKUqaeTzJkuRqO/SgCvQnzx+I6eKofjCgi9HI4OhsNjlURJOW93t2aHt7j6g5H1UZeeyMVt6RmsLg/+Jtws/aM2K9bJLMYB1BB0B5rl1Q5FZ5FNsC5CdbwcBxSnTWkjfw9YGjlrCtQy70sNJ+evxjfVAcKnDVlzqGU1z6eZiiNgFubrLAsPip0HRbqTUCDtiwoTvciy+Ik/ywQlsa0Z0rmnrVhK4c8/GLXJUtU6s5oJ3iBZcUY6jTMC18JdL+eQbcOE1AQXxp25D52mF89syXufh1ZoZWYLTx3Q27/ZQv1tXFFi5sGDEGPHKFkW55PBREu8go9LlX4+9UXAdGkXFnvW41Hao8in6BuHDnERPF3k9rHd/uF5KECBujZp9OAdGDg+nD5XZ6lGNNg7f1+4ihBAGweoS7pDoZFgRvXLPXcw36Ly+rEQ== sarah@ultrasaurus.com
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8qdfba7/NPCFXuACfepaBEoXZvIQZazrog4cU+75aYbAjbRzttERGFjokZLfb2xlzWIEoBRcMzkC0kPjgtGHtRIFx3kJmSNlzIyog9iE/ZP4u9Nb4W7G/JHxpVF2Swwun7HDmI6OD4cZKTyqw388ECqEOH/MY6bmFtXgzpvOxJ/XMOpvxxsLk/Wxihd2vY8IipP6iHcbBw4CqSrWXF3uWcSWmiPmLvRm9Ab67vCoar9SW3pKLiwU+u7hzS7W7RKXvY50iEw38C5P8qTO9n6Gn9zXv9KWtWP9gmriKWam1+yi/bI8WuBTFjUeWZ2mrV4QOwUj8Kgpi0wFYUen1HV9F cgrobb@github.com
EOF

echo "$public_keys" >> /home/ubuntu/.ssh/authorized_keys

echo "install docker"
export DEBIAN_FRONTEND=noninteractive
sudo snap install docker
sudo apt-get update
sudo apt-get install -y docker.io

echo "start and enable docker on restart"
sudo systemctl start docker
sudo systemctl enable docker

echo "add ubuntu user to docker group so docker can be used without sudo"
sudo usermod -aG docker ubuntu

echo "create a new shell with the ubuntu user and updated group"
sudo su - ubuntu

echo "clone dockerized AMS"
git clone https://github.com/veriskope/docker-adobe-media-server.git

echo "build AMS container"
cd docker-adobe-media-server
docker build --tag=ams .
echo "start container and map ports"
docker run -p 80:80 -p 443:443 -p 1111:1111 -p 1935:1935 --name ams -d ams

echo "docker install and setup is done"
