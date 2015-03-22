import numpy as np

class Mesh:
    def __init__(self, v=[], f=[]):
        self.v = v;
        self.f = f;

    # normalize the mesh into a unit ball. Don't return anything.
    def normalize(self):
        minv0 = np.min(self.v[:, 0])
        maxv0 = np.max(self.v[:, 0])
        minv1 = np.min(self.v[:, 1])
        maxv1 = np.max(self.v[:, 1])
        minv2 = np.min(self.v[:, 2])
        maxv2 = np.max(self.v[:, 2])
        avgv0 = np.mean(self.v[:, 0])
        avgv1 = np.mean(self.v[:, 1])
        avgv2 = np.mean(self.v[:, 2])
        scale = np.min([maxv0 - minv0, maxv1 - minv1, maxv2 - minv2])
        self.v = (self.v - [avgv0, avgv1, avgv2]) / scale

    # parse an obj file and return a Mesh object
    @staticmethod
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
