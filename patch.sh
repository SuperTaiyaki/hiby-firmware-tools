#!/bin/bash
ALBUM_SORT=

patterns() {
# Basic patterns to fix the non-ascii strangeness
cat <<EOF
s/COLLATE pinyin/              /g
s/collate pinyin/              /g
s/VOROIS/VORBIS/g
EOF

# Change max file limit from 20,000 to 65,000 (0x4e20 -> 0xfde8)
# a2af 204e 0224
# No idea what sort of data this actually is so this is a bit fragile
# For some reason, adding one byte to the front breaks this but 2 is fine
cat <<EOF
s/\x02\xa2\xaf\x20\x4e\x02\x24\x2c/\x02\xa2\xaf\xfd\xe8\x02\x24\x2c/
EOF

# Replace genre lists with 3 random albums
if [[ -n $ALBUM_SORT ]]
then
    cat <<EOF
s/album = ? AND genre = ? AND has_child_file/album = ?               AND has_child_file/g
s/SELECT DISTINCT album FROM MEDIA_TABLE WHERE genre like ? ORDER BY album/SELECT album FROM album_table ORDER BY RANDOM() LIMIT 3                 /
s/SELECT COUNT(id) FROM MEDIA_TABLE WHERE genre like ? and album like ?/SELECT COUNT(id) FROM MEDIA_TABLE WHERE                  album like ?/
EOF
fi
# If you want to add any more patterns make sure they don't change the file length
}

sed -f <(patterns) "$@"

