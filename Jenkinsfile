@Library('mss-sharedlibrary') _

// import io.jenkins.blueocean.rest.impl.pipeline.PipelineNodeGraphVisitor
// import io.jenkins.blueocean.rest.impl.pipeline.FlowNodeWrapper
// import org.jenkinsci.plugins.workflow.support.steps.build.RunWrapper
// import org.jenkinsci.plugins.workflow.actions.ErrorAction

// // Get information about all stages, including the failure cases
// // Returns a list of maps: [[id, failedStageName, result, errors]]
// @NonCPS
// List < Map > getStageResults(RunWrapper build) {

//   // Get all pipeline nodes that represent stages
//   def visitor = new PipelineNodeGraphVisitor(build.rawBuild)
//   def stages = visitor.pipelineNodes.findAll {
//     it.type == FlowNodeWrapper.NodeType.STAGE
//   }

//   return stages.collect {
//     stage ->

//       // Get all the errors from the stage
//       def errorActions = stage.getPipelineActions(ErrorAction)
//     def errors = errorActions?.collect {
//       it.error
//     }.unique()

//     return [
//       id: stage.id,
//       failedStageName: stage.displayName,
//       result: "${stage.status.result}",
//       errors: errors
//     ]
//   }
// }

// // Get information of all failed stages
// @NonCPS
// List < Map > getFailedStages(RunWrapper build) {
//   return getStageResults(build).findAll {
//     it.result == 'FAILURE'
//   }
// }

pipeline {
  //agent any
  //kubectl -n default create deploy node-app --image siddharth67/node-service:v1
  //kubectl -n default expose deploy node-app --name node-service --port 5000
   agent{
      label "numericAgent"
       }

       options {
         buildDiscarder logRotator( artifactDaysToKeepStr: '1', artifactNumToKeepStr: '1', daysToKeepStr: '1', numToKeepStr: '1')
         timestamps()
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
            //def mavenHome =  tool name: "maven:3.6.3", type: "maven"
            //def mavenCMD = "${mavenHome}/usr/share/maven"
            VERSION = "${env.BUILD_ID}"
            REGISTRY = 'eagunuworld/numeric-app'
            imageName = "eagunuworld/numeric-app:${BUILD_ID}"
            REGISTRY_CREDENTIAL = 'eagunuworld_dockerhub_creds'
            //def scmVars = checkout([$class: 'GitSCM', branches: [[name: 'master']], userRemoteConfigs: [[url: 'https://github.com/eagunuworld/BI_NumericDemo_App.git']]])
            //sha_value = "${scmVars.GIT_COMMIT}"
            deploymentName = "demo-pod"
            conName = "demo-con"
            svcName = "demo-svc"
            svcPort = "30004"
            mssNode01 = "http://34.174.184.64"
            jenkinsURL = "http://34.125.227.27"
            serverURL = "http://34.174.151.201"
            appURI = "increment/99"
          }

  stages {
    stage('DisplayEnvProperties') {
      steps {
        sh 'printenv'
      }
    }
     
    stage('Testing Slack - Pass  Stage') {
      steps {
        sh 'exit 0'
      }
    }

    }
  post {
      success {
      script {
        /* Use slackNotifier.groovy from shared library and provide current build result as parameter */  
        env.failedStage = "none"
        env.emoji = ":white_check_mark: :tada: :thumbsup_all:"
        slackcodenotifications currentBuild.result
      }
    }
    // failure {
    //   script {
    //     //Fetch information about  failed stage
    //     def failedStages = getFailedStages(currentBuild)
    //     env.failedStage = failedStages.failedStageName
    //     env.emoji = ":x: :red_circle: :sos:"
    //     slackcodenotifications currentBuild.result
    //   }
    // }
  }
}
