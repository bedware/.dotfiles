# function vichad()
# {
#   $env:NVIM_APPNAME="NvChad"
#   nvim $args
# }

function vis()
{
  $items = "default", "NvChad", "AstroNvim", "LazyVim"
  $config = $items | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0

  if ([string]::IsNullOrEmpty($config))
  {
    Write-Output "Nothing selected"
    break
  }
 
  if ($config -eq "default")
  {
    $config = ""
  }

  $env:NVIM_APPNAME=$config
  nvim $args
}
