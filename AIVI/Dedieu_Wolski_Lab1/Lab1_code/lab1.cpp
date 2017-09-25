/*

  //OpenCV documentation is available here: http://docs.opencv.org/2.4.9/

  //1.1a - Display & save individual frames of the video as RGB
  // You will need to use classes & methods from the highgui module:
  // VideoCapture, imwrite, imshow, ...
  // You have an example of use of VideoCapture here:
  // http://docs.opencv.org/2.4.9/modules/highgui/doc/reading_and_writing_images_and_video.html#videocapture

  //1.1b - Display & save individual frames of the video as Y from YCrCb
  // You will need to use:
  //  cvtColor from the imgproc module
  //  split from the core module

  //1.2 - Compute the measures: MSE, PSNR, Entropy, Error Image
  // You will need to code these measures in utils.hpp/utils.cpp

  //1.3 - Trace the curves with gnuplot
  // You have examples of gnuplot commands are available in files example*.gplot

*/

#include <cstdlib>
#include <iostream>
#include <queue>
#include <fstream>
#include "utils.hpp"

//using namespace cv; pour retirer les cv::

#include <opencv2/highgui/highgui.hpp> //VideoCapture, imshow, imwrite, ...
#include <opencv2/imgproc/imgproc.hpp> //cvtColor

int
main(int argc, char **argv)
{
  if(argc != 3) {
    std::cerr << "Usage: " << argv[0] << " video-filename distance-between-two-frames-for-prediction" << std::endl;
    return EXIT_FAILURE;
  }

  const char *videoFilename = argv[1];

  const int interFramesDistance = atoi(argv[2]);
  if (interFramesDistance <= 0) {
    std::cerr<<"Error: distance-between-two-frames-for-prediction must be a strictly positive integer"<<std::endl;
    return EXIT_FAILURE;
  }

  cv::VideoCapture cap;
  cap.open(videoFilename);
  if ( ! cap.isOpened()) {
    std::cerr << "Error : Unable to open video file " << argv[1] << std::endl;
    return -1;
  }

  unsigned long frameNumber = 0;
  cv::namedWindow("myWindow",1);

  std::queue<cv::Mat> myqueue;
  std::ofstream myfile("stats.txt");
  std::ofstream myfileEnt("statsEntropy.txt");

  int i =0;
  for ( ; ; ) {

    cv::Mat frameBGR;
    cv::Mat frameGRAY;
    //cv::Mat frameYCrCb;
    cv::Mat tmpMat[3];

    double mse;
    double psnr;
    double ent, entErr;
    cap >> frameBGR;
    cv::Mat frameErr(frameBGR.rows, frameBGR.cols,CV_8UC1);
    if (frameBGR.empty()) {
      break;
    }

    cvtColor(frameBGR, frameGRAY, CV_BGR2GRAY); //to gray
    if(frameNumber < interFramesDistance){
      myqueue.push(frameGRAY);
    }
    else{
      mse = computeMSE(myqueue.front(),frameGRAY);
      psnr = computePSNR(mse);
      ent = computeEntropy(frameGRAY);
      computeErrorImage(myqueue.front(), frameGRAY, frameErr);
      entErr = computeEntropy(frameErr);
      myqueue.pop();
      myqueue.push(frameGRAY);
      myfile << frameNumber << " " << mse << " " << psnr << std::endl;
      myfileEnt << frameNumber << " " << ent << " " << entErr << std::endl;

      std::string tmp = "../Data/imgSave" + std::to_string(i) + ".png";
      i++;
      split(frameErr, tmpMat);
      imwrite(tmp,tmpMat[0]);
    }
    //cvtColor(frameBGR, frameYCrCb, CV_BGR2YCrCb); //to YCrCb

    imshow("myWindow", frameGRAY);
    if(cv::waitKey(interFramesDistance) >= 0) break;
    ++frameNumber;
  }
  myfile.close();
  myfileEnt.close();

  return EXIT_SUCCESS;
}
