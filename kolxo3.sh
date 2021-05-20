#!/bin/sh

BASE_DIR=$HOME/kolxo3
UNION_DIR=$BASE_DIR/all
DOWNLOAD_DIR=/home/transmission/Downloads/KoLXo3

kol_umount(){
while sudo umount $UNION_DIR; do true; done;

for a in /dev/md[0-9]*
	do
		NUM=${a##*md}
		sudo umount $a
		sudo mdconfig -d -u $NUM
	done
	sudo rmdir $BASE_DIR/*
}

kol_mount() {
sudo mkdir -p $BASE_DIR

cd $DOWNLOAD_DIR
for ISO in disc*.iso;
do
	DISC_NAME=${ISO%.*}
	DISC_DIR=$BASE_DIR/$DISC_NAME
	MD_DEV=`sudo mdconfig -f $ISO` 
	sudo mkdir -p $DISC_DIR
	sudo mount_cd9660 /dev/$MD_DEV $DISC_DIR
done
}

kol_union() {
	cd $BASE_DIR
	sudo mkdir -p $UNION_DIR
	for DISC_DIR in disc[012]*
	do
	sudo mount_unionfs -o rw -o noatime $DISC_DIR $UNION_DIR
	done
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
