import sys
from math import cos, sin, pi
from scipy import ndimage
from meshtool import Mesh
import matplotlib.pyplot as pp
import numpy as np
import mayavi.mlab as mlab

def getRotationMatrix(theta, phi):
    R1 = np.asarray([[1, 0, 0],
        [0, cos(phi), -sin(phi)],
        [0, sin(phi), cos(phi)]])
    R2 = np.asarray([[cos(theta), 0, sin(theta)],
        [0, 1, 0],
        [-sin(theta), 0, cos(theta)]])
    return np.dot(R2, R1)

def renderViews(mesh,  outdir):
    divide1 = 10
    divide2 = 10
    divide3 = 10
    mlab.figure(size=(1024, 768))

    for i in range(divide1):
        for j in range(divide2):
            if (i * divide2 + j > 36):
                sys.exit(0);
            mesh2 = Mesh()
            mesh2.f = mesh.f
            mesh2.v = np.dot(getRotationMatrix(-pi - i * 2 * pi / divide1, -j * pi / divide2), mesh.v.T).T
            mlab.clf()
            mlab.triangular_mesh(mesh2.v[:, 0], mesh2.v[:, 1], mesh2.v[:, 2], mesh2.f)
            mlab.view(0, 0)
            img = mlab.screenshot()
            #pp.imsave('visualize{0}.png'.format(i * divide2 + j), img)
            for k in range(divide3):
                img2 = ndimage.rotate(img, 360 / divide3 * k, cval=128)
                pp.imsave(('{1}/visualize{0}.png'.format(i * divide2 * divide3 + j * divide3 + k + 1, outdir)), img2)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print "too few arguments!"
        print "usage: python {0} <obj file name> <output dir>".format(sys.argv[0])
        exit(-1)

    fn = sys.argv[1]
    mesh = Mesh.parseObj(fn)
    mesh.normalize()
    renderViews(mesh, sys.argv[2])
