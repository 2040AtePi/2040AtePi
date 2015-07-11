#include <iostream>
#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

using namespace std;
using namespace cv;

int main(int argc, char** argv){
  if(argc!=3){
    cout<<"wrong input"<<endl;
    return -1;
  }

  Mat image;
  image = imread(argv[1], CV_LOAD_IMAGE_GRAYSCALE);

  if(!image.data){
    cout<<"failed to open image"<<std::endl;
    return -1;
  }

  FILE *fp;
  if((fp = fopen(argv[2], "w")) == NULL){
    cout<<"failed to open text file"<<endl;
    return -1;
  }

  int rows = image.rows;
  int cols = image.cols;

  unsigned char value;
  int count = 0;
  for(int i=0; i<rows; i++){
    for(int j=0; j<cols; j++){
      value = image.at<unsigned char>(i, j);
      if(value<256/2){
        count++;
      }
    }
  }

  fprintf(fp, ".int %i\n", count);
  
  for(int i=0; i<rows; i++){
    for(int j=0; j<cols; j++){
      value = image.at<unsigned char>(i, j);
      if(value<256/2){
        //output pos
        fprintf(fp, ".int %i\n",  j); 
      }
    }
  }
  fclose(fp);

  cout<<"Success"<<endl;
  cout<<"Number of dark pixels : "<<count<<endl;
  return 0;
}
