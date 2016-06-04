SOM som;
int iter;
int maxIters = 5000;
int screenW = 600;
int screenH = 600;

boolean bDebug = true;
float learnDecay;
float radiusDecay;
PFont font;
boolean bGo = false;
String outString;
int fade = 0;
int last = 0;


void setup() 
{
  size(screenW, screenH+50, P3D);
  background(0);
  frameRate(32);
  
  som = new SOM(40, 40, 7);
  som.initTraining(maxIters);
  iter = 1;
  
  font = loadFont("BatangChe-12.vlw");
  textAlign(LEFT, TOP);
  learnDecay = som.learnRate;
  radiusDecay = (som.mapWidth + som.mapHeight) / 2;
}

void draw()
{

  if(keyPressed) {
    if (key == 'g' || key == 'G') {
      bGo = true;
           
    }
    if (key == 'p' || key == 'P') {
      bGo = false;
        
    }
    if (key == 'r' || key == 'R' ) {
      setup();
      bGo = false;
     
      learnDecay = som.learnRate;
      radiusDecay = (som.mapWidth + som.mapHeight) / 2;
    }  
  }
  


  float[][] country = new float[12][7] ;

  country[0][0] = 53608446;    country[0][1] = 1595;      country[0][2] = 767;      country[0][3] = 0.1;    country[0][4] = 0;  country[0][5] = 49100;    country[0][6] = 131;
  country[1][0] = 145212012;   country[1][1] = 13683;     country[1][2] = 8325;     country[1][3] = 1;      country[1][4] = 1;  country[1][5] = 612500;   country[1][6] = 473;
  country[2][0] = 10500000;    country[2][1] = 59;        country[2][2] = 59;       country[2][3] = 0;      country[2][4] = 0;  country[2][5] = 1870;     country[2][6] = 53;
  country[3][0] = 25609290;    country[3][1] = 1393;      country[3][2] = 2346;     country[3][3] = 0;      country[3][4] = 0;  country[3][5] = 33700;    country[3][6] = 166;
  country[4][0] = 69117271;    country[4][1] = 3082;      country[4][2] = 15500;    country[4][3] = 0.1;    country[4][4] = 1;  country[4][5] = 76600;    country[4][6] = 352;
  country[5][0] = 749610775;   country[5][1] = 2788;      country[5][2] = 9150;     country[5][3] = 0.1;    country[5][4] = 1;  country[5][5] = 126000;   country[5][6] = 520;
  country[6][0] = 36417842;    country[6][1] = 710;       country[6][2] = 408;      country[6][3] = 0;      country[6][4] = 0;  country[6][5] = 45000;    country[6][6] = 53;
  country[7][0] = 615201057;    country[7][1] = 1785;      country[7][2] = 3569;     country[7][3] = 0.2;    country[7][4] = 0;  country[7][5] = 46000;    country[7][6] = 184;
  country[8][0] = 28802096;    country[8][1] = 1203;      country[8][2] = 423;      country[8][3] = 0.1;     country[8][4] = 1;  country[8][5] = 43000;    country[8][6] = 120;
  country[9][0] = 29164233;    country[9][1] = 908;       country[9][2] = 407;      country[9][3] = 0.1;     country[9][4] = 1;  country[9][5] = 53600;    country[9][6] = 66;
  country[10][0]= 15786816;    country[10][1]= 404;       country[10][2]= 201;      country[10][3]= 0;      country[10][4]= 0;  country[10][5]= 18000;    country[10][6]= 67;
  country[11][0]= 41637773;    country[11][1]= 989;       country[11][2]= 3657;     country[11][3]= 0;      country[11][4]= 0;  country[11][5]= 18185;    country[11][6]= 115;






float[] max=new float[7];
for(int k=0; k<7;k++){
       max[k]=0; 
  for(int i=0;i<12;i++){
    if(country[i][k]>=max[k]){
      max[k]=country[i][k];
    }
  }
  for(int i=0;i<12;i++){
    country[i][k]=country[i][k]/max[k];
  }
}  
  

 background(0);
 
  int t = int(random(12));
  if (iter < maxIters && bGo){
    som.train(iter, country[t]);
    iter++;
  }
  
  background(0);
  som.render1(country[t]);
  for(int i=0;i<12;i++){
  som.render2(country[i],i); 
 }
     
 

  fill(0);
  rect(0, screenH, screenW, 35);
  fill(255);
  textFont(font);
  text("Radius:   "+radiusDecay, 450, 605);
  text("Learning: " +learnDecay, 450, 620);
  text("Iteration " + iter + "/" +maxIters, 450, 635);

  if (fade > 0) { 
    fill(255, fade);
    textFont(font);    
    text(outString, 350, 610);
  }

  fade -= (millis() - last) / 7;
  last = millis();  


}
  

class SOM
{
 int mapWidth;
 int mapHeight;
 Node[][] nodes;
 float radius;
 float timeConstant;
 float learnRate = 0.05;
 int inputDimension;
 
 SOM(int h, int w, int n)
 {
   mapWidth = w;
   mapHeight = h;
   radius = (h + w) / 2;
   inputDimension = n;
   
   nodes = new Node[h][w];
     for(int i = 0; i < h; i++){
     for(int j = 0; j < w; j++) {
       nodes[i][j] = new Node(n, h, w);
       nodes[i][j].x = i;
       nodes[i][j].y = j;
     }
   }
 } 
 
