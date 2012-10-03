import os
import json
import pyfits

def header2json():
    """
    FITS header to JSON.
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

if __name__ == '__main__':
    header2json()