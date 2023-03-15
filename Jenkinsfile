@Library('mss-sharedlibrary') _

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
         //skipDefaultCheckout(true)
        }

     parameters {
          choice choices: ['main', 'owasp_zap_scanning','slack_success_failed_demo', 'lab_mutation_Test', 'walmart-dev-mss', 'dependencyCheckTrivyOpenContest'], description: 'This is choice paramerized job', name: 'BranchName'
          string defaultValue: 'Eghosa DevOps', description: 'please developer select the person\' name', name: 'personName'
        }

  tools{
      maven 'demo-maven:3.8.6'
      }

 environment {
            DEPLOY = "${env.BRANCH_NAME == "python-dramed" || env.BRANCH_NAME == "master" ? "true" : "false"}"
            NAME = "${env.BRANCH_NAME == "python-dramed" ? "example" : "example-staging"}"
            VERSION = "${env.BUILD_ID}"
            REGISTRY = 'eagunuworld/numeric-app'
            imageName = "eagunuworld/numeric-app:${BUILD_ID}"
            REGISTRY_CREDENTIAL = 'eagunuworld_dockerhub_creds'
            deploymentName = "demo-pod"
            conName = "demo-con"
            svcName = "demo-svc"
            jenkinsURL = "http://34.125.227.27"
            serverURL = "http://34.174.151.201"
            appURI = "increment/99"
          }

  stages {
    stage('Build Artifact - Maven') {
      steps {
         //cleanWs()
        sh "mvn clean package -DskipTests=true"
        archiveArtifacts 'target/*.jar'
      }
    }

   stage('CodesVulnerabilityScanning') {    //(Pit mutation) is a plugin in jenkis and plugin was added in pom.xml line 68
      steps {
         parallel(
               "PitMutationTestReport": {
                    sh "mvn org.pitest:pitest-maven:mutationCoverage"  //section 3 video
                  },
                  "DependencyCheckReport": {
                      timeout(time: 4, unit: 'MINUTES') {
                      sh "mvn dependency-check:check"   //OWASP Dependency check plugin is required via jenkins
                    }    
                   },
                 "StaticAppSecurityTesting": {
                  withSonarQubeEnv('sonarQube') {
                    sh "mvn clean package sonar:sonar -Dsonar.projectKey=eagunu-number-app -Dsonar.host.url=http://34.125.84.141:9000 -Dsonar.login=sqp_5705583cefa89faa42f1fb1cf60944e8dae42248"
                   }
               }
             )
         }
      }
  } // pipeline stages end here 
   post {
        always {
        pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
        dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
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
