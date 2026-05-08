$files = @("index.html", "home2.html", "services.html", "pricing.html", "reports.html", "search-methodology.html", "database-access.html", "about.html", "contact.html")

$desktopDropdown = @"
                    <div class="relative group">
                        <button class="text-gray-600 dark:text-gray-300 hover:text-primary dark:hover:text-secondary font-medium px-4 py-2 rounded-full transition-all text-sm hover:bg-white dark:hover:bg-white/10 flex items-center gap-1 cursor-pointer">
                            Home <i data-lucide="chevron-down" class="w-4 h-4 transition-transform group-hover:rotate-180"></i>
                        </button>
                        <div class="absolute left-0 mt-2 w-48 bg-white dark:bg-dark-card border border-gray-100 dark:border-white/10 rounded-xl shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 transform translate-y-2 group-hover:translate-y-0 z-50">
                            <a href="index.html" class="block px-4 py-3 text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-white/5 hover:text-primary dark:hover:text-secondary border-b border-gray-100 dark:border-white/5 rounded-t-xl">Corporate Home</a>
                            <a href="home2.html" class="block px-4 py-3 text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-white/5 hover:text-primary dark:hover:text-secondary rounded-b-xl">Cinematic Home</a>
                        </div>
                    </div>
"@

$mobileDropdown = @"
                <div class="accordion-item w-full">
                    <button class="w-full px-4 py-3 rounded-xl text-base font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-white/5 flex justify-between items-center transition-colors">
                        Home
                        <i data-lucide="chevron-down" class="w-5 h-5 text-gray-500 transition-transform duration-300"></i>
                    </button>
                    <div class="accordion-content">
                        <div class="px-4 pb-2 pt-1">
                            <a href="index.html" class="block px-4 py-2 rounded-lg text-sm text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-white/10 transition-colors">Corporate Home</a>
                            <a href="home2.html" class="block px-4 py-2 mt-1 rounded-lg text-sm text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-white/10 transition-colors">Cinematic Home</a>
                        </div>
                    </div>
                </div>
"@

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        
        # We need to replace the first occurrence (desktop nav) and second occurrence (mobile nav)
        # But wait, the regex is the same for both if we don't care. Let's just do a regex replace.
        # But desktop has text-white... etc.
        
        # First match is desktop nav, second is mobile nav. The exact strings might have different classes.
        # Actually we can just do a regex replace.
        $regex = '(?s)<a href="index\.html" class="[^"]*">Home</a>\s*<a href="home2\.html" class="[^"]*">Home 2</a>'
        
        # Let's replace the first one with desktop dropdown, and the second one with mobile dropdown.
        # PowerShell -replace replaces all occurrences. So we can use a callback or index.
        $matches = [regex]::Matches($content, $regex)
        
        if ($matches.Count -eq 2) {
            $content = $content.Substring(0, $matches[0].Index) + $desktopDropdown + $content.Substring($matches[0].Index + $matches[0].Length)
            # Find the second match again because string length changed
            $matches = [regex]::Matches($content, $regex)
            if ($matches.Count -eq 1) {
                $content = $content.Substring(0, $matches[0].Index) + $mobileDropdown + $content.Substring($matches[0].Index + $matches[0].Length)
            }
            Set-Content $file $content
            Write-Host "Updated $file"
        } else {
            Write-Host "Could not find exactly 2 matches in $file (found $($matches.Count))"
        }
    }
}
