{ config, pkgs, ... }:

{
  # Enable cron
  services.cron = {
    enable = true;
    systemCronJobs = [
        "0,30  *     *   *    * chous /home/chous/bin/change-wallpaper.sh"
        #*     *     *   *    *            command to be executed
        #-     -     -   -    -
        #|     |     |   |    |
        #|     |     |   |    +----- day of week (0 - 6) (Sunday=0)
        #|     |     |   +------- month (1 - 12)
        #|     |     +--------- day of month (1 - 31) 
        #|     +----------- hour (0 - 23)
        #+------------- min (0 - 59)
    ]; 
  };

  services.fcron = {
    allow = [ "all" ];
    enable = true;
  };
}
