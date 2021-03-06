#!/bin/bash
ALBUM_SORT=

patterns() {
# Basic patterns to fix the non-ascii strangeness
cat <<EOF
s/COLLATE pinyin/              /g
s/collate pinyin/              /g
s/VOROIS/VORBIS/g
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

