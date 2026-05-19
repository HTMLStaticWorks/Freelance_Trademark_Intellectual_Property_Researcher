$port = 3000
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://127.0.0.1:$port/")
try {
    $listener.Start()
    Write-Output "Server successfully started on http://127.0.0.1:$port/"
} catch {
    Write-Error "Failed to start listener: $_"
    exit 1
}

$root = "d:\projects\Freelance Trademark & Intellectual Property Researcher"

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $url = $request.Url.LocalPath
        if ($url -eq "/") { $url = "/index.html" }
        # Normalize path separators
        $url = $url.Replace("/", "\")
        $filePath = Join-Path $root $url
        
        if (Test-Path $filePath -PathType Leaf) {
            $bytes = [System.IO.File]::ReadAllBytes($filePath)
            $extension = [System.IO.Path]::GetExtension($filePath).ToLower()
            $contentType = "text/html"
            if ($extension -eq ".css") { $contentType = "text/css" }
            elseif ($extension -eq ".js") { $contentType = "application/javascript" }
            elseif ($extension -eq ".png") { $contentType = "image/png" }
            elseif ($extension -eq ".jpg" -or $extension -eq ".jpeg") { $contentType = "image/jpeg" }
            elseif ($extension -eq ".svg") { $contentType = "image/svg+xml" }
            
            $response.ContentType = $contentType
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $response.StatusCode = 404
            $errBytes = [System.Text.Encoding]::UTF8.GetBytes("File Not Found: $filePath")
            $response.OutputStream.Write($errBytes, 0, $errBytes.Length)
        }
        $response.Close()
    } catch {
        # Silent fail on socket close, keep listening
    }
}
