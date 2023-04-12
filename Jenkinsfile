@Library("titan-library") _ 

pipeline {
    agent any
    
    environment {

        SONAR_AUTH_TOKEN    = credentials('sonarqube_pac_token')
        SONARQUBE_URL       = "${GLOBAL_SONARQUBE_URL}"
        SONAR_HOST_URL      = "${GLOBAL_SONARQUBE_URL}"
        
        BRANCH_NAME         = "${GIT_BRANCH.split("/").size() > 1 ? GIT_BRANCH.split("/")[1] : GIT_BRANCH}"
        
    }

    options {

        // Set this to true if you want to clean workspace during the prep stage
        skipDefaultCheckout(false)

        // Console debug options
        timestamps()
        ansiColor('xterm')
    }       
    
    stages {

        stage("stage 1") {            
            when {
                not {
                    anyOf { 
                        branch 'main' 
                        branch 'master'
                    }
                }
            }
            steps {
                echo 'stage 1: not a change request ' + env.BRANCH_NAME + ' == ' + env.GIT_BRANCH 
            }
        }

        stage("stage 2") {            
            when {
                anyOf { 
                    branch 'main' 
                    branch 'master'
                }
            }
            steps {
                echo 'stage 2: not a change request ' + env.BRANCH_NAME + ' == ' + env.GIT_BRANCH 
            }    
        }
            
        stage('Maven Build') {
            agent {
                docker {
                    image "maven:3.8.7-eclipse-temurin-19-focal"
                    args '-u root:root'
                }
            }
            

            steps {                
                script{
                    configFileProvider([configFile(fileId: 'settings.xml', variable: 'MAVEN_SETTINGS')]) {
                        sh """
                        mvn clean install -s '${MAVEN_SETTINGS}' \
                            --batch-mode \
                            -e \
                            -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn
                        """
                    }
                }
            }
        }

        stage("Publish to Nexus Repository Manager") {
            
            when {
                not {
                    expression { return changeRequest() }
                }
            }

            agent {
                docker {
                    image "maven:3.8.7-eclipse-temurin-19-focal"
                    args '-u root:root'
                }
            }

            steps {               

                script {
                    pomModel = readMavenPom(file: 'pom.xml')                    
                    pomVersion = pomModel.getVersion()
                    isSnapshot = pomVersion.contains("-SNAPSHOT")
                    repositoryId = 'maven-releases'                    

                    if (isSnapshot) {
                        repositoryId = 'maven-snapshots'
                    } 
                }
             
                configFileProvider([configFile(fileId: 'settings.xml', variable: 'MAVEN_SETTINGS')]) { 

                    sh """
                        mvn deploy \
                        --batch-mode \
                        -e \
                        -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn \
                        -DskipTests \
                        -DskipITs \
                        -Dmaven.main.skip \
                        -Dmaven.test.skip \
                        -s '${MAVEN_SETTINGS}' \
                        -P inject-application-properties \
                        -DrepositoryId='${repositoryId}'
                    """              
                }
            }
        }

        stage("Deploy skipped") {
            
            when {
                expression { return changeRequest() }
            }
            
            steps {
                echo 'Skipped Deploy as this is PullRequest'
            }
        }
    }


    post {
        always {
            // Clean the workspace after build
            cleanWs(cleanWhenNotBuilt: false,
                deleteDirs: true,
                disableDeferredWipeout: true,
                notFailBuild: true,
                patterns: [
                [pattern: '.gitignore', type: 'INCLUDE']
            ])
        }
    }
}
