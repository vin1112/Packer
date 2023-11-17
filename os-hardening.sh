# #!/bin/bash

# # ------------------------------------------------------------------------------------------------- #
# #Ensure updates, patches, and additional security software are installed
# echo
# echo -e "1.8 Ensure updates, patches, and additional security software are installed"
# apt-get upgrade --security
# policystatus=$?
# if [[ "$policystatus" -eq 0 ]]; then
# echo -e "Remediated: Ensure updates, patches, and additional security software are installed"
# else
# echo -e "UnableToRemediate: Ensure updates, patches, and additional security software are installed"
# fi

# # ------------------------------------------------------------------------------------------------- #

# ##Category 2.2 Services - Special Purpose Services
# echo
# echo -e "2.2 Services - Special Purpose Services"


# # ------------------------------------------------------------------------------------------------- #
# #Ensure time synchronization is in use

# echo
# echo -e "2.2.1.1 Ensure time synchronization is in use"
# apt-get install ntp && apt-get install chrony
# policystatus=$?
# if [[ "$policystatus" -eq 0 ]]; then
# echo -e "Remediated: Ensure time synchronization is in use"
# else
# echo -e "UnableToRemediate: Ensure time synchronization is in use"
# fi

# # ------------------------------------------------------------------------------------------------- #
# #Ensure ntp is configured
# echo
# echo -e "2.2.1.2 Ensure ntp is configured"
# if rpm -q ntp >/dev/null; then
#     egrep -q "^\s*restrict(\s+-4)?\s+default(\s+\S+)*(\s*#.*)?\s*$" /etc/ntp.conf && sed -ri "s/^(\s*)restrict(\s+-4)?\s+default(\s+[^[:space:]#]+)*(\s+#.*)?\s*$/\1restrict\2 default kod nomodify notrap nopeer noquery\4/" /etc/ntp.conf || echo "restrict default kod nomodify notrap nopeer noquery" >> /etc/ntp.conf 
#     egrep -q "^\s*restrict\s+-6\s+default(\s+\S+)*(\s*#.*)?\s*$" /etc/ntp.conf && sed -ri "s/^(\s*)restrict\s+-6\s+default(\s+[^[:space:]#]+)*(\s+#.*)?\s*$/\1restrict -6 default kod nomodify notrap nopeer noquery\3/" /etc/ntp.conf || echo "restrict -6 default kod nomodify notrap nopeer noquery" >> /etc/ntp.conf 
#     egrep -q "^(\s*)OPTIONS\s*=\s*\"(([^\"]+)?-u\s[^[:space:]\"]+([^\"]+)?|([^\"]+))\"(\s*#.*)?\s*$" /etc/sysconfig/ntpd && sed -ri '/^(\s*)OPTIONS\s*=\s*\"([^\"]*)\"(\s*#.*)?\s*$/ {/^(\s*)OPTIONS\s*=\s*\"[^\"]*-u\s+\S+[^\"]*\"(\s*#.*)?\s*$/! s/^(\s*)OPTIONS\s*=\s*\"([^\"]*)\"(\s*#.*)?\s*$/\1OPTIONS=\"\2 -u ntp:ntp\"\3/ }' /etc/sysconfig/ntpd && sed -ri "s/^(\s*)OPTIONS\s*=\s*\"([^\"]+\s+)?-u\s[^[:space:]\"]+(\s+[^\"]+)?\"(\s*#.*)?\s*$/\1OPTIONS=\"\2\-u ntp:ntp\3\"\4/" /etc/sysconfig/ntpd || echo "OPTIONS=\"-u ntp:ntp\"" >> /etc/sysconfig/ntpd
# fi
# echo -e "Remediated: Ensure ntp is configured"


# # ------------------------------------------------------------------------------------------------- #
# #Ensure chrony is configured

