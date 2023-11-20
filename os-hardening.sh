#!/bin/bash

# ------------------------------------------------------------------------------------------------------------------- #
# Update repos
sudo apt-get update -y 

# ------------------------------------------------------------------------------------------------------------------- #
# Upgrade existing packages to latest
sudo apt-get upgrade -y 


# ------------------------------------------------------------------------------------------------------------------- #
# Enter User Name and Password
USERNAME="jenkinsadmin"
PASSWORD="JenkinsAdmin@1234"

if ! id "$USERNAME" &>/dev/null; then
  # Create the user without prompting and set their password
  sudo useradd -m $USERNAME

  echo "$USERNAME:$PASSWORD" | sudo chpasswd

  # Add the user to the sudo group without prompting
  sudo usermod -aG sudo $USERNAME
  echo "Created Jenkins User: $USERNAME"
fi


# ------------------------------------------------------------------------------------------------------------------- #
# 1.0.1 Ensure password creation requirements are configured
echo
echo  "1.0.1 Ensure password creation requirements are configured"
sudo tee -a /etc/security/pwquality.conf <<EOL
minlen = 14
minclass = 4
minclass = 3
maxrepeat = 3
maxsequence = 3
maxclassrepeat = 4
EOL

# ------------------------------------------------------------------------------------------------------------------- #
# 1.0.2 Ensure lockout for failed password attempts is configured
echo
echo  "11.0.2 Ensure lockout for failed password attempts is configured"
sudo sed -i '/pam_unix.so/s/\(minlen=\|minclass=\|maxrepeat=\)[0-9]*/\1/' /etc/pam.d/common-password
sudo bash -c 'echo "auth required pam_faillock.so preauth silent audit deny=5 unlock_time=900 fail_interval=900" >> /etc/pam.d/common-auth'
sudo bash -c 'echo "auth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900 fail_interval=900" >> /etc/pam.d/common-auth'
sudo bash -c 'echo "account required pam_faillock.so" >> /etc/pam.d/common-auth'
sudo bash -c 'echo "password required pam_faillock.so" >> /etc/pam.d/common-auth'
echo  "Remediated: Ensure lockout for failed password attempts is configured"

# ------------------------------------------------------------------------------------------------------------------- #
# 1.0.3 Ensure password reuse is limited
echo
echo  "1.0.3 Ensure password reuse is limited"
sudo sed -i 's/^password\s*required\s*pam_unix.so.*/& remember=5/' /etc/pam.d/common-password
echo  "Remediated: Ensure password reuse is limited"

# ------------------------------------------------------------------------------------------------------------------- #
# 1.0.4 Ensure password hashing algorithm is SHA-512
echo
echo  "1.0.4 Ensure password hashing algorithm is SHA-512"
sudo sed -i 's/^password\s*required\s*pam_unix.so.*/& sha512/' /etc/pam.d/common-password
echo  "Remediated: Ensure password hashing algorithm is SHA-512"

# ------------------------------------------------------------------------------------------------------------------- #
# 1.0.5 Ensure default user shell timeout is 900 seconds or less
echo
echo  "1.0.5 Ensure default user shell timeout is 900 seconds or less"
sudo bash -c 'echo "TMOUT=900" >> /etc/profile'
echo  "Remediated: Ensure default user shell timeout is 900 seconds or less"

# ------------------------------------------------------------------------------------------------------------------- #
# 1.0.6 Ensure default group for the root account is GID 0
echo
echo  " 1.0.6  Ensure default group for the root account is GID 0"
usermod -g 0 root
policystatus=$?
if [ "$policystatus" -eq 0 ]; then
  echo  "Remediated: Ensure default group for the root account is GID 0"
else
  echo  "UnableToRemediate: Ensure default group for the root account is GID 0"
fi

# ------------------------------------------------------------------------------------------------------------------- #
# 1.0.7 Ensure access to the su command is restricted
echo  " 1.0.7 Ensure access to the su command is restricted"
sudo bash -c 'echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su'
echo "Access, Authentication, and Authorization measures applied."

