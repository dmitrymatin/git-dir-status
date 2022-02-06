param([string]$path = "C:\Users\dmitr\source\repos")

$initialLocation = Get-Location

Write-Output("Checking git statuses for path $path")

$directories = @(Get-ChildItem -Path $path -Directory | Select-Object -ExpandProperty FullName)

foreach ($dir in $directories) {
    Set-Location -Path $dir
    try {
        # redirect stderr to stdout https://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO-3.html
        $gitOutputString = $(git status --porcelain 2>&1)

        $isGitError = $gitOutputString -match "fatal"

        if ($isGitError) {
            Write-Output("git fatal error happened in directory $dir\: $gitOutputString")
            continue
        }

        $untrackedFilesExist = git status --porcelain | Where-Object { $_ -match '^\?\?' }
        if ($untrackedFilesExist) {
            Write-Output("There are untracked files in $dir")
        }
        else {
            $uncommitedChangesExist = git status --porcelain | Where-Object { $_ -notmatch '^\?\?' }
            if ($uncommitedChangesExist) {
                Write-Output("There are uncommitted changes to files in $dir")
            }
            else {
                Write-Output("$dir is clean")
            }
        }
    }
    catch {
        Write-Output("ERROR while working with directory $dir")
    }
}

# Clean-up
Set-Location -Path $initialLocation