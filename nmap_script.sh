#!/bin/bash

# Nmap Cheat Sheet 1
# https://www.stationx.net/nmap-cheat-sheet/

# Nmap Cheat Sheet 2
# https://hackertarget.com/nmap-cheatsheet-a-quick-reference-guide/


# nmap online book
# https://nmap.org/book/toc.html

# This script will do several basic, default, aggressive scan checks agaist the targets

# =============================================
# http://resources.infosecinstitute.com/nmap-cheat-sheet-discovery-exploits-part-3-gathering-additional-information-host-network-2/#article
## The easiest method to find all nse scripts is to use the find command like below.
# sudo find / -name '*.nse'

## Use nmap script
# nmap -p80 --script http-google-email <target>

# Phil example
# sudo nmap -sS -sV -p 0- -O -Pn --reason --script banner 35.176.10.50
# =============================================

# how to use this script
# ./nmap_script.sh --target=127.0.0.1 --scan-tech=-sS --scan-port=-p --os-detection=-A --flag-discov=-Ps --service-detec=-sV --nse-script=http-sql-injection --debugging-level=-ddd
# ./nmap_script.sh --target=$target --scan-tech=-$scan_tech --scan-port=$scan_port --os-detection=$os_detection --flag-discov=$flag_discov --service-detec=$service_detec --nse-script=$nse_script --debugging-level=$debugging_level

# =============================================
# Simple timer
start=$(date +'%m%s')

# display how to use the script
usage() {
 echo "Usage: $0\
[--target <string>]\
[--scan-tech <string>]\
[--scan-port <string>]\
[--os-detection <string>]\
[--flag-discov <string>]\
[--service-detec <string>]\
[--nse-script <string>]\
[--debugging-level <string>]\
[--verbose|-v (optional)]" 1>&2
 exit 1
}

# Define variables from options.
OPTS=`getopt -o v --long verbose,target:,scan-tech:,scan-port:,os-detection:,flag-discov:,service-detec:,nse-script:,debugging-level: -- "$@"`
if [ $? != 0 ]; then
  usage
fi

eval set -- "$OPTS"
# set initial values of the parameters, Set defaults.
DT=$(date +%d-%m-%Y--%H:%M:%S)
# TARGET_array=($TARGET)
# SCAN_TECH=
# SCAN_PORTS_array=($PORT)#  Ex: -p22; -p1-65535; -p U:53,111,137,T:21-25,80,139,8080,S:9
# OS_DETECTION= # -O or -A
# NMAP_FLAG_DISCOV=
# SERVICE_DETEC=
# NSE_SCRIPT=("http-sql-injection")
# DEBUGGING_LEVEL=


while true; do
  case "$1" in
    -v | --verbose )
      VERBOSE=true;
      shift;;
    --target )
      TARGET_array="$2";
      shift 2;;
    --scan-tech )
      SCAN_TECH="$2";
      shift 2;;
    --scan-port )
      SCAN_PORTS_array="$2"
      shift 2;;
    --os-detection )
      OS_DETECTION="$2"
      shift 2;;
    --flag-discov )
      NMAP_FLAG_DISCOV="$2"
      shift 2;;
    --service-detec)
      SERVICE_DETEC="$2"
      shift 2;;
    --nse-script )
      NSE_SCRIPT="$2"
      shift 2;;
    --debugging-level )
      DEBUGGING_LEVEL="$2"
      shift 2;;
    *)
      break;;
  esac
done


# All of these parameters are required
if [ "${TARGET_array}" = "" ] ; then
  usage
fi


