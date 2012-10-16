import os
import re
import sys
import StringIO
import numpy
import pyfits
import pywcs

def getBrickNumber():
    """
    Determine in which bricks the year 1 PHAT Stellar catalog exists.
    """
    
    # Open the PHAT Stellar Catalog
    f = open('Year1Catalog.txt', 'r')
    catalog = f.read().split('\n')[35:]
    
    clusters = numpy.array([])
    for cluster in catalog:
        cluster = re.split('\s+', cluster)
        if cluster[0] == '':
            cluster = cluster[1:]
        cluster = cluster[:-1]
        
        cluster[0] = int(cluster[0])
        for i in xrange(1, len(cluster)):
            cluster[i] = float(cluster[i])
        
        item = numpy.array(cluster[0:3])
        clusters = numpy.append(clusters, item)
    
    clusters = clusters.reshape(237, 3)

    # Examine the header of each brick
    path_to_headers = os.path.join('..', 'data', 'imghead_final')
    headers = os.listdir(path_to_headers)
    
    output = open('brick-number-year1.csv', 'w')
    for header in headers:
        hdr = pyfits.getheader(os.path.join(path_to_headers, header))
        try:
            wcs = pywcs.WCS(hdr)
        except:
            # print "Something went wrong with %s" % header
            continue
            
        naxis1 = wcs.naxis1
        naxis2 = wcs.naxis2
        
        sky = wcs.wcs_sky2pix(clusters[:, (1, 2)], 0)
        index = 0
        for coordinate in sky:
            [x, y] = coordinate
            if x < naxis1 and x > 0 and y < naxis2 and y > 0:
                identification = clusters[index][0]
                output.write("%s, %s, %s, %s\n" % (header.replace('.fits', ''), int(identification), str(coordinate[0]), str(coordinate[1])))
            index += 1
    output.close()
        
if __name__ == '__main__':
    sys.stderr = StringIO.StringIO()
    getBrickNumber()