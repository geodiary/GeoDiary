# Contributing

All contributions made to this repository are welcomed and appreciated. Nonetheless, the following information and rules should be kept in mind when making a contribution:

## Team values
1. Respect each other and treat each other as equals.
2. Accept constructive criticisms and welcome different viewpoints.
3. Be responsible for the work you have been assigned.
4. Be proactive in helping, collaborating with and communicating with others.

## Definition of done
All codes for User Stories must (1) satisfy all the requirements, (2) be reviewed by other members of the team.

## Git workflow
Team mebers will follow the [Feature branch workflow](https://knowledge.kitchen/Feature_branch_version_control_workflow). A basic summary of the process is shown below:

1. Pull the latest version of the remote repository to your local clone using `git pull`.
2. Checkout a new branch, where the branch name follows this convention: For example, a branch creating a feature for Task #3 on User Story #4 would be created as `git checkout -b task/3`.
3. Make your changes, add and commit them to your local clone.
4. Push the changes to the remote repository here on github using `git push origin task/3`.
5. Make a pull request here on github so another team member can review your work.

If you want to review another team member's code, you should follow these steps:
1. Checkout the branch that was used for the new feature: `git checkout task/3`.
2. Pull the latest version of the branch to your local clone `git pull`.
3. Run the necessary linting configuration, unit tests and generally verify the integrity of the code.
4. If there are no problems, checkout the master branch `git checkout master`.
5. Pull the latest version of the master branch to your local clone `git pull`.
6. Merge the feature branch with the master branch `git merge task/3`.
7. Push the new master branch from your local clone to the remote repository `git push origin master`. 
