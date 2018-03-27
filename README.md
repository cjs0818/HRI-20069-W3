# Yolo Homepage
 Refer to Yolo homepage
 * https://pjreddie.com/darknet/

# Install Docker
At first, install Docker to your system

* Download Docker CE (Community Edition)

  * https://www.docker.com/community-edition

# Download Git Repository of our Class
* **HOMEDIR** is assummed to be your working directory
  ```
  $ HOMEDIR = your_work_directory
  ```
* Download **HRI-20069-W3** repository for this class.
  ```
  $ cd $HOMEDIR
  $ git clone https://github.com/cjs0818/HRI-20069-W3
  $ cd HRI-20069-W3
  $ git submodule init
  $ git submodule update
  ```
  

#  !!! SKIP this because it is already included in HRI-20069-W3 repository !!!  (Download darknet)

 * Download **darknet** in **HRI-20069-W3** directory.
  ```
  $ cd $HOMEDIR/HRI-20069-W3
  $ git clone https://github.com/AlexeyAB/darknet
  ```

# Download Yolo Weights
 * Download a pre-trained yolo weight. (it can be done easily by ```./get_yolo_weights.sh```)
 ```
  $ wget https://pjreddie.com/media/files/yolo-voc.weights -P $HOMEDIR/darknet_weights_data
 ```
 
 * If you have time, download the other weights.
 ```
  $ wget https://pjreddie.com/media/files/yolo.weights -P $HOMEDIR/darknet_weights_data
  $ wget https://pjreddie.com/media/files/tiny-yolo.weights -P $HOMEDIR/darknet_weights_data
  $ wget https://pjreddie.com/media/files/yolo9000.weights -P $HOMEDIR/darknet_weights_data
 ```



# Download or Build the OpenCV docker image
 * Download **pristine70/cv_cuda** image
  ```
  $ docker login
  $ ~~~~
  $ ~~~~
  $ docker pull pristine70/cv_cuda
  ```
 * Or Build the OpenCV docker image.
  ```
  $ ./docker_build.sh
  ```
  which will perform ```docker build -t pristine70/cv_cuda```. But because it takes more than 1-hour, the above **Download** (```docker pull pristine70/cv_cuda```) is recommended.



# Start Docker

* Modify ```start.sh```.
  Set up parameters such as DOCKER (nvidia-docker or docker), EN0 (ifconfig ...), WORKDIR in the ```start.sh``` file

  ```
  DOCKER=nvidia-docker
  #DOCKER=docker

  #EN0=en0
  #EN0=enp0s5
  EN0=enp0s31f6
  
  #WORKDIR=/Users/jschoi/work/HRI-20069-W3
  WORKDIR=/home/jschoi/work/HRI-20069-W3
  ```

* Execute 'start.sh' file

  ```
  $ ./start.sh

  # Compile darknet inside Docker
  /root/work$ cd /root/work/darknet
  
  # Modify paramaters in Makefile according to your system
  OPENCV=0 into OPENCV=1
  Set or unset GPU, CUDNN, ...

  /root/work/darknet$ make clean
  /root/work/darknet$ make

  # Test darknet
  /root/work/darknet$ chmod 755 image_voc.sh
  /root/work/darknet$ ./image_voc.sh
  ```
  
# Train darknet
 ## Build data
  * !!! SKIP this because it is already included in HRI-20069-W3 repository !!! (download Yolo_mark)
  ```
  $ git clone https://github.com/AlexeyAB/Yolo_mark
  $ cd Yolo_mark
  $ cmake .
  $ make
  $ chmod 755 linux.mark.sh
  $ ./linux_mark.sh
  ```
 ## Arrange the data & configuration files
  * Arrange the followings and modify their contents properly
  
   * x64/Release/data/img/*.jpg
   * x64/Release/data/obj.data
   * x64/Release/data/obj.names
   * x64/Release/data/train.txt
  * Build your own data by performing ```./linux_mark.sh```
   * Draw bounding boxes and select the number of labels, then the resultant data will be generated in which values of x, y, width, height for each pictures are written.
   ```
   x64/Release/data/img/*.txt
   ```

  * Copy the generated files
   ```
   $ cp -R x64/Release/data $HOMEDIR/HRI-20069-W3/darknet/data_cjs
   ```
  * Copy a config file & modify the number of classes and filters.
   ```
   $ cp x64/Release/yolo-obj.cfg $HOMEDIR/HRI-20069-W3/darknet/data_cjs/
   ```
  * Modify ```obj.data``` to point your training data
   ```
   $ vi $HOMEDIR/HRI-20069-W3/darknet/data_cjs/obj.data
   classes = 2
   train  = data/data_cjs/train.txt
   valid  = data/data_cjs/train.txt
   names = data/data_cjs/obj.names
   backup = backup
   ```
  * Modify the ```yolo-obj.cfg``` based on your training data
   ```
   $ vi $HOMEDIR/HRI-20069-W3/darknet/data_cjs/yolo-obj.cfg
   ...
   filters = ~~
   classes = ~~
   ...
   ```
   
   Here, you should keep the rule of ```the # of filters = (5 + # of classes) * 5```. For example, if the # of classes = 2, then the # of filters should be 35
   
 ## Let's Train & Test
  * Download Pre-trained Convolutional Weights
  ```
  $ wget http://pjreddie.com/media/files/darknet19_448.conv.23 -P $HOMEDIR/darknet_weights_data
  ```   
   
  * Train your data
   Prepare the following ```train.sh``` and execute it.
   ```
   $ cd $HOMEDIR/HRI-20069-W3/darknet
   $ vi train.sh
   $ ./darknet detector train ./data_cjs/obj.data ./data_cjs/yolo-obj.cfg $HOMEDIR/darknet_weights_data/darknet19_448.conv.23
   $ ./train.sh
   
   ```
   
  Then, you will get yolo-obj_*number*.weights in a folder you have setup in the ```data_cjs/obj.data``` such as ```yolo-obj_2200.weights```


  * Test your data
   * Assuming that you acquired ```yolo-obj_2200.weights```

    ```
    $ cd $HOMEDIR/HRI-20069-W3/darknet
    $ vi img-voc_cjs.sh
    ./darknet detector test ./data_cjs/obj.data ./data_cjs/yolo-obj.cfg ./backup_cjs/yolo-obj_2200.weights ./data_cjs/img/bird3.jpg
    $ ./img-voc_cjs.sh
    ```



# [Option for accessing GPU PC] 
  ```
  $ ssh -X -l hri_20069 161.122.114.90 -p 22
  ```
