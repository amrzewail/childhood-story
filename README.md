# Graduation Project

## Frequent Git commands
* Use `git status` to list all new or modified files that haven't yet been committed.
* Use `git add path/to/file` to add a change in the working directory to the staging area. It tells Git that you want to include updates to a particular file in the next commit
* Use `git add .` to add *all* changes in the working directory to the staging area. It tells Git that you want to include updates to all files in the next commit
* Use `git commit -m "some message"` to flag the staged changes by `git add` as ready to push. "some message" is the message you want to include with the commit to summary your changes
* Use `git push` to push (upload) all local commited changes to the github servers 
* Use `gitk --all` to view a graphical representation of the current local and remote commits with a tree-like structure
* Use `git fetch` to download remote changes in the repo without applying them to your local branches. Can be thought as a refresh command
* Use `git pull` to download remote changes in the repo *and* apply them to the current local branch
* Use `git checkout -b <branch-name>` to create a new local branch. Should be used when working on a new feature, to avoid making WIP changes to the master branch. branch-name is the name of the branch you would like to create, do not include the brackets
* Use `git checkout <branch-name>` to switch to a currently available local branch
* Use `git push --set-upstream origin <branch-name>` for the first time you push a new branch to the github servers. Then you can use `git push` as normal.

### Download new changes
* `git status` make sure you are on the desired branch and you have no pending changes (red colored)
* `git fetch` check if there are new changes on the server
* `git pull` apply those changes

### Upload local changes
* `git status` make sure you are on the desired branch and check your file changes
* `git add .` add all pending changes to the stage phase (turn their color from red to green)
* `git commit -m "my brilliant changes"` commit your green changes to be ready for upload
* `git push` upload your commited changes to the github servers
* * NOTE: you may get an error saying there are pending changes on the server that you haven't downloaded yet, so use `git pull` to download these changes and merge with yours then try `git push` again.

### Create a new branch
* `git status` to make sure you are on the desired base branch
* `git checkout -b <my-new-branch>` create a new local branch based on the first branch
* `git push --set-upstream origin <my-new-branch>` after you make changes and you want to upload them

### Merge your branch with master
* `git status` to make sure you are on the target branch and there are NO pending changes
* `git fetch` to check if there are new changes to master. if there are new changes in master do the following:
* * `git checkout master` switch to master
* * `git pull` download the changes
* * `git checkout <my-branch>` return back to your branch
* `git merge master` to merge your branch with the master branch (this affects your branch but does not affect master)
* `git push` to upload your merged changes to the github servers

### Reset your work with main branch in github
* `git reset --hard` to reset your project with latest updated in github