# ------------------------------------------------------------------------------------------------------------------- #
# 1.0.8 Ensure password expiration is 365 days or less
echo
echo  "1.0.8Ensure password expiration is 365 days or less"
sudo bash -c 'egrep -q "^(\s*)PASS_MAX_DAYS\s+\S+(\s*#.*)?\s*$" /etc/login.defs && sed -ri "s/^(\s*)PASS_MAX_DAYS\s+\S+(\s*#.*)?\s*$/PASS_MAX_DAYS 90\2/" /etc/login.defs || echo "PASS_MAX_DAYS 90" >> /etc/login.defs'
sudo getent passwd | cut -f1 -d ":" | xargs -n1 sudo chage --maxdays 90
echo  "Remediated: Ensure password expiration is 365 days or less"

# ------------------------------------------------------------------------------------------------------------------- #
# 1.0.9 Ensure minimum days between password changes is 7 or more
echo
echo  "1.0.9 Ensure minimum days between password changes is 7 or more"
sudo bash -c 'egrep -q "^(\s*)PASS_MIN_DAYS\s+\S+(\s*#.*)?\s*$" /etc/login.defs && sed -ri "s/^(\s*)PASS_MIN_DAYS\s+\S+(\s*#.*)?\s*$/\PASS_MIN_DAYS 7\2/" /etc/login.defs || echo "PASS_MIN_DAYS 7" >> /etc/login.defs'
sudo getent passwd | cut -f1 -d ":" | xargs -n1 sudo chage --mindays 7
echo  "Remediated: Ensure minimum days between password changes is 7 or more"

# ------------------------------------------------------------------------------------------------------------------- #
# 1.1.0 Ensure password expiration warning days is 7 or more
echo
echo  "1.1.0 Ensure password expiration warning days is 7 or more"
sudo bash -c 'egrep -q "^(\s*)PASS_WARN_AGE\s+\S+(\s*#.*)?\s*$" /etc/login.defs && sed -ri "s/^(\s*)PASS_WARN_AGE\s+\S+(\s*#.*)?\s*$/\PASS_WARN_AGE 7\2/" /etc/login.defs || echo "PASS_WARN_AGE 7" >> /etc/login.defs'
sudo getent passwd | cut -f1 -d ":" | xargs -n1 sudo chage --warndays 7
echo  "Remediated: Ensure password expiration warning days is 7 or more"


# ------------------------------------------------------------------------------------------------------------------- #
#1.1.1 Ensure default user shell timeout is 900 seconds or less
echo
echo  "1.1.1 Ensure default user shell timeout is 900 seconds or less"
sudo bash -c 'egrep -q "^(\s*)TMOUT\s+\S+(\s*#.*)?\s*$" /etc/bash.bashrc && sed -ri "s/^(\s*)TMOUT\s+\S+(\s*#.*)?\s*$/\1TMOUT=600\2/" /etc/bash.bashrc || echo "TMOUT=600" >> /etc/bash.bashrc'
sudo bash -c 'egrep -q "^(\s*)TMOUT\s+\S+(\s*#.*)?\s*$" /etc/profile && sed -ri "s/^(\s*)TMOUT\s+\S+(\s*#.*)?\s*$/\1TMOUT=600\2/" /etc/profile || echo "TMOUT=600" >> /etc/profile'
sudo bash -c 'egrep -q "^(\s*)TMOUT\s+\S+(\s*#.*)?\s*$" /etc/profile.d/*.sh && sed -ri "s/^(\s*)TMOUT\s+\S+(\s*#.*)?\s*$/\1TMOUT=600\2/" /etc/profile.d/*.sh || echo "TMOUT=600" >> /etc/profile.d/*.sh'
echo  "Remediated: Ensure default user shell timeout is 900 seconds or less"

# ------------------------------------------------------------------------------------------------------------------- #
#1.1.2 Ensure access to the su command is restricted
echo
echo  "1.1.2 Ensure access to the su command is restricted"
sudo bash -c 'egrep -q "^\s*auth\s+required\s+pam_wheel.so(\s+.*)?$" /etc/pam.d/su && sed -ri "/^\s*auth\s+required\s+pam_wheel.so(\s+.*)?$/ { /^\s*auth\s+required\s+pam_wheel.so(\s+\S+)*(\s+use_uid)(\s+.*)?$/! s/^(\s*auth\s+required\s+pam_wheel.so)(\s+.*)?$/\1 use_uid\2/ }" /etc/pam.d/su || echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su'
policystatus=$?
if [ "$policystatus" -eq 0 ]; then
  echo  "Remediated: Ensure access to the su command is restricted"
