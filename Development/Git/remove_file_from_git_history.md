# Remove File from Git History

It is straight forward to remove a file from the current commit or HEAD but if you want remove entirely from the repository’s history then you need to run couple of commands. For example, to remove a file from current HEAD, `git rm pathtofile`

It took some trial and error for me to find something that worked for me

Find out the path fo the file in your repo
Execute Below command with file path

    git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch path_to_file" HEAD

It’s a time intensive task might takes good amount of time to complete. As it has to check each commit and remove. For my repo which is ~10 years old took almost 10hours with 90K commits.

If you want to push it to remote repo just do git push

    git push -all