/*

  //OpenCV documentation is available here: http://docs.opencv.org/2.4.9/

  //Block matching in mono and multi-resolution

*/

#include <cstdlib>
#include <iostream>
#include <iomanip>
#include <queue>
#include <sstream>
#include <fstream>


#include <opencv2/highgui/highgui.hpp> //VideoCapture, imshow, imwrite, ...
#include <opencv2/imgproc/imgproc.hpp> //cvtColor

#include "utils.hpp"
#include "blockmatching.hpp"

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
  if (nbLevels <= 0 || nbLevels>4) {
    std::cerr<<"Error: nbLevels must be a strictly positive integer"<<std::endl;
    return EXIT_FAILURE;
  }

  const int blockSize = 8;
  const int windowSize = 32;
  //TODO: it would be better to pass these values as parameters

  cv::VideoCapture cap;
  cap.open(videoFilename);
  if ( ! cap.isOpened()) {
    std::cerr << "Error : Unable to open video file " << argv[1] << std::endl;
    return -1;
  }

  unsigned long frameNumber = 0;

  const size_t deltaT = interFramesDistance;
  std::queue<cv::Mat> previousFrames;

  std::ofstream myfile("stats.txt");
  std::ofstream myfileEnt("statsEnt.txt");

  std::ofstream myfileBIS("statsBIS.txt");
  std::ofstream myfileMSE("statsMSE.txt");

  cv::string nameImg[nbLevels];
  for(int s=nbLevels-1; s>=0; s--){
    nameImg[s] = "image"+std::to_string(s);
  }

  for ( ; ; ) {

    cv::Mat frameBGR;
    cap >> frameBGR;
    if (frameBGR.empty()) {
      break;
    }

    //convert from BGR to Y
    cv::Mat frameY;
    cv::cvtColor(frameBGR, frameY, CV_BGR2GRAY);

    if (previousFrames.size() >= deltaT) {
      cv::Mat prevY = previousFrames.front();
      previousFrames.pop();



      if (nbLevels == 1) {
double MSE, PSNR, ENT, ENTe;

	cv::Mat motionVectors;
	blockMatchingMono(frameY, prevY, blockSize, windowSize, motionVectors);
  cv::Mat YC(prevY.rows, prevY.cols,CV_8UC1);
	computeCompensatedImage(motionVectors, prevY, YC);

  //save frame
  std::stringstream ss;
  ss<<"../data/frame_"<<std::setfill('0')<<std::setw(6)<<frameNumber<<".png";
  cv::imwrite(ss.str(), YC);

	//TODO: compute measures (& display images) ...
  cv::Mat tmp = frameY.clone();
  drawMVi(tmp,motionVectors);
  //std::cout << "motionVector:\n" << motionVectors << '\n';
  cv::imshow("image", tmp);
  cv::waitKey(10);

  MSE = computeMSE(prevY,YC);
  PSNR = computePSNR(MSE);
  ENT = computeEntropy(YC);
  cv::Mat frameErr;
  computeErrorImage(prevY, YC, frameErr);
  ENTe = computeEntropy(frameErr);


	std::cout<<frameNumber<<" "<<MSE<<" "<<PSNR<<" "<<ENT<<" "<<ENTe<<"\n";
  myfile << frameNumber << " " << MSE << std::endl;
  myfileEnt << frameNumber << " " << PSNR << " " << ENT << " " << ENTe << std::endl;
      }
      else {

	std::vector<cv::Mat> levelsY;
	std::vector<cv::Mat> levelsPrevY;
	std::vector<cv::Mat> motionVectorsP;
  std::vector<float> MSE;
  std::vector<float> PSNR;
  std::vector<float> ENT;
	blockMatchingMulti(frameY, prevY, blockSize, windowSize, nbLevels, levelsY, levelsPrevY, motionVectorsP);

	std::cout<<frameNumber;
  myfileMSE<<frameNumber<< " ";
  MSE.resize(nbLevels);
  PSNR.resize(nbLevels);
  ENT.resize(nbLevels);
	for (int i=nbLevels-1; i>=0; --i) {
    cv::Mat YC(levelsPrevY[i].rows, levelsPrevY[i].cols,CV_8UC1);
    computeCompensatedImage(motionVectorsP[i], levelsPrevY[i], YC);
    cv::Mat tmp = YC.clone();
    drawMVi(tmp,motionVectorsP[i]);
    cv::imshow(nameImg[i], tmp);
    cv::waitKey(10);

    MSE[i] = computeMSE(levelsPrevY[i],YC);
    PSNR[i] = computePSNR(MSE[i]);
    ENT[i] = computeEntropy(YC);

    // myfileBIS << frameNumber << " En "<< i <<" "<<MSE<< " " << PSNR << " " << ENT << std::endl;
    std::cout<< "res = " <<" "<<MSE[i]<<" "<<PSNR[i]<<" "<<ENT[i];
    myfileMSE<<MSE[i]<< " ";
	}
  myfileMSE  << std::endl;
  // myfileMSE << frameNumber << " ";
  // for (int i = nbLevels-1; i >=0 ; i--) {
  //   myfileMSE << MSE[i] << " ";
  // }
  myfileMSE << "\n";

  myfileBIS << std::endl;
	std::cout<<"\n";
      }


    }

    previousFrames.push(frameY);

    ++frameNumber;
  }

  myfileMSE.close();
  myfileBIS.close();
  myfileEnt.close();
  myfile.close();
  return EXIT_SUCCESS;
}
