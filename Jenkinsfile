@Library('mss-sharedlibrary') _
pipeline {
  //agent any
  // kubectl -n north-mpm create deploy node-app --image siddharth67/node-service:v1
  // kubectl -n north-mpm expose deploy node-app --name node-service --port 5000
   agent{
      label "numericAgent"
       }

       options {
         buildDiscarder logRotator( artifactDaysToKeepStr: '1', artifactNumToKeepStr: '2', daysToKeepStr: '1', numToKeepStr: '2')
         timestamps()
        }

     parameters {
          choice choices: ['main', 'owasp_zap_scanning', 'lab_mutation_Test', 'walmart-dev-mss', 'dependencyCheckTrivyOpenContest'], description: 'This is choice paramerized job', name: 'BranchName'
          string defaultValue: 'Eghosa DevOps', description: 'please developer select the person\' name', name: 'personName'
        }

  tools{
      maven 'demo-maven:3.8.6'
      }

   environment {
            DEPLOY = "${env.BRANCH_NAME == "python-dramed" || env.BRANCH_NAME == "master" ? "true" : "false"}"
            NAME = "${env.BRANCH_NAME == "python-dramed" ? "example" : "example-staging"}"
            //def mavenHome =  tool name: "maven:3.6.3", type: "maven"
            //def mavenCMD = "${mavenHome}/usr/share/maven"
            VERSION = "${env.BUILD_ID}"
            REGISTRY = 'eagunuworld/numeric-app'
            imageName = "eagunuworld/numeric-app:${BUILD_ID}"
            REGISTRY_CREDENTIAL = 'eagunuworld_dockerhub_creds'
            northDeploy = "numeric-pod"
            westdDeploy = "west-prod-pod"
            westCon = "west-prod-con"
            conName = "numeric-con"
            svcName = "numeric-svc"
            svcPort = "30005"
            svcName = "west-prod-svc"
            jenkinsURL = "http://34.125.127.99"
            serverURL = "34.174.30.70"
            appURI = "increment/99"
          }

  stages {
    stage('Build Artifact - Maven') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archiveArtifacts 'target/*.jar'
      }
    }

   stage('CodeDockerVulnerability Scanning') {    //(Pit mutation) is a plugin in jenkis and plugin was added in pom.xml line 68
      steps {
         parallel(
               "Mutation Test PIT": {
                    sh "mvn org.pitest:pitest-maven:mutationCoverage"  //section 3 video
                  },
                  "Dependency Check": {
                      sh "mvn dependency-check:check"    //OWASP Dependency check plugin is required via jenkins
                   },
                   "TrivyImage": {
                    sh "sudo rm -rf trivy"
                   },
                 "OPA Conftest": {
                  sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security.rego Dockerfile'
                }
             )
         }
       }

   stage('Push Docker Image To DockerHub') {
        steps {
            withCredentials([string(credentialsId: 'eagunuworld_dockerhub_creds', variable: 'eagunuworld_dockerhub_creds')])  {
              sh "docker login -u eagunuworld -p ${eagunuworld_dockerhub_creds} "
              sh 'docker build -t ${REGISTRY}:${VERSION} .'
                }
                 sh 'docker push ${REGISTRY}:${VERSION}'
              }
          }

// stage('KubernetesVulnerability Scanning') {  
//       steps {
//          parallel(
//                "ScanningImage": {
//                     sh "bash trivy-k8s-scan.sh" 
//                   },
//                   "ScanningDeploymentFile": {
//                     sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-k8s-security.rego west-prod-deploy.yml'
//                    },
//                    "printingEnv": {
//                     sh "printenv "
//                    },
//                  "kubesec Scannning": {
//                   sh 'bash kubesec-scan.sh'
//                 }
//              )
//          }
//       }

    stage('K8S CIS Benchmark') {
      steps {
        script {
          parallel(
            "Master": {
              sh "bash cis-benchmark-master.sh"
            },
            "Etcd": {
              sh "bash cis-benchmark-etcd.sh"
            },
            "Kubelet": {
              sh "bash cis-benchMark-kubelet.sh"
            },
            "north-mpm ns": {
              sh "kubectl apply -f north-mpm-ns.yml"
            },
            "west-prod ns": {
              sh "kubectl apply -f west-prod-ns.yml"
            }
          )
        }
      }
    }


  stage('Dev-mpm-deploy') {
      steps {
        parallel(
          "Deployment": {
              sh "sed -i 's#replace#${REGISTRY}:${VERSION}#g' north-mpm-pod.yaml"
              sh "kubectl -n north-mpm apply -f north-mpm-pod.yaml"
            },
          "Rollout North Status": {
            sh "bash north-mpm-rollout.sh"
          },
          "create north-mpm svc": {
            sh "kubectl -n north-mpm apply -f north-mpm-svc.yml"
          }
        )
      }
    }

 stage('Kindly Review And Approve West-Prod?') {
      steps {
        timeout(time: 2, unit: 'DAYS') {
          input 'Do you want to Approve the Deployment to West Production Environment/Namespace?'
        }
      }
    }

 stage('west-prod') {
      steps {
        parallel(
          "west-prod Deploy": {
              sh "sed -i 's#replace#${REGISTRY}:${VERSION}#g' west-prod-pod.yml"
              sh "kubectl -n west-prod apply -f west-prod-pod.yml"
            },
          "create west-prod svc": {
              sh "kubectl -n west-prod apply -f west-prod-svc.yml"
          },
          "Rollout West Status": {
            sh "bash west-prod-rollout.sh"
          }
        )
      }
    }
  // stage('Integration Tests - DEV') {
  //     steps {
  //       script {
  //         try {
  //             sh "bash integration-test.sh"
  //           } catch (e) {
  //             sh "kubectl -n default rollout undo deploy ${deploymentName}"
  //           }
  //           throw e
  //       }
  //     }
  //   }
 
  // stage('OWASP ZAP - DAST') {
  //     steps {
  //         sh 'bash zap.sh'
  //       }
  //     }

  //  stage('RemoveResources') {  
  //     steps {
  //        parallel(
  //              "KillProcesses": {
  //                   sh "docker ps -aq | xargs docker rm -f" 
  //                 },
  //                "RemoveDockerImages": {
  //                 sh 'docker rmi  $(docker images -q)'
  //               }
  //            )
  //        }
  //     }

    }
  post {
        always {
        // junit 'target/surefire-reports/*.xml'
        // jacoco execPattern: 'target/jacoco.exec'
        pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
        dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
        // publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'owasp-zap-report', reportFiles: 'zap_report.html', reportName: 'OWASP ZAP HTML Report', reportTitles: 'OWASP ZAP HTML Report'])
        // Use sendNotifications.groovy from shared library and provide current build result as parameter   
        //slacksharedlibrary currentBuild.result 
       //sendNotification currentBuild.result
       }
      success {
      script {
        /* Use slackNotifier.groovy from shared library and provide current build result as parameter */  
        env.failedStage = "none"
        env.emoji = ":white_check_mark: :tada: :thumbsup_all:"
        slackcodenotifications currentBuild.result
      }
    }
  }
}
