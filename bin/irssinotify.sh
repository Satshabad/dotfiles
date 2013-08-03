set -e

ssh root@198.199.67.210 ": >/home/ircuser/.irssi/fnotify ; tail -f /home/ircuser/.irssi/fnotify " |
sed -u 's/[&]//g' | while read heading message;
do /usr/bin/notify-send -i notification-message-im -- "${heading}" "${message}";
done
