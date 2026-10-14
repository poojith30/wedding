Add-Type -AssemblyName System.Drawing

$images = @(
    @{ File = "01-hero-wedding.jpg"; W = 1920; H = 1080; Ratio = "16:9"; Time = "Dawn"; Title = "Hero Cover · Hyderabad, India"; Dark = $true },
    @{ File = "02-hyderabad-dawn.jpg"; W = 1200; H = 1600; Ratio = "3:4"; Time = "05:00 AM"; Title = "Chapter 1 · The City Wakes"; Dark = $false },
    @{ File = "03-mothers-hands.jpg"; W = 1200; H = 1500; Ratio = "4:5"; Time = "06:00 AM"; Title = "Chapter 2 · A Mother's Hands"; Dark = $false },
    @{ File = "04-groom-moment.jpg"; W = 1200; H = 900; Ratio = "4:3"; Time = "07:00 AM"; Title = "Chapter 3 · The Groom's Quiet Moment"; Dark = $false },
    @{ File = "05-wedding-details.jpg"; W = 1200; H = 1600; Ratio = "3:4"; Time = "08:00 AM"; Title = "Chapter 4 · Two Traditions, One Wedding Day"; Dark = $false },
    @{ File = "06-family-conversation.jpg"; W = 1920; H = 1080; Ratio = "16:9"; Time = "10:00 AM"; Title = "Chapter 5 · The Conversation Behind the Celebration"; Dark = $false },
    @{ File = "07-hindu-ceremony.jpg"; W = 1500; H = 1200; Ratio = "5:4"; Time = "12:00 PM"; Title = "Chapter 6 · A Ceremony Rich in Meaning"; Dark = $false },
    @{ File = "08-family-moments.jpg"; W = 1200; H = 1600; Ratio = "3:4"; Time = "02:00 PM"; Title = "Chapter 7 · Beyond the Rituals"; Dark = $false },
    @{ File = "09-nikah-ceremony.jpg"; W = 1200; H = 1500; Ratio = "4:5"; Time = "04:00 PM"; Title = "Chapter 8 · Understanding the Nikah"; Dark = $false },
    @{ File = "10-two-families.jpg"; W = 2000; H = 1000; Ratio = "2:1"; Time = "06:00 PM"; Title = "Chapter 9 · When Two Families Share a Room"; Dark = $false },
    @{ File = "11-evening-celebration.jpg"; W = 1920; H = 1080; Ratio = "16:9"; Time = "08:00 PM"; Title = "Chapter 10 · Hyderabad Serves Up a Celebration"; Dark = $false },
    @{ File = "12-couple-portrait.jpg"; W = 1200; H = 1600; Ratio = "3:4"; Time = "10:00 PM"; Title = "Chapter 11 · A Photograph of the Future"; Dark = $false },
    @{ File = "13-midnight-ending.jpg"; W = 1920; H = 1080; Ratio = "16:9"; Time = "12:00 AM"; Title = "Chapter 12 · The Wedding Ends, the Marriage Begins"; Dark = $true }
)

