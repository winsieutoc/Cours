/*

  //OpenCV documentation is available here: http://docs.opencv.org/2.4.9/

  //Farneback

*/

#include <cstdlib>
#include <iostream>
#include <iomanip>
#include <queue>
#include <sstream>
#include <fstream>


#include <opencv2/highgui/highgui.hpp> //VideoCapture, imshow, imwrite, ...
#include <opencv2/imgproc/imgproc.hpp> //cvtColor
#include <opencv2/video/video.hpp> //calcOpticalFlowFarneback

#include "utils.hpp"

#define DISPLAY 1
#define SAVE_FRAME 0

int
main(int argc, char **argv)
{
  if(argc != 4) {
    std::cerr << "Usage: " << argv[0] << " video-filename distance-between-two-frames-for-prediction nbLevels" << std::endl;
    return EXIT_FAILURE;
  }

  const char *videoFilename = argv[1];

  const int interFramesDistance = atoi(argv[2]);
  if (interFramesDistance <= 0) {
    std::cerr<<"Error: distance-between-two-frames-for-prediction must be a strictly positive integer"<<std::endl;
    return EXIT_FAILURE;
  }

  const int nbLevels = atoi(argv[3]);
  if (nbLevels <= 0 || nbLevels>5) {
    std::cerr<<"Error: nbLevels must be a strictly positive integer"<<std::endl;
    return EXIT_FAILURE;
  }

  cv::VideoCapture cap;
  cap.open(videoFilename);
  if ( ! cap.isOpened()) {
    std::cerr << "Error : Unable to open video file " << argv[1] << std::endl;
    return -1;
  }

  unsigned long frameNumber = 0;

  const size_t deltaT = interFramesDistance;
  std::queue<cv::Mat> previousFrames;

  std::ofstream myfile("stats_F.txt");

  for ( ; ; ) {

    cv::Mat frameBGR;
    cap >> frameBGR;
    if (frameBGR.empty()) {
      break;
    }

    //save frame
#if SAVE_FRAME
    std::stringstream ss;
    ss<<"frame_"<<std::setfill('0')<<std::setw(6)<<frameNumber<<".png";
    cv::imwrite(ss.str(), frameBGR);
#endif //SAVE_FRAME

    //convert from BGR to Y
    cv::Mat frameY;
    cv::cvtColor(frameBGR, frameY, CV_BGR2GRAY);

    if (previousFrames.size() >= deltaT) {
      cv::Mat prevY = previousFrames.front();
      previousFrames.pop();

      cv::Mat motionVectors;

      const int nbIter = 15; //20;
      const int levels = nbLevels;
      const int winSize = 20; //15;
      const int poly_n = 5;
      const double poly_sigma = 1.2; //1.1;
      const double pyr_scale = 0.5;
      const int flags = cv::OPTFLOW_FARNEBACK_GAUSSIAN;

      //TODO: call calcOpticalFlowFarneback()
      calcOpticalFlowFarneback(frameY, prevY, motionVectors, pyr_scale, levels, winSize, nbIter, poly_n, poly_sigma, flags);

      cv::Mat YC;
      //TODO: compute compensated image YC
      computeCompensatedImageF(motionVectors,prevY,YC);

#if DISPLAY
      cv::Mat imgMV = frameY.clone();
      //TODO: draw motion vectors
      drawMVf(imgMV,motionVectors);
      cv::imshow("MVs", imgMV);
      cv::waitKey(10);
#endif //DISPLAY

      cv::Mat imErr0;
      computeErrorImage(frameY, prevY, imErr0);

      cv::Mat imErr;
      computeErrorImage(frameY, YC, imErr);

      const double MSE = computeMSE(frameY, YC);
      const double PSNR = computePSNR(MSE);
      const double ENT = computeEntropy(frameY);
      const double ENTe = computeEntropy(imErr);

      std::cout<<frameNumber<<" "<<MSE<<" "<<PSNR<<" "<<ENT<<" "<<ENTe<<std::endl;
      myfile<<frameNumber<<" "<<MSE<<" "<<PSNR<<" "<<ENT<<" "<<ENTe<<std::endl;
    }

    previousFrames.push(frameY);

    ++frameNumber;
  }

  myfile.close();
  return EXIT_SUCCESS;
}
