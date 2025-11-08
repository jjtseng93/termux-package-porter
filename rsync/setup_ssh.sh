
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -C "termux@$(hostname)"

cat ~/.ssh/id_rsa.pub>>~/.ssh/authorized_keys

cp ~/.ssh/id_rsa /sdcard/Download

echo "A pair of public/private keys is generated and copied to /sdcard/Download"
echo "Open your Android native file explorer and use Quick Share to send id_rsa to a trusted ssh client"
echo "Show ip address by ifconfig, username by whoami, start ssh server by sshd"
