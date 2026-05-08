$files = @("services.html", "pricing.html", "reports.html", "search-methodology.html", "database-access.html", "about.html", "contact.html")
$footerContent = Get-Content "footer_content.txt" -Raw

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        
        # We need to replace the existing <footer ...>...</footer>
        if ($content -match '(?s)(<footer.*?</footer\s*>)') {
            $content = $content -replace '(?s)(<footer.*?</footer\s*>)', $footerContent
            Set-Content $file $content
            Write-Host "Replaced footer in $file"
        } else {
            # If no footer is found, append it before </body>
            $content = $content -replace '</body>', "$footerContent`n</body>"
            Set-Content $file $content
            Write-Host "Injected footer into $file"
        }
    }
}
