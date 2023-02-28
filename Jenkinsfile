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

    //   stage('StaticAnalysis') {
    //    steps {
    //      parallel(
    //            "StaticCodesAnalysis": {
    //              sh "mvn clean package sonar:sonar -Dsonar.projectKey=eagunu-number -Dsonar.host.url=http://34.174.169.116:9000 -Dsonar.login=sqp_7cc61899f6f0b28a1491fa9aad5c25780c924ce7"
    //           },
    //           "No Tasks": {
    //          sh "ls -lart"
    //         },
    //        "checkingFile": {
    //         sh "ls -lart"
    //         }
    //       )
    //    }
    //  }

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

     stage('Mutation Tests') {
        steps {
           sh "mvn org.pitest:pitest-maven:mutationCoverage"
           }
        post {
          always {
            pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
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
