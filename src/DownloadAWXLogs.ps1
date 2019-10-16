param
(
    [Parameter(Mandatory=$true, HelpMessage="Provide the job template id")]
    [string] $jobTemplateId
)

# Initialize
$apiHost = "https://awx.abs.com"
$apiJobsUri = "/api/v2/jobs/"
$apiJobsFilter = "?job_template=" + $jobTemplateId + "&status=failed"
$apiFailedJobsUrl = $apiHost + $apiJobsUri + $apiJobsFilter

# Set Headers
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Content-Type','application/json')
$headers.Add('Authorization','Bearer xxxxxxxxxxxxxxxxxxxxxxxxxx')
# Get the failed jobs for the given job template id
Write-Output "Getting the failed jobs for the job template Id $jobTemplateId"
$response = Invoke-RestMethod -Uri $apiFailedJobsUrl -Headers $headers -Method Get -ErrorAction Stop -Verbose
Write-Output "The list of failed jobs retrieved"

# Create the logs folder
Write-Output "Create logs folder" 
New-Item -ItemType Directory ".\logs"

# Loop through the count (no. of jobs) in the response
Write-Output "Creating the logs for failed jobs..."
For ($counter=0; $counter -lt $response.count; $counter++)
{    
    $logFile = ".\logs\" + $response.results[$counter].id + ".html"
    # Write-Output $response.results[$counter].id
    Invoke-WebRequest -Uri ($apiHost + $response.results[$counter].url + "stdout/") -Headers $headers -Method Get -OutFile $logFile -Verbose
}
Write-Output "Creating the logs for the failed jobs completed successfully"