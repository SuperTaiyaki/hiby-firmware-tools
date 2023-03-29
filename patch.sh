#!/bin/bash
#ALBUM_SORT=YES

# These 2 don't work on 2.2 as far as I can tell
#ARTIST_CHRONOLOGICAL_ALBUMS=1
#ALBUM_ARTIST=MAYBE

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

if [[ -n $ARTIST_CHRONOLOGICAL_ALBUMS ]]
then
    cat <<EOF
s/SELECT DISTINCT album FROM MEDIA_TABLE WHERE artist like ? ORDER BY album      /SELECT DISTINCT album FROM MEDIA_TABLE WHERE artist like ? ORDER BY year, album/
EOF

if [[ -n $ALBUM_ARTIST ]]
then
    cat <<EOF
s/MEDIA\([1-9]\)_TABLE( id,path,name,album,artist,genre,year,dis_id,ck_id,has_child_file,begin_time,end_time,cue_id,character,size,sample_rate,bit_rate,bit,channel,format,quality,album_pic_path,lrc_path,track_gain,track_peak,ctime,mtime,pinyin_charater,album_artist)/MEDIA\1_TABLE( id,path,name,album,album_artist,genre,year,dis_id,ck_id,has_child_file,begin_time,end_time,cue_id,character,size,sample_rate,bit_rate,bit,channel,format,quality,album_pic_path,lrc_path,track_gain,track_peak,ctime,mtime,pinyin_charater,artist)/g
EOF
fi
fi
# year, album would be better but then have to use the empty space and padding and ughhhh

# If you want to add any more patterns make sure they don't change the file length
}

sed -f <(patterns) "$@"

