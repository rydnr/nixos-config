{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "chous";
  home.homeDirectory = "/home/chous";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  home.packages = with pkgs; [ coreutils ncurses ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    emacs = {
      enable = true;
      extraPackages = epkgs: [ epkgs.nix-mode epkgs.magit ];
    };

    git = {
      enable = true;
      userName = "Jose San Leandro";
      userEmail = "github@acm-sl.org";
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

  };

  # config.hs created by nixos-rebuild
#  home.file.".xmonad/config.hs".source = "/home/chous/.xmonad/xmonad.hs.orig";

  home.file.".profile".text = ''
    # Source .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
    fi
  '';

  home.file.".bashrc".text = ''
    sudo setkeycodes 3a 29 2>&1 > /dev/null
    alias bat="cat /sys/class/power_supply/BAT0/capacity"
    export TERM="xterm-256color"
    alias pythoneda_shared_artifactchanges_dbus="dbus-monitor --system \"type='signal',path='/pythoneda/shared/artifact_changes'\""

    export TODAY="$(date '+%Y%m%d')"
    #if [[ ! -e ~/.profile.''${TODAY} ]]; then
      #  rsync -avz /home/chous/.mozilla/firefox/4tv9d8tg.dev.orig/ /home/chous/.mozilla/firefox/4tv9d8tg.dev/
    #  touch ~/.profile.''${TODAY}
    #fi
    #~/bin/xrandr.sh
    #keychain ~/.ssh/id_rsa ~/.ssh/id_dsa ~/.ssh/id_dsa-prod ~/.ssh/id_rsa-github ~/.ssh/chous-git.osoco.es > /dev/null 2>&1
    source ~/.bashrc-exports
    source ~/.bashrc-aliases
    source ~/.bashrc-functions
    source ~/.bashrc-privateexports
    source ~/.bashrc-privatealiases
    source ~/.bashrc-privatealiases-bluetooth
    source ~/.bashrc-privatefunctions
    #source ~/bin/lp.sh
    #export LD_LIBRARY_PATH=
    xauth nlist :0 2>/dev/null 3>/dev/null | sed -e 's/^..../ffff/' 2>/dev/null | xauth -f /tmp/.docker.xauth nmerge - >/dev/null 2>&1

    eval "$(starship init bash)"

    export AWT_TOOLKIT=MToolkit
    export _JAVA_AWT_WM_NONREPARENTING=1
    export JDK_JAVA_OPTIONS='-Dsun.java2d.xrender=true'

    #[[ -f ''${HOME}/bin/xrandr.sh ]] && ''${HOME}/bin/xrandr.sh > /dev/null 2>&1
    # vim: syntax=sh ts=2 sw=2 sts=4 sr noet
  '';

  home.file.".bashrc-exports".text = ''
    #export JAVA_OPTS="''${JAVA_OPTS} -XX:+CMSClassUnloadingEnabled -XX:+UseConcMarkSweepGC"
    export PATH=$PATH:~/.dry-wit/src:~/.cabal/bin:~/.xmonad/bin
    export CHECKERS=''${HOME}/toolbox/checker-framework/checkers
    export GRAILS_HOME=~/.gvm/grails/current
    export MAILDIR=$HOME/.maildir/
    export AUDIO_LANG="es"
    export AUDIO_CHANNELS="2"
    #export AXIS_HOME=/usr/java/axis
    #export AXIS_LIB=$AXIS_HOME/lib
    #export AXISCLASSPATH=$AXIS_LIB/axis.jar:$AXIS_LIB/commons-discovery.jar:$AXIS_LIB/commons-logging.jar:$AXIS_LIB/jaxrpc.jar:$AXIS_LIB/saaj.jar:$AXIS_LIB/log4j-1.2.8.jar:$AXIS_LIB/xml-apis.jar:$AXIS_LIB/xercesImpl.jar
    #export CVSROOT=":pserver:jlean@ven24devel:/home/cvsroot"
    #export ANT_HOME="/usr/java/apache-ant"
    #export TOMCAT_HOME="/usr/java/jakarta-tomcat-3.3.1a"
    #export CATALINA_HOME="/usr/java/catalina"
    #export ELUCIDATOR_HOME="/usr/java/elucidator"
    #export ELUCIDATOR_MAIN_CONFIG_FILE="''${HOME}/.elucidator/Main.conf"
    #export ANT_HOME="/usr/java/apache-ant"
    #export MAVEN_HOME="/usr/share/maven-bin-1.0/"
    #export MAVEN2_HOME="/usr/share/maven-bin-2.0/"
    #export BCEL_HOME="/usr/java/bcel"
    #export EJP_TRACER_HOME="/usr/java/ejp-tracer"
    #export JMP_LIB="/usr/local/lib"
    #export ASPECTJ_HOME="/usr/java/aspectj"
    #export JALOPY_HOME="/usr/java/jalopy"
    #export JPROFMEM_HOME="/usr/java/jprofmem"
    #export PLAY_HOME="''${HOME}/toolbox/play"
    #export GROOVY_HOME="''${HOME}/toolbox/groovy"
    #export CLASSPATH=$CLASSPATH:/usr/java/xt/xt.jar:/usr/java/xt/sax.jar:/usr/java/xp/xp.jar:$BCEL_HOME/bcel.jar:$EJP_TRACER_HOME/lib/tracerapi.jar:$ASPECTJ_HOME/lib/aspectjrt.jar:$JALOPY_HOME/jalopy.jar:$JALOPY_HOME/jalopy-ant.jar:$AXISCLASSPATH
    #export CLASSPATH=""
    #export TZ=TUC0
    export EMACS_UNIBYTE="Latin-1"
    #export CDPATH=".:~/dev/acmsl/svn:~/dev/ventura24/svn:/usr/java"
    #export FSVS_CONF=/etc/fsvs-jlean
    #export FSVS_WAA=/var/spool/fsvs-jlean
    #export PS1='\[\033k\033\\\]\u@\h:\w\$ '
    export EDITOR=emacsclient
    export _JAVA_AWT_WM_NONREPARENTING=1
    #export ANDROID_HOME=''${HOME}/toolbox/android-sdk
    ##export LD_LIBRARY_PATH=''${LD_LIBRARY_PATH}:/nix/var/nix/profiles/system/sw/lib
    #export STUDIO_VM_OPTIONS=''${HOME}/.AndroidStudio/studio.vmoptions
    #export JAVA_HOME="$(realpath $(dirname $(readlink $(which java)))/..)"
    export GPG_TTY=$(tty)
    # vim: syntax=sh ts=2 sw=2 sts=4 sr noet
  '';

  home.file.".bashrc-aliases".text = ''
    alias d="ls --color"
    alias ls="ls --color=auto"
    alias ll="ls --color -l"
    alias w3ccvs="CVSROOT=:pserver:anonymous@dev.w3.org:/sources/public cvs"

    #alias emacs="(pushd ~ ; emacs --unibyte ; popd) &"
    #alias emacs="emacs -nw --unibyte"

    alias nicesvn="ps -ef | grep svn | grep -v grep | awk '{printf(\"sudo renice -19 -p %s\n\", \$2);}' | sh"

    alias euler="ssh -p 21 euler"

    alias mvn="/run/current-system/sw/bin/mvn -T 1C -Dlog4j.configuration=file:///home/chous/github/queryj/queryj-core/src/test/resources/log4j.xml -Dqueryjroot=/home/chous/github/queryj"
    alias mvn-debug='MAVEN_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=*:5005" /run/current-system/sw/bin/mvn -T 1C -Dlog4j.configuration=file:///home/chous/github/queryj/queryj-core/src/test/resources/log4j.xml -Dqueryjroot=/home/chous/github/queryj'
    alias mvn-jde="mvn org.apache.maven.plugin:maven-emacs-plugin:1.2.2:jdee"
    alias mvn-jetty="mvn -Dorg.mortbay.jetty.webapp.parentLoaderPriority=true jetty:run-exploded"
    #alias mvn="mvn -Dlog4j.configuration=file://''${HOME}/.m2/log4j.xml"
    #alias mvn="color_maven -Dlog4j.configuration=file:///home/chous/.m2/log4j.xml"

    alias mvn-jde="mvn org.apache.maven.plugin:maven-emacs-plugin:1.2.2:jdee"
    alias jetty7-debug='java -Xdebug -Xrunjdwp:transport=dt_socket,address=9998,server=y,suspend=y -DDEBUG -Dlog4j.configuration=file://$PWD/log4j-v24.xml -jar start.jar OPTIONS=All'
    alias jetty7-start='java -DDEBUG -Dlog4j.configuration=file://$PWD/log4j-v24.xml -jar start.jar OPTIONS=All'
    alias jdownloader="java -jar ~/.jd/JDownloader.jar"
    alias git-push-queryj="git push origin +refs/heads/ventura24-2_0-stable.local:ventura24-2_0-stable"
    alias kde='sudo cat ~/.lp/kde | tail -n 1 | xclip'
    alias prod='sudo cat ~/.lp/produccion | tail -n 1 | xclip'
    alias music="sshfs chous@euler:/home/chous/realhome/music /home/chous/music/euler"
    alias mvn-deploy="mvn deploy:deploy-file -Durl=http://maven/artifactory/ext-releases-local -DrepositoryId=internal"
    alias checkstyle=~/algs4/bin/checkstyle
    alias findbugs=~/algs4/bin/findbugs
    alias rt-queryj="git --git-dir ~/.RT.git.d/queryj --work-tree ~/github/queryj"
    alias rt-rt="git --git-dir ~/.RT.git.d/RT --work-tree ~/github/RT"
    alias rt-codemotion2013="git --git-dir ~/.RT.git.d/codemotion-2013 --work-tree ~/github/codemotion-2013"
    alias rt-antlr4netty="git --git-dir ~/.RT.git.d/kata-antlr4-netty --work-tree ~/github/kata-antlr4-netty"
    alias rt-walkmod-code-conventions="git --git-dir ~/.RT.git.d/walkmod-code-conventions --work-tree ~/github/walkmod-code-conventions"
    alias rt-blender-katas="git --git-dir ~/.RT.git.d/blender-katas --work-tree ~/github/blender-katas"
    alias mongo="docker run -d -p 27017:27017 acmsl/mongodb-pagecarelanding"
    alias groovy="~/toolbox/groovy/bin/groovy --indy";
    alias mcollective-build="ACTIVEMQ_CLIENT_PASSWORD=\"ZD2rTwbbmVyUzxbXzZynSEAcsRb7ar4xKeyRj83PN7HxDegZ34Tv3eUnpPyV4QCU\" ACTIVEMQ_SERVER_PASSWORD=\"c2mA8TBkEV5mu9w6jaX7hFvdNZXmNqsenD7ufHa5yKtb3tb9hARRtPmJKAKPC32h\" ACTIVEMQ_PRE_SHARED_KEY=\"nqm9wy97tjfr9fH4phKS3Cf74r4KRn9mwjA2UTnPpYWsTPsBEXNxZe6KXFdZ8fRM\" DATE=\"201410\" ./build.sh mcollective-activemq mcollective-common mcollective-server mcollective-client";
    alias du-large="du -h | grep -P '^[0-9\.]+G'";
    alias jenkins="cp ~/.ssh/id_rsa-github-jenkins* ~/github/acmsl-jenkins-configs; docker run -d -m=\"1024m\" -c=1 -p 8081:8080 -v ~/github/acmsl-jenkins-configs:/home/jenkins acmsl/jenkins:latest"
    #alias jenkins="cp ~/.ssh/id_rsa-github-jenkins* ~/github/acmsl-jenkins-configs; docker run -d -c=1 -p 8081:8080 -v ~/github/acmsl-jenkins-configs:/home/jenkins acmsl/jenkins:latest"
    alias rt-devdel="git --git-dir \"/home/chous/.RT.git.d/devdel\" --work-tree \"/home/chous/github/devdel\"";
    alias rt-gtd="git --git-dir \"/home/chous/.RT.git.d/gtd\" --work-tree \"/home/chous/github/gtd\"";
    alias rt-JavaCSS="git --git-dir \"/home/chous/.RT.git.d/JavaCSS\" --work-tree \"/home/chous/github/JavaCSS\"";
    alias rt-sails-platzi="git --git-dir \"/home/chous/.RT.git.d/sails-platzi\" --work-tree \"/home/chous/github/sails-platzi\"";
    alias rt-lc="git --git-dir \"/home/chous/.RT.git.d/lc\" --work-tree \"/home/chous/github/lc\"";
    alias startx="sudo /etc/init.d/udev restart; sudo chgrp video /proc/ati; /usr/bin/startx"
    alias ipodenc="~/dev/acmsl/svn/misc/trunk/bin/ipodenc.sh"
    alias sm="wine /mnt/windows/SM\ v7/SM\ v7/Simulator.exe"
    export GRADLE_TAG='3.2.1';
    export GRAILS_TAG='201610';
    export NODEJS_TAG='201610';
    alias android-studio="docker run -it --rm --name android-studio --rm -v ''${HOME}/AndroidProjects:/data -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/kvm:/dev/kvm nexus.osoco.es/osoco/android-studio:201608"
    alias socat-socket-proxy='socat -v UNIX-LISTEN:/tmp/docker.sock,fork UNIX-CONNECT:/var/run/docker.sock'
    alias mrproper='docker rm $(docker ps -q -f status=exited); docker volume rm $(docker volume ls -qf dangling=true); docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
    #alias pharo='docker run -it --rm -v ''${PWD}:/work -v ''${XSOCK}:''${XSOCK} -v ''${XAUTH}:''${XAUTH} -e XAUTHORITY:''${XAUTH} acmsl/pharo:5.0 ';
    #alias gradle='docker run -it --rm -v ''${PWD}:/work -v ''${XSOCK}:''${XSOCK} -v ''${XAUTH}:''${XAUTH} -e XAUTHORITY:''${XAUTH} acmsl/gradle:3.2.1 ';
    alias gradle-packer='export _prj="packer"; mkdir ''${HOME}/.gradle-''${_prj} 2> /dev/null; docker run -it --rm -e DOCKER_HOST="tcp://socat:2375" --link socat:socat -e HOST_PROJECTDIR="''${PWD}" -e HOST_USERHOME="''${HOME}" -e TERM="''${TERM}" -e TERMCAP="''${TERMCAP}" -v ''${PWD}:/work -v ~/.gradle-''${_prj}:/opt/.gradle nexus.osoco.es/osoco/gradle:''${GRADLE_TAG}';
    #alias pharo='docker run -it --rm -v /home/chous/osoco:/work --net=host -v ''${XSOCK}:''${XSOCK} -v ''${XAUTH}:''${XAUTH} -e XAUTHORITY:''${XAUTH} nexus.osoco.es/osoco/gradle-pharo'
    #source ~/bin/color_maven.zsh
    #alias ssh='ssh-ident'
    #alias term="urxvt --background-expr \"scale keep { again 3600; return load \\\"''${HOME}/wallpapers/$(ls ''${HOME}/wallpapers | sort -R | head -n 1)\\\" }\"";
    declare -a mouseCursors=('Black' 'White' 'Orange' 'Green' 'Blue' 'Ghost');
    mouseCursor=''${mouseCursors[''${RANDOM} % ''${#mouseCursors[@]}]}
    alias set-mouse-cursor="xsetroot -cursor_name ComixCursors-''${mouseCursor}-Large";

    alias gradle-gtoolkit='docker run -it --rm --net=host -v ''${PWD}:/home/pharo/work -v ''${XSOCK}:''${XSOCK} -v ''${XAUTH}:''${XAUTH} -e XAUTHORITY=''${XAUTH} --ipc=host acmsl-phusion/gradle-gtoolkit:6.8.2-8.0 bash'

    # from https://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html

    #1: Control ls command output

    ## Colorize the ls output ##
    alias ls='ls --color=auto'

    ## Use a long listing format ##
    alias ll='ls -la'

    ## Show hidden files ##
    alias l.='ls -d .* --color=auto'

    #2: Control cd command behavior

    ## get rid of command not found ##
    alias cd..='cd ..'

    ## a quick way to get out of current directory ##
    alias ..='cd ..'
    alias ...='cd ../../../'
    alias ....='cd ../../../../'
    alias .....='cd ../../../../'
    alias .4='cd ../../../../'
    alias .5='cd ../../../../..'

    #3: Control grep command output

    ## Colorize the grep command output for ease of use (good for log files)##
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'

    #4: Start calculator with math support

    alias bc='bc -l'

    #4: Generate sha1 digest

    alias sha1='openssl sha1'

    #5: Create parent directories on demand

    alias mkdir='mkdir -pv'

    #6: Colorize diff output

    # You can compare files line by line using diff and use a tool called colordiff to colorize diff output:
    # install  colordiff package :)
    alias diff='colordiff'

    #7: Make mount command output pretty and human readable format

    alias mount='mount |column -t'

    #8: Command short cuts to save time

    # handy short cuts #
    alias h='history'
    alias j='jobs -l'

    #9: Create a new set of commands

    alias path='echo -e ''${PATH//:/\\n}'
    alias now='date +"%T"'
    alias nowtime=now
    alias nowdate='date +"%d-%m-%Y"'

    #10: Set vim as default

    alias vi=vim
    alias svi='sudo vi'
    alias vis='vim "+set si"'
    alias edit='vim'

    #11: Control output of networking tool called ping

    # Stop after sending count ECHO_REQUEST packets #
    alias ping='ping -c 5'
    # Do not wait interval 1 second, go fast #
    alias fastping='ping -c 100 -s.2'

    #12: Show open ports
    # Use netstat command to quickly list all TCP/UDP port on the server:
    alias ports='netstat -tulanp'

    #13: Wakeup sleeping servers

    ## replace mac with your actual server mac address #
    alias wakeupnas01='/usr/bin/wakeonlan 00:11:32:11:15:FC'
    alias wakeupnas02='/usr/bin/wakeonlan 00:11:32:11:15:FD'
    alias wakeupnas03='/usr/bin/wakeonlan 00:11:32:11:15:FE'

    #14: Control firewall (iptables) output

    ## shortcut  for iptables and pass it via sudo#
    alias ipt='sudo /sbin/iptables'

    # display all rules #
    alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
    alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
    alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
    alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
    alias firewall=iptlist

    #15: Debug web server / cdn problems with curl

    #19: Tune sudo and su

    # become root #
    alias root='sudo -i'
    alias su='sudo -i'

    #20: Pass halt/reboot via sudo

    # reboot / halt / poweroff
    alias reboot='sudo /sbin/reboot'
    alias poweroff='sudo /sbin/poweroff'
    alias halt='sudo /sbin/halt'
    alias shutdown='sudo /sbin/shutdown'

    #22: Alias into our backup stuff

    # if cron fails or if you want backup on demand just run these commands #
    # again pass it via sudo so whoever is in admin group can start the job #
    # Backup scripts #
    alias backup='sudo /home/scripts/admin/scripts/backup/wrapper.backup.sh --type local --taget /raid1/backups'
    alias nasbackup='sudo /home/scripts/admin/scripts/backup/wrapper.backup.sh --type nas --target nas01'
    alias s3backup='sudo /home/scripts/admin/scripts/backup/wrapper.backup.sh --type nas --target nas01 --auth /home/scripts/admin/.authdata/amazon.keys'
    alias rsnapshothourly='sudo /home/scripts/admin/scripts/backup/wrapper.rsnapshot.sh --type remote --target nas03 --auth /home/scripts/admin/.authdata/ssh.keys --config /home/scripts/admin/scripts/backup/config/adsl.conf'
    alias rsnapshotdaily='sudo  /home/scripts/admin/scripts/backup/wrapper.rsnapshot.sh --type remote --target nas03 --auth /home/scripts/admin/.authdata/ssh.keys  --config /home/scripts/admin/scripts/backup/config/adsl.conf'
    alias rsnapshotweekly='sudo /home/scripts/admin/scripts/backup/wrapper.rsnapshot.sh --type remote --target nas03 --auth /home/scripts/admin/.authdata/ssh.keys  --config /home/scripts/admin/scripts/backup/config/adsl.conf'
    alias rsnapshotmonthly='sudo /home/scripts/admin/scripts/backup/wrapper.rsnapshot.sh --type remote --target nas03 --auth /home/scripts/admin/.authdata/ssh.keys  --config /home/scripts/admin/scripts/backup/config/adsl.conf'
    alias amazonbackup=s3backup

    #23: Desktop specific – play avi/mp3 files on demand

    ## play video files in a current directory ##
    # cd ~/Download/movie-name

    # play all music files from the current directory #
    alias playwave='for i in *.wav; do mplayer "$i"; done'
    alias playogg='for i in *.ogg; do mplayer "$i"; done'
    alias playmp3='for i in *.mp3; do mplayer "$i"; done'

    # play files from nas devices #
    alias nplaywave='for i in /nas/multimedia/wave/*.wav; do mplayer "$i"; done'
    alias nplayogg='for i in /nas/multimedia/ogg/*.ogg; do mplayer "$i"; done'
    alias nplaymp3='for i in /nas/multimedia/mp3/*.mp3; do mplayer "$i"; done'

    # shuffle mp3/ogg etc by default #
    alias music='mplayer --shuffle *'

    #24: Set default interfaces for sys admin related commands

    ## All of our servers eth1 is connected to the Internets via vlan / router etc  ##
    alias dnstop='dnstop -l 5  eth1'
    alias vnstat='vnstat -i eth1'
    alias iftop='iftop -i eth1'
    alias tcpdump='tcpdump -i eth1'
    alias ethtool='ethtool eth1'

    # work on wlan0 by default #
    # Only useful for laptop as all servers are without wireless interface
    alias iwconfig='iwconfig wlan0'

    #25: Get system memory, cpu usage, and gpu memory info quickly

    ## pass options to free ##
    alias meminfo='free -m -l -t'

    ## get top process eating memory
    alias psmem='ps auxf | sort -nr -k 4'
    alias psmem10='ps auxf | sort -nr -k 4 | head -10'

    ## get top process eating cpu ##
    alias pscpu='ps auxf | sort -nr -k 3'
    alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

    ## Get server cpu info ##
    alias cpuinfo='lscpu'

    ## older system use /proc/cpuinfo ##
    ##alias cpuinfo='less /proc/cpuinfo' ##

    ## get GPU ram on desktop / laptop##
    alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

    ## this one saved by butt so many times ##
    alias wget='wget -c'

    #my default browser
    alias browser=firefox

    ## set some other defaults ##
    alias df='df -H'
    alias du='du -ch'

    # top is atop, just like vi is vim
    alias top='atop'

    ## nfsrestart  - must be root  ##
    ## refresh nfs mount / cache etc for Apache ##
    alias nfsrestart='sync && sleep 2 && /etc/init.d/httpd stop && umount netapp2:/exports/http && sleep 2 && mount -o rw,sync,rsize=32768,wsize=32768,intr,hard,proto=tcp,fsc natapp2:/exports /http/var/www/html &&  /etc/init.d/httpd start'

    ## Memcached server status  ##
    alias mcdstats='/usr/bin/memcached-tool 10.10.27.11:11211 stats'
    alias mcdshow='/usr/bin/memcached-tool 10.10.27.11:11211 display'

    ## quickly flush out memcached server ##
    alias flushmcd='echo "flush_all" | nc 10.10.27.11 11211'

    ## supply list of urls via file or stdin
    alias cdnmdel='/home/scripts/admin/cdn/purge_cdn_cache --profile akamai --stdin'
    alias amzcdnmdel='/home/scripts/admin/cdn/purge_cdn_cache --profile amazon --stdin'
    bash_prompt_command() {
      RTN=$?
      prevCmd=$(prevCmd $RTN)
    }
    PROMPT_COMMAND=bash_prompt_command
    prevCmd() {
      if [ $1 == 0 ] ; then
        echo $GREEN
      else
        echo $RED
      fi
    }
    if [ $(tput colors) -gt 0 ] ; then
      RED=$(tput setaf 1)
      GREEN=$(tput setaf 2)
      RST=$(tput op)
    fi
    # export PS1="[e[36m]u.h.W[e[0m][$prevCmd]>[$RST]"

    dotSlash=""
    for i in 1 2 3 4
    do
      dotSlash=''${dotSlash}'../';
      baseName=".''${i}"
      alias $baseName="cd ''${dotSlash}"
    done

    #progress bar on file copy. Useful evenlocal.
    alias cpProgress="rsync --progress -ravz"

    #I find it useful when emailing blurbs to people and want to illustrate long timeout in one pass.
    alias ping="time ping"

    alias du1='du -d 1'

    # To open last edited file

    alias lvim="vim -c \"normal '0\""

    function cdl() {
      cd "$@";
      ls -al;
    }
    alias ..='cdl ..'

    #Grabs the disk usage in the current directory
    alias usage='du -ch | grep total'

    #Gets the total disk usage on your machine
    alias totalusage='df -hl --total | grep total'

    #Shows the individual partition usages without the temporary memory values
    alias partusage='df -hlT --exclude-type=tmpfs --exclude-type=devtmpfs'

    #Gives you what is using the most space. Both directories and files. Varies on
    #current directory
    alias most='du -hsx * | sort -rh | head -10'

    alias usage='du -ch 2> /dev/null |tail -1'

    # shoot the fat ducks in your current dir and sub dirs
    alias ducks='du -ck | sort -nr | head'

    alias ps2='ps -ef | grep -v $$ | grep -i '
    alias psg='ps -Helf | grep -v $$ | grep -i -e WCHAN -e '

    function f {
      arg_path=$1 && shift
      find $arg_path -wholename "*/path-to-ignore/*" -prune -o $* -print
    }
    # This will move you up by one dir when pushing AltGr .
    # It will move you back when pushing AltGr Shift .
    # bind '"â€¦":"pushd ..n"' # AltGr .
    # bind '"Ã·":"popdn"' # AltGr Shift .
    alias ll='ls -l'

    # I also changed "mount" to "mnt" for the column's:
    alias mnt="mount |column -t"

    alias lt='ls -alrt'

    #not an alias, but I thought this simpler than the cd control
    #If you pass no arguments, it just goes up one directory.
    #If you pass a numeric argument it will go up that number of directories.
    #If you pass a string argument, it will look for a parent directory with that name and go up to it.
    up() {
      dir=""
      if [ -z "$1" ]; then
        dir=..
      elif [[ $1 =~ ^[0-9]+$ ]]; then
        x=0
        while [ $x -lt ''${1:-1} ]; do
          dir=''${dir}../
          x=$(($x+1))
        done
      else
        dir=''${PWD%/$1/*}/$1
      fi
      cd "$dir";
    }

    #turn screen off
    alias screenoff="xset dpms force off"

    #quick file tree
    alias filetree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

    alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v –line-numbers'
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'

    # and something I use rather frequently when people chose funny file/directory names (sad enough):

    # chr() {
    # printf \$(printf '%03o' $1)
    # }

    ord() {
    printf '%d' "'$1"
    }

    alias flush=sync

    alias hg='history|grep '

    alias trace='mtr --report-wide --curses $1'
    alias killtcp='sudo ngrep -qK 1 $1 -d wlan0'
    alias usage='ifconfig wlan0 | grep bytes'
    alias connections='sudo lsof -n -P -i +c 15'
    alias up1="cd .."
    # edit multiple files split horizontally or vertically
    alias e="vim -o "
    alias E="vim -O "
    # directory-size-date (remove the echo/blank line if you desire)
    alias dsd="echo;ls -Fla"
    alias dsdm="ls -FlAh | more"
    # show directories only
    alias dsdd="ls -FlA | grep :*/"
    # show executables only
    alias dsdx="ls -FlA | grep *"
    # show non-executables
    alias dsdnx="ls -FlA | grep -v *"
    # order by date
    alias dsdt="ls -FlAtr "
    # dsd plus sum of file sizes
    alias dsdz="ls -Fla $1 $2 $3 $4 $5 | awk '{ print; x=x+$5 } END { print \"total bytes = \",x }'"
    # only file without an extension
    alias noext='dsd | egrep -v ".|/"'
    # send pwd to titlebar in puttytel
    alias ttb='echo -ne "33]0;`pwd`07"'
    # send parameter to titlebar if given, else remove certain paths from pwd
    alias ttbx="titlebar"
    # titlebar
    # if [ $# -lt 1 ]; then
    #   ttb=`pwd | sed -e 's+/projects/++' -e 's+/project01/++' -e 's+/project02/++' -e 's+/export/home/++' -e 's+/home/++'`
    # else
    #   ttb=$1
    # fi
    # echo -ne "33]0;`echo $ttb`07"
    alias machine="echo you are logged in to ... `uname -a | cut -f2 -d' '`"
    alias info='clear;machine;pwd'
    # file tree of directories only
    alias dirtree="ls -R | grep :*/ | grep ":$" | sed -e 's/:$//' -e 's/[^-][^/]*//--/g' -e 's/^/   /' -e 's/-/|/'"

    #    This one pings a router quickly

    #alias pr="ping `netstat -nr| grep -m 1 -iE 'default|0.0.0.0' | awk '{print $2}'`"

    alias rl='. ~/.bashrc'

    alias clearx="echo -e '/0033/0143'"
    alias clear='printf "33c"'

    #  https://github.com/dmeekabc
    #  https://github.com/dmeekabc/tagaProductized/tree/master/iboaUtils

    #  IBOA Auto Alias Utility Six (6) Core Aliases:
    #         aa – Add Alias
    #         ea – Edit Alias
    #        ia – Insert Alias
    #         iap – Insert Alias (P)revious
    #         iapw – Insert Alias (P)revious (W)atch
    #         ta – Trace Alias
    #         Run the iboaInstall.sh file to install the utility including all of the user/group/system alias files.
    #         https://github.com/dmeekabc/tagaProductized/blob/master/iboaUtils/iboaInstall.sh

    alias g="git"
    alias gr="git rm -rf"
    alias gs="git status"
    alias ga="g add"
    alias gc="git commit -m"
    alias gp="git push origin master"
    alias gl="git pull origin master"

    alias ai="sd apt-get –yes install"
    alias as="apt-cache search"

    alias .p="pushd ."
    alias p.="popd"
    alias j='jobs -l'
    alias h='history'
    alias la='ls -aF'
    alias lsrt='ls -lrtF'
    alias lla='ls -alF'
    alias ll='ls -lF'
    alias ls='ls -F'
    alias pu=pushd
    alias pd=popd
    alias r='fc -e -' # typing 'r' 'r'epeats the last command

    # Sizes of the directories in the current directory
    alias size='du -h –max-depth=1'
    alias tf='tail -f '

    # grep in *.cpp files
    alias findcg='find . -iname "*.cpp" | xargs grep -ni --color=always '
    # grep in *.cpp files
    alias findhg='find . -iname "*.h" | xargs grep -ni --color=always '

    #finds that help me cleanup when hit the limits

    alias bigfiles="find . -type f 2>/dev/null | xargs du -a 2>/dev/null | awk '{ if ($1 > 5000) print $0 }'"
    alias verybigfiles="find . -type f 2>/dev/null | xargs du -a 2>/dev/null | awk '{ if ($1 > 500000) print $0 }'"

    #show only my procs
    alias psme='ps -ef | grep $USER --color=always '
    alias exiy='exit'
    # Do not wait interval 1 second, go fast #
    alias fastping='ping -c 100 -i.2'

    # Back Up [function, not alias] – Copy a file to the current directory with today's date automatically appended to the end.
    bu() { cp $@ $@.backup-`date +%y%m%d`; echo "`date +%Y-%m-%d` backed up $PWD/$@" >> ~/.backups.log; }

    mcd () {
    mkdir -p $1;
    cd $1
    }

    alias kk='sudo kill' # Expecting a pid
    pss() {
      [[ ! -n ''${1} ]] && return; # bail if no argument
      pro="[''${1:0:1}]''${1:1}"; # process-name –> [p]rocess-name (makes grep better)
      ps axo pid,command | grep -i ''${pro}; # show matching processes
      pids="$(ps axo pid,command | grep -i ''${pro} | awk '{print $1}')"; # get pids
      complete -W "''${pids}" kk # make a completion list for kk
    }


    chmoddr()   {
      # CHMOD _D_irectory _R_ecursivly

      if [ -d "$1" ]; then
        echo "error: please use the mode first, then the directory";
        return 1;
      elif [ -d "$2" ]; then
        find $2 -type d -print0 | xargs -0 chmod $1;
      fi
    }

    assimilate(){
      _assimilate_opts="";

      if [ "$#" -lt 1 ]; then
        echo "not enough arguments";
        return 1;
      fi
      SSHSOCKET=~/.ssh/assimilate_socket.$1;
      echo "resistence is futile! $1 will be assimilated";
      if [ "$2" != "" ]; then
        _assimilate_opts=" -p$2 ";
      fi

      ssh -M -f -N $_assimilate_opts -o ControlPath=$SSHSOCKET $1;
      if [ ! -S $SSHSOCKET ]; then echo "connection to $1 failed! (no socket)"; return 1; fi

      ### begin assimilation

      # copy files
      scp -o ControlPath=$SSHSOCKET ~/.bashrc $1:~;
      scp -o ControlPath=$SSHSOCKET -r ~/.config/htop $1:~;

      # import ssh key
      if [[ -z $(ssh-add -L|ssh -o ControlPath=$SSHSOCKET $1 "grep -f - ~/.ssh/authorized_keys") ]]; then
        ssh -o ControlPath=$SSHSOCKET $1 "mkdir ~/.ssh > /dev/null 2>&1";
        ssh-add -L > /dev/null&&ssh-add -L|ssh -o ControlPath=$SSHSOCKET $1 "cat >> ~/.ssh/authorized_keys"
      fi
      ssh -o ControlPath=$SSHSOCKET $1 "chmod -R 700 ~/.ssh";

      ### END
      ssh -S $SSHSOCKET -O exit $1 2>1 >/dev/null;
    }

    alias watchtail='watch -n .5 tail -n 20'
    alias watchdir='watch -n .5 ls -la'
    alias watchsize='watch -n .5 du -h –max-depth=1'

    # grep all files in the current directory
    function _grin() { grep -rn --color $1 .;}
    alias grin=_grin
    # find file by name in current directory
    function _fn() { find . -name $1;}
    alias fn=_fn

    #    http://philip.vanmontfort.be/bestanden/linux/bashrc

    # three letters to tune into my favorite radio stations
    alias dlf="mplayer -nocache -audiofile-cache 64 -prefer-ipv4 $(which GET 2> /dev/null && GET http://www.dradio.de/streaming/dlf.m3u|head -1)"
    alias dlr="mplayer -nocache -audiofile-cache 64 -prefer-ipv4 $(which GET 2> /dev/null && GET http://www.dradio.de/streaming/dkultur.m3u|head -1)"

    # When using mplayer you may set bookmarks using 'i'. You may read it easier using

    mplay() {
      export EDL="$HOME/.mplayer/current.edl"
      mplayer -really-quiet -edlout $EDL $* ;
      echo $(awk '{print $2 }' $EDL | cut -d, -f1 | cut -d. -f1 )
    }

    # Buring ISO-images does not need starting GUIs and clicking around

    alias isowrite="cdrecord dev=1,0,0 fs=32M driveropts=burnfree speed=120 gracetime=1 -v -dao -eject -pad -data"

    alias s=less        # use less a lot to see config files and logfiles
    alias lst='ls -ltr'   # most recently updated files last

    # when checking for servers and tcp ports for a non root user these are also handy
    alias myps='ps -fHu $USER'     # if not $USER, try $LOGIN
    alias myports="netstat -lntp 2>/dev/null | grep -v ' - *$'"  # Linux only?
    alias untar='tar -zxvf'

    # quick check of JSON files on the command line:
    function json() { cat "$@" | /usr/bin/python -m json.tool ;}

    # grep command history.  Uses function so a bare 'gh' doesn't just hang waiting for input.
    function gh () {
    if [ -z "$1" ]; then
    echo "Bad usage. try:gh run_test";
    else
    history | egrep $* |grep -v "gh $*"
    fi
    }

    alias h='history 100'     # give only recent history be default.

    alias wcl='wc -l'        # count # of lines
    alias perlrep='perl -i -p -e '               # use perl regex to do find/replace in place on files.  CAREFUL!!

    # list file/folder sizes sorted from largest to smallest with human readable sizes
    function dus () {
    du --max-depth=0 -k * | sort -nr | awk '{ if($1>=1024*1024) {size=$1/1024/1024; unit="G"} else if($1>=1024) {size=$1/1024; unit="M"} else {size=$1; unit="K"}; if(size<10) format="%.1f%s"; else format="%.0f%s"; res=sprintf(format,size,unit); printf "%-8s %sn",res,$2 }'
    }
    #    http://wiki.linuxquestions.org/wiki/Scripting#Command_Line_Trash_Can

    # Define a command to cd then print the resulting directory.
    # I do this to avoid putting the current directory in my prompt.
    #alias cd='cdir'
    #function cdir () {
    #  cd "$*"
    #  pwd
    #}

    function mkcd(){
      mkdir -p $1
      cd $1
    }
    #function ga() { alias | grep -i $*; functions | grep -i $*}

    # Find a file from the current directory
    alias ff='find . -name '

    # grep the output of commands
    alias envg='env | grep -i'
    alias psg='ps -eaf | head -1; ps -eaf | grep -v " grep " | grep -i'
    alias aliasg='alias | grep -i'
    alias hg='history | grep -i'

    # cd to the directory a symbolically linked file is in.
    function cdl() {
      if [ "x$1" = "x" ] ; then
        echo "Missing Arg"
      elif [ -L "$1" ] ; then
        link=`/bin/ls -l $1 | tr -s ' ' | cut -d' ' -f10`
        if [ "x$link" = "x" ] ; then
          echo "Failed to get link"
          return
        fi
        dirName_=`dirname $link`
        cd "$dirName_"
      else
        echo "$1 is not a symbolic link"
      fi
      return
    }
    # cd to the dir that a file is found in.
    function cdff {
      filename=`find . -name $1 | grep -iv "Permission Denied" | head -1`
      if [ "xx''${filename}xx" != "xxxx" ] ; then
        dirname=''${filename%/*}
        if [ -d $dirname ] ; then
          cd $dirname
        fi
      fi
    }

    # set -o vi
    # eval `resize`

    # awk tab delim  (escape ' awk to disable aliased awk)
    tawk='awk -F "t" '
    # case insensitive grep
    alias ig="grep --color -i "

    # ls sort by time
    alias lt="ls -ltr "
    # ls sort by byte size
    alias lS='ls -Slr'

    # ps by process grep  (ie. psg chrome)
    alias psg='ps -ef|grep --color '
    # ps by user
    alias psu='ps auxwwf '
    # ps by user with grep (ie. psug budman)
    alias psug='psu|grep --color '

    # find broken symlinks
    alias brokenlinks='find . -xtype l -printf "%p -> %ln"'

    # which and less a script (ie. ww backup.ksh)
    function ww { if [[ ! -z $1 ]];then _f=$(which $1);echo $_f;less $_f;fi }

    # For those of you who use Autosys:

    # alias to read log files based on current run date (great for batch autosys jobs)
    # ie.  slog mars-reconcile-job-c
    export RUN_DIR=~/process/dates
    function getRunDate {
      print -n $(awk -F'"' '/^run_date=/{print $2}' ~/etc/run_profile)
    }
    function getLogFile {
      print -n $RUN_DIR/$(getRunDate)/log/$1.log
    }
    function showLogFile {
      export LOGFILE=$(getLogFile $1);
      print "nLog File: $LOGFILEn";
      less -z-4 $LOGFILE;
    }
    alias slog="showLogFile "

    # Autosys aliases
    alias av="autorep -w -J "
    alias av0="autorep -w -L0 -J "
    alias avq="autorep -w -q -J "
    alias aq0="autorep -w -L0 -q -J "
    alias ava="autorep -w -D PRD_AUTOSYS_A -J "
    alias avc="autorep -w -D PRD_AUTOSYS_C -J "
    alias avt="autorep -w -D PRD_AUTOSYS_T -J "
    alias am="autorep -w -M "
    alias ad="autorep -w -d -J "
    alias jd="job_depends -w -c -J "
    alias jdd="job_depends -w -d -J "
    alias jrh="jobrunhist -J "
    alias fsjob="sendevent -P 1 -E FORCE_STARTJOB -J "
    alias startjob="sendevent -P 1 -E FORCE_STARTJOB -J "
    alias runjob="sendevent -P 1 -E STARTJOB -J "
    alias killjob="sendevent -P 1 -E KILLJOB -J "
    alias termjob="sendevent -P 1 -E KILLJOB -K 15 -J "
    alias onhold="sendevent -P 1 -E JOB_ON_HOLD -J "
    alias onice="sendevent -P 1 -E JOB_ON_ICE -J "
    alias offhold="sendevent -P 1 -E JOB_OFF_HOLD -J "
    alias office="sendevent -P 1 -E JOB_OFF_ICE -J "
    alias setsuccess="sendevent -P 1 -E CHANGE_STATUS -s SUCCESS -J "
    alias inactive="sendevent -P 1 -E CHANGE_STATUS -s INACTIVE -J "
    alias setterm="sendevent -P 1 -E CHANGE_STATUS -s TERMINATED -J "
    alias failed="njilgrep -npi -s FA $AUTOSYS_JOB_PREFIX"
    alias running="njilgrep -npi -s RU $AUTOSYS_JOB_PREFIX"
    alias iced="njilgrep -npi -s OI $AUTOSYS_JOB_PREFIX"
    alias held="njilgrep -npi -s OH $AUTOSYS_JOB_PREFIX"

    alias killme='slay $USER'

    function gi(){
      npm install --save-dev grunt-"$@"
    }

    function gci(){
      npm install --save-dev grunt-contrib-"$@"
    }

    alias v='vim'
    alias vi='vim'
    alias e='emacs'
    alias t='tail -n200'
    alias h='head -n20'
    alias g='git'
    alias p='pushd'
    alias o='popd'
    alias d='dirs -v'
    alias rmf='rm -rf'

    alias reboot='echo "Are you sure you want to reboot host `hostname` [y/N]?" && read reboot_answer && if [ "$reboot_answer" == y ]; then /sbin/reboot; fi'


    alias shutdown='echo "Are you sure you want to shutdown host `hostname` [y/N]?" && read shutdown_answer && if [ "$shutdown_answer" == y ]; then /sbin/shutdown -h now; fi'
    ## get rid of command not found ##

    # Find all IP addresses connected to your network
    alias netcheck='nmap -sP $(ip -o addr show | grep inet  | grep eth | cut -d  -f 7)'

    # See real time stamp when running dmesg
    #alias dmesg='command dmesg|perl -ne "BEGIN{$a= time()- qx:cat /proc/uptime:};s/[s*(d+).d+]/localtime($1 + $a)/e; print $_;" | sed -e "s|(^.*"`date +%Y`" )(.*)|x1b[0;34m1x1b[0m - 2|g"'

    # Nice readable way to see memory usage
    alias minfo='egrep "Mem|Cache|Swap" /proc/meminfo'

    # Need to figure out which drive your usb is assigned? Functions work the same way as an alias. Simply copy the line into your .profile/.bashrc file. Then type: myusb

    myusb () { usb_array=();while read -r -d $'n'; do usb_array+=("$REPLY"); done < <(find /dev/disk/by-path/ -type l -iname *usb*scsi* -not -iname *usb*scsi*part* -print0 | xargs -0 -iD readlink -f D | cut -c 8) && for usb in "''${usb_array[@]}"; do echo "USB drive assigned to sd$usb"; done; }

    alias gr="grep -E -i –color"

    # Sometimes when working with text files this is quite helpful:

    alias top10="sort|uniq -c|sort -n -r|head -n 10"
    # list usernames
    alias lu="awk -F: '{ print $1}' /etc/passwd"

    # better ls
    alias ls='ls -lAi --group-directories-first --color="always"'

    # make basic commands interactive and verbose
    #alias cp='cp -iv'      # interactive
    #alias rm='rm -ri'      # interactive
    #alias mv='mv -iv'       # interactive, verbose
    #alias grep='grep -i --color="always"'  # ignore case

    # starts nano with line number enabled
    alias nano='nano -c'

    # clear screen
    alias cl='clear'

    # shows the path variable
    alias path='echo -e ''${PATH//:/\n}'

    # Filesystem diskspace usage
    alias dus='df -h'

    # quick ssh to raspberry pi
    alias raspi='ssh root@192.168.1.6'

    # perform 'ls' after 'rm' if successful.
    rmls() {
      command rm "$*"
      RESULT=$?
      if [ "$RESULT" -eq 0 ]; then
        ls
      fi
    }

    #alias rm='rmls'

    # reloads changes
    alias rfc='source ~/.bashrc; cl'
    alias rf='source ~/.bashrc'

    # perform 'ls' after 'cd' if successful.
    function cdls() {
      builtin cd "$*"
      RESULT=$?
      if [ "$RESULT" -eq 0 ]; then
        ls
      fi
    }

    alias cd='cdls'

    # search for a string recursively in any C source files
    alias src-grep='find . -name "*.[ch]" | xargs grep '

    # for easily editting the path variable
    function vimpath () {
      declare TFILE=/tmp/path.$LOGNAME.$$;
      echo $PATH | sed 's/^:/.:/;s/:$/:./' | sed 's/::/:.:/g' | tr ':' '12' > $TFILE;
      vim $TFILE;
      PATH=`awk ' { if (NR>1) printf ":"; printf "%s",$1 }' $TFILE`;
      rm -f $TFILE;
      echo $PATH
    }

    alias vimpath='vimpath'
    alias backupstuff='rsync -avhpr --delete-delay /some/location/foo/bar /media/your/remote/location'

    #    quick update bashrc etc:
    alias bashrc="vim ~/.bashrc && source ~/.bashrc"

    #To play a random collection of music from your music library.
    #(You need to have VLC installed)
    alias play='nvlc ''${HOME}/music/ -Z'

    #    Whats the weather doing?
    alias rain='curl -4 http://wttr.in/Madrid'

    #    One of my favorite: copy something from command line to clipboard:
    alias c='xsel --clipboard'
    #    Then use like:
    #    grep John file_for_contacts | c

    alias s="sshpass -p'mypassword' ssh"

    # Count the number of files in current dir
    alias lsc='ls -l | wc -l'

    # Sort directories by sizes
    alias dush='du -h --max-depth=1 | sort -h'

    # Can't see all the files in one page ?
    alias lsless='ls | less'

    # Make a video capture of the desktop
    alias capturedesktop='avconv -f x11grab -r 25 -s 1900x1000 -i :0.0+0,24 -vcodec libx264  -threads 0'

    # Capture desktop, with sound
    alias capturedesktop_withsound='avconv -f x11grab -r 25 -s 1900x1000 -i :0.0+0,24 -vcodec libx264  -threads 0 -f alsa -i hw:0 '

    # Only print actual code/configuration
    alias removeblanks="egrep -v &#039;(^[[:space:]]*#|^$|^[[:space:]]*//)"

    # Useful when you want to scp to your own machine from a remote server
    alias myip="ifdata -pa eno1";

    #    List files in order of ascending size (the second form takes a file-pattern argument):
    function lsdu() { ls -l $* | sort --key=5.1 -n; };
    function lsduf() { ls -l | egrep $* | sort --key=5.1 -n; };

    #    List the 10 most recently edited/changed files (m = more, a poor-man's more)
    alias lsm='ls -lt | head -n 10'

    #    List the tasks using the most CPU time
    alias hogs='ps uxga | sort --key=3.1 -n'
    alias sdiff='sdiff -w 240'
    function pyloc() { egrep -v '^[ ]*(#|$dollar)' $* | wc; }; # count lines (python, sh)
    function loc() { egrep -v '^[ ]*(//|/*|*|$dollar)' $* | wc; }; # count lines (c, c++)

    alias renamedots="rename 'y/ :/ /' *"
    alias ab='docker run --rm piegsaj/ab'
    #alias php='docker run --rm -it -v "$PWD":/opt -w /opt php php'
    #alias java='docker run --rm -it -v "$PWD":/opt -w /opt java java'
    #alias node='docker run --rm -it -v "$PWD":/opt -w /opt node node'
    #alias ruby='docker run --rm -it -v "$PWD":/opt -w /opt ruby ruby'
    #alias python='docker run --rm -it -v "$PWD":/opt -w /opt python python'
    #alias htop='docker run --rm -it --pid host tehbilly/htop'
    alias mysql='docker run --rm -it imega/mysql-client mysql'
    alias bye='(xlock &); sudo systemctl suspend'
    alias curlj='curl -H "Content-Type: application/json"'
    alias bundle-install='nix-shell -p bundler --run "bundle install --gemfile=Gemfile"'
    alias jekyll-serve='nix-shell -p bundler --run "bundle exec jekyll serve --livereload --watch --trace"'
    alias kubectl-delete-all-evicted="kubectl get pods -o json | jq  '.items[] | select(.status.reason!=null) | select(.status.reason | contains(\"Evicted\")) | \"kubectl delete pod \(.metadata.name) -n \(.metadata.namespace)\"' | tr -d '\"' | sh"
    alias myip="curl -s tp.ht | grep 'h1' | sed 's h1  g' | tr -d '</>'"
    alias gitlg='git log --pretty="format:%h %G? %aN  %s"'
    alias nix-default="nix-shell -E 'with import <nixpkgs> { }; callPackage ./default.nix { }'"
    alias nixos-rebuild="sudo touch /var/run/containerd/daemon; sudo nixos-rebuild --install-bootloader --upgrade switch"
    alias cargo2nix="echo 'Now run rm -f Cargo.lock && cargo generate-lockfile && cargo2nix' && nix develop github:cargo2nix/cargo2nix#bootstrap"
    # vim: syntax=sh ts=2 sw=2 sts=4 sr noet
  '';

  home.file.".bashrc-functions".text = ''

    #function nix-env(){ nix-env -qa \* -P | fgrep -i "$1"; }

    # Colorize Maven Output
    # Colors reference: http://en.wikipedia.org/wiki/ANSI_escape_code
    color_maven() {
        /run/current-system/sw/bin/mvn $* | sed \
        -e 's/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/[32;1mTests run: \1[0m, Failures: [31;1m\2[0m, Errors: [33;1m\3[0m, Skipped: [34;1m\4[0m/g' \
        -e 's/\(\[INFO\] \-[-]*$\)/[36;1m\1[0m/g' \
        -e 's/\(\[INFO\] Building.*\)/[36;1m\1[0m/g' \
        -e 's/\(.*WARN.*\)/[33;1m\1[0m/g' \
        -e 's/\(.*ERROR.*\)/[31;1m\1[0m/g' \
        -e 's/\(Downloaded:.*\)/[32;1m\1[0m/g'
    }

    function basher() {
        if [[ $1 = 'run' ]];  then
            shift
            docker run -e HIST_FILE=/root/.bash_history \
              -v $HOME/.bash_history:/root/.bash_history "$@"
        else
            docker "$@"
        fi
    }

    function robomongo() {
        XSOCK=/tmp/.X11-unix
        XAUTH=/tmp/.docker.xauth
        xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
        xhost localhost
        docker run -d --rm -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH --net=host nexus.osoco.es/osoco/robo3t:latest
    }

    function find_file_in_nix_store() {
        local _packagePrefix="''${1}";
        local _packageSuffix="''${2}";
        local _fileName="''${3}";
    #    ls /nix/store | grep "''${_packagePrefix}" | grep "''${_packageSuffix}" | awk -v file="''${_fileName}" '{printf("find /nix/store/%s -name %s\n", $2, file);}' | sh | awk -F'-' '{printf("%s %s\n", $3, $0);}' | sort | tail -n 1

        command ls /nix/store | command grep "''${_packagePrefix}" | command grep "''${_packageSuffix}" | command awk -v file="''${_fileName}" '{printf("find /nix/store/%s -name %s\n", $0, file);}' | command sh  | command awk -F'-' '{printf("%s %s\n", $3, $0);}' | command sort | command tail -n 1 | command awk '{print $2;}'
    }

    function find_folder_of_file_in_nix_store() {
        local _packagePrefix="''${1}";
        local _packageSuffix="''${2}";
        local _fileName="''${3}";
        local _folder="$(find_file_in_nix_store "''${_packagePrefix}" "''${_packageSuffix}" "''${_fileName}")";
        command dirname "''${_folder}";
    }

    function find_stdc_folder() {
        find_folder_of_file_in_nix_store gcc lib "libstdc++.so.6"
    }

    function patch_gradle_libnativeplatform() {
        local _rpath="$(find_stdc_folder)";
        if [ "x''${_rpath}" != "x" ]; then
            command find ~/.gradle/native -name libnative-platform.so -exec patchelf --set-rpath "''${_rpath}" {} \;
        fi
    }

    function patch_micronaut() {
        local _rpath="$(find_stdc_folder):$(find_libz_parent_folder_in_nix_store)";
        local _ldLinux="$(find_ldlinux_in_nix_store)";
        if [ "x''${_rpath}" != "x" ]; then
            command find ~/.sdkman/candidates/micronaut -name mn -exec patchelf --set-rpath "''${_rpath}" {} \;
            command find ~/.sdkman/candidates/micronaut -name mn -exec patchelf --set-interpreter "''${_ldLinux}" {} \;
        fi
    }

    ## Finds out the location of the libstdc++.so.6 library.
    function find_stdcplusplus_in_nix_store() {
        local _fileName="libstdc++.so.6";

        command ls /nix/store | command grep "gcc" | command grep "lib" | command awk -v file="''${_fileName}" '{printf("find /nix/store/%s -name %s\n", $0, file);}' | command sh  | command awk -F'-' '{printf("%s %s\n", $3, $0);}' | command sort | command tail -n 1 | command awk '{print $2;}'
    }

    ## Finds out the location of the folder containing the libstdc++.so.6 library.
    function find_stdcplusplus_parent_folder_in_nix_store() {
        local _folder="$(find_stdcplusplus_in_nix_store)";
        command dirname "''${_folder}";
    }

    ## Finds out the location of the libz.so.1 library.
    function find_libz_parent_folder_in_nix_store() {
        local _lib=$(find_lib_in_nix_store "libz.so.1");
        command dirname "''${_lib}";
    }

    ## Finds out the location of the libz.so.1 library.
    function find_libz_in_nix_store() {
        find_lib_in_nix_store "libz.so.1";
    }

    ## Finds out the location of the ld-linux-x86-64.so.2 library.
    function find_ldlinux_in_nix_store() {
        find_lib_in_nix_store "ld-linux-x86-64.so.2";
    }

    ## Fixes the interpreter of given file
    function fix_interpreter_in_file() {
        local _fileName="''${1}";

        local _ldLinux=$(find_ldlinux_in_nix_store);

        patchelf --set-interpreter "''${_ldLinux}" "''${_fileName}";
    }

    ## Finds out the location of given library.
    function find_lib_in_nix_store() {
        local _fileName="''${1}";

        command ls /nix/store | command awk -v file="''${_fileName}" '{printf("find /nix/store/%s -name %s\n", $0, file);}' | command sh  | command awk -F'-' '{printf("%s %s\n", $3, $0);}' | command sort | command tail -n 1 | command awk '{print $2;}'
    }


    ## Runs Vault commands
    function dvault() {
      local _command="''${1}";
      shift;
      local _subcommand="''${1}";
      shift;
      local _afterCommand="";
      local _afterSubcommand="";
      local _vaultUrl="''${VAULT_URL:-http://vault:8200}";

      if [[ "''${_command}" == "operator" ]]; then
        _afterSubcommand="-address=''${_vaultUrl}";
      else
        _afterCommand="-address=''${_vaultUrl}";
      fi
      echo docker exec -it vault vault ''${_command} ''${_afterCommand} ''${_subcommand} ''${_afterSubcommand} $@
      docker exec -it vault vault ''${_command} ''${_afterCommand} ''${_subcommand} ''${_afterSubcommand} $*
    }

    ## hex to decimal
    function hex2dec() {
      local _hex="''${1}";

      echo "ibase=16;obase=A;''${_hex^^}" | bc
    }

    ## Converts epub files to mobi, copies them to the tablet, and moves them to the NAS
    function epub_mobi_tablet_nas() {
      local _dir="''${1:-''${PWD}}";

      local _oldIFS="''${IFS}";
      IFS=$'\n';
      local _f;
      for _epub in "''${_dir}"/*.epub; do
        IFS="''${_oldIFS}";
        local _mobi="$(basename "''${_epub}" .epub).mobi";
        ebook-convert "''${_epub}" "''${_mobi}" && \
        adb push "''${_mobi}" /sdcard/kindle && \
        sudo mv "''${_epub}" "''${_mobi}" /mnt/nas-books/
      done
      IFS="''${_oldIFS}";
    }

    ## Converts epub files to mobi, copies them to the tablet, and moves them to the NAS
    function epub_mobi_nas() {
      local _dir="''${1:-''${PWD}}";

      local _oldIFS="''${IFS}";
      IFS=$'\n';
      local _f;
      for _epub in "''${_dir}"/*.epub; do
        IFS="''${_oldIFS}";
        local _mobi="$(basename "''${_epub}" .epub).mobi";
        ebook-convert "''${_epub}" "''${_mobi}" && \
        sudo mv "''${_epub}" "''${_mobi}" /mnt/nas-books/
      done
      IFS="''${_oldIFS}";
    }

    ## Copies them to the tablet, and moves them to the NAS
    function pdf_tablet_nas() {
      local _dir="''${1:-''${PWD}}";

      local _oldIFS="''${IFS}";
      IFS=$'\n';
      local _f;
      for _pdf in "''${_dir}"/*.pdf; do
        IFS="''${_oldIFS}";
        adb push "''${_pdf}" /sdcard/kindle && \
        sudo mv "''${_pdf}" /mnt/nas-books/
      done
      IFS="''${_oldIFS}";
    }

    ## Copies them to the tablet, and moves them to the NAS
    function pdf_nas() {
      local _dir="''${1:-''${PWD}}";

      local _oldIFS="''${IFS}";
      IFS=$'\n';
      local _f;
      for _pdf in "''${_dir}"/*.pdf; do
        IFS="''${_oldIFS}";
        sudo mv "''${_pdf}" /mnt/nas-books/
      done
      IFS="''${_oldIFS}";
    }
    # vim: syntax=sh ts=2 sw=2 sts=4 sr noet
  '';

  home.file.".bashrc-privateexports".text = ''

    export ANONTWI_TOKEN_KEY=1021414848-3UanI1RV6ATy4XVtlVUOyifIlGqP9QFid0RIzrN
    export ANONTWI_TOKEN_SECRET=hpIiAJLXixKplaIGmfrQYW2Y4QPleeIoONNVc1M
    export BATS_DOCKER="406021078145.dkr.ecr.eu-west-1.amazonaws.com"
    export CONTESTIA_DOCKER="185740788475.dkr.ecr.eu-west-1.amazonaws.com"
    #export LEGO_HOME=''${HOME}/osoco/inditex/lego
    #export MAVEN_OPTS="-Djavax.net.ssl.trustStore=''${HOME}/.jrecerts/inditex-keystore -Djavax.net.ssl.trustStorePassword=changeit -Dmaven.surefire.debug'"
    export GOPATH=''${HOME}/go

    export CONTESTIA_DEV_CLUSTER="dev-contestia-33-eks-50-clusters-50-all-in-one";
    export CONTESTIA_STAGING_CLUSTER="staging-contestia-33-eks-50-clusters-50-all-in-one";
    export CONTESTIA_PRO_CLUSTER="staging-contestia-33-eks-50-clusters-50-all-in-one";
    export CONTESTIA_CIMIC_CLUSTER="cimic-contestia-33-eks-50-clusters-50-all-in-one";
    export CONTESTIA_IFEMA_CLUSTER="ifema-contestia-33-eks-50-clusters-50-all-in-one";
    # vim: syntax=sh ts=2 sw=2 sts=4 sr noet
  '';

  home.file.".bashrc-privatealiases".text = ''

    alias lp='sudo cat ~/.lp/lastpass | tail -n 1 | xclip'
    alias bw='sudo cat ~/.lp/bitwarden | tail -n 1 | xclip'
    alias gitosoco="git config --global user.name josesl; git config --global user.email jose.sanleandro@osoco.es"
    alias gitrydnr="git config --global user.name rydnr; git config --global user.email github@acm-sl.org"
    alias newpassword="head -c63 /dev/random | uuencode -m - | sed -n '2s/=*$//;2p'"
    alias rename_spaces="ls | grep ' ' | while read -r f; do mv -v "$f" $(echo "$f}" | tr ' ' '_'); done"
    #alias start="sudo mount /mnt/documents; (tor &); (firefox &)"
    #alias start="(~/toolbox/tor/start-tor-browser &); (/opt/google/chrome/google-chrome &); (emacs &); (pidgin &); (idea.sh &)"
    #alias start="(firefox-bin &); (emacs &); (pidgin &); (docker run -d -p 27017:27017 osoco-registry:5000/osoco/mongodb-openbadges && docker run -d -p 5672:5672 -p 15672:15672 -p 61613:61613 osoco-registry:5000/osoco/rabbitmq-openbadges && docker run -d -p 5432:5432 osoco-registry:5000/osoco/postgresql-openbadges &); (cd ~/osoco/open-badges/game-denormalizer && gradle run &); (cd ~/osoco/open-badges/game-rule-engine && gradle run &); (cd ~/osoco/open-badges/game-rest-api && gradle run &); (cd ~/osoco/open-badges/game-notification && gradle run &); (cd ~/osoco/open-badges/game-webapp && gradle run &)"
    alias start="(firefox &); (emacs &); (pidgin &)"
    alias jrebel="JAVA_TOOL_OPTIONS=\"''${JAVA_TOOL_OPTIONS} -javaagent:/home/chous/toolbox/jrebel/jrebel.jar\""
    alias jjk='pushd ~/.jjk/; I=0; while [ $I -lt 6 ]; do I=$((I+1)); ls | sort -R | head -n 5 | xargs mplayer -nosound & done; popd'
    alias bt-phone="sudo hciconfig hci0 name \"(hostname)\"; echo 'connect 50:01:BB:19:61:74' | bluetoothctl"
    alias bt-ipad="sudo hciconfig hci0 name \"(hostname)\"; echo 'connect B8:F6:B1:EA:11:74' | bluetoothctl"
    alias bt-nc="sudo hciconfig hci0 name \"(hostname)\"; echo 'connect 20:15:08:13:01:17' | bluetoothctl"
    alias bt-i7="sudo hciconfig hci0 name \"(hostname)\"; echo 'connect 20:18:04:07:AC:DE' | bluetoothctl"
    alias bt-soaiy="sudo hciconfig hci0 name \"(hostname)\"; echo 'connect 23:2D:4F:C1:55:92' | bluetoothctl"
    alias bt-aftershokz="sudo hciconfig hci0 name \"(hostname)\"; echo 'connect 20:74:CF:00:21:55' | bluetoothctl"
    alias vb='for m in vbox{drv,netadp,netflt}; do sudo modprobe $m; done; VirtualBox'
    alias mvn-debugn='MAVEN_OPTS="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=4001,server=y,suspend=n -Dqueryjroot=/home/chous/github/queryj" mvn -Dmaven.surefire.debug -Dqueryjroot=/home/chous/github/queryj'
    alias mvn-debug='MAVEN_OPTS="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=4001,server=y,suspend=y -Dqueryjroot=/home/chous/github/queryj" mvn -Dmaven.surefire.debug  -Dqueryjroot=/home/chous/github/queryj'
    # [ -f ~/.lp/produccion ] && for f in ~/.lp/*; do alias $(basename $f)="dollar='$' echo \"tail -n 1 $f | awk '{printf(\\\"%s\\\", \"\\\$\"0);}'\" | sh | xclip"; done

        alias kbd='setxkbmap -v us -variant dvp -option "ctrl:swapcaps,compose:ralt";# xmodmap ~/.Xmodmap'
    alias git_resolve="git st | grep 'both\|added' | awk -F':' '{print \$2}' | xargs vim"
    alias git_resolve_add="git st | grep 'both\|added' | awk -F':' '{print \$2}' | xargs git add"
    alias bloomrpc="docker run -it --rm -v /home/chous/osoco/inditex:/home/bloomrpc -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH --ipc=host --net=host osoco-phusion/bloomrpc:1.4.1"
    alias pharo8='docker run -it --rm --net=host -v ''${PWD}:/home/pharo/work -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH --ipc=host --entrypoint=/bin/bash acmsl-phusion/gradle-gtoolkit-texlive:7.1.1-9.0-0.8.805'
    alias gtoolkit='docker run -it --rm --net=host -v ''${PWD}:/home/pharo/work -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH --ipc=host --user=pharo acmsl-phusion/gtoolkit:v0.8.270 bash'
    # vim: syntax=sh ts=2 sw=2 sts=4 sr noet
  '';

  home.file.".bashrc-privatealiases-bluetooth".text = ''

    alias bt-phone="sudo hciconfig hci0 name \"(hostname)\"; echo 'connect 50:01:BB:19:61:74' | bluetoothctl";
    alias bt-bw-fye15="sudo hciconfig hci0 name \"(hostname)\"; echo 'connect F4:4E:FC:80:02:41' | bluetoothctl";
    alias bt-maria="sudo hciconfig hci0 name \"$(hostname)\"; echo 'power on' | bluetoothctl; echo 'agent on' | bluetoothctl; echo 'connect 18:F0:E4:D9:81:9C' | bluetoothctl"
    alias bt-phone="sudo hciconfig hci0 name \"$(hostname)\"; echo 'power on' | bluetoothctl; echo 'agent on' | bluetoothctl; echo 'connect 84:CF:BF:89:69:E8' | bluetoothctl"
    alias bt-ipad="sudo hciconfig hci0 name \"$(hostname)\"; echo 'power on' | bluetoothctl; echo 'agent on' | bluetoothctl; echo 'connect B8:F6:B1:EA:11:74' | bluetoothctl"
    alias bt-bose="sudo hciconfig hci0 name \"$(hostname)\"; echo 'power on' | bluetoothctl; echo 'agent on' | bluetoothctl; echo 'connect 2C:41:A1:B0:A6:00' | bluetoothctl; sleep 2; echo 'connect 2C:41:A1:B0:A6:00' | bluetoothctl"
    alias bt-gta="sudo hciconfig hci0 name \"$(hostname)\"; echo 'power on' | bluetoothctl; echo 'agent on' | bluetoothctl; echo 'connect 84:11:9E:48:90:1D' | bluetoothctl; sleep 2; echo 'connect 84:11:9E:48:90:1D' | bluetoothctl"
    alias bt-tt-bh03="sudo hciconfig hci0 name \"$(hostname)\"; echo 'power on' | bluetoothctl; echo 'agent on' | bluetoothctl; echo 'connect A0:E9:DB:51:0F:D0' | bluetoothctl; sleep 2; echo 'connect A0:E9:DB:51:0F:D0' | bluetoothctl"
    alias bt-e8="sudo hciconfig hci0 name \"$(hostname)\"; echo 'power on' | bluetoothctl; echo 'agent on' | bluetoothctl; echo 'connect 17:50:04:20:01:BE' | bluetoothctl; sleep 2; echo 'connect 17:50:04:20:01:BE' | bluetoothctl"
    alias bt-leyre="sudo hciconfig hci0 name \"$(hostname)\"; echo 'power on' | bluetoothctl; echo 'agent on' | bluetoothctl; echo 'connect 00:EC:0A:F7:E2:5E' | bluetoothctl; sleep 2; echo 'connect 00:EC:0A:F7:E2:5E' | bluetoothctl"
    alias bt-aftershok="sudo hciconfig hci0 name \"$(hostname)\"; echo 'power on' | bluetoothctl; echo 'agent on' | bluetoothctl; echo "" | bluetoothctl; sleep 2; echo 'connect ' | bluetoothctl";
    # vim: syntax=sh ts=2 sw=2 sts=4 sr noet
  '';

  home.file.".bashrc-privatefunctions".text = ''

    function bats_core_build() {
        [ -z "''${1}" ] && echo "Usage: bats_core_build [tagName]" && return
        bbvaats_pharo_image_build "core" "''${1}" "pre";
    }
    function contestia_core_build() {
        [ -z "''${1}" ] && echo "Usage: contestia_core_build [tagName]" && return
        bbvaats_pharo_image_build "core" "''${1}" "pro";
    }
    function bats_roundfilter_build() {
        [ -z "''${1}" ] && echo "Usage: bats_roundfilter_build [tagName]" && return
        bbvaats_pharo_image_build "roundfilter" "''${1}" "pre";
    }
    function contestia_roundfilter_build() {
        [ -z "''${1}" ] && echo "Usage: contestia_roundfilter_build [tagName]" && return
        bbvaats_pharo_image_build "roundfilter" "''${1}" "pro";
    }
    function bats_backoffice_build() {
        [ -z "''${1}" ] && echo "Usage: bats_backoffice_build [tagName]" && return
        [ ! -e "build/libs/BBVA-ATS-Backoffice-''${1}.war" ] && echo "Build the war file first, using grails war" && return
        bbvaats_image_build "backoffice" "''${1}" "pre";
    }
    function contestia_backoffice_build() {
        [ -z "''${1}" ] && echo "Usage: contestia_backoffice_build [tagName]" && return
        [ ! -e "build/libs/BBVA-ATS-Backoffice-''${1}.war" ] && echo "Build the war file first, using grails war" && return
        bbvaats_image_build "backoffice" "''${1}" "pro";
    }
    function bbvaats_pharo_image_build() {
        [ -z "''${1}" ] && echo "Usage: bbvaats_image_build [core|roundfilter] [tagName] [pre|pro]" && return
       /usr/bin/cp bats-''${1}-0.2.0-SNAPSHOT.image bats-''${1}.image && \
       /usr/bin/cp bats-''${1}-0.2.0-SNAPSHOT.changes bats-''${1}.changes && \
       bbvaats_image_build $@
     }

    function bats_ecr_login() {
         $(aws-bats ecr get-login | sed 's/-e none //g')
     }

    function contestia_ecr_login() {
         $(aws-contestia ecr get-login | sed 's/-e none //g')
     }

    function manning_ecr_login() {
         $(aws-manning ecr get-login | sed 's/-e none //g')
     }

    function bbvaats_image_build() {
        [ -z "''${1}" ] && echo "Usage: bbvaats_image_build [core|roundfilter|backoffice] [tagName] [pre|pro]" && return
        [ -z "''${2}" ] && echo "Usage: bbvaats_image_build [core|roundfilter] [tagName] [pre|pro]" && return
        [ -z "''${3}" ] && echo "Usage: bbvaats_image_build [core|roundfilter] [tagName] [pre|pro]" && local _dockerRegistry;
        case "''${3}" in
            "pre") _dockerRegistry="''${BATS_DOCKER}";
                bats_ecr_login
                ;;
            "pro") _dockerRegistry="''${CONTESTIA_DOCKER}";
                contestia_ecr_login
                ;;
            *) echo "Usage: bbvaats_image_build [core|roundfilter] [tagName] [pre|pro]" && return
                ;;
        esac
        docker build -t nexus.osoco.es/osoco/bats-''${1}:''${2} . && \
        docker tag nexus.osoco.es/osoco/bats-''${1}:''${2} ''${_dockerRegistry}/osoco/bats-''${1}:''${2%-*} && \
        docker tag nexus.osoco.es/osoco/bats-''${1}:''${2} ''${_dockerRegistry}/osoco/bats-''${1}:''${2} && \
        docker push nexus.osoco.es/osoco/bats-''${1}:''${2} && \
        docker push ''${_dockerRegistry}/osoco/bats-''${1}:''${2}
        docker push ''${_dockerRegistry}/osoco/bats-''${1}:''${2%-*}
    }
    # Downloads a book from safari
    function safari_download() {
      local _book="''${1}";
      local _output="''${2}";
      [[ -z "''${_book}" ]] && echo "Usage: safari_download *isbn* outputFile" && return 1;
      [[ -z "''${_output}" ]] && echo "Usage: safari_download isbn *outputFile*" && return 2;
      ~/.npm-packages/bin/safaribooks-downloader -b ''${_book} -o "''${_output}" -u rydnr -p 'NczV6qHg!3%s'
    }
    function connect-inditex() {
      [ -z "''${1}" ] && echo "Usage: connect-inditex DSID-cookie" && return 1;
      sudo openconnect --verbose --disable-ipv6 --protocol=nc --cookie="DSID=$1"  developer.vpn.inditex.com | sudo tee /var/log/openconnect.log
    }
    function fix_grpc_interpreters() {
      local _ld_linux_so="/nix/store/6m2k8kx8h216jlx9dg3lp4m90bz05yck-glibc-2.30/lib64/ld-linux-x86-64.so.2";
    #  /nix/store/1mnsmslnx5anjfksac6417xfzzglrwhr-glibc-2.27/lib64/ld-linux-x86-64.so.2";
      for f in $(find . -name 'protoc-*.exe'); do
        echo "Patching ''${f}"
        patchelf --set-interpreter "''${_ld_linux_so}" "''${f}"
      done
    }
    function build_barrabes_base() {
      local -i _rescode;
      pushd ~/osoco/DevOps/.set-square-phusion-images;
      rsync -avz ~/.dry-wit/src/ .templates/common-files/dry-wit/src/;
      time ./build.sh -v -f -o base;
      _rescode=$?;
      if [[ ''${_rescode} -eq 0 ]]; then
        docker tag barrabes-phusion/base:0.11 992473791893.dkr.ecr.eu-west-1.amazonaws.com/nexplore-contestia/base:0.11;
        _rescode=$?;
      fi
      if [[ ''${_rescode} -eq 0 ]]; then
         docker tag barrabes-phusion/base:0.11 992473791893.dkr.ecr.eu-west-1.amazonaws.com/nexplore-contestia/base:nexplore;
        _rescode=$?;
      fi
      if [[ ''${_rescode} -eq 0 ]]; then
         docker tag barrabes-phusion/base:0.11 992473791893.dkr.ecr.eu-west-1.amazonaws.com/barrabes-phusion/base:0.11;
        _rescode=$?;
      fi
      if [[ ''${_rescode} -eq 0 ]]; then
         docker tag barrabes-phusion/base:0.11 992473791893.dkr.ecr.eu-west-1.amazonaws.com/barrabes-phusion/base:nexplore;
        _rescode=$?;
      fi
      popd;
    }
    function build_contestia_server() {
      local _server="''${1}";
      local -i _rescode;
      pushd ~/osoco/DevOps/;
      time ./build.sh -v -f -o contestia-''${_server};
      _rescode=$?;
      if [[ ''${_rescode} -eq 0 ]]; then
        docker tag barrabes-phusion/contestia-''${_server}:latest 992473791893.dkr.ecr.eu-west-1.amazonaws.com/nexplore-contestia/''${_server}:dev;
        _rescode=$?;
      fi
      popd;
      return ''${_rescode};
    }
    function build_contestia_server_recursively() {
      local _server="''${1}";
      while ! build_barrabes_base; do echo -n ""; done
      while ! build_contestia_server "''${_server}"; do echo -n ""; done
    }
    function build_contestia_rabbitmq() {
      while ! build_contestia_server rabbitmq; do echo -n ""; done
    }
    function build_contestia_rabbitmq_recursively() {
      while ! build_contestia_server_recursively rabbitmq; do echo -n ""; done
    }
    function build_contestia_mongodb() {
      while ! build_contestia_server mongodb; do echo -n ""; done
    }
    function build_contestia_mongodb_recursively() {
      while ! build_contestia_server_recursively mongodb; do echo -n ""; done
    }
    function build_contestia_grails_service() {
      local -i _rescode;
      pushd ~/osoco/DevOps/;
      time ./build.sh -v -f -o grails-service;
      _rescode=$?;
      if [[ ''${_rescode} -eq 0 ]]; then
        docker tag barrabes-phusion/grails-service:nexplore 992473791893.dkr.ecr.eu-west-1.amazonaws.com/nexplore-contestia/grails-service:nexplore;
        _rescode=$?;
      fi
      popd;
      return ''${_rescode};
    }
    function build_contestia_grails_service_recursively() {
      while ! build_barrabes_base ; do echo -n ""; done
      while ! build_contestia_grails_service; do echo -n ""; done
    }
    function build_contestia_app_service() {
      local _app="''${1}";
      local -i _rescode;
      pushd ~/osoco/DevOps/;
      time ./build.sh -v -f -o contestia-''${_app}-service;
      _rescode=$?;
      if [[ ''${_rescode} -eq 0 ]]; then
        docker tag barrabes-phusion/contestia-''${_app}-service:nexplore 992473791893.dkr.ecr.eu-west-1.amazonaws.com/nexplore-contestia/''${_app}-service:nexplore;
        _rescode=$?;
      fi
      popd;
      return ''${_rescode};
    }
    function build_contestia_app_service_recursively() {
      local _app="''${1}";
      local -i _rescode;

      case "''${_app}" in
        core | roundfilter) build_barrabes_base;
                            _rescode=$?;
                            ;;
        *) build_contestia_grails_service;
           _rescode=$?;
           ;;
      esac;
      if [[ ''${_rescode} -eq 0 ]]; then
        build_contestia_app_service "''${_app}";
        _rescode=$?;
      fi
      return ''${_rescode};
    }
    function build_contestia_core_service() {
      rm -f ~/osoco/DevOps/contestia-core-service/service;
      while ! build_contestia_app_service core; do echo -n ""; done
    }
    function build_contestia_core_service_recursively() {
      while ! build_contestia_app_service_recursively core; do echo -n ""; done
    }
    function build_contestia_roundfilter_service() {
      rm -f ~/osoco/DevOps/contestia-roundfilter-service/service;
      while ! build_contestia_app_service roundfilter; do echo -n ""; done
    }
    function build_contestia_roundfilter_service_recursively() {
      while ! build_contestia_app_service_recursively roundfilter; do echo -n ""; done
    }
    function build_contestia_backoffice_service() {
      while ! build_contestia_app_service backoffice; do echo -n ""; done
    }
    function build_contestia_backoffice_service_recursively() {
      while ! build_contestia_app_service_recursively backoffice; do echo -n ""; done
    }
    function build_contestia_evaapp_service() {
      while ! build_contestia_app_service evaapp; do echo -n ""; done
    }
    function build_contestia_evaapp_service_recursively() {
      while ! build_contestia_app_service_recursively evaapp; do echo -n ""; done
    }
    function build_contestia_app() {
      local _app="''${1}";
      shift;
      local -i _rescode;
      pushd ~/osoco/nexplore/contestia-''${_app};
      docker build -t barrabes-phusion/contestia-''${_app}:nexplore ''${}@} .;
      _rescode=$?;
      if [[ ''${_rescode} -eq 0 ]]; then
        docker tag barrabes-phusion/contestia-''${_app}:nexplore 992473791893.dkr.ecr.eu-west-1.amazonaws.com/nexplore-contestia/''${_app}:nexplore;
        _rescode=$?;
      fi
      popd;
      return ''${_rescode};
    }
    function build_contestia_app_recursively() {
      local _app="''${1}";
      shift;
      build_contestia_app_service "''${_app}" && build_contestia_app "''${_app}" $@;
    }
    function build_contestia_core() {
      while ! build_contestia_app core --no-cache; do echo -n ""; done
    }
    function build_contestia_core_recursively() {
      while ! build_contestia_app_recursively core; do echo -n ""; done
    }
    function build_contestia_roundfilter() {
      while ! build_contestia_app roundfilter --no-cache; do echo -n ""; done
    }
    function build_contestia_roundfilter_recursively() {
      while ! build_contestia_app_recursively roundfilter; do echo -n ""; done
    }
    function build_contestia_backoffice() {
      while ! build_contestia_app backoffice; do echo -n ""; done
    }
    function build_contestia_backoffice_recursively() {
      while ! build_contestia_app_recursively backoffice; do echo -n ""; done
    }
    function build_contestia_evaapp() {
      while ! build_contestia_app evaapp; do echo -n ""; done
    }
    function build_contestia_evaapp_recursively() {
      while ! build_contestia_app_recursively evaapp; do echo -n ""; done
    }

    # fun: klog-pod
    # api: public
    # txt: Prints the logs of a given pod.
    # opt: env: The environment. Either dev, Staging, PRO, CIMIC or IFEMA. Mandatory.
    # opt: namespace: The Kubernetes namespace. Mandatory.
    # opt: pod: The name of the pod. Mandatory.
    # opt: index: The index of the POD, if more than one exists. Optional. Defaults to 1.
    # txt: Returns 0 always.
    # use: klog-pod PRO contestia contestia-backoffice-pro 1
    function klog-pod() {
      local _env="''${1}";
      local _namespace="''${2}";
      local _pod="''${3}";
      local _index=''${4:-};
      local _profile;
      local _environment="''${_env}";
      local _cluster="''${_environment}-contestia-33-eks-50-clusters-50-all-in-one";
      local _region="eu-west-1";
      case "''${_env}" in
           "Staging") _environment=staging;
                      _cluster="''${_environment}-contestia-33-eks-50-clusters-50-all-in-one";
                      _region=eu-central-1;
                      ;;
           "PRO") _environment=production;
                  _cluster="PRO-contestia-33-eks-50-clusters-05-all-in-one";
                  ;;
           "CIMIC") _environment=cimic;
                    _cluster="''${_environment}-contestia-33-eks-50-clusters-50-all-in-one";
                    _region=ap-southeast-2;
                    ;;
           "IFEMA") _environment=ifema;
                    _cluster="''${_environment}-contestia-33-eks-50-clusters-50-all-in-one";
                    ;;
      esac
      _profile="nexplore-contestia-''${_environment}";
      aws --profile ''${_profile} --region ''${_region} eks update-kubeconfig --name ''${_cluster} > /dev/null 2>&1;
      local _podName;
      local _podNames="$(kubectl -n ''${_namespace} get pods -o json | jq ".items[] | select(.metadata.labels.\"app.kubernetes.io/instance\" == \"''${_pod}\") | .metadata.name" | tr -d '"')";
      if [[ -z "''${_podNames:-}" ]]; then
        _podNames="$(kubectl -n ''${_namespace} get pods -o json | jq ".items[] | select(.metadata.labels.\"app.kubernetes.io/instance\" == \"''${_pod#contestia-}\") | .metadata.name" | tr -d '"')";
      fi
      local -i _i=1;
      local _oldIFS="''${IFS}";
      IFS=" ";
      for _podName in $(echo ''${_podNames} | xargs echo); do
        if [[ -z "''${_index}" ]] || [[ "''${_index}" == "''${_i}" ]]; then
          echo "kubectl -n ''${_namespace} logs -f ''${_podName}"
          kubectl -n ''${_namespace} logs -f ''${_podName}
        fi
        ((_i++));
      done
      IFS="''${_oldIFS}";
    }
    # vim: syntax=sh ts=2 sw=2 sts=4 sr noet
  '';

  nixpkgs.config.packageOverrides = pkgs: {
    fcitx-engines = throw "fcitx-engines is deprecated, use fcitx5 instead.";
  };
}
