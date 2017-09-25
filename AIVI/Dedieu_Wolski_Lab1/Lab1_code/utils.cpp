#include "utils.hpp"
#include <cstdlib>
#include <iostream>

void
computeErrorImage(const cv::Mat &im, const cv::Mat &imC, cv::Mat &imErr)
{
  assert(im.size()==imC.size());
  assert(im.type() == imC.type());
  assert(im.type() == imErr.type());
  int res = 0;
  int rows = im.rows;
  int cols = im.cols;
  for (int x = 0; x < rows; x++) {
    const unsigned char *r1 = im.ptr<const unsigned char>(x);
    const unsigned char *r2 = imC.ptr<const unsigned char>(x);
    for (int y = 0; y < cols; y++) {
        res = (int)r1[y] - (int)r2[y] +128;
        if(res<0)
          res=0;
        if(res>255)
          res = 255;
        imErr.data[x*cols+y] = (const unsigned char)res;
    }
  }
}

double computeMSE(const cv::Mat &im, const cv::Mat &imC)
{
  assert(im.size() == imC.size());
  assert(im.type() == imC.type());
  double res = 0.0;
  int rows = im.rows;
  int cols = im.cols;
  for (int x = 0; x < rows; x++) {
    const unsigned char *r1 = im.ptr<const unsigned char>(x);
    const unsigned char *r2 = imC.ptr<const unsigned char>(x);
    for (int y = 0; y < cols; y++) {
        res += ((double)r1[y] - (double)r2[y])*((double)r1[y] - (double)r2[y]);
    }
  }
  return (res/(double)(rows*cols));
}

double computePSNR(const cv::Mat &im, const cv::Mat &imC)
{
  return 10*log10((255*255)/(computeMSE(im, imC)));
}

double computePSNR(double MSE)
{
  return 10*log10((255*255)/MSE);
}

double computeEntropy(const cv::Mat &im)
{
  double histo[256];
  for(int i=0; i<256; i++){
    histo[i]=0;
  }
  int rows = im.rows;
  int cols = im.cols;
  for (int i = 0; i < rows; i++) {
    const unsigned char *r1 = im.ptr<const unsigned char>(i);
    for (int j = 0; j < cols; j++) {
      histo[(int)r1[j]]++;
    }
  }
  double res = 0;
  for (int k = 0; k < 256; k++) {
    histo[k] /= rows*cols;
    if(histo[k]==0){
      res+=0;
    }
    else{
      res += histo[k]*log2(histo[k]);
    }
  }
  return -res;
}
