pipeline {
  //agent any
  //kubectl -n default create deploy node-app --image siddharth67/node-service:v1
  //kubectl -n default expose deploy node-app --name node-service --port 5000
   agent{
      label "node01"
       }

       options {
         buildDiscarder logRotator( artifactDaysToKeepStr: '1', artifactNumToKeepStr: '1', daysToKeepStr: '1', numToKeepStr: '1')
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
            imageName = 'eagunuworld/numeric-app:${GIT_COMMIT}'
            REGISTRY_CREDENTIAL = 'eagunuworld_dockerhub_creds'
          }

  //  environment {
  //   deploymentName = "demo-pod"
  //   containerName = "demo-con"
  //   serviceName = "demo-svc"
  //   imageName = "eagunuworld/numeric-app:${GIT_COMMIT}"
  //   applicationURL = "34.174.241.37"
  //   applicationURI = "increment/100"
  // }

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
                   "unkown": {
                    sh "ls -lart"
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

stage('KubernetesVulnerability Scanning') {  
      steps {
         parallel(
               "Docker Images": {
                    sh "docker images" 
                  },
                  "ScanningDeploymentFile": {
                    sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-k8s-security.rego deployment-svc.yaml'
                   },
                   "printingEnv": {
                    sh "printenv "
                   },
                 "kubesec Scannning": {
                  sh 'bash kubesec-scan.sh'
                }
             )
         }
      }

    stage('KubernetesDeployment') {
      steps {
          sh "sed -i 's#replace#${REGISTRY}:${VERSION}#g' deployment-svc.yaml"
          sh "cat deployment-svc.yaml"
          sh "kubectl apply -f deployment-svc.yaml"
       }
     }

   stage('Remove images from Agent Server') {
        steps{
            script {
                  sh 'docker rmi  $(docker images -q)'
                  }
                }
            }
    }
  post {
        always {
        // junit 'target/surefire-reports/*.xml'
        // jacoco execPattern: 'target/jacoco.exec'
        pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
        dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
        // publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'owasp-zap-report', reportFiles: 'zap_report.html', reportName: 'OWASP ZAP HTML Report', reportTitles: 'OWASP ZAP HTML Report'])
       }
  }
}
