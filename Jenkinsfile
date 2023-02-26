pipeline {
  //agent any
  //kubectl -n default create deploy node-app --image siddharth67/node-service:v1 
  //kubectl -n default expose deploy node-app --name node-service --port 5000
   agent{
      label "kubeadm-master"
       }

    options {
      buildDiscarder logRotator(
        artifactDaysToKeepStr: '1',
        artifactNumToKeepStr: '2',
        daysToKeepStr: '1',
        numToKeepStr: '2')
      timestamps()
     }

  tools{
      maven 'demo-maven:3.8.6'
      }
   
   environment {
    deploymentName = "demo-pod"
    containerName = "demo-con"
    serviceName = "demo-svc"
    imageName = "eagunuworld/numeric-app:${GIT_COMMIT}"
    applicationURL = "34.174.241.37"  
    applicationURI = "increment/100"
  }

  stages {

    //  stage('StaticAnalysis Codes Trivy Vulnerability') {
    //   steps {
    //     parallel(
    //           "SonarQube,Docker And Trivy": {
    //             sh "mvn clean package sonar:sonar \
    //             -Dsonar.projectKey=eagunu-number \
    //             -Dsonar.host.url=http://10.182.0.4:9000 \
    //            -Dsonar.login=sqp_b920c762c89da87913cee2831bb77addc36c73b6"
    //          },
    //          "ScanningDockerImage": {
    //         sh "bash trivy-docker-image-scan.sh"
    //       },
    //       "scm codes": {
    //         sh "ls -lart"
    //       }
    //     )
    //   }
    // }

    stage('Build Artifact - Maven') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archiveArtifacts 'target/*.jar'
      }
    }

  //   stage('Unit Tests - JUnit and JaCoCo') {
  //     steps {
  //       sh "mvn test"
  //     }
  //     post {
  //       always {
  //         junit 'target/surefire-reports/*.xml'
  //         jacoco execPattern: 'target/jacoco.exec'
  //       }
  //     }
  //   }

  //  stage('Mutation Tests') {
  //     steps {
  //        sh "mvn org.pitest:pitest-maven:mutationCoverage"
  //        }
  //     post {
  //       always {
  //         pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
  //       }
  //     }
  //   } 
   
  //  stage('Mutation Tests - PIT') {      NO      //(Pit mutation) is a plugin in jenkis and plugin was added in pom.xml line 68
  //     steps {
  //        parallel(
  //              "Mutation Test PIT": {
  //                   sh "mvn org.pitest:pitest-maven:mutationCoverage"  //section 3 video 
  //                 },
  //                 "Dependency Check": {
  //                     sh "mvn dependency-check:check"    //OWASP Dependency check plugin is required via jenkins
  //                 },
  //                "OPA Conftest": {
  //                 sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security.rego Dockerfile'
  //              }
  //            )
  //        }
  //     }
    
    // stage('VulnerabilityScan - Docker ') {
    //   steps {
    //     sh "mvn dependency-check:check"
    //   }
    //   post {
    //     always {
    //       dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
    //     }
    //   }
    // }

     // stage('Vulnerability Scan NO - Kubernetes') {
    //   steps {
    //     sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-k8s-security.rego k8s_deployment_service.yaml'
    //   }
    // }

    stage('Docker Image And Trivy') {
           steps {
             parallel(
                  "Docker Build and Push": {
                       withDockerRegistry([credentialsId: "eagunuworld_dockerhub_creds_username-pwd", url: ""]) {
                        sh 'printenv'
                       sh 'docker build -t eagunuworld/numeric-app:""$GIT_COMMIT"" .'
                      sh 'docker push eagunuworld/numeric-app:""$GIT_COMMIT""'
                    }
                 },
                 "Remove Trivy": {
                sh "sudo rm -rf trivy"
              }
             )
           }
         }

    stage('Vulnerability Scan - Kubernetes') {
      steps {
        parallel(
          "OPA Scan": {
            sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-k8s-security.rego k8s_deployment_service.yaml'
          },
          "Kubesec Scan": {
            sh "bash kubesec-scan.sh"
          },
          "TrivyScanningArtifacts": {
            sh "bash trivy-k8s-scan.sh"
          }
        )
      }
    }

    stage('Remove All Images Before Deployment') {
           steps{
                  sh 'docker rmi  $(docker images -q)'
            }
          }

    stage('mpm Deployment') {       //section 3 records 68
           steps {
             parallel(
               "Deployment": {
                    sh "ls -lart"
                   sh "bash k8s-deployment.sh"
                 },
               "Rollout Status": {
                   sh "bash k8s-deployment-rollout-status.sh"
                 }
             )
           }
         }

    //  stage('Integration Tests - mpm') {
    //   steps {
    //     script {
    //       try {
    //           sh "bash integration-test.sh"
    //       } catch (exc) {
    //           sh "kubectl -n default rollout undo deploy ${deploymentName}"
    //         }
    //       }
    //     }
    //   }

  stage('Prompte to PROD?') {
      steps {
          timeout(time: 2, unit: 'DAYS') {
           input 'Kindly Review And Approve Deployment To QA NameSpace'
         }
       }
      }


    // stage('OWASP ZAP - DAST') {
    //   steps {
    //       sh 'bash zap.sh'
    //     }
    //    }
    //   }
    // post {
    // always {
    //   junit 'target/surefire-reports/*.xml'
    //   jacoco execPattern: 'target/jacoco.exec'
    //   publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'owasp-zap-report', reportFiles: 'zap_report.html', reportName: 'OWASP ZAP Report', reportTitles: 'OWASP ZAP Report', useWrapperFileDirectly: true])
    //   //pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
    //   //dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
    // }

    // success {

    // }

    // failure {

    // }
  }
}




