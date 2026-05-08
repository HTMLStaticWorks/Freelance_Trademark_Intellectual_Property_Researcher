$files = @("index.html", "home2.html", "services.html", "pricing.html", "reports.html", "search-methodology.html", "about.html", "contact.html", "dashboard.html", "login.html", "signup.html")

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        $content = $content -replace '"database-access\.html"', '"contact.html"'
        $content = $content -replace '>Databases</a>', '>Contact</a>'
        Set-Content $file $content
        Write-Host "Updated $file"
    }
}

Remove-Item "database-access.html" -Force
Write-Host "Removed database-access.html"
