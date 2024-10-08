#compdef railway

autoload -U is-at-least

_railway() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    _arguments "${_arguments_options[@]}" \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
":: :_railway_commands" \
"*::: :->railwayapp" \
&& ret=0
    case $state in
    (railwayapp)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:railway-command-$line[1]:"
        case $line[1] in
            (add)
_arguments "${_arguments_options[@]}" \
'*-p+[The name of the plugin to add]:PLUGIN:(postgresql mysql redis mongodb)' \
'*--plugin=[The name of the plugin to add]:PLUGIN:(postgresql mysql redis mongodb)' \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
&& ret=0
;;
(completion)
_arguments "${_arguments_options[@]}" \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
':shell:(bash elvish fish powershell zsh)' \
&& ret=0
;;
(connect)
_arguments "${_arguments_options[@]}" \
'-e+[Environment to pull variables from (defaults to linked environment)]:ENVIRONMENT: ' \
'--environment=[Environment to pull variables from (defaults to linked environment)]:ENVIRONMENT: ' \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
'::service_name -- The name of the plugin to connect to:' \
&& ret=0
;;
(delete)
_arguments "${_arguments_options[@]}" \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
&& ret=0
;;
(domain)
_arguments "${_arguments_options[@]}" \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
&& ret=0
;;
(docs)
_arguments "${_arguments_options[@]}" \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
&& ret=0
;;
(down)
_arguments "${_arguments_options[@]}" \
'-s+[Service to remove the deployment from (defaults to linked service)]:SERVICE: ' \
'--service=[Service to remove the deployment from (defaults to linked service)]:SERVICE: ' \
'-e+[Environment to remove the deployment from (defaults to linked environment)]:ENVIRONMENT: ' \
'--environment=[Environment to remove the deployment from (defaults to linked environment)]:ENVIRONMENT: ' \
'-y[Skip confirmation dialog]' \
'--yes[Skip confirmation dialog]' \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
&& ret=0
;;
(environment)
_arguments "${_arguments_options[@]}" \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
'::environment -- The environment to link to:' \
&& ret=0
;;
(init)
_arguments "${_arguments_options[@]}" \
'-n+[Project name]:NAME: ' \
'--name=[Project name]:NAME: ' \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
&& ret=0
;;
(link)
_arguments "${_arguments_options[@]}" \
'--environment=[Environment to link to]:ENVIRONMENT: ' \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
'::project_id -- Project ID to link to:' \
'::service -- The service to link:' \
&& ret=0
;;
(list)
_arguments "${_arguments_options[@]}" \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
&& ret=0
;;
(login)
_arguments "${_arguments_options[@]}" \
'-b[Browserless login]' \
'--browserless[Browserless login]' \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
&& ret=0
;;
(logout)
_arguments "${_arguments_options[@]}" \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
&& ret=0
;;
(logs)
_arguments "${_arguments_options[@]}" \
'-s+[Service to view logs from (defaults to linked service)]:SERVICE: ' \
'--service=[Service to view logs from (defaults to linked service)]:SERVICE: ' \
'-e+[Environment to view logs from (defaults to linked environment)]:ENVIRONMENT: ' \
'--environment=[Environment to view logs from (defaults to linked environment)]:ENVIRONMENT: ' \
'-d[Show deployment logs]' \
'--deployment[Show deployment logs]' \
'-b[Show build logs]' \
'--build[Show build logs]' \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
'::deployment_id -- Deployment ID to pull logs from. Omit to pull from latest deloy:' \
&& ret=0
;;
(open)
_arguments "${_arguments_options[@]}" \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
&& ret=0
;;
(run)
_arguments "${_arguments_options[@]}" \
'-s+[Service to pull variables from (defaults to linked service)]:SERVICE: ' \
'--service=[Service to pull variables from (defaults to linked service)]:SERVICE: ' \
'-e+[Environment to pull variables from (defaults to linked environment)]:ENVIRONMENT: ' \
'--environment=[Environment to pull variables from (defaults to linked environment)]:ENVIRONMENT: ' \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
'*::args -- Args to pass to the command:' \
&& ret=0
;;
(service)
_arguments "${_arguments_options[@]}" \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
'::service -- The service to link:' \
&& ret=0
;;
(shell)
_arguments "${_arguments_options[@]}" \
'-s+[Service to pull variables from (defaults to linked service)]:SERVICE: ' \
'--service=[Service to pull variables from (defaults to linked service)]:SERVICE: ' \
'--silent[Open shell without banner]' \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
&& ret=0
;;
(starship)
_arguments "${_arguments_options[@]}" \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
&& ret=0
;;
(status)
_arguments "${_arguments_options[@]}" \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
&& ret=0
;;
(unlink)
_arguments "${_arguments_options[@]}" \
'-s[Unlink a service]' \
'--service[Unlink a service]' \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
&& ret=0
;;
(up)
_arguments "${_arguments_options[@]}" \
'-s+[Service to deploy to (defaults to linked service)]:SERVICE: ' \
'--service=[Service to deploy to (defaults to linked service)]:SERVICE: ' \
'-e+[Environment to deploy to (defaults to linked environment)]:ENVIRONMENT: ' \
'--environment=[Environment to deploy to (defaults to linked environment)]:ENVIRONMENT: ' \
'-d[Don'\''t attach to the log stream]' \
'--detach[Don'\''t attach to the log stream]' \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
'::path:_files' \
&& ret=0
;;
(variables)
_arguments "${_arguments_options[@]}" \
'-s+[Service to show variables for]:SERVICE: ' \
'--service=[Service to show variables for]:SERVICE: ' \
'-k[Show variables in KV format]' \
'--kv[Show variables in KV format]' \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
&& ret=0
;;
(whoami)
_arguments "${_arguments_options[@]}" \
'--json[Output in JSON format]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
":: :_railway__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:railway-help-command-$line[1]:"
        case $line[1] in
            (add)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(completion)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(connect)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(delete)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(domain)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(docs)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(down)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(environment)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(init)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(link)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(list)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(login)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(logout)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(logs)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(open)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(run)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(service)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(shell)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(starship)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(status)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(unlink)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(up)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(variables)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(whoami)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
        esac
    ;;
