$pages = @{
    "services.html" = "Services"
    "pricing.html" = "Pricing"
    "reports.html" = "Reports"
    "search-methodology.html" = "Methodology"
    "database-access.html" = "Databases"
    "about.html" = "About"
    "contact.html" = "Contact"
    "home2.html" = "Home 2"
}

$activeClass = 'text-white bg-primary dark:text-primary dark:bg-secondary font-medium px-4 py-2 rounded-full transition-all text-sm shadow-sm'
$inactiveClass = 'text-gray-600 dark:text-gray-300 hover:text-primary dark:hover:text-secondary font-medium px-4 py-2 rounded-full transition-all text-sm hover:bg-white dark:hover:bg-white/10'

foreach ($file in $pages.Keys) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        
        # 1. Deactivate Home
        $content = $content -replace "(<a href=`"index.html`" class=`")[^`"]+(`">Home</a>)", "`$1$inactiveClass`$2"
        
        # 2. Activate current page
        $linkName = $pages[$file]
        $content = $content -replace "(<a href=`"$file`" class=`")[^`"]+(`">$linkName</a>)", "`$1$activeClass`$2"
        
        Set-Content $file $content
        Write-Host "Set active state for $file"
    }
}