 void initTraining(int iterations)
 {
   timeConstant = iterations/log(radius);   
 }
 
 void train(int i, float w[])
 {   
   radiusDecay = radius*exp(-1*i/timeConstant);
   learnDecay = learnRate*exp(-1*i/timeConstant);
   int ndxComposite = bestMatch(w);
   int x = ndxComposite >> 16;
   int y = ndxComposite & 0x0000FFFF;

   
   for(int a = 0; a < mapHeight; a++) {
   for(int b = 0; b < mapWidth; b++) {
       
        
        float d = dist(nodes[x][y].x, nodes[x][y].y, nodes[a][b].x, nodes[a][b].y);
        float influence = exp((-1*sq(d)) / (2*radiusDecay*i));
       
        
        if (d < radiusDecay){         
          for(int t = 0; t < inputDimension; t++)
            nodes[a][b].w[t] += influence*learnDecay*(w[t] - nodes[a][b].w[t]);
        } 
     } 
   } 
  
 } 
 
 
 
 int bestMatch(float w[])
 {
   float minDist = sqrt(inputDimension);
   int minIndex = 0;
   
   for (int i = 0; i < mapHeight; i++) {
     for (int j = 0; j < mapWidth; j++) {
       float tmp = weight_distance(nodes[i][j].w, w);
       if (tmp < minDist) {
         minDist = tmp;
         minIndex = (i << 16) + j;
       }  
     } 
   } 
   
  // note this index is x << 16 + y. 
  return minIndex;
 }
 
 float weight_distance(float x[], float y[])
 {
    if (x.length != y.length) {
      println ("Error in SOM::distance(): array lens don't match");
      exit();
    }
    float tmp = 0.0;
    for(int i = 0; i < x.length; i++)
       tmp += sq( (x[i] - y[i]));
    tmp = sqrt(tmp);
    return tmp;
 }


void render1(float w[])
 {
   
   
   int pixPerNodeW = screenW / mapWidth;
   int pixPerNodeH = screenH / mapHeight;
   
     for(int i = 1; i < mapWidth-1; i++) {
     for(int j = 1; j < mapHeight-1; j++) {
     for(int z = i-1;z<i+2;z++){
         for(int k = j-1;k<j+2;k++){
           if(!(z==i)&&(k==j)){
             float neighbouWeight=0;
             float colour;
             neighbouWeight=neighbouWeight+weight_distance(nodes[i][j].w,nodes[z][k].w);
             colour=neighbouWeight*255*10;
             
            fill(0,0,colour);
            stroke(0);
            rectMode(CORNER);
            rect(i*pixPerNodeW, j*pixPerNodeH, pixPerNodeW, pixPerNodeH); 
       }
     } 
  
 }   
     }
     }   
 
 } 
 void render2(float[] w,int t)
 {
   
 
   int pixPerNodeW = screenW / mapWidth;
   int pixPerNodeH = screenH / mapHeight;
  
   int ndxComposite = bestMatch(w);
   int x = ndxComposite >> 16;
   int y = ndxComposite & 0x0000FFFF;

   for(int i = 0; i < mapWidth; i++) {
     for(int j = 0; j < mapHeight; j++) {
  
     if(i==x && j==y){
    
     if(t==0){
     fill(255);
     textSize(20);
     text("JPN",i*pixPerNodeW, j*pixPerNodeH);
     }
   if(t==1){
     fill(255);
     textSize(20);
     text("USA",i*pixPerNodeW, j*pixPerNodeH);
   }
   if(t==2){
     fill(255);
     textSize(20);
     text("AUS",i*pixPerNodeW, j*pixPerNodeH);
   }
   if(t==3){
      fill(255);
      textSize(20);
      text("KOR",i*pixPerNodeW, j*pixPerNodeH);
   }
   if(t==4){
     fill(255);
     textSize(20);
     text("RUS",i*pixPerNodeW, j*pixPerNodeH);
   }
   if(t==5){
     fill(255);
     textSize(20);
     text("CHN",i*pixPerNodeW, j*pixPerNodeH);
   }
   if(t==6){
     fill(255);
     textSize(20);
     text("GER",i*pixPerNodeW, j*pixPerNodeH);
   }
   if(t==7){
     fill(255);
     textSize(20);
     text("IND",i*pixPerNodeW, j*pixPerNodeH);
   }
   if(t==8){
     fill(255);
     textSize(20);
     text("FRA",i*pixPerNodeW, j*pixPerNodeH);
   }
   if(t==9){
     fill(255);
     textSize(20);
     text("ENG",i*pixPerNodeW, j*pixPerNodeH);
   }
   if(t==10){
     fill(255);
     textSize(20);
     text("CAN",i*pixPerNodeW, j*pixPerNodeH);
   }
   if(t==11){
     fill(255);
     textSize(20);
     text("TUR",i*pixPerNodeW, j*pixPerNodeH);
   }
   
       }
        } 
   } 
 }
 }




 


class Node
{
  int x, y; 
  int weightCount;
  float [] w; 
  Node(int n, int X, int Y)
  {
    x = X;
    y = Y;
    weightCount = n;
    w = new float[weightCount];
    
    // initialize weights to random values
    for(int i = 0; i < weightCount; i++) 
    {
      w[i] = random(0, 1);
    }
  }
}

