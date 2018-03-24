# Install Docker
At first, install Docker to your system

* Download Docker CE (Community Edition)

  * https://www.docker.com/community-edition

* WORKDIR is assummed to be your working directory

  ```
  $ WORKDIR=your_work_directory
  $ cd $WORKDIR
  ```

# Download the git repository of our class
  ```
  $ git clone https://github.com/cjs0818/HRI-20069-W3
  $ cd HRI-20069-W3
  ```
  

#  !!! SKIP this because it is already included in HRI-20069-W3 repository !!!  (Download darknet)
  ```
  $ git clone https://github.com/AlexeyAB/darknet
  ```


 * Download yolo weights

  ```
  $ wget https://pjreddie.com/media/files/yolo.weights -P ../darknet_weights_data
  $ wget https://pjreddie.com/media/files/yolo-voc.weights -P ../darknet_weights_data
  $ wget https://pjreddie.com/media/files/tiny-yolo.weights -P ../darknet_weights_data
  $ wget https://pjreddie.com/media/files/yolo9000.weights -P ../darknet_weights_data
  $ wget http://pjreddie.com/media/files/darknet19_448.conv.23 -P ../darknet_weights_data
  ```


# Build Docker

  ```
  $ ./docker_build.sh
  ```
  
* Change DISPLAY_IP in start.sh according to your system (using ifconfig)

* Change WORKDIR in start.sh according to your system


# Start Docker

* Set up parameters such as DOCKER (nvidia-docker or docker), EN0 (ifconfig ...), WORKDIR in the 'start.sh' file

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
  * Perform ```./linux_mark.sh```
   * Draw bounding boxes and select the number of labels, then the resultant data will be generated in which values of x, y, width, height for each pictures are written.
   ```
   x64/Release/data/img/*.txt
   ```

  * Copy the generated files
   ```
   $ cp -R x64/Release/data $WORKDIR/HRI-20069-W3/darknet/data_cjs
   ```
  * Copy a config file & modify the number of classes and filters.
   ```
   $ cp x64/Release/yolo-obj.cfg $WORKDIR/HRI-20069-W3/darknet/data_cjs/
   $ vi $WORKDIR/HRI-20069-W3/darknet/data_cjs/yolo-obj.cfg
   ...
   filters = ~~
   classes = ~~
   ...
   ```
   
   Here, 
   ```
   the # of filters = (5 + # of classes) * 5
   ```
   For example, if the # of classes = 2, then the # of filters should be 35
   
  * Train your data
   Prepare the following ```train.sh``` and execute it.
   ```
   $ cd $WORKDIR/HRI-20069-W3/darknet
   $ vi train.sh
   $ ./darknet detector train ./data_cjs/obj.data ./data_cjs/yolo-obj.cfg ~/work/darknet_weights_data/darknet19_448.conv.23
   $ ./train.sh
   
   ```
   
  Then, you will get yolo-obj_*number*.weights in a folder you have setup in the ```data_cjs/obj.data```


  * Test your data
   * Assuming that you acquired ```yolo-obj_2200.weights```

    ```
    $ cd $WORKDIR/HRI-20069-W3/darknet
    $ vi img-voc_cjs.sh
    ./darknet detector test ./data_cjs/obj.data ./data_cjs/yolo-obj.cfg ./backup_cjs/yolo-obj_2200.weights ./data_cjs/img/bird3.jpg
    $ ./img-voc_cjs.sh
    ```



# [Option for accessing GPU PC] 
  ```
  $ ssh -X -l hri_20069 161.122.114.90 -p 22
  ```