
1. Create user and group:

    groupadd -s -g 9999 nopasswdlogin
    useradd -l -N -u 9999 -G nopasswdlogin -g nobody -m -r -s /bin/bash bitwarden
    passwd -d bitwarden

2. Change /etc/pam.d files to enable passwordless login for bitwarden user, as shown in pam folder:

    auth      sufficient pam_succeed_if.so user ingroup nopasswdlogin

3. Copy files from skel to ~bitwarden

    install -o bitwarden -g nobody skel/.* ~bitwarden/

4. To use bitwarden, just login to that user:

    su - bitwarden

On first login, you'll need to do:

    bw login

5. To push your GPG files to bitwarden, go to the directory of your GPG files and run the script:

    $path_to_repo/bitwarden_push.sh

The script works with files named like this: username@domain-name.tld

