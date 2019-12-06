#!/usr/bin/env bash

echo "add public keys to authorized_keys"

read -r -d '' public_keys <<'EOF'
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1Te88nbLhOWlvjPJ8Ig4ZnNcfBrCb6Q5OaKOEhvaJ/xNm6ZjqcAo4tF0UklTyLAFwAb08E9ibE2lyu7BEq307q8v7yyu6n/L8riJraEVltLre+ZWBRCCZkts/EhnFjiRxSJ+3rZXLxAGCDStHC6X1dlZu9d50KH/GDBXEBYMCsMUdWd57DFLHZALg0CpSlkNCijzdD1mxjRu9bh7HfXYE9421UzswfPyuPC5bUM1uctYhD4muDq4PHmw2VpCSHVRuSmDUeTVPpg/PI4YJ7zBxIdu32hB2CaG6VMRWDUX7dDR1tjtK3jDuC8OOhAB9Fl6nv7Grp9GPQzKfP5SsAIxv jgrevich
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDpJR60jRCwIWLylRj1NPweE9r6KB4W6Nvh2VSgpt64mJrNNBITpaN7EJt6TTHVJzVfGjdZdrc34mJEH9Jh8xzFH51IlIjcPoq4FgtU2D1fyWL8KL+TpmXefcHeQYGkJv5qBf1Glg8laEjgCZ+7j//Jqm9Brg2tKULkDVxy8S/kD7dfh4VWFa7mKfgAZfnEwSW0FYHB9bhTDUJQGR6sHcN057ACFxO1JZbB6be/OssgKrzhJGaVyFJuKUwKUqaeTzJkuRqO/SgCvQnzx+I6eKofjCgi9HI4OhsNjlURJOW93t2aHt7j6g5H1UZeeyMVt6RmsLg/+Jtws/aM2K9bJLMYB1BB0B5rl1Q5FZ5FNsC5CdbwcBxSnTWkjfw9YGjlrCtQy70sNJ+evxjfVAcKnDVlzqGU1z6eZiiNgFubrLAsPip0HRbqTUCDtiwoTvciy+Ik/ywQlsa0Z0rmnrVhK4c8/GLXJUtU6s5oJ3iBZcUY6jTMC18JdL+eQbcOE1AQXxp25D52mF89syXufh1ZoZWYLTx3Q27/ZQv1tXFFi5sGDEGPHKFkW55PBREu8go9LlX4+9UXAdGkXFnvW41Hao8in6BuHDnERPF3k9rHd/uF5KECBujZp9OAdGDg+nD5XZ6lGNNg7f1+4ihBAGweoS7pDoZFgRvXLPXcw36Ly+rEQ== sarah@ultrasaurus.com
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHyPlkPUmFpI3491GS2o/LN8HSLhcKh0YjE89NHmWaWrNJYGAWW3g7r8dpfTjqQ9695exPEfs2vAgMm9UyLLGt+jGmajfdlYRUo9xtX5BCB0r0S9BqYO6EkE3/xTs794bTKwe7OK465Tv0AY4N7KLfbaSw11iAhOygHzbaYfqTZiKHrxmIirYUzJ9JqQvh1HUsGAUyvvRDDXkpGevoiUaDoDnbgjYBYAB/Mel5ywVZ5IjhPT1VVWT+54TjM58d7TCFXeytjSzcIvYkVYnRW4nZKkBTokqiPofvkoVPDIAHsU0ZUIncthpeS80cbQJwvJflvlZpRxuWrsJqdYTIQZOwPC65mSgJ+I3S8FcUkIwt9iNUJQPtYC53n6hz3Z9K3XO4s+0CEk87aF8N0aaUwBLXr9LSVwr1sxpXSBdh0KpsXCbBCV+mnvjBtM1TeSgXZU5jwhOPvFJJZCe7wHch2j8iBp0jT9mpDedalllPdTdar3ELEGSkRgjyffK5yLDvrcMQzf9AAp9DKtRAQBzeB6oM2QNiw3m1OyLQcAr911kpB0cDEQaBivazM+I3a3hTN5FT2HOK4XGb4A4kiJfJA/GBVR/glwHaPVNapwB1fPlazNGOw0I3gfQYzJ0GlYXKOnsSmQw0KC79zXt8mH/uDSqy5R3xHk3PiiRouet56FlgIw== cgrobb@github.com
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEOIHNbCLXcbP9dNpJrpLBsfjboto1n8MgdBN7KknLdAXvx1ylzgzQyTJ/KRwmhHHXEWwbTJm09zpOeFiDHOYFmbL7OoFPn/gC40rewDbXMjuCKkNNITQLWjJRyi1jkuHu/bII9LB1qghD1VtmvSi1uqT2Sa/E3R8489VOEMgW+WhQER9tyfbKbN5+iJViu6ehcU12xjVC4mOyfFyNphdWHZKLLNCiZIM0HjW3jfofVFuJDrqby9yDNOUgmA91wuSr9wyBeAVKtj4qBSF2Lk80pNvqJbFwJ9TMz8XhLxX1IG9tGZe+WdeVkpVU0g5hGAP5nOKbvRSI8wzAfXM9jMvd9M7zDPzXx8zByUFW2DERokZlqa4KnhQLjs++pudloognbczFyWyst/ZvcGswJO5VoDwKRAWIKN+P4DOOlW2icJ1WM/ni6r78mlQldTeeKTbeYVP2ks8no6mrxuQy04UBj0l03DKgm0tXlBf+hcsfGUA8Dv88HkhJNzyNfa8nMSu7M2REs9EVrKm73EarI5lBdMtyhifW6ss8Fi6ddlvp373panarsohofiHcDMbTrtBfo8VLhYeQ63Jzkm1/+m3SPfww/MO5yeWq3z/ViNcHCHZ2KyFLt2ud1buQNbyi5wMOV4UpcQ9rBER3vV6i1W2AifgmSFs4YqnI7MVZmSBJ1w== sean.bryant@veriskope.com
EOF

echo "$public_keys" >> /home/ubuntu/.ssh/authorized_keys

echo "install docker"
export DEBIAN_FRONTEND=noninteractive
sudo snap install -y docker
sudo apt update
sudo apt install -y docker.io 

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
