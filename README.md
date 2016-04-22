# DisplayBoards
This is a repo for the SBC display computers attached to the numerous Television displayboards at the Space Systems Lab

# Instructions

 1. Image your favorite OpenELEC image first. Copy it to your SD card as such:
    
        sudo dd if=OpenELEC-RPi2.arm-6.0.3.img of=/dev/sdc bs=4M
    
    (Note - your OpenELEC image may vary!)

 2. Unplug and boot with your RPi. Once it has booted (it says it wants to reboot), unplug it!

 3. Mount the data partition, and run:
    
        ./install_config_archive.sh /path/to/mounted/data/partition
    
 4. Mount the mini system partition, and copy `SYSTEM` to this directory.

 5. Run:
    
        ./patch_image.sh SYSTEM
    

 6. Copy the new `SYSTEM` back onto the mini system partition.

 7. Run:
    
        ./install_oemsplash.sh /path/to/mounted/mini/system/partition
    

 8. (OPTIONAL) To force composite mode, you can also run this command:
    
        ./install_display_config_rpi1.sh /path/to/mounted/mini/system/partition
    

 9. (OPTIONAL) To force composite mode 16:9 ratio, you can also run this
    command:
    
        ./install_display_config_rpi1_ratio169.sh /path/to/mounted/mini/system/partition
    
    Note that you should only run this after you run the composite mode
    installer.

 10. (OPTIONAL) Copy videos you want to the data partition's `video` folder.
     (If it doesn't exist, create it.)

 11. Unmount both partitions and eject the SD card.

 12. Plug in and enjoy!
 
 13. (OPTIONAL) If you are using composite mode, you can go into
     `System > Settings > System > Video Output > Video calibration...`
     to adjust the overscan. This would allow all of the contents of the
     screen to be seen.
