#include "GME.hpp"

#include <opencv2/calib3d/calib3d.hpp> //findHomography

#include <iostream>
#include <math.h>

void
computeGME(const cv::Mat &motionVectors,
	   cv::Mat &motionVectorsGlobal)
{
	motionVectorsGlobal = cv::Mat(motionVectors.rows, motionVectors.cols, CV_32FC2);
	cv::Mat src = cv::Mat(motionVectors.rows, motionVectors.cols, CV_32FC2);
	cv::Mat dst = cv::Mat(motionVectors.rows, motionVectors.cols, CV_32FC2);

  //TODO: compute global motion estimated vectors
  // use cv::findHomography and cv::perspectiveTransform
	for (int i=0; i<motionVectors.rows; ++i) {
    for (int j=0; j<motionVectors.cols; ++j) {
			src.at<cv::Point2f>(i,j) = cv::Point2f(i,j);
			dst.at<cv::Point2f>(i,j) = cv::Point2f(i+motionVectors.at<cv::Vec2f>(i,j)[0],j+motionVectors.at<cv::Vec2f>(i,j)[1]);
		}
	}
	dst = dst.reshape(1,motionVectors.rows * motionVectors.cols);
	cv::Mat tmp = src.reshape(1,motionVectors.rows * motionVectors.cols);
	cv::Mat homography = cv::findHomography(tmp,dst,CV_RANSAC);

	cv::Mat dst2;
	cv::perspectiveTransform(src,dst2,homography);

	motionVectorsGlobal = dst2-src;

  //See http://docs.opencv.org/2.4.9/modules/calib3d/doc/camera_calibration_and_3d_reconstruction.html?highlight=findhomography#findhomography
  // and https://docs.opencv.org/2.4.9/modules/core/doc/operations_on_arrays.html?highlight=perspectivetransform#cv2.perspectiveTransform
  //According to the documentation, cv::findHomography & cv::perspectiveTransform take InputArrays & OutputArrays
  //See here http://docs.opencv.org/2.4.13/modules/core/doc/intro.html#inputarray-and-outputarray
  //They are just proxies around a cv::Mat or a std::vector
  //For example, for cv::findHomography(), for 'src',  we can pass a cv::Mat of type CV_32FC2 or a std::vector<cv::Point2f>. It will work the same.
  //
  //**WARNING**
  //If you pass cv::Mats to cv::findHomography, they have to have 1 column or 1 row !
  //Otherwise, there is an assert that will fail in OpenCV implementation.
  //You can use cv::reshape to just change the shape of you matrix :
  // pass from a matrix of size rows x cols to a matrix of size 1 x rows*cols.
  //Here you would call: reshape(0, 1);
  assert(motionVectorsGlobal.type() == CV_32FC2);


}

void
computeGlobalMotionError(const cv::Mat &motionVectors,
			 const cv::Mat &motionVectorsGlobal,
			 cv::Mat &motionError)
{
  assert(motionVectors.type() == CV_32FC2);
  assert(motionVectorsGlobal.type() == CV_32FC2);

  motionError.create(motionVectors.rows, motionVectors.cols, CV_32F);

  //TODO: compute the error between actual motion vectors and estimated global motion vectors
	cv::Mat tmp = cv::Mat(motionVectors.rows, motionVectors.cols, CV_32F);
	for (int i=0; i<motionVectors.rows; ++i) {
    for (int j=0; j<motionVectors.cols; ++j) {
			float x = motionVectors.at<cv::Vec2f>(i,j)[0]-motionVectorsGlobal.at<cv::Vec2f>(i,j)[0];
			float y = motionVectors.at<cv::Vec2f>(i,j)[1]-motionVectorsGlobal.at<cv::Vec2f>(i,j)[1];
		 	tmp.at<float>(i,j) = sqrt((x*x)+(y*y));
		}
	}
	cv::normalize(tmp, motionError, 0, 1, cv::NORM_MINMAX, CV_32F);

  assert(motionError.type() == CV_32F);
}
