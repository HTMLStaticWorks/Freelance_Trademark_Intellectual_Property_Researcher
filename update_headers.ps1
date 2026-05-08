$files = @("services.html", "pricing.html", "reports.html", "search-methodology.html", "database-access.html", "about.html", "contact.html")
$header = Get-Content "index.html" -Raw
if ($header -match '(?s)(<!-- Header Navigation -->\s*<header.*?</header>)') {
    $headerContent = $matches[1]
    # Replace active states in the header for specific pages if needed, but for now we'll just inject the full menu and then we can fix active states later.
    foreach ($file in $files) {
        $content = Get-Content $file -Raw
        $content = $content -replace '(?s)(<!-- Header(?: Navigation)? -->\s*<header.*?</header>)', $headerContent
        Set-Content $file $content
        Write-Host "Updated $file"
    }
} else {
    Write-Host "Header not found in index.html"
}
