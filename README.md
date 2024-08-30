# 🌟 ph-ee-core

Welcome to the ph-ee-core repository! This guide will walk you through building the projects, running Checkstyle, raising Pull Requests (PRs), and understanding the services included in this repo.

### 📦 Services Included

* ph-ee-bulk-processor
* ph-ee-channel-connector
* ph-ee-connector-common
* ph-ee-connector-mock-payment-schema
* ph-ee-env-template
* ph-ee-identity-account-mapper
* ph-ee-importer-es
* ph-ee-importer-rdbms
* ph-ee-vouchers
* ph-ee-integration-test
* ph-ee-operations-app
* ph-ee-operations-web
* ph-ee-notifications
* message-gateway

### 🛠️ How to Build a Project

To build a specific project within the ph-ee-core repository:

Navigate to the project directory:
```shell
cd path/to/project-directory
```

Run the build command:
```shell
./gradlew build
```
Check for successful build output.

### ✅ How to Run Checkstyle

Ensure your code adheres to the project's coding standards by running Checkstyle:

To check checkstyle for specific service directory:
Navigate to the project directory:
```shell
cd path/to/project-directory
```
#### Checkstyle
Use below command to execute the checkstyle test.
```shell
./gradlew checkstyleMain
```

#### Spotless
Use below command to execute the spotless apply.
```shell
./gradlew spotlessApply
```
Review the output and resolve any issues.

### 📝 PR Guidelines

PR title should have the Jira ticket enclosed in [].

Format: `[jira_ticket]` description

Example: `[phee-123]` PR title

Add a link to the Jira ticket.

Describe the changes made and why they were made.

#### Checklist:

1. [ ] Followed the PR title naming convention mentioned above.
2. [ ] Added design-related bullet points or design document links in the description.
3. [ ] Updated corresponding Postman Collection or API documentation.
4. [ ] Created/updated unit or integration tests.
5. [ ] Added required Swagger annotations and updated API documentation.
6. [ ] Followed naming conventions as per the Naming Convention Document.

### 🔄 How to Run Services Locally (Individually/Multiple)

#### Running a Service Individually:

* Navigate to the main class of the service.
* Run the main class in Java.

#### Running Multiple Services Locally:

* For each service, modify the port in the application.yml file to avoid conflicts.
* Start each service by running the main class of Java in its respective directory.

### 🚀 How to Raise a Pull Request (PR)

Contributing to ph-ee-core? Here's how you can raise a PR:

Fork the repository and create a new branch:
```shell
git checkout -b feature/your-feature-name
```

Make your changes and commit them:
```shell
git commit -m "Add: Description of changes"
```


Push your branch to your forked repository:
```shell
git push origin feature/your-feature-name
```


Open a PR on the main repository, ensuring you:

Link the relevant Jira ticket in the PR title: `[JIRA-ID]` Your PR Title.

Add a detailed description of your changes.

### 🧪 How to Run/See Pipeline Results

After raising a PR, you can check the pipeline results on CircleCI to ensure that your builds are successful and charts are building properly.

#### Accessing Pipeline Results:

After you submit a PR, go to CircleCI, where the pipeline will automatically run.
The status of your build will be displayed, indicating whether it passed or failed.

#### Checking Integration Test Results:

* In CircleCI, navigate to the **minikube-run-helm-upgrade-and-helm-test** job.
* Go to the **Tests** tab to review the integration test results.
* By following these steps, you can verify that your code changes are functioning correctly and meet the required standards.


### 🔍 Additional Information

Documentation: Link to additional documentation.

- [Gitbook](https://mifos.gitbook.io/docs/payment-hub-ee/business-overview)
- [Postman](https://www.getpostman.com/collections/b503484fc231b5857306)
- [Swagger](https://app.swaggerhub.com/apis/myapi943/payment-hub_ap_is/1.0)
- [CircleCI](https://app.circleci.com/projects/project-dashboard/github/fynarfin/)
