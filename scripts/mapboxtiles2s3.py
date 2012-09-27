#!/usr/bin/env python

"""
Script to upload contents of an MapBox Tile to S3.
"""
import os
import sys
import sqlite3
from boto.s3.connection import S3Connection

def main():
    """Start here"""
    # Some defaults we'll always use
    mime_type = 'image/png'
    print "Opening file"
    # Try to work with the mbtile file
    mbcon = sqlite3.connect(mbtile_fname)
    cur = mbcon.cursor()
    metadata = dict(mbcon.execute('select name, value from metadata;').fetchall(
))
    bucket_name = metadata['name'].lower()
    total = mbcon.execute('select count(zoom_level) from tiles;').fetchone()[0]
    print "Connecting to s3"
    # Try to connect to s3 and create our bucket
    s3con = S3Connection(AWS_ID, AWS_SECRET_KEY)
    bucket = s3con.create_bucket(bucket_name)
    bucket.set_acl('public-read')
    
    # Do the work
    for tile in mbcon.execute('select zoom_level, tile_column, tile_row, tile_data from tiles;'):
        name = "%s/%s/%s.png" % (tile[0], tile[1], tile[2])
        key = bucket.new_key(name)

        key.content_type = mime_type
        key.set_contents_from_string(tile[3])
    return(0)

if __name__ == '__main__':
    AWS_ID = os.environ['AMAZON_ACCESS_KEY_ID']
    AWS_SECRET_KEY = os.environ['AMAZON_SECRET_ACCESS_KEY']
    sys.argv.pop(0)
    mbtile_fname = sys.argv.pop(0)
    sys.exit(main())