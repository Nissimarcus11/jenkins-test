pipeline {
    agent any

    stages {

        stage('Pull Docker image'){
            steps {
                sh '''
                    docker pull nginx:tricie-perl
                '''
            }
        }
        stage('Trivy Scan & HTML Report') {
            steps {
                sh '''
                mkdir -p $HOME/bin
                export PATH=$HOME/bin:$PATH
                curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b $HOME/bin v0.67.2
                # Create template directory
                mkdir -p /tmp/trivy-templates
                # Download Trivy HTML template if missing
                if [ ! -f /tmp/trivy-templates/html.tpl ]; then
                    curl -L https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl \
                    -o /tmp/trivy-templates/html.tpl
                fi
                # Generate HTML Report
                trivy image \
                    --format template \
                    --exit-code 1 \
                    --ignore-unfixed \
                    --template "@/tmp/trivy-templates/html.tpl" \
                    --output trivy-report.html \
                    nginx:tricie-perl
                '''
            }
        }
        stage('Publish Trivy HTML Report') {
            steps {
                publishHTML target: [
                    reportDir: '.',
                    reportFiles: 'trivy-report.html',
                    reportName: 'Trivy Scan Report',
                    allowMissing: false,
                    keepAll: true,
                    alwaysLinkToLastBuild: true
                ]
            }
        }
    }
}
