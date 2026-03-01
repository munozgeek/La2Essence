$dir = "c:\L2\La2Essence\game\data\stats\skills"
$files = Get-ChildItem -Path "$dir\*.xml"
$regex = [regex]'(?s)<skill\b.*?</skill>'
$updatedCount = 0

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName)
    if ($content.Contains("<itemConsumeId>3031</itemConsumeId>")) {
        $mc = $regex.Matches($content)
        $newContent = $content
        $fileUpdated = $false
        
        foreach ($m in $mc) {
            $skillText = $m.Value
            if ($skillText.Contains("<itemConsumeId>3031</itemConsumeId>")) {
                $newSkillText = [regex]::Replace($skillText, '(?s)<itemConsumeCount>.*?</itemConsumeCount>', '<itemConsumeCount>0</itemConsumeCount>')
                if ($newSkillText -cne $skillText) {
                    $newContent = $newContent.Replace($skillText, $newSkillText)
                    $fileUpdated = $true
                }
            }
        }
        
        if ($fileUpdated) {
            # Write with UTF8 without BOM to preserve XML validity
            $utf8NoBom = New-Object System.Text.UTF8Encoding $false
            [System.IO.File]::WriteAllText($file.FullName, $newContent, $utf8NoBom)
            Write-Host "Updated $($file.Name)"
            $updatedCount++
        }
    }
}

Write-Host "Total files updated: $updatedCount"
