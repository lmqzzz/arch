#Requires AutoHotkey v2.0
#SingleInstance Force

; Focus the app if it's already open, otherwise launch it
FocusOrRun(exe, cmd) {
    if WinExist("ahk_exe " exe) {
        WinActivate
        return
    }
    Run cmd
}

!l::FocusOrRun("LeagueClientUx.exe", '"C:\Riot Games\Riot Client\RiotClientServices.exe" --launch-product=league_of_legends --launch-patchline=live')
!s::FocusOrRun("steamwebhelper.exe", '"C:\Program Files (x86)\Steam\steam.exe"')
!/::FocusOrRun("brave.exe", '"C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"')
!d::FocusOrRun("Discord.exe", '"' EnvGet("LOCALAPPDATA") '\Discord\Update.exe" --processStart Discord.exe')
!y::FocusOrRun("YouTube Music.exe", '"' EnvGet("LOCALAPPDATA") '\Programs\youtube-music\YouTube Music.exe"')

; Alacritty: always open a new terminal window and switch to it
!Enter:: {
    Run '"C:\Program Files\Alacritty\alacritty.exe"', , , &pid
    if WinWait("ahk_pid " pid, , 5)
        WinActivate
}
