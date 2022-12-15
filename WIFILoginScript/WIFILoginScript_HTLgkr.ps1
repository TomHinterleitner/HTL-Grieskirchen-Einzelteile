### EDIT THESE VALUES FOR YOUR ACCOUNT
### Use the following command to Base64 encode your password:
###   [System.Convert]::ToBase64String([System.Text.Encoding]::UNICODE.GetBytes( YOUR_PASSWORD_HERE ))
### If you want to show your 

$username = 'YOUR_USERNAME'
$passwordBase64Encoded = 'YOUR_BASE64_ENCODED_PASSWORD_SEE_ABOVE'
$password = [System.Text.Encoding]::UNICODE.GetString([System.Convert]::FromBase64String($passwordBase64Encoded))

### 0 = Hide console shortly after start (Google how to change shortcut for completly hidden console)
### Any other number = time in seconds console is visible (recommended in case there are errors)
$consoleVisible = 1.5

### THESE VALUES SHOULD WORK FINE ("Reverse Engineered" @ 17.09.2021)

$loginHost = '10.10.0.251:8002'
$loginUrl = "http://$loginHost/index.php?zone=cp_htl"

# Google Chrome User Agent
$userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36"

$headers = @{
  Host = $loginHost
  'Cache-Control' = 'max-age=0'
  'Upgrade-Insecure-Requests' = '1'
  Origin = "http://$loginHost"
  Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'
  Referer = $loginUrl
  #"Accept-Encoding" = "gzip, deflate"
  'Accept-Language' = 'de-AT,de-DE;q=0.9,de;q=0.8,en-US;q=0.7,en;q=0.6'
}

# This (like the original web page) transmitts the password in clear text, beware of proxies / VPNs!
$body = @{
  'auth_user' = $username
  'auth_pass' = $password
  'accept' = 'Anmelden'
  'redirurl' = 'http%3A%2F%2F10.10.0.2%2Fcaptiveportal%2Fcp_logon_done.html'
}

# Voodoo magic to hide console if desired
if ($consoleVisible -eq 0)
{
  Add-Type -Name Window -Namespace Console -MemberDefinition '
  [DllImport("Kernel32.dll")]
  public static extern IntPtr GetConsoleWindow();
  [DllImport("user32.dll")]
  public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);'

  [Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0)
}

$Response = Invoke-WebRequest -Uri $loginUrl `
                              -Method 'Post' `
                              -Headers $headers `
                              -Body $body `
                              -UserAgent $userAgent

# Output success / failure
if ($consoleVisible -ne 0 -and $Response.StatusCode -eq 200)
{
    $host.ui.RawUI.ForegroundColor = "Green"
    Write-Output "SUCCESS: Login request succeeded"
} else
{
    $host.ui.RawUI.ForegroundColor = "Red"
    Write-Output "ERROR: Login request failed with CODE=$Response.StatusCode"
    Write-Output "Raw Output:\n$Response.RawContent"
}

Start-Sleep $consoleVisible