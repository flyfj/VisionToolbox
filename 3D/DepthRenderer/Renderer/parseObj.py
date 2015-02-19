import sys
import numpy as np

class Mesh:
    def __init__(self, v=[], f=[]):
        self.v = v;
        self.f = f;

def parseObj(fn):
    mesh = Mesh()
    # parse the vertex coordinates
    lines = file(fn).readlines()
    # first pass to get the min/max
    for l in lines:
        if l[0] == 'v': 
            fields = l.split(' ')
            v1 = float(fields[1])
            v2 = float(fields[2])
            v3 = float(fields[3])
            mesh.v.append([v1, v2, v3])
        if l[0] == 'f':
            fields = l.split(' ')
            v1 = int(fields[1])
            v2 = int(fields[2])
            v3 = int(fields[3])
            mesh.f.append([v1, v2, v3])
    mesh.v = np.asarray(mesh.v)
    mesh.f = np.asarray(mesh.f) - 1
    return mesh

if __name__ == '__main__':
    if len(sys.argv) < 1:
        print "too few arguments!"
        print "usage: python {0} <obj file name>".format(sys.argv[0])
        exit(-1)

    fn = sys.argv[1]
    mesh = parseObj(fn)
    print 'Mesh parsed. Has {0} vertices, and {1} faces.'.format(mesh.v.shape[0], mesh.f.shape[0])
