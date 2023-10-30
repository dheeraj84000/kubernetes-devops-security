pipeline {
  agent any
tools {

maven '3.9.5'
  
}
  stages {
      stage('Build Artifact') {
            steps {
              //sh "mvn --version"
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' //so that they can be downloaded later
            }
        }  
     stage('unit testing') {
       steps{
           sh  'mvn test'
         
       }
       post {

           always {

             junit 'target/surefire-reports/*.xml'
             jacoco execPattern: 'target/jacoco.exec'
             
           }
         
       }

       
     }
    stage('docker image build') {
      steps{

           withDockerRegistry(credentialsId: 'docker-hub-cred', url: "") {
            sh "printenv"
            sh 'sudo docker build . -t dheeraj84000/numeric-app:"$GIT_COMMIT"'
            sh 'sudo docker push dheeraj84000/numeric-app:"$GIT_COMMIT" '
        }
        
      }
    }
    }
}
