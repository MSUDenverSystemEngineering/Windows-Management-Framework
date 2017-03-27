Add-AppveyorTest -Name "PsScriptAnalyzer" -Outcome Running
Invoke-Pester
$Results = Invoke-ScriptAnalyzer -Path . -Recurse -Severity Error,Warning -ErrorAction SilentlyContinue
If ($Results) {
  $ResultString = $Results | Out-String
  Write-Warning $ResultString
  Add-AppveyorMessage -Message "PSScriptAnalyzer output contained one or more result(s) with 'Error' or 'Warning' severity.`
  Check the 'Tests' tab of this build for more details." -Category Error
  Update-AppveyorTest -Name "PsScriptAnalyzer" -Outcome Failed -ErrorMessage $ResultString
  # Failing the build
  Throw "Build failed"
}
Else {
  Update-AppveyorTest -Name "PsScriptAnalyzer" -Outcome Passed
}
