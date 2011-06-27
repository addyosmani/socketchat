<<<<<<< HEAD
#####################
# SocketStream Chat #
#####################

SocketStream app which demos the open source SocketStream framework at https://github.com/socketstream/socketstream
=======
SocketStream Chat
===
>>>>>>> 04aaac510358d204db4cc87b49ae2c4c2e1af5c2

Chat app which demos the open source SocketStream framework at https://github.com/socketstream/socketstream

INSTALL
-------


Before you run SocketStream, you will need to install the following software:

  - Node.js (http://nodejs.org)
  - Node Package Manager (http://npmjs.org)
  - Redis (http://redis.io)

Instructions on how to install those items of software are included below for reference, and are taken from the home pages of those software libraries.

Note: You may also need to install the following packages:

    yum install gettext-devel expat-devel curl-devel zlib-devel openssl-devel
  
Step 1 - Install Node.js

Firstly, Check you have the dependencies for Node.js installed first (see https://github.com/joyent/node/wiki/Installation). If you satisfy them, then follow the command line instructions below:

    wget http://nodejs.org/dist/node-v0.4.8.tar.gz     # (check this is the latest version)
    tar xzf node-v0.4.8.tar.gz
    cd node-v0.4.8
    ./configure
    make
    sudo make install
    
Step 2 - Install Node Package Manager (npm)

    curl http://npmjs.org/install.sh | sh

Step 3 - Install redis

    wget http://redis.googlecode.com/files/redis-2.2.7.tar.gz
    tar xzf redis-2.2.7.tar.gz
    cd redis-2.2.7
    make
    
Step 4 - Install SocketStream

    git clone git://github.com/socketstream/socketstream.git
    cd socketstream/
    npm install -g
    
<<<<<<< HEAD
Step 5 - Install SocketChat

    git clone https://github.com/addyosmani/socketchat
    cd socketchat/
    npm link

The complete installation process should take less than 20 minutes including dependencies. 
=======
Step 4 - Install SocketStream chat

    git clone https://github.com/addyosmani/socketchat
    cd socketchat/
    npm link
>>>>>>> 04aaac510358d204db4cc87b49ae2c4c2e1af5c2
