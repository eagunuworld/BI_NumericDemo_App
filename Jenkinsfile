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
          choice choices: ['main', 'lab_mutation_Test', 'walmart-dev-mss'], description: 'This is choice paramerized job', name: 'BranchName'
          string defaultValue: 'Eghosa DevOps', description: 'please developer select the person\' name', name: 'personName'
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
      stage('StaticAnalysis') {   //without qg set 
       steps {
         parallel(
               "StaticCodesAnalysis": {
                 sh "mvn clean package sonar:sonar -Dsonar.projectKey=eagunu-number -Dsonar.host.url=http://34.174.248.94:9000 -Dsonar.login=sqp_c13dc0b55ee2d6771fcc1167db2d866ddc7c1b26"
              },
              "No Tasks": {
             sh "ls -lart"
            },
           "checkingFile": {
            sh "ls -lart"
            }
          )
       }
     }

    stage('Build Artifact - Maven') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archiveArtifacts 'target/*.jar'
      }
    }
    
 stage('Vulnerability Scan - Docker ') {
      steps {
        sh "mvn dependency-check:check"
      }
      post {
        always {
          dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
        }
      }
    }
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
    // success {

    // }

    // failure {

    // }
  }
}