$outDir = "c:\Users\Poojith\OneDrive\Desktop\wedding\public\images"
if (!(Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force }

foreach ($item in $images) {
    $bmp = New-Object System.Drawing.Bitmap($item.W, $item.H)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    if ($item.Dark) {
        $bg = [System.Drawing.Color]::FromArgb(38, 20, 26) # deep wine / dark charcoal
        $gold = [System.Drawing.Color]::FromArgb(196, 168, 115)
        $textMain = [System.Drawing.Color]::FromArgb(250, 246, 238)
        $textMuted = [System.Drawing.Color]::FromArgb(180, 160, 140)
    } else {
        $bg = [System.Drawing.Color]::FromArgb(238, 231, 220) # soft cream #EEE7DC
        $gold = [System.Drawing.Color]::FromArgb(180, 154, 101) # antique gold #B49A65
        $textMain = [System.Drawing.Color]::FromArgb(41, 39, 37) # charcoal #292725
        $textMuted = [System.Drawing.Color]::FromArgb(100, 44, 59) # burgundy #642C3B
    }

    $bgBrush = New-Object System.Drawing.SolidBrush($bg)
    $g.FillRectangle($bgBrush, 0, 0, $item.W, $item.H)

    # Double rule borders
    $borderPen = New-Object System.Drawing.Pen($gold, 2)
    $g.DrawRectangle($borderPen, 30, 30, ($item.W - 60), ($item.H - 60))
    $innerPen = New-Object System.Drawing.Pen($gold, 1)
    $g.DrawRectangle($innerPen, 42, 42, ($item.W - 84), ($item.H - 84))

    # Corner decorative squares
    $cornerSize = 14
    $corners = @(
        @{ X = 42; Y = 42 },
        @{ X = ($item.W - 42 - $cornerSize); Y = 42 },
        @{ X = 42; Y = ($item.H - 42 - $cornerSize) },
        @{ X = ($item.W - 42 - $cornerSize); Y = ($item.H - 42 - $cornerSize) }
    )
    $goldBrush = New-Object System.Drawing.SolidBrush($gold)
    foreach ($c in $corners) {
        $g.FillRectangle($goldBrush, $c.X, $c.Y, $cornerSize, $cornerSize)
    }

    # Ornamental center diamond
    $midX = [int]($item.W / 2)
    $midY = [int]($item.H / 2)
    $polyPoints = @(
        (New-Object System.Drawing.Point($midX, ($midY - 140))),
        (New-Object System.Drawing.Point(($midX + 70), ($midY - 70))),
        (New-Object System.Drawing.Point($midX, $midY)),
        (New-Object System.Drawing.Point(($midX - 70), ($midY - 70)))
    )
    $polyPen = New-Object System.Drawing.Pen($gold, 1.5)
    $g.DrawPolygon($polyPen, $polyPoints)

    # Typography
    $titleFont = New-Object System.Drawing.Font("Georgia", 26, [System.Drawing.FontStyle]::Regular)
    $labelFont = New-Object System.Drawing.Font("Georgia", 13, [System.Drawing.FontStyle]::Italic)
    $metaFont = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Regular)
    $stampFont = New-Object System.Drawing.Font("Georgia", 10, [System.Drawing.FontStyle]::Bold)

    $formatCenter = New-Object System.Drawing.StringFormat
    $formatCenter.Alignment = [System.Drawing.StringAlignment]::Center
    $formatCenter.LineAlignment = [System.Drawing.StringAlignment]::Center

    $mainBrush = New-Object System.Drawing.SolidBrush($textMain)
    $mutedBrush = New-Object System.Drawing.SolidBrush($textMuted)

    # Top category stamp
    $stampRect = New-Object System.Drawing.RectangleF(60, 60, ($item.W - 120), 40)
    $g.DrawString("HYDERABAD DOCUMENTARY · ARCHIVAL PHOTOGRAPHIC SPECIFICATION", $stampFont, $goldBrush, $stampRect, $formatCenter)

    # Center text blocks
    $titleRect = New-Object System.Drawing.RectangleF(80, ($midY + 20), ($item.W - 160), 60)
    $g.DrawString($item.Title, $titleFont, $mainBrush, $titleRect, $formatCenter)

    $timeRect = New-Object System.Drawing.RectangleF(80, ($midY + 85), ($item.W - 160), 30)
    $g.DrawString("$($item.Time) · Aspect Ratio $($item.Ratio) ($($item.W) x $($item.H) px)", $labelFont, $mutedBrush, $timeRect, $formatCenter)

    $fileRect = New-Object System.Drawing.RectangleF(80, ($midY + 125), ($item.W - 160), 30)
    $g.DrawString("Expected File: /images/$($item.File)", $metaFont, $mutedBrush, $fileRect, $formatCenter)

    # Bottom colophon
    $bottomRect = New-Object System.Drawing.RectangleF(60, ($item.H - 90), ($item.W - 120), 30)
    $g.DrawString("Tasteful layout geometry placeholder · Preserving visual cadence and aspect ratio", $metaFont, $goldBrush, $bottomRect, $formatCenter)

    # Save as high quality JPEG
    $filePath = Join-Path $outDir $item.File
    $encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.FormatDescription -eq "JPEG" }
    $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 92L)
    $bmp.Save($filePath, $encoder, $encoderParams)

    $g.Dispose()
    $bmp.Dispose()
    Write-Output "Generated: $($item.File)"
}
