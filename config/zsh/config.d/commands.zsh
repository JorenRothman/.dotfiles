alias deploy_dierenrecht_prod='ssh dierenrecht.nl -t "cd production; sh ./scripts/deploy-production.sh"'
alias deploy_dierenrecht_staging='ssh dierenrecht.instance.studio -t "cd dierenrecht; sh ./scripts/deploy-staging.sh"'
alias deploy_phion_prod='ssh phion.nl -t "cd phion; composer run-script deploy-production"'
