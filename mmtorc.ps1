$infile = "$PSScriptRoot\export.json" # the exported file from mattermost -> # /opt/mattermost/bin/mattermost export bulk export.json --all-teams
$outdir = "$PSScriptRoot\file" # temp folder
$outfile = "$PSScriptRoot\mm-to-rocket-import.zip" # the resulting zip file that can be imported into rocket.chat via "admin -> import"
$excludeChannels = "off-topic", "town-square", "test" # channels to exclude in export
$defaultUsers = "admin" # default usernames ("admin;user1;user2") for all channels (which have to deal with adding users after finishing the import)

New-Item -ItemType Directory -Force -Path $outdir

$json = Get-Content $infile | ConvertFrom-Json

$channels = @()
foreach ($channel in $json.channel) {
    if ($channel -eq $null) {
        continue
    }
    if ($excludeChannels.Contains($channel.name)) {
        continue
    }

    "found channel: $($channel)"
    $c = @{}
    $c.Key = $channel.name
    $c.Creator = "admin"
    if ($channel.type -eq "P" ) {
        $c.Type = "private"
    }
    else {
        $c.Type = "public"
    }
    $c.Users = $defaultUsers

    New-Item -ItemType Directory -Force -Path "$outdir\$($channel.name)"

    $channels += $c
}

$channels 
| select "Key", "Creator", "Type", "Users" 
| ConvertTo-Csv -Delimiter "," -UseQuotes Always 
| select -Skip 1 > "$outdir\channels.csv"
 
$posts = @{}
foreach ($post in $json.post) {
    if ($post -eq $null) {
        continue
    }
    if ($excludeChannels.Contains($post.channel)) {
        continue
    }
    $p = @{}
    $p.User = $post.user
    $p.Time = $post.create_at
    $p.Message = $post.message #-replace "`"", "'"
    if (!$posts.ContainsKey($post.channel)) {
        $newList = New-Object System.Collections.ArrayList($null)
        $posts.add($post.channel, $newList)
    }
    $channelPosts = $posts[$post.channel]
    $channelPosts.Add($p)
}

foreach ($channel in $posts.Keys) {
    $postsForChannel = $posts[$channel]
    $postsForChannel
    | select "User", "Time", "Message"
    | ConvertTo-Csv -Delimiter "," -UseQuotes Always 
    | select -Skip 1 > "$outdir\$channel\messages.csv"
}

Remove-Item -Force -Path $outfile
Compress-Archive -Path "$outdir\*" -DestinationPath $outfile
Remove-Item -Recurse -Force -Path $outdir
