import os
import sys
import numpy
import pyfits

def getYear1Catalog():
    """
    Convert FITS table of year 1 PHAT cluster catalog to CSV
    """
    data_file = os.path.join('..', 'data', 'phat_pcassign.fits')
    data = pyfits.getdata(data_file)
    
    output = open('year1catalog.csv', 'w')
    for row in data:
        fieldname = row[0]
        cluster = row[4]
        x = row[5]
        y = row[6]
        pixradius = row[7]
        ra = row[8]
        dec = row[9]
        output.write("%s, %s, %s, %s, %s, %s, %s\n" % (fieldname, cluster, x, y, pixradius, ra, dec))
    
    output.close()

def getSyntheticCatalog():
    """
    Convert FITS table of synthetic clusters to CSV
    """
    data_file = os.path.join('..', 'data', 'phat_fcz-directory.fits')
    data = pyfits.getdata(data_file)
    
    with open('synthetic-clusters.csv', 'w') as f:
        for row in data:
            subimg = row[1]
            fcid = row[2]
            x = row[3]
            y = row[4]
            ra = row[9]
            dec = row[10]
            reff = row[17]
            pixradius = reff * 13.12
            f.write("%s, %s, %s, %s, %s, %s, %s, %s\n" % (subimg, fcid, x, y, ra, dec, reff, pixradius))
        
if __name__ == '__main__':
    # getYear1Catalog()
    getSyntheticCatalog()