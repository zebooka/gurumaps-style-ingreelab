#!/usr/bin/env php
<?php

foreach (glob(__DIR__ . '/*/colors.mapcss') as $colorsFile) {
    $colorsDarkFile = dirname($colorsFile) . '/colors_dark.mapcss';
    $lines = file($colorsFile);
    foreach ($lines as $i => $line) {
        if (preg_match('@#([0-9a-f]{1,8})\s*;\s*//\s*(s|l|c):\s*(-?\d+(?:\\.\d+)?|#[0-9a-f]{1,8})@i', $line, $matches)) {
            $color = $matches[1];
            $hsla = rgb2hsl(decodeColor($color));
            if ('l' == strtolower($matches[2])) {
                $hsla[2] = 1 - $hsla[2] + (float)$matches[3];
            } elseif ('s' == strtolower($matches[2])) {
                $hsla[2] = 1 - $hsla[2];
                $hsla[1] += (float)$matches[3];
            } elseif ('c' == strtolower($matches[2])) {
            } else {
                throw new UnexpectedValueException("Unsupported color modifier {$matches[2]} for line: {$matches[0]}");
            }

            if ('c' == strtolower($matches[2])) {
                $darkColor = ltrim($matches[3], '#');
            } else {
                $darkColor = encodeColor(hsl2rgb($hsla));
            }
            echo "{$color} --- {$matches[2]}:{$matches[3]} ---> {$darkColor}\n";
            $lines[$i] = str_replace("#{$color}", "#{$darkColor}", $line);
        }
    }
    file_put_contents($colorsDarkFile, implode('', $lines));
    echo "{$colorsFile}\n --> {$colorsDarkFile}\n";
}

function decodeColor($hex)
{
    if (1 == strlen($hex)) {
        return [hexdec($hex), hexdec($hex), hexdec($hex), 255];
    } elseif (3 == strlen($hex) || 4 == strlen($hex)) {
        return [
            hexdec($hex[0] . $hex[0]),
            hexdec($hex[1] . $hex[1]),
            hexdec($hex[2] . $hex[2]),
            4 == strlen($hex) ? hexdec($hex[3] . $hex[3]) : 255
        ];
    } elseif (6 == strlen($hex) || 8 == strlen($hex)) {
        return [
            hexdec($hex[0] . $hex[1]),
            hexdec($hex[2] . $hex[3]),
            hexdec($hex[4] . $hex[5]),
            8 == strlen($hex) ? hexdec($hex[6] . $hex[7]) : 255
        ];
    } else {
        throw new \UnexpectedValueException("Can not decode color #{$hex}.");
    }
}

function encodeColor($rgba)
{
    foreach ($rgba as $i => $c) {
        $rgba[$i] = strtoupper(str_pad(dechex(min(255, max(0, $rgba[$i]))), 2, 0, STR_PAD_LEFT));
    }
    return $rgba[0] . $rgba[1] . $rgba[2] . ($rgba[3] != 'FF' ? $rgba[3] : '');
}

function rgb2hsl($rgba)
{
    $r = $rgba[0] / 255;
    $g = $rgba[1] / 255;
    $b = $rgba[2] / 255;
    $a = $rgba[3];
    $max = max($r, $g, $b);
    $min = min($r, $g, $b);
    $l = ($max + $min) / 2;
    $d = $max - $min;
    if ($d == 0) {
        $h = $s = 0;
    } else {
        $s = $d / (1 - abs(2 * $l - 1));
        switch ($max) {
            case $r:
                $h = 60 * fmod((($g - $b) / $d), 6);
                if ($b > $g) {
                    $h += 360;
                }
                break;
            case $g:
                $h = 60 * (($b - $r) / $d + 2);
                break;
            case $b:
                $h = 60 * (($r - $g) / $d + 4);
                break;
        }
    }
    return [$h, $s, $l, $a];
}

function hsl2rgb($hsla)
{
    $h = $hsla[0];
    $s = $hsla[1];
    $l = $hsla[2];
    $a = $hsla[3];
    $c = (1 - abs(2 * $l - 1)) * $s;
    $x = $c * (1 - abs(fmod(($h / 60), 2) - 1));
    $m = $l - ($c / 2);
    if ($h < 60) {
        $r = $c;
        $g = $x;
        $b = 0;
    } elseif ($h < 120) {
        $r = $x;
        $g = $c;
        $b = 0;
    } elseif ($h < 180) {
        $r = 0;
        $g = $c;
        $b = $x;
    } elseif ($h < 240) {
        $r = 0;
        $g = $x;
        $b = $c;
    } elseif ($h < 300) {
        $r = $x;
        $g = 0;
        $b = $c;
    } else {
        $r = $c;
        $g = 0;
        $b = $x;
    }
    return [floor(($r + $m) * 255), floor(($g + $m) * 255), floor(($b + $m) * 255), $a];
}
