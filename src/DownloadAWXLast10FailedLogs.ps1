param
(
    [Parameter(Mandatory=$true, HelpMessage="Provide the job template id")]
    [string] $jobTemplateId
)

# Initialize
$apiHost = "https://awx.abs.com"
$apiJobsUri = "/api/v2/jobs/?order_by=-id" # Get the jobs in reverse order by id
$apiJobsFilter = "&job_template=" + $jobTemplateId + "&status=failed"
$apiFailedJobsUrl = $apiHost + $apiJobsUri + $apiJobsFilter

# Set Headers
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Content-Type','application/json')
$headers.Add('Authorization','Bearer xxxxxxxxxxxxxxxxxxxxxxxxxx')
# Get the failed jobs for the given job template id
Write-Output "Getting the failed jobs for the job template Id $jobTemplateId"
$response = Invoke-RestMethod -Uri $apiFailedJobsUrl -Headers $headers -Method Get -ErrorAction Stop -Verbose
Write-Output "The list of failed jobs retrieved in reverse order by id"

# Create the logs folder
Write-Output "Create logs folder" 
New-Item -ItemType Directory ".\logs"
# Loop through the count (no. of jobs) in the response
$failedJobsCount = 10
Write-Output "Creating the logs for last 10 failed jobs..."
For ($counter=0; $counter -lt $response.count; $counter++)
{    
    $logFile = ".\logs\" + $response.results[$counter].id + ".html"
    Invoke-WebRequest -Uri ($apiHost + $response.results[$counter].url + "stdout/") -Headers $headers -Method Get -OutFile $logFile -Verbose
    if ($counter -eq ($failedJobsCount -1))
    {
        break
    }
}
Write-Output "Creating the logs for the last 10 failed jobs completed successfully"