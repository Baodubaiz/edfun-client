<#
.SYNOPSIS
  Syncs games into the hub and the SDK into games.

.DESCRIPTION
  1. Copies gamora-client/addons/gamora_sdk  ->  <game repo>/client/addons/gamora_sdk   (hub is the SDK source of truth)
  2. Copies <game repo>/client/games/<id>     ->  gamora-client/games/<id>                (game repos are the game source of truth)

  Run it before testing or building the hub. Never edit gamora-client/games/* directly.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File tools/sync_games.ps1
  powershell -ExecutionPolicy Bypass -File tools/sync_games.ps1 -GamesRoot D:\work\Gamora-Games
#>
param(
    [string]$GamesRoot = (Join-Path $PSScriptRoot "..\..\..\Gamora-Games")
)

$ErrorActionPreference = "Stop"

$hubRoot  = Resolve-Path (Join-Path $PSScriptRoot "..")
$hubSdk   = Join-Path $hubRoot "addons\gamora_sdk"
$hubGames = Join-Path $hubRoot "games"

if (-not (Test-Path $GamesRoot)) { throw "Games folder not found: $GamesRoot" }
$GamesRoot = Resolve-Path $GamesRoot
New-Item -ItemType Directory -Force $hubGames | Out-Null

$synced = 0
foreach ($repo in Get-ChildItem $GamesRoot -Directory) {
    $client = Join-Path $repo.FullName "client"
    $gamesDir = Join-Path $client "games"
    if (-not (Test-Path (Join-Path $client "project.godot")) -or -not (Test-Path $gamesDir)) { continue }

    # 1. SDK: hub -> game repo
    $gameSdk = Join-Path $client "addons\gamora_sdk"
    if (Test-Path $gameSdk) { Remove-Item $gameSdk -Recurse -Force -Confirm:$false }
    New-Item -ItemType Directory -Force (Split-Path $gameSdk) | Out-Null
    Copy-Item $hubSdk $gameSdk -Recurse
    Write-Host "SDK  -> $($repo.Name)"

    # 2. Game: game repo -> hub
    foreach ($game in Get-ChildItem $gamesDir -Directory) {
        if (-not (Test-Path (Join-Path $game.FullName "game.json"))) {
            Write-Warning "Skipping $($repo.Name)/games/$($game.Name): no game.json"
            continue
        }
        $target = Join-Path $hubGames $game.Name
        if (Test-Path $target) { Remove-Item $target -Recurse -Force -Confirm:$false }
        Copy-Item $game.FullName $target -Recurse
        Write-Host "Game <- $($repo.Name)/games/$($game.Name)"
        $synced++
    }
}

Write-Host "Done: $synced game(s) synced into $hubGames"