# echo
# echo -e "2.2.1.3 Ensure chrony is configured"
# if rpm -q chrony >/dev/null; then
#     egrep -q "^(\s*)OPTIONS\s*=\s*\"(([^\"]+)?-u\s[^[:space:]\"]+([^\"]+)?|([^\"]+))\"(\s*#.*)?\s*$" /etc/sysconfig/chronyd && sed -ri '/^(\s*)OPTIONS\s*=\s*\"([^\"]*)\"(\s*#.*)?\s*$/ {/^(\s*)OPTIONS\s*=\s*\"[^\"]*-u\s+\S+[^\"]*\"(\s*#.*)?\s*$/! s/^(\s*)OPTIONS\s*=\s*\"([^\"]*)\"(\s*#.*)?\s*$/\1OPTIONS=\"\2 -u chrony\"\3/ }' /etc/sysconfig/chronyd && sed -ri "s/^(\s*)OPTIONS\s*=\s*\"([^\"]+\s+)?-u\s[^[:space:]\"]+(\s+[^\"]+)?\"(\s*#.*)?\s*$/\1OPTIONS=\"\2\-u chrony\3\"\4/" /etc/sysconfig/chronyd || echo "OPTIONS=\"-u chrony\"" >> /etc/sysconfig/chronyd
# fi
# policystatus=$?
# if [[ "$policystatus" -eq 0 ]]; then
# echo -e "Remediated: Ensure chrony is configured"
# else
# echo -e "UnableToRemediate: Ensure chrony is configured"
# fi



# # ------------------------------------------------------------------------------------------------- #
# ##Category 1.1 Initial Setup - Filesystem Configuration
# echo -e "1.1 Initial Setup - Filesystem Configuration"

# # ------------------------------------------------------------------------------------------------- #

# # 4.1.8 Ensure login and logout events are collected

# echo
# echo -e "4.1.8 Ensure login and logout events are collected"
# grep "-w /var/log/lastlog -p wa -k logins" /etc/audit/audit.rules || echo "-w /var/log/lastlog -p wa -k logins" >> /etc/audit/audit.rules
# grep "-w /var/run/faillock/ -p wa -k logins" /etc/audit/audit.rules || echo "-w /var/run/faillock/ -p wa -k logins" >> /etc/audit/audit.rules
# echo -e "Remediated: Ensure login and logout events are collected"


# # ------------------------------------------------------------------------------------------------- #

# # 4.1.9 Ensure session initiation information is collected
# echo
# echo -e "4.1.9 Ensure session initiation information is collected"
# grep "-w /var/run/utmp -p wa -k session" /etc/audit/audit.rules || echo "-w /var/run/utmp -p wa -k session" >> /etc/audit/audit.rules
# grep "-w /var/log/wtmp -p wa -k logins" /etc/audit/audit.rules || echo "-w /var/log/wtmp -p wa -k logins" >> /etc/audit/audit.rules
# grep "-w /var/log/btmp -p wa -k logins" /etc/audit/audit.rules || echo "-w /var/log/btmp -p wa -k logins" >> /etc/audit/audit.rules
# echo -e "Remediated: Ensure session initiation information is collected"


# # ------------------------------------------------------------------------------------------------- #

# # 4.1.10 Ensure discretionary access control permission modification events are collected
# echo
# echo -e "4.1.10 Ensure discretionary access control permission modification events are collected"
# egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+chmod\s+-S\s+fchmod\s+-S\s+fchmodat\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+perm_mod\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules
# egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+chown\s+-S\s+fchown\s+-S\s+fchownat\s+-S\s+lchown\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+perm_mod\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules
# egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+setxattr\s+-S\s+lsetxattr\s+-S\s+fsetxattr\s+-S\s+removexattr\s+-S\s+lremovexattr\s+-S\s+fremovexattr\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+perm_mod\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules
# uname -p | grep -q 'x86_64' && egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+chmod\s+-S\s+fchmod\s+-S\s+fchmodat\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+perm_mod\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules
# uname -p | grep -q 'x86_64' && egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+chown\s+-S\s+fchown\s+-S\s+fchownat\s+-S\s+lchown\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+perm_mod\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules
# uname -p | grep -q 'x86_64' && egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+setxattr\s+-S\s+lsetxattr\s+-S\s+fsetxattr\s+-S\s+removexattr\s+-S\s+lremovexattr\s+-S\s+fremovexattr\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+perm_mod\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules
# echo -e "Remediated: Ensure discretionary access control permission modification events are collected"

