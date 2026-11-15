# Editable, code-native Soft Kitty icons. Generates a single Roblox sprite atlas.
Add-Type -AssemblyName System.Drawing
$assetDir = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../assets'))
$atlas = [System.Drawing.Bitmap]::new(512,192)
$g = [System.Drawing.Graphics]::FromImage($atlas)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$pen = [System.Drawing.Pen]::new([System.Drawing.Color]::White,3.4)
$pen.StartCap = $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$pen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
function Line($x1,$y1,$x2,$y2) { $g.DrawLine($pen,[single]$x1,[single]$y1,[single]$x2,[single]$y2) }
function Ellipse($x,$y,$w,$h) { $g.DrawEllipse($pen,[single]$x,[single]$y,[single]$w,[single]$h) }
function Rect($x,$y,$w,$h) { $g.DrawRectangle($pen,[single]$x,[single]$y,[single]$w,[single]$h) }
function Paw {
    Ellipse 16 16 8 10; Ellipse 28 11 8 11; Ellipse 40 16 8 10
    $p = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $p.AddBezier(17,41,19,29,25,26,32,29); $p.AddBezier(32,29,39,26,45,29,47,41)
    $p.AddBezier(47,41,48,50,39,50,32,46); $p.AddBezier(32,46,25,50,16,50,17,41)
    $g.DrawPath($pen,$p); $p.Dispose()
}
$names = @('Home','QB','Catching','Kicker','Player','Physics','Visual','Defense','Automatics','Trolling','Misc','World','Settings','Search','Close','Minimize','Chevron','Paw')
for ($i=0; $i -lt $names.Count; $i++) {
    $state=$g.Save(); $g.TranslateTransform(($i % 8)*64, [math]::Floor($i/8)*64)
    switch ($names[$i]) {
        Home { Line 13 30 32 14; Line 32 14 51 30; Line 18 27 18 49; Line 46 27 46 49; Line 18 49 46 49; Line 28 49 28 36; Line 28 36 36 36; Line 36 36 36 49 }
        QB { Ellipse 13 20 38 24; Line 23 32 41 32; Line 27 27 27 37; Line 33 27 33 37; Line 39 27 39 37 }
        Catching { Paw }
        Kicker { Line 21 14 29 30; Line 29 30 45 39; Line 45 39 50 48; Line 50 48 25 48; Line 25 48 15 35; Line 15 35 21 24; Line 40 19 48 13 }
        Player { Ellipse 24 14 16 16; $g.DrawArc($pen,16,32,32,30,185,170) }
        Physics { Ellipse 27 27 10 10; Ellipse 10 23 44 18; $g.DrawArc($pen,21,9,22,46,0,360) }
        Visual { $p=[System.Drawing.Drawing2D.GraphicsPath]::new(); $p.AddBezier(10,32,22,13,42,13,54,32); $p.AddBezier(54,32,42,51,22,51,10,32); $g.DrawPath($pen,$p); $p.Dispose(); Ellipse 25 25 14 14 }
        Defense { $p=[System.Drawing.Drawing2D.GraphicsPath]::new(); $p.AddLines([System.Drawing.PointF[]]@([System.Drawing.PointF]::new(16,18),[System.Drawing.PointF]::new(32,12),[System.Drawing.PointF]::new(48,18),[System.Drawing.PointF]::new(46,37),[System.Drawing.PointF]::new(32,51),[System.Drawing.PointF]::new(18,37))); $p.CloseFigure(); $g.DrawPath($pen,$p); $p.Dispose(); Line 24 31 30 37; Line 30 37 41 25 }
        Automatics { Line 35 12 20 34; Line 20 34 32 34; Line 32 34 28 52; Line 28 52 45 27; Line 45 27 33 27; Line 33 27 35 12 }
        Trolling { Line 18 25 20 13; Line 20 13 30 20; Line 34 20 44 13; Line 44 13 47 26; $g.DrawArc($pen,16,19,32,32,0,180); Ellipse 23 29 2 3; Ellipse 39 29 2 3; Line 29 38 35 38; Line 11 33 20 34; Line 44 34 53 33 }
        Misc { Rect 14 14 13 13; Rect 37 14 13 13; Rect 14 37 13 13; Rect 37 37 13 13 }
        World { Ellipse 12 12 40 40; Ellipse 23 12 18 40; Line 13 32 51 32; $g.DrawArc($pen,13,21,38,21,0,180) }
        Settings { Ellipse 20 20 24 24; Ellipse 27 27 10 10; foreach ($a in 0,45,90,135,180,225,270,315) { $r=$a*[Math]::PI/180; Line (32+15*[Math]::Cos($r)) (32+15*[Math]::Sin($r)) (32+21*[Math]::Cos($r)) (32+21*[Math]::Sin($r)) } }
        Search { Ellipse 14 13 27 27; Line 37 37 50 50 }
        Close { Line 19 19 45 45; Line 45 19 19 45 }
        Minimize { Line 17 34 47 34 }
        Chevron { Line 23 18 38 32; Line 38 32 23 46 }
        Paw { Paw }
    }
    $g.Restore($state)
}
$atlas.Save((Join-Path $assetDir 'mochi-icons-v1.png'),[System.Drawing.Imaging.ImageFormat]::Png)
# Separate pink paw for cursor and subtle static decorations.
$paw = [System.Drawing.Bitmap]::new(64,64)
$pg = [System.Drawing.Graphics]::FromImage($paw)
$pg.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$pg.DrawImage($atlas,[System.Drawing.Rectangle]::new(0,0,64,64),[System.Drawing.Rectangle]::new(64,128,64,64),[System.Drawing.GraphicsUnit]::Pixel)
$pg.Dispose()
for ($y=0;$y -lt 64;$y++) { for ($x=0;$x -lt 64;$x++) { $a=$paw.GetPixel($x,$y).A; if ($a) { $paw.SetPixel($x,$y,[System.Drawing.Color]::FromArgb($a,232,140,183)) } } }
$paw.Save((Join-Path $assetDir 'mochi-paw-v1.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $pen.Dispose(); $atlas.Dispose(); $paw.Dispose()
Write-Output 'Rendered 18 Soft Kitty icons and a paw cursor.'
