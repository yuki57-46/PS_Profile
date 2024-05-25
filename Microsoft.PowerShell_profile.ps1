$script = "$Home\profile.ps1"
if (Test-Path $script) {
  . $script
}

# 必要になったら実行できるようにしておく
# en: Be ready to run when needed
# Import posh-git
function Use-PoshGit {
  Import-Module posh-git
}

# ネットワーク接続を確認するための関数
# en: Function to check network connection
function Test-NetworkConnection {
  try {
    $pingResult = Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet -ErrorAction SilentlyContinue
    return $pingResult
  } 
  catch {
    return $false
  }
}

#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

# ネットワークがオフラインの場合は、実行しない
# en: Do not execute if the network is offline
if (Test-NetworkConnection)
{# オンラインの場合のみ実行できる
  # en: Can only be executed if online
  Import-Module -Name Microsoft.WinGet.CommandNotFound
}

# Oh-My-Posh theme
oh-my-posh init pwsh --config "~\AppData\Local\Programs\oh-my-posh\themes\rudolfs-dark.omp.json" | Invoke-Expression

# zsh-like tab completion
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete


# Terminal-Icons
Import-Module Terminal-Icons

# winget completion
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}




