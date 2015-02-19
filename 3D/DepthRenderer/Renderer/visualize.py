from math import cos, sin, pi
import matplotlib.pyplot as pp
import sys, parseObj
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

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print "too few arguments!"
        print "usage: python {0} <obj file name>".format(sys.argv[0])
        exit(-1)

    fn = sys.argv[1]
    mesh = parseObj.parseObj(fn)
    divide1 = 10
    divide2 = 10
    mlab.figure(size=(1024, 768))

    for i in range(divide1):
        for j in range(divide2):
            mesh2 = parseObj.Mesh()
            mesh2.f = mesh.f
            mesh2.v = np.dot(getRotationMatrix(-pi - i * 2 * pi / divide1, -j * pi / divide2), mesh.v.T).T
            mlab.clf()
            mlab.triangular_mesh(mesh2.v[:, 0], mesh2.v[:, 1], mesh2.v[:, 2], mesh2.f)
            mlab.view(0, 0, 10)
            img = mlab.screenshot()
            pp.imsave('visualize{0}.png'.format(i * divide1 + j), img)
