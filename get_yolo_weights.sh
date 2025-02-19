# Pre-trained Full Weights
#wget -c https://pjreddie.com/media/files/yolo.weights -P ../darknet_weights_data
wget -c https://pjreddie.com/media/files/yolo-voc.weights -P ../darknet_weights_data
#wget -c https://pjreddie.com/media/files/tiny-yolo.weights -P ../darknet_weights_data
#wget -c https://pjreddie.com/media/files/yolo9000.weights -P ../darknet_weights_data


# Pre-trained Convolutional Weights for Training
wget -c http://pjreddie.com/media/files/darknet19_448.conv.23 -P ../darknet_weights_data


# Pre-trained Full Weights for RNN
#wget -c https://pjreddie.com/media/files/grrm.weights -P ../darknet_weights_data
#wget -c https://pjreddie.com/media/files/shakespeare.weights -P ../darknet_weights_data


cp ../darknet_weights_data/*.* darknet/