# # ------------------------------------------------------------------------------------------------- #


# # 4.1.11 Ensure unsuccessful unauthorized file access attempts are collected
# echo
# echo -e "4.1.11 Ensure unsuccessful unauthorized file access attempts are collected"
# egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+creat\s+-S\s+open\s+-S\s+openat\s+-S\s+truncate\s+-S\s+ftruncate\s+-F\s+exit=-EACCES\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+access\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/audit.rules
# egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+creat\s+-S\s+open\s+-S\s+openat\s+-S\s+truncate\s+-S\s+ftruncate\s+-F\s+exit=-EPERM\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+access\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/audit.rules
# uname -p | grep -q 'x86_64' && egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+creat\s+-S\s+open\s+-S\s+openat\s+-S\s+truncate\s+-S\s+ftruncate\s+-F\s+exit=-EACCES\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+access\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/audit.rules
# uname -p | grep -q 'x86_64' && egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+creat\s+-S\s+open\s+-S\s+openat\s+-S\s+truncate\s+-S\s+ftruncate\s+-F\s+exit=-EPERM\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+access\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/audit.rules
# echo -e "Remediated: Ensure unsuccessful unauthorized file access attempts are collected"

# # ------------------------------------------------------------------------------------------------- #

# echo
# echo -e "4.1.12 Ensure use of privileged commands is collected"
# for file in `find / -xdev \( -perm -4000 -o -perm -2000 \) -type f`; do
#     egrep -q "^\s*-a\s+(always,exit|exit,always)\s+-F\s+path=$file\s+-F\s+perm=x\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+privileged\s*(#.*)?$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F path=$file -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules;
# done
# policystatus=$?
# if [[ "$policystatus" -eq 0 ]]; then
# echo -e "Remediated: Ensure use of privileged commands is collected"
# else
# echo -e "UnableToRemediate: Ensure use of privileged commands is collected"
# fi

# # ------------------------------------------------------------------------------------------------- #

# # 4.1.14 Ensure file deletion events by users are collected
# echo
# echo -e "4.1.14 Ensure file deletion events by users are collected"
# egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+unlink\s+-S\s+unlinkat\s+-S\s+rename\s+-S\s+renameat\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+delete\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/rules.d/audit.rules
# uname -p | grep -q 'x86_64' && egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+unlink\s+-S\s+unlinkat\s+-S\s+rename\s+-S\s+renameat\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+delete\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/rules.d/audit.rules
# echo -e "Remediated: Ensure file deletion events by users are collected"

# # ------------------------------------------------------------------------------------------------- #

# # 4.1.15 Ensure changes to system administration scope (sudoers) is collected
# echo
# echo -e "4.1.15 Ensure changes to system administration scope (sudoers) is collected"
# grep "-w /etc/sudoers -p wa -k scope" /etc/audit/audit.rules || echo "-w /etc/sudoers -p wa -k scope" >> /etc/audit/audit.rules
# grep "-w /etc/sudoers.d/ -p wa -k scope" /etc/audit/audit.rules || echo "-w /etc/sudoers.d/ -p wa -k scope" >> /etc/audit/audit.rules
# echo -e "Remediated: Ensure changes to system administration scope (sudoers) is collected"


# # ------------------------------------------------------------------------------------------------- #

