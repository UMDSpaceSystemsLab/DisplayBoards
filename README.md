# DisplayBoards
This is a repo for the SBC display computers attached to the numerous Television displayboards at the Space Systems Lab

# Instructions

 1. Install your favorite OpenELEC image first. Copy it to your SD card
    as such:
    
        sudo dd if=OpenELEC-RPi2.arm-6.0.3.img of=/dev/sdc bs=4M
    
    (Note - your OpenELEC image may vary!)

 2. Unplug and boot with your RPi. Once it has booted (it says it wants to
    reboot), unplug it!

 3. Set up your `SSL_DISPLAYBOARD_ARC_PASS` environment variable to the
    archive password, e.g.
    
        export SSL_DISPLAYBOARD_ARC_PASS="MyPasswordHere"
    
    (It may be useful to store the above line in your `.bashrc`, or in a
    script that you can easily source.)

 4. Mount the system and data partition, and run:
    
        ./install_all.sh /path/to/mounted/mini/system/partition /path/to/mounted/data/partition
    
    * If you want to enable (force) composite output, add `-c`:
    
        ./install_all.sh /path/to/mounted/mini/system/partition /path/to/mounted/data/partition -c
    
    * If you want to enable (force) 16:9 composite output, add `-w`:
    
        ./install_all.sh /path/to/mounted/mini/system/partition /path/to/mounted/data/partition -w
    
 5. That's it! Go ahead and boot your shiny new SD card!
 
 6. (OPTIONAL) If you are using composite mode, you can go into
    `System > Settings > System > Video Output > Video calibration...`
    to adjust the overscan. This would allow all of the contents of the
    screen to be seen.

