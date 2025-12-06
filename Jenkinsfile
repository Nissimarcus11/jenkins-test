pipeline {
    agent any
    environment {
        JenkinsAWS     = credentials('JenkinsAWS')
    }
    stages {

        stage('Pull Docker image'){
            steps {
                sh '''
                    docker pull nginx:mainline-alpine3.22
                '''
            }
        }
        stage('Amazon Inspector Scan') {
            steps {
                sh '''
                    echo "Listing current directory"
                    ls -lar

                    chmod +x ${WORKSPACE}/aws_inspector.sh
                    ${WORKSPACE}/aws_inspector.sh
                '''
                
                step([
                    $class: 'com.amazon.inspector.jenkins.amazoninspectorbuildstep.AmazonInspectorBuilder',
                    archivePath: "nginx:mainline-alpine3.22",
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
                        // Publish AWS Inspector report if it exists
                        if (fileExists('${BUILD_NUMBER}/index.html')) {
                            publishHTML target: [
                                reportDir: '.',
                                reportFiles: '${BUILD_NUMBER}/index.html',
                                reportName: 'AWS Inspector Report',
                                keepAll: true,
                                alwaysLinkToLastBuild: true
                            ]
                    }
                }
            }
        }   
        // stage('Trivy Scan & HTML Report') {
        //     steps {
        //         sh '''
        //         mkdir -p $HOME/bin
        //         export PATH=$HOME/bin:$PATH
        //         curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b $HOME/bin v0.67.2
        //         # Create template directory
        //         mkdir -p /tmp/trivy-templates
        //         # Download Trivy HTML template if missing
        //         if [ ! -f /tmp/trivy-templates/html.tpl ]; then
        //             curl -L https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl \
        //             -o /tmp/trivy-templates/html.tpl
        //         fi
        //         # Generate HTML Report
        //         trivy image \
        //             --format template \
        //             --exit-code 1 \
        //             --ignore-unfixed \
        //             --template "@/tmp/trivy-templates/html.tpl" \
        //             --output trivy-report.html \
        //             nginx:mainline-alpine3.22
        //         '''
        //     }
        //     post {
        //         always {
        //                 publishHTML target: [
        //                     reportDir: '.',
        //                     reportFiles: 'trivy-report.html',
        //                     reportName: 'Trivy Scan Report',
        //                     allowMissing: false,
        //                     keepAll: true,
        //                     alwaysLinkToLastBuild: true
        //                 ]
        //         }
        //     }
        // }

    }
    
}