else
  echo  "UnableToRemediate: Ensure access to the su command is restricted"
fi

# ------------------------------------------------------------------------------------------------------------------- #
# 1.1.3
echo "Changing Deafult SSH Port "
# Define the new SSH port you want to use
NEW_SSH_PORT=2222

# Check if the SSH configuration file exists
if [ -f /etc/ssh/sshd_config ]; then
  # Backup the current configuration file
  cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

  # Update the SSH port in the configuration file
  sudo sed -i "s/Port 22/Port $NEW_SSH_PORT/" /etc/ssh/sshd_config
  
  sudo systemctl restart ssh

  echo "SSH port changed to $NEW_SSH_PORT"
else
  echo "SSH configuration file not found. Please check the SSH installation."
fi

# ------------------------------------------------------------------------------------------------------------------- #
# 1.1.4 Check if auditd is installed
if ! command -v auditd &> /dev/null; then
    echo "auditd is not installed. Installing..."

    # Use the appropriate package manager for your system
    if command -v apt-get &> /dev/null; then
        sudo apt-get install -y auditd
    else
        echo "Unsupported package manager. Please install auditd manually."
        exit 1
    fi

    # Check installation success
    if [ $? -eq 0 ]; then
        echo "auditd installed successfully."
    else
        echo "Failed to install auditd. Please check the installation manually."
        exit 1
    fi
else
    echo "auditd is already installed."
fi

# ------------------------------------------------------------------------------------------------------------------- #
# 1.1.5 Ensure events that modify the system's network environment are collected
echo
echo  "1.1.5 Ensure events that modify the system's network environment are collected"
sudo bash -c 'egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+sethostname\s+-S\s+setdomainname\s+-k\s+system-locale\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/rules.d/audit.rules'
sudo bash -c 'egrep "^-w\s+/etc/issue\s+-p\s+wa\s+-k\s+system-locale\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/issue -p wa -k system-locale" >> /etc/audit/rules.d/audit.rules'
sudo bash -c 'egrep "^-w\s+/etc/issue.net\s+-p\s+wa\s+-k\s+system-locale\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/issue.net -p wa -k system-locale" >> /etc/audit/rules.d/audit.rules'
sudo bash -c 'egrep "^-w\s+/etc/hosts\s+-p\s+wa\s+-k\s+system-locale\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/hosts -p wa -k system-locale" >> /etc/audit/rules.d/audit.rules'
sudo bash -c 'egrep "^-w\s+/etc/sysconfig/network\s+-p\s+wa\s+-k\s+system-locale\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/sysconfig/network -p wa -k system-locale" >> /etc/audit/rules.d/audit.rules'
sudo bash -c 'uname -p | grep -q "x86_64" && egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+sethostname\s+-S\s+setdomainname\s+-k\s+system-locale\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/rules.d/audit.rules'
echo  "Remediated: Ensure events that modify the system's network environment are collected"

# ------------------------------------------------------------------------------------------------------------------- #
# 1.1.6 Ensure login and logout events are collected
echo
echo  "1.1.6 Ensure login and logout events are collected"

sudo bash -c 'awk "/-w \/var\/log\/lastlog -p wa -k logins/" /etc/audit/audit.rules || echo "-w /var/log/lastlog -p wa -k logins" >> /etc/audit/audit.rules'
sudo bash -c 'awk "/-w \/var\/run\/faillock\/ -p wa -k logins/" /etc/audit/audit.rules || echo "-w /var/run/faillock/ -p wa -k logins" >> /etc/audit/audit.rules'
echo  "Remediated: Ensure login and logout events are collected"

