import os
import sys
import json
import numpy
from astropy.io import fits as pyfits


def fixSubImg(subimg):
    [field, subimg] = subimg.split('_')
    return "%s_%02d" % (field, int(subimg))

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
    
    data_dir = os.path.join('..', 'data')
    data = pyfits.getdata(os.path.join(data_dir, 'phat_subimg-cntrs2_v5.fits'))
    
    FILENAME = data['FILENAME']
    RA = data['RA']
    DEC = data['DEC']
    NX = data['NX']
    NY = data['NY']
    
    obj = {}
    for index, img_id in enumerate(FILENAME):
      obj[img_id] = {
        "ra": RA[index],
        "dec": DEC[index],
        "nx": str(NX[index]),
        "ny": str(NY[index])
      }
    
    output = open(os.path.join(data_dir, 'image-centers-round-2.json'), 'w')
    output.write(json.dumps(obj))
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
    data_dir = os.path.join('..', 'data')
    data = pyfits.getdata(os.path.join(data_dir, 'phat_fcz2-directory_v2.fits'))
    
    SUBIMG = data['SUBIMG']
    FCID = data['FCID']
    X = data['X']
    Y = data['Y']
    RA = data['RA']
    DEC = data['DEC']
    REFF = data['REFF']
    
    synthetics = {}
    for index, subimg in enumerate(SUBIMG):
      if subimg not in synthetics:
        synthetics[subimg] = []
      
      obj = {
        "fcid": str(FCID[index]),
        "x": str(X[index]),
        "y": str(Y[index]),
        "reff": str(REFF[index]),
        "pixradius": str(REFF[index] * 13.12)
      }
      synthetics[subimg].append(obj)
    
    output = open(os.path.join(data_dir, 'synthetic-clusters-round-2.json'), 'w')
    output.write( json.dumps(synthetics) )
    output.close()


def getBetaSubjects():
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
  elif argument == 'beta':
    getBetaSubjects()