# # 4.1.16 Ensure system administrator actions (sudolog) are collected
# echo
# echo -e "4.1.16 Ensure system administrator actions (sudolog) are collected"
# grep "-w /var/log/sudo.log -p wa -k actions" /etc/audit/audit.rules || echo "-w /var/log/sudo.log -p wa -k actions" >> /etc/audit/audit.rules
# policystatus=$?
# if [[ "$policystatus" -eq 0 ]]; then
# echo -e "Remediated: Ensure system administrator actions (sudolog) are collected"
# else
# echo -e "UnableToRemediate: Ensure system administrator actions (sudolog) are collected"
# fi

# # ------------------------------------------------------------------------------------------------- #

# # 4.1.18 Ensure the audit configuration is immutable
# echo
# echo -e "4.1.18 Ensure the audit configuration is immutable"
# grep "-e 2" /etc/audit/audit.rules || echo "-e 2" >> /etc/audit/audit.rules
# policystatus=$?
# if [[ "$policystatus" -eq 0 ]]; then
# echo -e "Remediated: Ensure the audit configuration is immutable"
# else
# echo -e "UnableToRemediate: Ensure the audit configuration is immutable"
# fi  



# ############################################################################################################################

# ##Category 5.3 Access, Authentication and Authorization - Configure PAM
# echo
# echo -e "5.3 Access, Authentication and Authorization - Configure PAM"

# # 5.3.1 Ensure password creation requirements are configured
# echo
# echo -e "5.3.1 Ensure password creation requirements are configured"
# egrep -q "^\s*password\s+requisite\s+pam_pwquality.so\s+" /etc/pam.d/password-auth && sed -ri '/^\s*password\s+requisite\s+pam_pwquality.so\s+/ { /^\s*password\s+requisite\s+pam_pwquality.so(\s+\S+)*(\s+try_first_pass)(\s+.*)?$/! s/^(\s*password\s+requisite\s+pam_pwquality.so\s+)(.*)$/\1try_first_pass \2/ }' /etc/pam.d/password-auth && sed -ri '/^\s*password\s+requisite\s+pam_pwquality.so\s+/ { /^\s*password\s+requisite\s+pam_pwquality.so(\s+\S+)*(\s+retry=[0-9]+)(\s+.*)?$/! s/^(\s*password\s+requisite\s+pam_pwquality.so\s+)(.*)$/\1retry=3 \2/ }' /etc/pam.d/password-auth && sed -ri 's/(^\s*password\s+requisite\s+pam_pwquality.so(\s+\S+)*\s+)retry=[0-9]+(\s+.*)?$/\1retry=3\3/' /etc/pam.d/password-auth || echo "password requisite pam_pwquality.so try_first_pass retry=3" >> /etc/pam.d/password-auth
# egrep -q "^\s*password\s+requisite\s+pam_pwquality.so\s+" /etc/pam.d/system-auth && sed -ri '/^\s*password\s+requisite\s+pam_pwquality.so\s+/ { /^\s*password\s+requisite\s+pam_pwquality.so(\s+\S+)*(\s+try_first_pass)(\s+.*)?$/! s/^(\s*password\s+requisite\s+pam_pwquality.so\s+)(.*)$/\1try_first_pass \2/ }' /etc/pam.d/system-auth && sed -ri '/^\s*password\s+requisite\s+pam_pwquality.so\s+/ { /^\s*password\s+requisite\s+pam_pwquality.so(\s+\S+)*(\s+retry=[0-9]+)(\s+.*)?$/! s/^(\s*password\s+requisite\s+pam_pwquality.so\s+)(.*)$/\1retry=3 \2/ }' /etc/pam.d/system-auth && sed -ri 's/(^\s*password\s+requisite\s+pam_pwquality.so(\s+\S+)*\s+)retry=[0-9]+(\s+.*)?$/\1retry=3\3/' /etc/pam.d/system-auth || echo "password requisite pam_pwquality.so try_first_pass retry=3" >> /etc/pam.d/system-auth
# egrep -q "^(\s*)minlen\s*=\s*\S+(\s*#.*)?\s*$" /etc/security/pwquality.conf && sed -ri "s/^(\s*)minlen\s*=\s*\S+(\s*#.*)?\s*$/\minlen=14\2/" /etc/security/pwquality.conf || echo "minlen=14" >> /etc/security/pwquality.conf
# egrep -q "^(\s*)dcredit\s*=\s*\S+(\s*#.*)?\s*$" /etc/security/pwquality.conf && sed -ri "s/^(\s*)dcredit\s*=\s*\S+(\s*#.*)?\s*$/\dcredit=-1\2/" /etc/security/pwquality.conf || echo "dcredit=-1" >> /etc/security/pwquality.conf
# egrep -q "^(\s*)ucredit\s*=\s*\S+(\s*#.*)?\s*$" /etc/security/pwquality.conf && sed -ri "s/^(\s*)ucredit\s*=\s*\S+(\s*#.*)?\s*$/\ucredit=-1\2/" /etc/security/pwquality.conf || echo "ucredit=-1" >> /etc/security/pwquality.conf
# egrep -q "^(\s*)ocredit\s*=\s*\S+(\s*#.*)?\s*$" /etc/security/pwquality.conf && sed -ri "s/^(\s*)ocredit\s*=\s*\S+(\s*#.*)?\s*$/\ocredit=-1\2/" /etc/security/pwquality.conf || echo "ocredit=-1" >> /etc/security/pwquality.conf
# egrep -q "^(\s*)lcredit\s*=\s*\S+(\s*#.*)?\s*$" /etc/security/pwquality.conf && sed -ri "s/^(\s*)lcredit\s*=\s*\S+(\s*#.*)?\s*$/\lcredit=-1\2/" /etc/security/pwquality.conf || echo "lcredit=-1" >> /etc/security/pwquality.conf
# echo -e "Remediated: Ensure password creation requirements are configured"

