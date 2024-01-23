#!groovy

@Library("titan-library") _

def modules = ['activej-bytebuf']
// def modules123 = ['activej-bytebuf', 'activej-common', 'auto-service', 'chronicle-map', 'eclipse-collections', 'eclipse-collections-api', 'guava', 'javax-inject', 'jheaps', 'jsr305', 'mutiny', 'mvstore', 'ontology-model', 'protobuf-java', 'reactive-streams', 'record-builder-core', 'roaringbitmap', 'smallrye-common-annotation', 'snorocket']

pipeline {
    agent any

    tools {
        jdk "java-21"
        maven 'default'
        git 'git'
    }

    environment {
        SONAR_AUTH_TOKEN    = credentials('sonarqube_pac_token')
        SONARQUBE_URL       = "${GLOBAL_SONARQUBE_URL}"
        SONAR_HOST_URL      = "${GLOBAL_SONARQUBE_URL}"

        GPG_PASSPHRASE      = credentials('gpg_passphrase')

        BRANCH_NAME         = "${GIT_BRANCH.split("/").size() > 1 ? GIT_BRANCH.split("/")[1] : GIT_BRANCH}"


    }

    options {
        // Set this to true if you want to clean workspace during the prep stage
        skipDefaultCheckout(false)

        // Console debug options
        timestamps()
        ansiColor('xterm')

        // necessary for communicating status to gitlab
        gitLabConnection('fda-shield-group')
    }

    stages {
        stage('Maven Build') {
            steps {
                updateGitlabCommitStatus name: 'build', state: 'running'

                script{

                    for(String module: modules) {
                        configFileProvider([configFile(fileId: 'settings.xml', variable: 'MAVEN_SETTINGS')]) {
                            sh """
                                mvn clean install \
                                    -f '${module}'/pom.xml \
                                    -s '${MAVEN_SETTINGS}' \
                                    -Dmaven.build.cache.enabled=false \
                                    --batch-mode \
                                    -e \
                                    -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn 
                            """
                        }
                    }
                }
            }
        }

        stage("Publish to Nexus Repository Manager") {
            steps {
                script {
                    repositoryId = 'maven-releases'

                    for(String module: modules) {
                        configFileProvider([configFile(fileId: 'settings.xml', variable: 'MAVEN_SETTINGS')]) {
                            sh """
                                mvn deploy \
                                    -f '${module}'/pom.xml \
                                    --batch-mode \
                                    -e \
                                    -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn \
                                    -Dmaven.build.cache.enabled=false \
                                    -DskipTests \
                                    -DskipITs \
                                    -Dmaven.main.skip \
                                    -Dmaven.test.skip \
                                    -s '${MAVEN_SETTINGS}' \
                                    -DrepositoryId='${repositoryId}' \
                                    -Dgpg.passphrase='${GPG_PASSPHRASE}'
                            """
                        }
                    }
                }
            }
        }

        stage("Publish to OSSRH maven central") {
            steps {
                script {
                    repositoryId = 'maven-releases'

                    for(String module: modules) {
                        configFileProvider([configFile(fileId: 'settings.xml', variable: 'MAVEN_SETTINGS')]) {
                                sh """
                                mvn deploy \
                                    --batch-mode \
                                    -f '${module}'/pom.xml \
                                    -e \
                                    -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn \
                                    -DskipTests \
                                    -DskipITs \
                                    -Dmaven.main.skip \
                                    -Dmaven.test.skip \
                                    -s '${MAVEN_SETTINGS}' \
                                    -DrepositoryId='${repositoryId}' \
                                    -DrepositoryIdOSSRH='true' \
                                    -PemptySourceJavadocOSSRH,stageOSSRH -Dgpg.passphrase='${GPG_PASSPHRASE}'
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        failure {
            updateGitlabCommitStatus name: 'build', state: 'failed'
            emailext(

                recipientProviders: [requestor(), culprits()],
                subject: "Build failed in Jenkins: ${env.JOB_NAME} - #${env.BUILD_NUMBER}",
                body: """
                    Build failed in Jenkins: ${env.JOB_NAME} - #${BUILD_NUMBER}

                    See attached log or URL:
                    ${env.BUILD_URL}
                """,
                attachLog: true
            )
        }
        aborted {
            updateGitlabCommitStatus name: 'build', state: 'canceled'
        }
        unstable {
            updateGitlabCommitStatus name: 'build', state: 'failed'
            emailext(
                subject: "Unstable build in Jenkins: ${env.JOB_NAME} - #${env.BUILD_NUMBER}",
                body: """
                    See details at URL:
                    ${env.BUILD_URL}
                """,
                attachLog: true
            )
        }
        changed {
            updateGitlabCommitStatus name: 'build', state: 'success'
            emailext(
                recipientProviders: [requestor(), culprits()],
                subject: "Jenkins build is back to normal: ${env.JOB_NAME} - #${env.BUILD_NUMBER}",
                body: """
                Jenkins build is back to normal: ${env.JOB_NAME} - #${env.BUILD_NUMBER}

                See URL for more information:
                ${env.BUILD_URL}
                """
            )
        }
        success {
            updateGitlabCommitStatus name: 'build', state: 'success'
        }
        cleanup {
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
