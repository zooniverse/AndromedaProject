import os
import sys
import numpy
import pyfits

def getYear1Catalog():
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
        output.write("%s, %s, %s, %s, %s, %s, %s" % (fieldname, cluster, x, y, pixradius, ra, dec))
        output.write('\n')
    
    output.close()
    
        
if __name__ == '__main__':
    getYear1Catalog()