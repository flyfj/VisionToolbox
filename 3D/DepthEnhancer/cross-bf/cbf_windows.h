#ifndef CBF_H_
#define CBF_H_

#define KINECT2

#define NUM_SCALES 3
#ifdef KINECT2
#define IMG_HEIGHT 424 //480 //427
#define IMG_WIDTH 512 //640 //561
#endif
#ifdef KINECT1
#define IMG_HEIGHT 480
#define IMG_WIDTH 640
#endif

typedef unsigned char uint8_t;

namespace cbf {

// Filters the given depth image using a Cross Bilateral Filter.
//
// Args:
//   depth - HxW row-major ordered matrix.
//   intensity - HxW row-major ordered matrix.
//   mask - HxW row-major ordered matrix.
//   result - HxW row-major ordered matrix.
//   sigma_s - the space sigma (in pixels)
//   sigma_r - the range sigma (in intensity values, 0-1)
void cbf(uint8_t* depth, uint8_t* intensity,
         bool* mask, uint8_t* result, double* sigma_s,
         double* sigma_r);

}  // namespace

#endif  // CBF_H_
