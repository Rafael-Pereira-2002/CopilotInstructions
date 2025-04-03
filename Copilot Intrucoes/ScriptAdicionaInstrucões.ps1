# Path to the centralized copilot-instructions.md file
$sourceFile = "C:\Users\rafaelpereira\source\repos\Copilot Intrucoes\copilot-instructions.md"

# Parent directory containing all Visual Studio projects
$reposDir = "C:\Users\rafaelpereira\source\repos"

# Ensure the source file exists
if (-Not (Test-Path -Path $sourceFile)) {
    Write-Host "Source file $sourceFile does not exist."
    exit 1
}

# Iterate over each subdirectory in the parent directory
Get-ChildItem -Path $reposDir -Directory | ForEach-Object {
    $repo = $_.FullName
    
    # Prepare paths for testing
    $csprojPath = Join-Path -Path $repo -ChildPath "*.csproj"
    $slnPath = Join-Path -Path $repo -ChildPath "*.sln"
    
    # Check if the directory contains a Visual Studio project file
    if ((Test-Path -Path $csprojPath) -or (Test-Path -Path $slnPath)) {
        Write-Host "Processing project: $repo"

        # Define the .github directory path
        $githubDir = Join-Path -Path $repo -ChildPath ".github"

        # Create the .github directory if it doesn't exist
        if (-Not (Test-Path -Path $githubDir)) {
            New-Item -ItemType Directory -Path $githubDir | Out-Null
            Write-Host "Created directory: $githubDir"
        }

        # Define the path for the symbolic link
        $linkPath = Join-Path -Path $githubDir -ChildPath "copilot-instructions.md"

        # Check if the symbolic link already exists
        if (Test-Path -Path $linkPath) {
            Write-Host "Symbolic link already exists: $linkPath"
        } else {
            # Create the symbolic link
            New-Item -ItemType SymbolicLink -Path $linkPath -Target $sourceFile | Out-Null
            Write-Host "Created symbolic link: $linkPath -> $sourceFile"
        }
    } else {
        Write-Host "Skipping non-project directory: $repo"
    }
}

Write-Host "Script completed." -ForegroundColor Green