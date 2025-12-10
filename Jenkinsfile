pipeline {
    agent any
    environment {
        JenkinsAWS     = credentials('JenkinsAWS')
    }
    stages {

        stage('set Docker image'){
            steps {
                script {
                    sh '''
                        echo "Setting Docker image variable"
                        DOCKER_IMAGE="nginx:mainline-alpine3.22"
                    '''
                }
            }
        }
        stage ('Print Docker image'){
            steps {
                script {
                    sh '''
                        echo "Docker image is: ${DOCKER_IMAGE}"
                    '''
                }
            }
        }
        // stage('Pull Docker image'){
        //     steps {
        //         sh '''
        //             docker pull nginx:mainline-alpine3.22
        //         '''
        //         sh '''
        //             export DOCKER_IMAGE="nginx:mainline-alpine3.22"
        //         ''' 
        //         sh '''
        //             echo "Docker image pulled: ${DOCKER_IMAGE}"
        //         '''
        //     }
        // }
        
        // stage('Amazon Inspector Scan') {
        //     steps {
        //         sh '''
        //             echo "Listing current directory"
        //             ls -lar
        //             DOCKER_IMAGE="nginx:mainline-alpine3.22"
        //             export DOCKER_IMAGE="nginx:mainline-alpine3.22"
        //             chmod +x ${WORKSPACE}/aws_inspector.sh
        //             ${WORKSPACE}/aws_inspector.sh
        //         '''
                
        //         step([
        //             $class: 'com.amazon.inspector.jenkins.amazoninspectorbuildstep.AmazonInspectorBuilder',
        //             archivePath: "${env.DOCKER_IMAGE}",
        //             awsRegion: 'ap-south-2',
        //             isEpssThresholdEnabled: 'true',
        //             // AWS creds for inspector API
        //             awsCredentialId: 'JenkinsAWS',
        //             // Docker creds for pulling image
        //             // credentialId: 'JenkinsAWS',
        //             sbomgenPath: "${env.HOME}/bin/amazon_inspector/inspector-sbomgen",
        //             sbomgenSelection: 'Manual',
        //             isAutoFailCveEnabled : 'true',
        //             reportArtifactName: 'aws-inspector-report-arm64'
        //         ])
                
        //     }
        //     post {
        //         always {
        //             script{
        //                 publishHTML target: [
        //                     reportDir: '.',
        //                     reportFiles: '$BUILD_NUMBER/index.html',
        //                     reportName: 'Inspector Vulnerability Report',
        //                     keepAll: true,
        //                     alwaysLinkToLastBuild: true
        //                 ]
        //             }
        //         }
        //     }
        // }   
        

    }
    
}
