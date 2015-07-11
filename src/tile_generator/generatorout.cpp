#include <iostream>
#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

using namespace std;
using namespace cv;

int main(int argc, char** argv){
  if(argc!=2){
    cout<<"wrong input"<<endl;
    return -1;
  }

  Mat image;
  image = imread(argv[1], CV_LOAD_IMAGE_GRAYSCALE);

  if(!image.data){
    cout<<"failed to open image"<<std::endl;
    return -1;
  }

  int rows = image.rows;
  int cols = image.cols;
  int lastBlack = -1;

  unsigned char value;
  int count = 0;
  for(int i=0; i<rows; i++){
    lastBlack=-1;
    for(int j=0; j<cols; j++){
      value = image.at<unsigned char>(i, j);
      if(value<256/2){
        if(lastBlack==-1){
          count+=2;
        }
        lastBlack=j;
      }else{
        if(lastBlack!=-1){
          count++;
        }
        lastBlack=-1;
      }
    }
  }

  printf(".int %i\n", count);
  
  for(int i=0; i<rows; i++){
    lastBlack=-1;
    for(int j=0; j<cols; j++){
      value = image.at<unsigned char>(i, j);
      if(value<256/2){
        if(lastBlack==-1){
          printf(".int %i\n.int %i\n", i, j);
        }
        lastBlack=j;
      }else{
        if(lastBlack!=-1){
          printf(".int %i\n", j);
        }
        lastBlack=-1;
      }
    }
  }
  return 0;
}
