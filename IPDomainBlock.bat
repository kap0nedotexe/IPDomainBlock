@echo off
:: Define IPs, IP ranges, and Domains to block
:: Empty lists won't be processed, no need to edit the script
:: Cleanup: netsh ipsec static delete policy name=BlockPolicy
setlocal

set "BLOCKED_IPS=192.168.1.1 192.168.1.5 192.168.1.10"
set "BLOCKED_RANGES=192.168.10.0-192.168.10.255"
set "BLOCKED_DOMAINS=DOMAIN1.COM DOMAIN2.COM DOMAIN3.COM"

:: Define IPSec policy and rule names
set "POLICY_NAME=BlockPolicy"
set "FILTERLIST_NAME=BlockFilterList"
set "FILTERACTION_NAME=BlockFilterAction"
set "RULE_NAME=BlockRule"

:: Check if there is IPs or IP ranges to block
set "HAS_IPS_OR_RANGES="
if not "%BLOCKED_IPS%"=="" set "HAS_IPS_OR_RANGES=true"
if not "%BLOCKED_RANGES%"=="" set "HAS_IPS_OR_RANGES=true"

if defined HAS_IPS_OR_RANGES (
    :: Create filter list
    netsh ipsec static add filterlist name=%FILTERLIST_NAME% description="Block Filter List"
    
    :: Add IP filters
    if not "%BLOCKED_IPS%"=="" (
        for %%I in (%BLOCKED_IPS%) do (
            netsh ipsec static add filter filterlist=%FILTERLIST_NAME% srcaddr=me dstaddr=%%I description="Block IP %%I"
        )
    )
    
    :: Add IP range filters
    if not "%BLOCKED_RANGES%"=="" (
        for %%R in (%BLOCKED_RANGES%) do (
            netsh ipsec static add filter filterlist=%FILTERLIST_NAME% srcaddr=me dstaddr=%%R description="Block IP Range %%R"
        )
    )
    
    :: Create and assign IPSec policy
    netsh ipsec static add policy name=%POLICY_NAME% description=%POLICY_NAME%
    netsh ipsec static set policy name=%POLICY_NAME% assign=yes
    
    :: Create filter action to block traffic
    netsh ipsec static add filteraction name=%FILTERACTION_NAME% action=block
    
    :: Add rule to link filter list with the block action
    netsh ipsec static add rule name=%RULE_NAME% policy=%POLICY_NAME% filterlist=%FILTERLIST_NAME% filteraction=%FILTERACTION_NAME% description="IPSec Block Rule"
)

:: Handle domain blocking by modifying hosts file
if not "%BLOCKED_DOMAINS%"=="" (
    set "HOSTS_FILE=%SystemRoot%\System32\drivers\etc\hosts"
    echo. >> "%HOSTS_FILE%"
    echo # Added by BlockScript >> "%HOSTS_FILE%"
    for %%D in (%BLOCKED_DOMAINS%) do (
        echo 0.0.0.0 %%D >> "%HOSTS_FILE%"
    )
)

endlocal
@echo The script has completed successfully!
