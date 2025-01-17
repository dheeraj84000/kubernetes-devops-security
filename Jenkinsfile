pipeline {
  agent any
environment {
  imageName= "dheeraj84000/numeric-app"
  deploymentFileName= "k8s_deployment_service.yaml"
}
  
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

    stage('sonarqube integration'){

      steps{
      withSonarQubeEnv('SonarQube'){
        sh "mvn clean verify sonar:sonar -Dsonar.projectKey=devsecops-application -Dsonar.projectName='devsecops-application' -Dsonar.host.url=http://localhost:9000 -Dsonar.token=sqp_105d4174c70aaa432d8eeb74ca718da1d20d4242"
       }
      //   timeout(time: 4, unit: 'MINUTES'){

      //   script{
      //           waitForQualityGate abortPipeline: true
          
      //   }
      // }
      
      }
      
      
    }

        stage("Quality Gate") {
            steps {
                //timeout(time: 1, unit: 'MINUTES') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
               // }
            }
        }

    //    stage("OWASP Dependency Check Running..."){

    //      steps{
    //           sh "mvn dependency-check:check"
           
    //      }
    //      post {
    //              always {
    //                dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
    //              }
           
    //      }

         
    //    }

    // stage("trivy base image check..."){

    //   steps{
         
    //     sh "sudo bash Trivy.sh"
    //   }
      
    // }

    stage("OWASP Dependency and trivy base image check..."){

      steps{
             parallel(
               "OWASP Dependency Running...": {
                sh "mvn dependency-check:check" 
               },

               "trivy base image Scan...": {
                 sh "sudo bash Trivy.sh"
                 
               }
            
               
             )
        }
      post {
                  always {
                    dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
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
    stage("kubernetes deployment") {
      steps{
          withKubeConfig([credentialsId: 'kubeconfig']) {
      sh 'sed -i s#replace#"${imageName}:${GIT_COMMIT}"#g ${deploymentFileName}' 
      sh 'kubectl apply -f ${deploymentFileName}'
    }
        
      }
      
    }
    }
}
