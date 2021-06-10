#!/bin/sh

BASE_DIR=$HOME/kolxo3
UNION_DIR=$BASE_DIR/all
DOWNLOAD_DIR=/home/transmission/Downloads/KoLXo3
DOAS=doas

kol_umount(){
while $DOAS umount $UNION_DIR; do true; done;

for a in /dev/md[0-9]*
	do
		NUM=${a##*md}
		$DOAS umount $a
		$DOAS mdconfig -d -u $NUM
	done
	$DOAS rmdir $BASE_DIR/*
}

kol_mount() {
$DOAS mkdir -p $BASE_DIR

cd $DOWNLOAD_DIR
for ISO in disc*.iso;
do
	DISC_NAME=${ISO%.*}
	DISC_DIR=$BASE_DIR/$DISC_NAME
	MD_DEV=`$DOAS mdconfig -f $ISO` 
	$DOAS mkdir -p $DISC_DIR
	$DOAS mount_cd9660 /dev/$MD_DEV $DISC_DIR
done
}

# pkg install fusefs-uinonfs
# sysctl vfs.usermount=1
kol_union() {
	cd $BASE_DIR
	mkdir -p $UNION_DIR
	MOUNT_OPT=$(ls -d disc* | tr '\n' ':' | sed 's/:$//')
	$DOAS unionfs -o allow_other $MOUNT_OPT $UNION_DIR
}

case $1 in
	umount)
		kol_umount
		;;
	mount)
		kol_mount
		;;
	union)
		kol_union
		;;
esac