esac
;;
        esac
    ;;
esac
}

(( $+functions[_railway_commands] )) ||
_railway_commands() {
    local commands; commands=(
'add:Add a new plugin to your project' \
'completion:Generate completion script' \
'connect:Connect to a plugin'\''s shell (psql for Postgres, mongosh for MongoDB, etc.)' \
'delete:Delete plugins from a project' \
'domain:Generates a domain for a service if there is not a railway provided domain' \
'docs:Open Railway Documentation in default browser' \
'down:Remove the most recent deployment' \
'environment:Change the active environment' \
'init:Create a new project' \
'link:Associate existing project with current directory, may specify projectId as an argument' \
'list:List all projects in your Railway account' \
'login:Login to your Railway account' \
'logout:Logout of your Railway account' \
'logs:View a deploy'\''s logs' \
'open:Open your project dashboard' \
'run:Run a local command using variables from the active environment' \
'service:Link a service to the current project' \
'shell:Open a local subshell with Railway variables available' \
'starship:Starship Metadata' \
'status:Show information about the current project' \
'unlink:Disassociate project from current directory' \
'up:Upload and deploy project from the current directory' \
'variables:Show variables for active environment' \
'whoami:Get the current logged in user' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'railway commands' commands "$@"
}
(( $+functions[_railway__add_commands] )) ||
_railway__add_commands() {
    local commands; commands=()
    _describe -t commands 'railway add commands' commands "$@"
}
(( $+functions[_railway__help__add_commands] )) ||
_railway__help__add_commands() {
    local commands; commands=()
    _describe -t commands 'railway help add commands' commands "$@"
}
(( $+functions[_railway__completion_commands] )) ||
_railway__completion_commands() {
    local commands; commands=()
    _describe -t commands 'railway completion commands' commands "$@"
}
(( $+functions[_railway__help__completion_commands] )) ||
_railway__help__completion_commands() {
    local commands; commands=()
    _describe -t commands 'railway help completion commands' commands "$@"
}
(( $+functions[_railway__connect_commands] )) ||
_railway__connect_commands() {
    local commands; commands=()
    _describe -t commands 'railway connect commands' commands "$@"
}
(( $+functions[_railway__help__connect_commands] )) ||
_railway__help__connect_commands() {
    local commands; commands=()
    _describe -t commands 'railway help connect commands' commands "$@"
}
(( $+functions[_railway__delete_commands] )) ||
_railway__delete_commands() {
    local commands; commands=()
    _describe -t commands 'railway delete commands' commands "$@"
}
(( $+functions[_railway__help__delete_commands] )) ||
_railway__help__delete_commands() {
    local commands; commands=()
    _describe -t commands 'railway help delete commands' commands "$@"
}
(( $+functions[_railway__docs_commands] )) ||
_railway__docs_commands() {
    local commands; commands=()
    _describe -t commands 'railway docs commands' commands "$@"
}
(( $+functions[_railway__help__docs_commands] )) ||
_railway__help__docs_commands() {
    local commands; commands=()
    _describe -t commands 'railway help docs commands' commands "$@"
}
(( $+functions[_railway__domain_commands] )) ||
_railway__domain_commands() {
    local commands; commands=()
    _describe -t commands 'railway domain commands' commands "$@"
}
(( $+functions[_railway__help__domain_commands] )) ||
_railway__help__domain_commands() {
    local commands; commands=()
    _describe -t commands 'railway help domain commands' commands "$@"
}
(( $+functions[_railway__down_commands] )) ||
_railway__down_commands() {
    local commands; commands=()
    _describe -t commands 'railway down commands' commands "$@"
}
(( $+functions[_railway__help__down_commands] )) ||
_railway__help__down_commands() {
    local commands; commands=()
    _describe -t commands 'railway help down commands' commands "$@"
}
(( $+functions[_railway__environment_commands] )) ||
_railway__environment_commands() {
    local commands; commands=()
    _describe -t commands 'railway environment commands' commands "$@"
}
(( $+functions[_railway__help__environment_commands] )) ||
_railway__help__environment_commands() {
    local commands; commands=()
    _describe -t commands 'railway help environment commands' commands "$@"
}
(( $+functions[_railway__help_commands] )) ||
_railway__help_commands() {
    local commands; commands=(
'add:Add a new plugin to your project' \
'completion:Generate completion script' \
'connect:Connect to a plugin'\''s shell (psql for Postgres, mongosh for MongoDB, etc.)' \
'delete:Delete plugins from a project' \
'domain:Generates a domain for a service if there is not a railway provided domain' \
'docs:Open Railway Documentation in default browser' \
'down:Remove the most recent deployment' \
'environment:Change the active environment' \
'init:Create a new project' \
'link:Associate existing project with current directory, may specify projectId as an argument' \
'list:List all projects in your Railway account' \
'login:Login to your Railway account' \
'logout:Logout of your Railway account' \
'logs:View a deploy'\''s logs' \
'open:Open your project dashboard' \
'run:Run a local command using variables from the active environment' \
'service:Link a service to the current project' \
'shell:Open a local subshell with Railway variables available' \
'starship:Starship Metadata' \
'status:Show information about the current project' \
'unlink:Disassociate project from current directory' \
'up:Upload and deploy project from the current directory' \
'variables:Show variables for active environment' \
'whoami:Get the current logged in user' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'railway help commands' commands "$@"
}
(( $+functions[_railway__help__help_commands] )) ||
_railway__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'railway help help commands' commands "$@"
}
(( $+functions[_railway__help__init_commands] )) ||
_railway__help__init_commands() {
    local commands; commands=()
    _describe -t commands 'railway help init commands' commands "$@"
}
(( $+functions[_railway__init_commands] )) ||
_railway__init_commands() {
    local commands; commands=()
    _describe -t commands 'railway init commands' commands "$@"
}
(( $+functions[_railway__help__link_commands] )) ||
_railway__help__link_commands() {
    local commands; commands=()
    _describe -t commands 'railway help link commands' commands "$@"
}
(( $+functions[_railway__link_commands] )) ||
_railway__link_commands() {
    local commands; commands=()
    _describe -t commands 'railway link commands' commands "$@"
}
(( $+functions[_railway__help__list_commands] )) ||
_railway__help__list_commands() {
    local commands; commands=()
    _describe -t commands 'railway help list commands' commands "$@"
}
(( $+functions[_railway__list_commands] )) ||
_railway__list_commands() {
    local commands; commands=()
    _describe -t commands 'railway list commands' commands "$@"
}
(( $+functions[_railway__help__login_commands] )) ||
_railway__help__login_commands() {
    local commands; commands=()
    _describe -t commands 'railway help login commands' commands "$@"
}
(( $+functions[_railway__login_commands] )) ||
_railway__login_commands() {
    local commands; commands=()
    _describe -t commands 'railway login commands' commands "$@"
}
(( $+functions[_railway__help__logout_commands] )) ||
_railway__help__logout_commands() {
    local commands; commands=()
    _describe -t commands 'railway help logout commands' commands "$@"
}
(( $+functions[_railway__logout_commands] )) ||
_railway__logout_commands() {
    local commands; commands=()
    _describe -t commands 'railway logout commands' commands "$@"
}
(( $+functions[_railway__help__logs_commands] )) ||
_railway__help__logs_commands() {
    local commands; commands=()
    _describe -t commands 'railway help logs commands' commands "$@"
}
(( $+functions[_railway__logs_commands] )) ||
_railway__logs_commands() {
    local commands; commands=()
    _describe -t commands 'railway logs commands' commands "$@"
}
(( $+functions[_railway__help__open_commands] )) ||
_railway__help__open_commands() {
    local commands; commands=()
    _describe -t commands 'railway help open commands' commands "$@"
}
(( $+functions[_railway__open_commands] )) ||
_railway__open_commands() {
    local commands; commands=()
    _describe -t commands 'railway open commands' commands "$@"
}
(( $+functions[_railway__help__run_commands] )) ||
_railway__help__run_commands() {
    local commands; commands=()
    _describe -t commands 'railway help run commands' commands "$@"
}
(( $+functions[_railway__run_commands] )) ||
_railway__run_commands() {
    local commands; commands=()
    _describe -t commands 'railway run commands' commands "$@"
}
(( $+functions[_railway__help__service_commands] )) ||
_railway__help__service_commands() {
    local commands; commands=()
    _describe -t commands 'railway help service commands' commands "$@"
}
(( $+functions[_railway__service_commands] )) ||
_railway__service_commands() {
    local commands; commands=()
    _describe -t commands 'railway service commands' commands "$@"
}
(( $+functions[_railway__help__shell_commands] )) ||
_railway__help__shell_commands() {
    local commands; commands=()
    _describe -t commands 'railway help shell commands' commands "$@"
}
(( $+functions[_railway__shell_commands] )) ||
_railway__shell_commands() {
    local commands; commands=()
    _describe -t commands 'railway shell commands' commands "$@"
}
(( $+functions[_railway__help__starship_commands] )) ||
_railway__help__starship_commands() {
    local commands; commands=()
    _describe -t commands 'railway help starship commands' commands "$@"
}
(( $+functions[_railway__starship_commands] )) ||
_railway__starship_commands() {
    local commands; commands=()
    _describe -t commands 'railway starship commands' commands "$@"
}
(( $+functions[_railway__help__status_commands] )) ||
_railway__help__status_commands() {
    local commands; commands=()
    _describe -t commands 'railway help status commands' commands "$@"
}
(( $+functions[_railway__status_commands] )) ||
_railway__status_commands() {
    local commands; commands=()
    _describe -t commands 'railway status commands' commands "$@"
}
(( $+functions[_railway__help__unlink_commands] )) ||
_railway__help__unlink_commands() {
    local commands; commands=()
    _describe -t commands 'railway help unlink commands' commands "$@"
}
(( $+functions[_railway__unlink_commands] )) ||
_railway__unlink_commands() {
    local commands; commands=()
    _describe -t commands 'railway unlink commands' commands "$@"
}
(( $+functions[_railway__help__up_commands] )) ||
_railway__help__up_commands() {
    local commands; commands=()
    _describe -t commands 'railway help up commands' commands "$@"
}
(( $+functions[_railway__up_commands] )) ||
_railway__up_commands() {
    local commands; commands=()
    _describe -t commands 'railway up commands' commands "$@"
}
(( $+functions[_railway__help__variables_commands] )) ||
_railway__help__variables_commands() {
    local commands; commands=()
    _describe -t commands 'railway help variables commands' commands "$@"
}
(( $+functions[_railway__variables_commands] )) ||
_railway__variables_commands() {
    local commands; commands=()
    _describe -t commands 'railway variables commands' commands "$@"
}
(( $+functions[_railway__help__whoami_commands] )) ||
_railway__help__whoami_commands() {
    local commands; commands=()
    _describe -t commands 'railway help whoami commands' commands "$@"
}
(( $+functions[_railway__whoami_commands] )) ||
_railway__whoami_commands() {
    local commands; commands=()
    _describe -t commands 'railway whoami commands' commands "$@"
}

if [ "$funcstack[1]" = "_railway" ]; then
    _railway "$@"
else
    compdef _railway railway
fi