# ------------------------------------------------------------------------------------------------------------------- #
# 1.1.7 Ensure session initiation information is collected
echo
echo  "1.1.7  Ensure session initiation information is collected"
sudo bash -c 'awk "/-w \/var\/run\/utmp -p wa -k session/" /etc/audit/audit.rules || echo "-w /var/run/utmp -p wa -k session" >> /etc/audit/audit.rules'
sudo bash -c 'awk "/-w \/var\/log\/wtmp -p wa -k logins/" /etc/audit/audit.rules || echo "-w /var/log/wtmp -p wa -k logins" >> /etc/audit/audit.rules'
sudo bash -c 'awk "/-w \/var\/log\/btmp -p wa -k logins/" /etc/audit/audit.rules || echo "-w /var/log/btmp -p wa -k logins" >> /etc/audit/audit.rules'
echo  "Remediated: Ensure session initiation information is collected"

# ------------------------------------------------------------------------------------------------------------------- #
# 1.1.8 Ensure changes to system administration scope (sudoers) is collected
echo
echo  "1.1.8 Ensure changes to system administration scope (sudoers) is collected"
sudo bash -c 'awk "/-w \/etc\/sudoers -p wa -k scope/" /etc/audit/audit.rules || echo "-w /etc/sudoers -p wa -k scope" >> /etc/audit/audit.rules'
sudo bash -c 'awk "/-w \/etc\/sudoers\.d\/ -p wa -k scope/" /etc/audit/audit.rules || echo "-w /etc/sudoers.d/ -p wa -k scope" >> /etc/audit/audit.rules'
echo  "Remediated: Ensure changes to system administration scope (sudoers) is collected"

# ------------------------------------------------------------------------------------------------------------------- #
# 1.1.9 Ensure system administrator actions (sudolog) are collected
echo
echo  "1.1.9 Ensure system administrator actions (sudolog) are collected"
sudo bash -c 'awk "/-w \/var\/log\/sudo.log -p wa -k actions/" /etc/audit/audit.rules || echo "-w /var/log/sudo.log -p wa -k actions" >> /etc/audit/audit.rules'
policystatus=$?
if [ "$policystatus" -eq 0 ]; then
  echo  "Remediated: Ensure system administrator actions (sudolog) are collected"
else
  echo  "UnableToRemediate: Ensure system administrator actions (sudolog) are collected"
fi

# ------------------------------------------------------------------------------------------------------------------- #
# 1.2.0 Ensure the audit configuration is immutable
echo
echo  "1.2.0 Ensure the audit configuration is immutable"
sudo bash -c 'awk "/-e 2/" /etc/audit/audit.rules || echo "-e 2" >> /etc/audit/audit.rules'
policystatus=$?
if [ "$policystatus" -eq 0 ]; then
  echo  "Remediated: Ensure the audit configuration is immutable"
else
  echo  "UnableToRemediate: Ensure the audit configuration is immutable"
fi

# ------------------------------------------------------------------------------------------------------------------- #
# 1.2.1 Ensure SSH PermitEmptyPasswords is disabled
echo
echo  "1.2.1 Ensure SSH PermitUserEnvironment is disabled"
sudo bash -c 'egrep -q "^(\s*)PermitUserEnvironment\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)PermitUserEnvironment\s+\S+(\s*#.*)?\s*$/\1PermitUserEnvironment no\2/" /etc/ssh/sshd_config || echo "PermitUserEnvironment no" >> /etc/ssh/sshd_config'
echo  "Remediated: Ensure SSH PermitUserEnvironment is disabled"

# ------------------------------------------------------------------------------------------------------------------- #
# 1.2.2 Ensure SSH MaxAuthTries is set to 4 or less
echo
echo  "1.2.2  Ensure SSH MaxAuthTries is set to 4 or less"
sudo bash -c 'egrep -q "^(\s*)MaxAuthTries\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)MaxAuthTries\s+\S+(\s*#.*)?\s*$/\1MaxAuthTries 4\2/" /etc/ssh/sshd_config || echo "MaxAuthTries 4" >> /etc/ssh/sshd_config'
policystatus=$?
if [ "$policystatus" -eq 0 ]; then
  echo  "Remediated:Ensure SSH MaxAuthTries is set to 4 or less"
else
  echo  "UnableToRemediate: Ensure SSH MaxAuthTries is set to 4 or less"
fi