# # ------------------------------------------------------------------------------------------------- #

# # 5.3.3 Ensure password reuse is limited
# echo
# echo -e "5.3.3 Ensure password reuse is limited"
# egrep -q "^\s*password\s+sufficient\s+pam_unix.so(\s+.*)$" /etc/pam.d/password-auth && sed -ri '/^\s*password\s+sufficient\s+pam_unix.so\s+/ { /^\s*password\s+sufficient\s+pam_unix.so(\s+\S+)*(\s+remember=[0-9]+)(\s+.*)?$/! s/^(\s*password\s+sufficient\s+pam_unix.so\s+)(.*)$/\1remember=5 \2/ }' /etc/pam.d/password-auth && sed -ri 's/(^\s*password\s+sufficient\s+pam_unix.so(\s+\S+)*\s+)remember=[0-9]+(\s+.*)?$/\1remember=5\3/' /etc/pam.d/password-auth || echo "password sufficient pam_unix.so remember=5" >> /etc/pam.d/password-auth
# egrep -q "^\s*password\s+sufficient\s+pam_unix.so(\s+.*)$" /etc/pam.d/system-auth && sed -ri '/^\s*password\s+sufficient\s+pam_unix.so\s+/ { /^\s*password\s+sufficient\s+pam_unix.so(\s+\S+)*(\s+remember=[0-9]+)(\s+.*)?$/! s/^(\s*password\s+sufficient\s+pam_unix.so\s+)(.*)$/\1remember=5 \2/ }' /etc/pam.d/system-auth && sed -ri 's/(^\s*password\s+sufficient\s+pam_unix.so(\s+\S+)*\s+)remember=[0-9]+(\s+.*)?$/\1remember=5\3/' /etc/pam.d/system-auth || echo "password sufficient pam_unix.so remember=5" >> /etc/pam.d/system-auth
# echo -e "Remediated: Ensure password reuse is limited"

# # ------------------------------------------------------------------------------------------------- #

