import os
import sys
import json
import numpy
import pyfits

def header2json():
    """
    Convert FITS headers with WCS to JSON.
    """
    wcs_keywords = ['WCSAXES', 'NAXIS1', 'NAXIS2', 'CRPIX1', 'CRPIX2', 'CRVAL1', 'CRVAL2', 'CTYPE1', 'CTYPE2', 'CD1_1', 'CD1_2', 'CD2_1', 'CD2_2']
    
    data_dir = os.path.join('..', 'data', 'imghead_final')
    headers = os.listdir(data_dir)
    
    for f in headers:
        path = os.path.join(data_dir, f)
        header = pyfits.getheader(path)
        
        wcs = {}
        for key in wcs_keywords:
            wcs[key] = header[key]
        
        output = open(os.path.join(data_dir, '..', 'headers', f + ".json"), 'w')
        output.write(json.dumps(wcs))
        output.close()


def subimage_centers():
    
    def rescale(x, y):
        x = 215. * x / 650.
        y = 248. * y / 750.
        return [x, y]
    
    data_dir = os.path.join('..', 'data')
    data = pyfits.getdata(os.path.join(data_dir, 'phat_subimg-cntrs_v1.fits'))
    
    d = {}
    for row in data:
        img_id = row[3]
        [x, y] = rescale(row[6], row[7])
        d[img_id] = {'x': str(x), 'y': str(y), 'ra': row[4], 'dec': row[5]}
    output = open(os.path.join(data_dir, 'image-centers.json'), 'w')
    output.write(json.dumps(d))
    output.close()


def getYear1Catalog():
    """
    Convert FITS table of year 1 PHAT cluster catalog to CSV
    """
    data_file = os.path.join('..', 'data', 'phat_pcassign_v1.fits')
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


def betaSubjects():
  """
  Select beta subjects in a 3:1 ratio of real to synthetics.
  
  Subfields for beta are:
  
  B21-F14
  B15-F09
  B15-F11
  
  There are 28 subimages per subfield.  Each subimage is flavored as
  color, grayscale, color+synthetics, grayscale+synthetics.
  """
  subimage = 0
  ratio = 3
  
  color = "%s_%d"
  gray = "%s_F475W"
  synth = "%s_sc"
  
  for subfield in ['B21-F14', 'B15-F09', 'B15-F11']:
    for i in xrange(1, 29):
      f1 = color % (subfield, i)
      f2 = gray % (f1)
      print f1
      print f2
      
      if (i - 1) % 3 == 0:        
        f3 = synth % (f1)
        f4 = synth % (f2)      
        print f3
        print f4

if __name__ == '__main__':
  betaSubjects()
  
  if len(sys.argv) != 2:
    sys.exit()

  argument = sys.argv[1]
  if argument == 'header':
    header2json()
  elif argument == 'centers':
    subimage_centers()
  elif argument == 'year1':
    getYear1Catalog()
  elif argument == 'synthetic':
    getSyntheticCatalog()