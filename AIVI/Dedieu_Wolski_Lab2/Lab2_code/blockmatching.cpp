#include "blockmatching.hpp"

#include <opencv2/imgproc/imgproc.hpp>

#include "utils.hpp"
#include <iostream>



void blockMatchingMono(const cv::Mat &m1, const cv::Mat &m2,
		       int blockSize,
		       int windowSize,
		       cv::Mat &motionVectors)
{
  assert(m1.size() == m2.size()
	 && m1.type() == m2.type()
	 && m1.type() == CV_8UC1);
  assert(blockSize > 0);
  assert(windowSize > 0);

  //Here we suppose that m1.cols & m1.rows are multiple of blockSize
  const int blockXCount = m1.cols / blockSize;
  const int blockYCount = m1.rows / blockSize;

	// std::cout << "m1 size " << m1.rows << " " << m1.cols << "m2 size "<< m2.rows << " " << m2.cols << '\n';

  motionVectors.create(blockYCount, blockXCount, CV_32SC2);

  //TODO: fill motionVectors.

  //We want to traverse all blocks from the m1 image.
  //For each block b1 in m1, we search the block b2 in m2 image
  //such as computeMSE(b1, b2) is minimal.

  //To call computeMSE we will need to create a cv::Mat corresponding to each block.
  //You can for example use the rowRange()/colRange() methods of cv::Mat.

  //Suppose b1 is at position (x1, y1)
  // and the best b2 (that is the block that minimizes computeMSE(b1, b2)) is at (x2Best, y2Best)
  // then the motion vector is (x2Best-x1, y2Best-y1).
  //We can fill the motionVectors matrix with:
  // motionVectors.at<cv::Vec2i>(i, j) = cv::Vec2i(x2Best-x1, y2Best-y1);
	cv::Mat ssBlock1;
	cv::Mat ssBlock2;
	int x, y;
	double resMin;
	for (int k = 0; k < blockYCount; k++) { //ROWS
		for (int l = 0; l < blockXCount; l++) { //COLS
			x = l*blockSize; // COLS
			y = k*blockSize; // ROWS
			if(y+blockSize<m1.rows && x+blockSize<m1.cols){
				ssBlock1 = m1.rowRange(y,y+blockSize).colRange(x,x+blockSize);
				int xBest = 0;
				int yBest = 0;
				resMin = DBL_MAX;
				const int minX = std::max(x-windowSize/2,0);
				const int minY = std::max(y-windowSize/2,0);
				const int maxX = std::min(x+windowSize/2,m1.cols)-blockSize;
				const int maxY = std::min(y+windowSize/2,m1.rows)-blockSize;
				for (int i = minX; i < maxX; i++) { //ROWS
					for (int j = minY; j < maxY; j++) { //COLS
						if(i>=0 && j>=0 && i+blockSize<m2.cols && j+blockSize<m2.rows){
							ssBlock2 = m2.rowRange(j,j+blockSize).colRange(i,i+blockSize);
							double res = computeMSE(ssBlock1,ssBlock2);
							if(res<resMin){
								resMin = res;
								xBest = i;
								yBest = j;
							}
						}
					}
				}
				motionVectors.at<cv::Vec2i>(k,l) = cv::Vec2i(xBest-x, yBest-y); //(x-j, y-i)
			}
		}
	}

}


//Helper function for blockMatchingMulti
//Here motion vectors are used both as an input and an output.
//If they are non empty, then they are used to initialize block b2 search window position.
void blockMatchingMono2(const cv::Mat &m1, const cv::Mat &m2,
			int blockSize,
			int windowSize,
			cv::Mat &motionVectors)
{
  assert(m1.size() == m2.size()
	 && m1.type() == m2.type()
	 && m1.type() == CV_8UC1);
  assert(blockSize > 0);
  assert(windowSize > 0);

  //Here we suppose that m1.cols & m1.rows are multiple of blockSize
  const int blockXCount = m1.cols / blockSize;
  const int blockYCount = m1.rows / blockSize;
	motionVectors.create(blockYCount, blockXCount, CV_32SC2);

  //TODO : fill motionVectors
	cv::Mat ssBlock1;
	cv::Mat ssBlock2;
	int x, y;
	double resMin;
	for (int k = 0; k < blockYCount; k++) { //ROWS
		for (int l = 0; l < blockXCount; l++) { //COLS
			x = l*blockSize; // COLS
			y = k*blockSize; // ROWS
			if(y+blockSize<m1.rows && x+blockSize<m1.cols){
				ssBlock1 = m1.rowRange(y,y+blockSize).colRange(x,x+blockSize);
				int xBest = 0;
				int yBest = 0;
				resMin = DBL_MAX;
				const int minX = std::max(x-windowSize/2,0);
				const int minY = std::max(y-windowSize/2,0);
				const int maxX = std::min(x+windowSize/2,m1.cols)-blockSize;
				const int maxY = std::min(y+windowSize/2,m1.rows)-blockSize;
				for (int i = minX; i < maxX; i++) { //ROWS
					for (int j = minY; j < maxY; j++) { //COLS
						if(i>=0 && j>=0 && i+blockSize<m2.cols && j+blockSize<m2.rows){
							ssBlock2 = m2.rowRange(j,j+blockSize).colRange(i,i+blockSize);
							double res = computeMSE(ssBlock1,ssBlock2);
							if(res<resMin){
								resMin = res;
								xBest = i;
								yBest = j;
							}
						}
					}
				}
				motionVectors.at<cv::Vec2i>(k,l) = cv::Vec2i(xBest-x, yBest-y); //(x-j, y-i)
			}
		}
	}

}




void up(const cv::Mat &m, cv::Mat &m2)
{
  assert(m.type() == CV_32SC2);

  m2 = 2 * m;
}


void blockMatchingMulti(const cv::Mat &m1, const cv::Mat &m2,
			int blockSize,
			int windowSize,
			int nbLevels,
			std::vector<cv::Mat> &levels1,
			std::vector<cv::Mat> &levels2,
			std::vector<cv::Mat> &motionVectors)
{
  assert(m1.size() == m2.size()
	 && m1.type() == m2.type()
	 && m1.type() == CV_8UC1);
  assert(blockSize > 0);
  assert(windowSize > 0);
  assert(nbLevels > 0);

  motionVectors.resize(nbLevels);
  levels1.resize(nbLevels);
  levels2.resize(nbLevels);

  std::vector<int> blockSizes(nbLevels);
  levels1[0] = m1;
  levels2[0] = m2;
  blockSizes[0] = blockSize;
  for (int i=1; i<nbLevels; ++i) { //start from 1
    cv::pyrDown(levels1[i-1], levels1[i], cv::Size(levels1[i-1].cols/2, levels1[i-1].rows/2));
    cv::pyrDown(levels2[i-1], levels2[i], cv::Size(levels2[i-1].cols/2, levels2[i-1].rows/2));
    blockSizes[i] = blockSizes[i-1]/2;
  }

  for (int i=nbLevels-1; i>=0; i--) {

    blockMatchingMono2(levels1[i], levels2[i], blockSizes[i], windowSize, motionVectors[i]);

    if (i > 0) {
      up(motionVectors[i], motionVectors[i-1]);
    }
  }

}