if [ ${#SCAN_PORTS_array[@]} -gt 0 ];
then
  SCAN_PORTS_array="-p$SCAN_PORTS_array";
fi

echo ""
echo "================ SCAN  DETAILS  ==================================="
echo "TARGET: ${TARGET_array[*]} "
echo "PORTS SELECTED: ${SCAN_PORTS_array[*]} "
echo "SCAN TECH FLAG: $SCAN_TECH "
echo "DETECT OS WITH : $OS_DETECTION "
echo "TRY TO DETECT SERVICES RUNNING: $SERVICE_DETEC "
echo "DETAILS OF DEBUGGING LEVEL: $DEBUGGING_LEVEL "
echo "HOST DISCOVERY FLAG: $NMAP_FLAG_DISCOV "
echo "Nmap NSE SCRIPT: $NSE_SCRIPT "
echo "==================================================="
echo ""

echo "START THE Nmap SCAN"

# SCAN TECHNIQUES, OS DETECTION, PORT SPECIFICATION/SCAN ORDER, HOST DISCOVERY, SERVICE/VERSION DETECTION
for (( i=0; i<${#TARGET_array[@]}; i+=1 )) do
  echo "SCAN TECHNIQUES on ${TARGET_array[$i]} with the flag: => $SCAN_TECH and Detecting OS with flag: $OS_DETECTION  and posrt: ${SCAN_PORTS_array[*]} <="
  sudo nmap ${SCAN_PORTS_array[*]} -T3 -vvv $SCAN_TECH $OS_DETECTION $SERVICE_DETEC $DEBUGGING_LEVEL $NMAP_FLAG_DISCOV -oX "target-$DT-${TARGET_array[$i]}.xml" ${TARGET_array[$i]}

  sudo xsltproc "target-$DT-${TARGET_array[$i]}.xml" -o "target-$DT-${TARGET_array[$i]}.html"
  sleep 2
  echo "sending email..."
  
  /usr/local/bin/wkhtmltopdfwrap target-$DT-${TARGET_array[$i]}.html /tmp/target-$DT-${TARGET_array[$i]}.pdf > /dev/null 2>&1 && /bin/echo -e "This is an automatically generated email about the Nmap Pentesting sent by Jenkins with the output date and time $DT. " | mail -s "Nmap Scanner"  email@example.com -A /tmp/target-$DT-${TARGET_array[$i]}.pdf

  rm target-$DT-${TARGET_array[$i]}.xml
  rm target-$DT-${TARGET_array[$i]}.html
  # rm target-$DT-${TARGET_array[$i]}.pdf
  echo "done!"
  echo "****** END ********";
  echo ""
done;

# FIREWALL/IDS EVASION AND SPOOFING:


# CHECK FOR SQL INJECTIONS with a default script:
if [ ${#NSE_SCRIPT[@]} -gt 0 ];
then
  NSE_SCRIPT="--script $NSE_SCRIPT";

  for (( i=0; i<${#TARGET_array[@]}; i+=1 )) do
    echo "RUN NSE SCRIPT: ${NSE_SCRIPT[*]} on ports:${SCAN_PORTS_array[*]} Sites URL: => ${TARGET_array[$i]} <="
    sudo nmap -vvv ${SCAN_PORTS_array[*]} ${NSE_SCRIPT[*]} $DEBUGGING_LEVEL -oX "nse-report-$DT-${TARGET_array[$i]}.xml" "${TARGET_array[$i]}"
    sudo xsltproc "nse-report-$DT-${TARGET_array[$i]}.xml" -o "nse-report-$DT-${TARGET_array[$i]}.html"
    sleep 2
    echo "sending email..."

    /usr/local/bin/wkhtmltopdfwrap nse-report-$DT-${TARGET_array[$i]}.html /tmp/nse-report-$DT-${TARGET_array[$i]}.pdf > /dev/null 2>&1 && /bin/echo -e "This is an automatically generated email about the Nmap Pentesting sent by Jenkins with the output date and time $DT. " | mail -s "Nmap Scanner"  email@example.com -A /tmp/nse-report-$DT-${TARGET_array[$i]}.pdf

    rm nse-report-$DT-${TARGET_array[$i]}.xml
    rm nse-report-$DT-${TARGET_array[$i]}.html
    # rm nse-report-$DT-${TARGET_array[$i]}.pdf
    echo "done!"
    echo "****** END ********";
    echo ""
  done;
fi

exit;



# # ==== Good commands to keep ===========
# # TCP SYN Scan
# # SYN scan is the default and most popular scan option, for good reasons. It can be performed quickly, scanning thousands of ports per second on a fast network not hampered by restrictive firewalls. It is also relatively unobtrusive and stealthy, since it never completes TCP connections.
# # checking the open ports on host
# nmap -sS -vv $TARGET -oX $DT-Output.xml
#
# # TCP Connect Scan
# # TCP connect scan is the default TCP scan type when SYN scan is not an option. This is the case when a user does not have raw packet privileges. Instead of writing raw packets as most other scan types do, nmap -vv asks the underlying operating system to establish a connection with the target machine and port by issuing the connect system call.
# nmap –sT -vv $TARGET
#
#
# # UDP SCANS
# # While most popular services on the Internet run over the TCP protocol, UDP services are widely deployed. DNS, SNMP, and DHCP (registered ports 53, 161/162, and 67/68) are three of the most common. Because UDP scanning is generally slower and more difficult than TCP, some security auditors ignore these ports. This is a mistake, as exploitable UDP services are quite common and attackers certainly don’t ignore the whole protocol.
#
# # The –data-length option can be used to send a fixed-length random payload to every port or (if you specify a value of 0) to disable payloads. If an ICMP port unreachable error (type 3, code 3) is returned, the port is closed. Other ICMP unreachable errors (type 3, codes 1, 2, 9, 10, or 13) mark the port as filtered. Occasionally, a service will respond with a UDP packet, proving that it is open. If no response is received after retransmissions, the port is classified as open|filtered.
# nmap –sU -vv target
# nmap –sU –data-length=value -vv target
#
#
# # SCTP INIT Scan
# # SCTP is a relatively new alternative to the TCP and UDP protocols, combining most characteristics of TCP and UDP, and also adding new features like multi-homing and multi-streaming. It is mostly being used for SS7/SIGTRAN related services but has the potential to be used for other applications as well. SCTP INIT scan is the SCTP equivalent of a TCP SYN scan. It can be performed quickly, scanning thousands of ports per second on a fast network not hampered by restrictive firewalls. Like SYN scan, INIT scan is relatively unobtrusive and stealthy, since it never completes SCTP associations.
# nmap –sY -vv target
#
# # TCP NULL, FIN, and Xmas scans
# # Sets the FIN, PSH, and URG flags, lighting the packet up like a Christmas tree.
#
# # TCP Window Scan
# # Window scan is exactly the same as ACK scan, except that it exploits an implementation detail of certain systems to differentiate open ports from closed ones, rather than always printing unfiltered when an RST is returned.
# nmap –sW -vv target
#
# # Using HTTP User Agent to get access to your router, host
# nmap -p80 –script http-brute –script-args userdb=/var/usernames.txt,passdb=/var/passwords.txt 192.168.1.1
# nmap –script http-brute –script-args brute.mode=user <target>
# nmap –script http-brute –script-args brute.mode=pass <target>
#
# # Testing for Default credentials:
# nmap -p80 –script http-default-accounts <target>
#
# # brute force wordpress
# nmap -p80 –script http-wordpress-brute <target>
# nmap -p80 –script http-wordpress-brute –script-args http-wordpressbrute threads=5 <target>
# nmap -p80 –script http-wordpress-brute –script-args http-wordpressbrute uri=”/hidden-wp-login.php” <target>
#
# # Detecting XST Vulnerabilities:
# nmap -p80 –script http-methods,http-trace –script-args http-methods.retest <target>
#
# # Detecting XSS Vulnerabilities:
# nmap -p80 –script http-unsafe-output-escaping <target>
#
#
# # Detecting SQL Injection:
# nmap -p80 –script http-sql-injection <target>
# nmap -p80 –script http-sql-injection –script-args httpspider.maxpagecount=200 <target>
# nmap -p80 –script http-sql-injection –script-args httpspider.withinhost=false <target>
#
#
# # ========== Ninja Pentester ==========================================
#
# # Database auditing
# # The bellow lists the database name in MySQL setup and only works if username and password are null.
# nmap -sV –script=mysql-databases 192.168.195.130
#
# # The bellow lists the database name in MySQL setup and only works if username "root" and password are toor.
# nmap -sV –script=mysql-databases –script-args mysqluser=root,mysqlpass=toor 192.168.195.130
#
# # It checks for MySQL servers with an empty password for root or anonymous.
# sudo nmap –script mysql-empty-password 192.168.195.130
#
# # Listing mysql server variables:
# nmap -p3306 –script mysql-variables localhost
#
# # Basically it checks the root and toor credentials
# nmap –script=mysql-brute localhost
#
# # Mysql info:
# # if the vulnerability results results in the "Exploiting CVE-2012-2122" click in the link bellow
# # http://www.cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2012-2122
# nmap –script=mysql-info localhost
#
#
#
# # Pen testing mail servers
