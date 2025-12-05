pipeline {
    agent any

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
                load "envvars.groovy"
                
                sh '''
                    echo 'Verifying Amazon Inspector SBOM Generator installation'
                    echo '${INSPECTOR_INSTALL_DIR} contents:'
                    ${INSPECTOR_INSTALL_DIR}/inspector-sbomgen --version
                '''
                
            }
            post {
                always {
                    sh "echo 'Amazon Inspector Scan Completed. Check the generated SBOM files.'"
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