# # 5.3.4 Ensure password hashing algorithm is SHA-512
# echo
# echo -e "5.3.4 Ensure password hashing algorithm is SHA-512"
# egrep -q "^\s*password\s+sufficient\s+pam_unix.so\s+" /etc/pam.d/password-auth && sed -ri '/^\s*password\s+sufficient\s+pam_unix.so\s+/ { /^\s*password\s+sufficient\s+pam_unix.so(\s+\S+)*(\s+sha512)(\s+.*)?$/! s/^(\s*password\s+sufficient\s+pam_unix.so\s+)(.*)$/\1sha512 \2/ }' /etc/pam.d/password-auth || echo "password sufficient pam_unix.so sha512" >> /etc/pam.d/password-auth
# egrep -q "^\s*password\s+sufficient\s+pam_unix.so\s+" /etc/pam.d/system-auth && sed -ri '/^\s*password\s+sufficient\s+pam_unix.so\s+/ { /^\s*password\s+sufficient\s+pam_unix.so(\s+\S+)*(\s+sha512)(\s+.*)?$/! s/^(\s*password\s+sufficient\s+pam_unix.so\s+)(.*)$/\1sha512 \2/ }' /etc/pam.d/system-auth || echo "password sufficient pam_unix.so sha512" >> /etc/pam.d/system-auth
# echo -e "Remediated: Ensure password hashing algorithm is SHA-512"

# ############################################################################################################################

# ##Category 5.4 Access, Authentication and Authorization - User Accounts and Environment
# echo
# echo -e "5.4 Access, Authentication and Authorization - User Accounts and Environment"


# # ------------------------------------------------------------------------------------------------- #
# # 5.4.1.1 Ensure password expiration is 365 days or less
# echo
# echo -e "5.4.1.1 Ensure password expiration is 365 days or less"
# egrep -q "^(\s*)PASS_MAX_DAYS\s+\S+(\s*#.*)?\s*$" /etc/login.defs && sed -ri "s/^(\s*)PASS_MAX_DAYS\s+\S+(\s*#.*)?\s*$/\PASS_MAX_DAYS 90\2/" /etc/login.defs || echo "PASS_MAX_DAYS 90" >> /etc/login.defs
# getent passwd | cut -f1 -d ":" | xargs -n1 chage --maxdays 90
# echo -e "Remediated: Ensure password expiration is 365 days or less"   

# # ------------------------------------------------------------------------------------------------- # 
# # 5.4.1.2 Ensure minimum days between password changes is 7 or more
# echo
# echo -e "5.4.1.2 Ensure minimum days between password changes is 7 or more"
# egrep -q "^(\s*)PASS_MIN_DAYS\s+\S+(\s*#.*)?\s*$" /etc/login.defs && sed -ri "s/^(\s*)PASS_MIN_DAYS\s+\S+(\s*#.*)?\s*$/\PASS_MIN_DAYS 7\2/" /etc/login.defs || echo "PASS_MIN_DAYS 7" >> /etc/login.defs
# getent passwd | cut -f1 -d ":" | xargs -n1 chage --mindays 7
# echo -e "Remediated: Ensure minimum days between password changes is 7 or more"

