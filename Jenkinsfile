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

       
     }
    }
}
