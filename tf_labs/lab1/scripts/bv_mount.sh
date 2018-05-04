set -x


iscsiadm -m node -o new -T iqn.2015-12.com.oracleiaas:63df7a02-0e39-4720-919c-c0a34fc0555f -p 169.254.2.2:3260
iscsiadm -m node -o update -T iqn.2015-12.com.oracleiaas:63df7a02-0e39-4720-919c-c0a34fc0555f -n node.startup -v automatic
iscsiadm -m node -T iqn.2015-12.com.oracleiaas:63df7a02-0e39-4720-919c-c0a34fc0555f -p 169.254.2.2:3260 -l 


mkfs -t  ext4 /dev/sdb <<EOF
y
EOF

mkdir /u01
echo "/dev/sdb	/u01	ext4	defaults,noatime,_netdev	0	2" >>/etc/fstab
mount -a
