pipeline {
    agent any
    environment {
        JenkinsAWS     = credentials('JenkinsAWS')
    }
    stages {

        // stage('set Docker image'){
        //     steps {
        //         script {
        //             sh '''
        //                 chmod +x build.sh
        //                 ./build.sh && echo "Docker image built: ${IMAGE_NAME_EXPORT}:${tag_export}"
        //             '''
        //                 // def DockerImage = sh(script: 'echo \$DOCKER_IMAGE', returnStdout: true).trim()
        //                 // env.DOCKER_IMAGE=DockerImage
        //         }
        //     }
        // }
        // stage ('Print Docker image'){
        //     steps {
        //         script {
        //             sh '''
        //                 echo "Docker image is: ${DOCKER_IMAGE}"
        //             '''
        //         }
        //     }
        // }
        stage('Pull Docker image'){
            steps {
                sh '''
                    docker pull nginx:mainline-alpine3.22
                '''
                sh '''
                    docker save nginx:mainline-alpine3.22 -o image.tar
                ''' 
                
            }
        }
        
        stage('Amazon Inspector Scan') {
            steps {
                sh '''
                    echo "Listing current directory"
                    ls -lar
                    
                '''
                
                step([
                    $class: 'com.amazon.inspector.jenkins.amazoninspectorbuildstep.AmazonInspectorBuilder',
                    archivePath: "image.tar",
                    archiveType : 'tarball',
                    awsRegion: 'ap-south-2',
                    isEpssThresholdEnabled: 'true',
                    // AWS creds for inspector API
                    awsCredentialId: 'JenkinsAWS',
                    // Docker creds for pulling image
                    // credentialId: 'JenkinsAWS',
                    sbomgenPath: "${env.HOME}/bin/amazon_inspector/inspector-sbomgen",
                    sbomgenSelection: 'Manual',
                    isAutoFailCveEnabled : 'true',
                    reportArtifactName: 'aws-inspector-report-arm64'
                ])
                
            }
            post {
                always {
                    script{
                        publishHTML target: [
                            reportDir: '.',
                            reportFiles: '$BUILD_NUMBER/index.html',
                            reportName: 'Inspector Vulnerability Report',
                            keepAll: true,
                            alwaysLinkToLastBuild: true
                        ]
                    }
                }
            }
        }   
        

    }
    
}
