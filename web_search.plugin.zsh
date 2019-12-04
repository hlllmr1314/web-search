## depending of xdg-utils
## https://github.com/theskumar/dotfiles/blob/master/.zsh/plugins/web_search/web_search.plugin.zsh

function web_search() {
  # get the open command
  local open_cmd
  [[ "$OSTYPE" = linux* ]] && open_cmd='xdg-open'
  [[ "$OSTYPE" = darwin* ]] && open_cmd='open'

  pattern='(google|duckduckgo|bing|yahoo|github|youtube|baidu|xcserver|ciserver|jira|confluence)'

  if [[ "$1" == 'xcserver' ]]; then
    url="http:xcserver:8080/"
    $open_cmd "$url"
    return
  fi

  if [[ "$1" == 'ciserver' ]]; then
    url="http:ciserver:8080/"
    $open_cmd "$url"
    return
  fi

  # if [[ "$1" == 'confluence' ]]; then
  #   url="https://confluence.ecarx.com.cn"
  #   $open_cmd "$url"
  #   return
  # fi

  # check whether the search engine is supported
  if [[ $1 =~ pattern ]];
  then
    echo "Search engine $1 not supported."
    return 1
  fi

  local url
  ([[ "$1" == 'yahoo' ]] && url="https://search.yahoo.com") || url="https://www.$1.com"
  
  if [[ "$1" == 'jira' ]]; then
    url="https://jira.ecarx.com.cn"
  fi

   if [[ "$1" == 'confluence' ]]; then
    url="https://confluence.ecarx.com.cn"
  fi

  # no keyword provided, simply open the search engine homepage
  if [[ $# -le 1 ]]; then
    $open_cmd "$url"
    return
  fi

  typeset -A search_syntax=(
    google     "/search?q="
    bing       "/search?q="
    github     "/search?q="
    duckduckgo "/?q="
    yahoo      "/search?p="
    youtube    "/results?search_query="
    baidu      "/s?wd="
    jira       "/browse/"
    confluence "/dosearchsite.action?queryString="
  )

  url="${url}${search_syntax[$1]}"
  shift   # shift out $1

  while [[ $# -gt 0 ]]; do
    url="${url}$1+"
    shift
  done

  url="${url%?}" # remove the last '+'
  nohup $open_cmd "$url" &> /dev/null
}

alias bing='web_search bing'
alias google='web_search google'
alias yahoo='web_search yahoo'
alias ddg='web_search duckduckgo'
alias github='web_search github'
alias youtube='web_search youtube'
alias baidu='web_search baidu'
alias xcserver='web_search xcserver'
alias jira='web_search jira'
alias confluence='web_search confluence'

#add your own !bang searches here
alias wiki='web_search duckduckgo \!w'
alias news='web_search duckduckgo \!n'
alias map='web_search duckduckgo \!m'
alias image='web_search duckduckgo \!i'
alias ducky='web_search duckduckgo \!'
