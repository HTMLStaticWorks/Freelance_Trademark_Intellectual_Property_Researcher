$pages = @{
    "services.html" = "Services"
    "pricing.html" = "Pricing"
    "reports.html" = "Reports"
    "search-methodology.html" = "Methodology"
    "database-access.html" = "Databases"
    "about.html" = "About"
    "contact.html" = "Contact"
}

$desktopActiveClass = "text-white bg-primary dark:text-primary dark:bg-secondary font-medium px-4 py-2 rounded-full transition-all text-sm shadow-sm"
$mobileActiveClass = "block px-4 py-3 rounded-xl text-base font-medium text-secondary bg-primary/5 dark:bg-white/5"
$inactiveClass = "text-gray-600 dark:text-gray-300 hover:text-primary dark:hover:text-secondary font-medium px-4 py-2 rounded-full transition-all text-sm hover:bg-white dark:hover:bg-white/10"
$mobileInactiveClass = "block px-4 py-3 rounded-xl text-base font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-white/5"

foreach ($file in $pages.Keys) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        $linkName = $pages[$file]
        
        # 1. Deactivate Home Button
        $content = $content -replace '(?s)(<button\s+class=")[^"]+(">\s*Home)', "`$1$inactiveClass flex items-center gap-1 cursor-pointer bg-transparent border-none`$2"
        
        # 2. Update all links to inactive first (to reset)
        # This is tricky because we don't want to reset the active one.
        
        # 3. Use Regex object to replace specific occurrences
        $desktopRegex = [regex]::new("(?s)(<nav[^>]*>.*?<a\s+href=`"$file`"\s+class=`")[^`"]+(`">$linkName</a>)")
        $content = $desktopRegex.Replace($content, "`${1}$desktopActiveClass`${2}", 1)
        
        $mobileRegex = [regex]::new("(?s)(<div\s+id=`"mobile-menu`"[^>]*>.*?<a\s+href=`"$file`"\s+class=`")[^`"]+(`">$linkName</a>)")
        $content = $mobileRegex.Replace($content, "`${1}$mobileActiveClass`${2}", 1)

        Set-Content $file $content
        Write-Host "Set active state for $file"
    }
}
