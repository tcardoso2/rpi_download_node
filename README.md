# rpi_download_node
A NodeJs shell (sh) installer for Raspberry pi.
Just clone and run the shell file in your raspberry pi.

It will:
#. Attempt to get your RPI arch
#. Then will search for a suitable package in nodejs.org
#. Downloads and unpacks
#. Copies files into /usr/local

After this you should be able to run
````
node -v
````
````
npm -v
````
