🧩 PART 1 – QUESTION 1 (MANUAL / ON-DEMAND PIPELINE)
🔹 STEP 1: Create Maven Spring Boot Project

Go to 👉 https://start.spring.io/

Choose:

Project: Maven

Language: Java

Spring Boot: latest

Artifact: my_maven_app

Packaging: Jar

Java: 21

Dependencies: Spring Web

Click Generate → ZIP downloaded

🔹 STEP 2: Extract & Add Controller
unzip my_maven_app.zip
cd my_maven_app


Create controller:

nano src/main/java/com/example/my_maven_app/HomeController.java


Paste 👇

package com.example.my_maven_app;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {

    @GetMapping("/")
    public String home() {
        return "Hello from Maven + Docker + Swarm!";
    }
}


Save → CTRL + O, ENTER, CTRL + X

🔹 STEP 3: Test Maven Build
mvn clean package -DskipTests


✔ JAR created in target/

🔹 STEP 4: Create Dockerfile
nano Dockerfile


Paste 👇

FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
CMD ["java","-jar","app.jar"]

🔹 STEP 5: Test Docker Locally
docker build -t my_maven_app .
docker run -p 10000:8080 my_maven_app


Open browser:

http://localhost:10000


✔ Output seen → SUCCESS

Stop container: CTRL + C

🔹 STEP 6: Push Code to GitHub
Initialize Git
git init
git branch -m main
git add .
git commit -m "Initial Maven App"

Create GitHub Repo

Repo name: my_maven_app

Copy SSH URL

git remote add origin git@github.com:USERNAME/my_maven_app.git
git push origin main

🔹 STEP 7: Docker Hub Setup

Create Docker Hub account

Create repo: my_maven_app

🔹 STEP 8: Add Docker Hub Credentials in Jenkins

Jenkins →
Manage Jenkins → Credentials → Global → Add Credentials

Kind: Username & Password

ID: dockerhub

Username: DockerHub username

Password: DockerHub password

🔹 STEP 9: Jenkins GitHub SSH Access
sudo su - jenkins
ssh-keygen -t ed25519
cat ~/.ssh/id_ed25519.pub


👉 Add key to GitHub → SSH Keys

ssh-keyscan github.com >> ~/.ssh/known_hosts
ssh -T git@github.com
exit

🔹 STEP 10: Create Jenkinsfile
nano jenkinsfile


Paste 👇

pipeline {
    agent any

    environment {
        IMAGE_NAME = "dockerhubusername/my_maven_app"
        DOCKERHUB = credentials('dockerhub')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'git@github.com:USERNAME/my_maven_app.git'
            }
        }

        stage('Build Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Docker Push') {
            steps {
                sh 'docker login -u $DOCKERHUB_USR -p $DOCKERHUB_PSW'
                sh 'docker push $IMAGE_NAME:latest'
            }
        }

        stage('Deploy to Docker Swarm') {
            steps {
                sh '''
                docker service rm my_app || true
                docker service create --name my_app -p 8081:8080 $IMAGE_NAME:latest
                '''
            }
        }
    }
}


Commit & push:

git add .
git commit -m "Added Jenkinsfile"
git push origin main

🔹 STEP 11: Create Jenkins Pipeline Job

Jenkins → New Item → Pipeline

Pipeline from SCM

SCM: Git

Repo URL: SSH URL

Script Path: jenkinsfile

Click Build Now ✅

🎉 QUESTION 1 DONE

🧩 PART 2 – QUESTION 2 (CRON-BASED AUTOMATED)

⚠️ ONLY CHANGE IS TRIGGER

🔹 STEP 12: Enable Cron Trigger in Jenkins

Open Pipeline Job → Configure → Build Triggers

✔ Check Build periodically

Add:

H/5 * * * *


Save.

🔹 RESULT

Pipeline runs every 5 minutes

Fully automated

No “Build Now”

🎉 QUESTION 2 DONE
