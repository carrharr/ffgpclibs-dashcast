# ffgpclibs-dashcast

The objective of this marvelously crappy script is to get DashCast and MP4Client Working 
in Ubuntu 16.04 and in order to do that youll need [Its explained for ultra dummies(well I hope)]: 

# THIS HASNT BEEN PROPERLY TESTED, SO RUN AT YOUR OWN RISK!!!!!

+ Ensure you have vim installed `sudo apt-get install vim`
+ Run the Script `./script.sh`, (preferably from and within home directory)
+ When it gets to line 63 it will open a file with vim 
+ DO `:/if (!audio_data_conf)`and return. It'll look for the line we want 
+ Comment out that line pressing `i` and then `//`
+ Get out, save (Press escape then `:wq`and return )and let script continue till it echoes done.
+ Hopefully everything will be working fine (y).


# THIS HASNT BEEN PROPERLY TESTED, SO RUN AT YOUR OWN RISK!!!!!
