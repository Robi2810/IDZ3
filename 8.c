#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
 
double mabs(double x){ return (x < 0)? -x : x; }

double root_res(double num){
  if(num == 0){
     return 0.0;
  }
  else if(num == 1){
     return 1.0;
  }
  if(num == -1){
     return -1.0;
  }
  else if(num < 0){
     num = -num;
     int rootDegree = 5;
     double eps = 0.001;   
     double root = num / rootDegree; 
     double rn = num;                 
     while(mabs(root - rn) >= eps){
         rn = num;
         for(int i = 1; i < 5; i++){
            rn = rn / root;
         }
         root = rn / num + root * (1.0 - 1.0 / num);
     }
     return -root;
  }
  int rootDegree = 5;
  double eps = 0.001;   
  double root = num / rootDegree; 
  double rn = num;                 
  while(mabs(root - rn) >= eps){
      rn = num;
      for(int i = 1; i < 5; i++){
          rn = rn / root;
      }
      root = rn / num + root * (1.0 - 1.0 / num);
  }
  return root;
}

int main(int argc, char *argv[]) {
  if((argc != 2) && (argc != 4)){
    printf("Incrorrect input, check README.md\n");
    return 0;
  }
  clock_t start, end;
  if(strcmp(argv[1], "-r") == 0){
    srand(time(NULL));
    int a = (rand()%10000)+100;
    double b = (rand()%25)+1;
    double num = a / b; 
    printf("random num = %lf\n", num);
    start = clock();
    double root = root_res(num);
    end = clock();
    printf("root: %lf\ntime: %.6lf\n", root, (double)(end-start)/(CLOCKS_PER_SEC));
  }
  else if(strcmp(argv[1], "-h") == 0){
    printf("\n-h help\n");
    printf("-r create random number\n");
    printf("-f use number from first file and save result in second file\n");
    printf("-s take number from terminal and print result in terminal\n");
  }
  else if(strcmp(argv[1], "-f") == 0){
    FILE *input = fopen(argv[2], "r");
    FILE *out = fopen(argv[3], "w");
    if((input == NULL) || (out == NULL)){
      printf("incorrect file\n");
      return 0;
    }
    double num; 
    fscanf(input, "%lf", &num);
    start = clock(); 
    double root = root_res(num);
    end = clock();
    fprintf(out, "root = %lf\ntime: %.6lf\n", root, (double)(end-start)/(CLOCKS_PER_SEC));
    fclose(input);
    fclose(out);
  }
  else if((strcmp(argv[1], "-s") == 0)){
    double num;
    scanf("%lf", &num);
    start = clock();
    double root = root_res(num);
    end = clock();
    printf("root = %lf\ntime: %.6lf\n", root, (double)(end-start)/(CLOCKS_PER_SEC));
  }
  return 0;
}