# # ------------------------------------------------------------------------------------------------- #
# # 5.4.1.3 Ensure password expiration warning days is 7 or more
# echo
# echo -e "5.4.1.3 Ensure password expiration warning days is 7 or more"
# egrep -q "^(\s*)PASS_WARN_AGE\s+\S+(\s*#.*)?\s*$" /etc/login.defs && sed -ri "s/^(\s*)PASS_WARN_AGE\s+\S+(\s*#.*)?\s*$/\PASS_WARN_AGE 7\2/" /etc/login.defs || echo "PASS_WARN_AGE 7" >> /etc/login.defs
# getent passwd | cut -f1 -d ":" | xargs -n1 chage --warndays 7
# echo -e "Remediated: Ensure password expiration warning days is 7 or more" 
# # ------------------------------------------------------------------------------------------------- #
# # 5.4.1.4 Ensure inactive password lock is 30 days or less
# echo
# echo -e "5.4.1.4 Ensure inactive password lock is 30 days or less"
# useradd -D -f 30 && getent passwd | cut -f1 -d ":" | xargs -n1 chage --inactive 30
# policystatus=$?
# if [[ "$policystatus" -eq 0 ]]; then
# echo -e "Remediated: Ensure inactive password lock is 30 days or less"
# else
# echo -e "UnableToRemediate: Ensure inactive password lock is 30 days or less"
# fi
# # ------------------------------------------------------------------------------------------------- #
# # 5.4.2 Ensure system accounts are non-login
# echo
# echo -e "5.4.2 Ensure system accounts are non-login"
# for user in `awk -F: '($3 < 1000) {print $1 }' /etc/passwd`; do
# if [ $user != "root" ]; then
#     usermod -L $user
#     if [ $user != "sync" ] && [ $user != "shutdown" ] && [ $user != "halt" ]; then
#     usermod -s /usr/sbin/nologin $user
#     fi
# fi
# done
# policystatus=$?
# if [[ "$policystatus" -eq 0 ]]; then
# echo -e "Remediated: Ensure system accounts are non-login"
# else
# echo -e "UnableToRemediate: Ensure system accounts are non-login"
# fi

# # ------------------------------------------------------------------------------------------------- #
# # 5.4.3 Ensure default group for the root account is GID 0
# echo
# echo -e "5.4.3 Ensure default group for the root account is GID 0"
# usermod -g 0 root
# policystatus=$?
# if [[ "$policystatus" -eq 0 ]]; then
# echo -e "Remediated: Ensure default group for the root account is GID 0"
# else
# echo -e "UnableToRemediate: Ensure default group for the root account is GID 0"
# fi
# # ------------------------------------------------------------------------------------------------- #
# #Ensure default user shell timeout is 900 seconds or less
# echo
# echo -e "5.4.5 Ensure default user shell timeout is 900 seconds or less"
# egrep -q "^(\s*)TMOUT\s+\S+(\s*#.*)?\s*$" /etc/bash.bashrc && sed -ri "s/^(\s*)TMOUT\s+\S+(\s*#.*)?\s*$/\1TMOUT=600\2/" /etc/bash.bashrc || echo "TMOUT=600" >> /etc/bash.bashrc
# egrep -q "^(\s*)TMOUT\s+\S+(\s*#.*)?\s*$" /etc/profile && sed -ri "s/^(\s*)TMOUT\s+\S+(\s*#.*)?\s*$/\1TMOUT=600\2/" /etc/profile || echo "TMOUT=600" >> /etc/profile
# egrep -q "^(\s*)TMOUT\s+\S+(\s*#.*)?\s*$" /etc/profile.d/*.sh && sed -ri "s/^(\s*)TMOUT\s+\S+(\s*#.*)?\s*$/\1TMOUT=600\2/" /etc/profile.d/*.sh || echo "TMOUT=600" >> /etc/profile.d/*.sh
# echo -e "Remediated: Ensure default user shell timeout is 900 seconds or less"

# # ------------------------------------------------------------------------------------------------- #

# #Ensure access to the su command is restricted
# echo
# echo -e "5.6 Ensure access to the su command is restricted"
# egrep -q "^\s*auth\s+required\s+pam_wheel.so(\s+.*)?$" /etc/pam.d/su && sed -ri '/^\s*auth\s+required\s+pam_wheel.so(\s+.*)?$/ { /^\s*auth\s+required\s+pam_wheel.so(\s+\S+)*(\s+use_uid)(\s+.*)?$/! s/^(\s*auth\s+required\s+pam_wheel.so)(\s+.*)?$/\1 use_uid\2/ }' /etc/pam.d/su || echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su
# policystatus=$?
# if [[ "$policystatus" -eq 0 ]]; then
# echo -e "Remediated: Ensure access to the su command is restricted"
# else
# echo -e "UnableToRemediate: Ensure access to the su command is restricted"
# fi
