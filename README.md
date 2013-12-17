dirwall
=======

## ABOUT:

  I wrote this because I wanted to have the ability to have useful
iptables rules described in a concice and (hopefully) sane format.

  I separated the rules from the script logic to make it easier to
update the script without touching the actual rules.  This also
makes it easy for other packages to manage the rules.


## FAQ:

  dirwall is a linux iptables firewall script that stores the rules
seperate from the script logic.  The rule syntax is intended to be
simpler than the iptables commands they generate.


## CONFIG:

  Configuration settings are either stored in files in the
"/etc/dirwall/config/" dir, or generated via scripts in the
"/etc/dirwall/scripts/" dir.


## CONFIG FILES (in "/etc/dirwall/config/"):

  VERBOSE - boolean to enable verbose output

  DEBUG - boolean to enable debugging

  LOG - boolean to enable logging via syslog

  LOG_FLOOD - log flood limit

  LOG_LEVEL - syslog log level

  ALLOW_ICMP - icmp types to allow

  RPFILTER - boolean to enable rp_filter (required until interfaces supported)

  FORWARD - boolean to enable forwarding ("/proc/sys/net/ipv4/ip_forward")

  POLICY_FILTER_INPUT - filter chain input target default policy

  POLICY_FILTER_FORWARD - filter chain forward target default policy

  POLICY_FILTER_OUTPUT - filter chain output target default policy

  POLICY_NAT_PREROUTING - nat chain prerouting target default policy

  POLICY_NAT_POSTROUTING - nat chain postrouting target default policy

  POLICY_NAT_OUTPUT - nat chain output target default policy


(all config files are optional)


## CONFIG SCRIPTS (in "/etc/dirwall/scripts/"):

  dirwall-begin - for custom local commands to be run before the dirwall
                  script has done most of it's work

  dirwall-end - for custom local commands to be run after the dirwall
                script has done most of it's work

  iface-wan - custom local script that prints the local wan interface


## RULES:

  The dirwall rules are stored in rule files located in 
"/etc/dirwall/{ACCEPT,FORWARD,MASQ,NAT,NOLOG,REJECT}/*".

  There may be multiple rules per file, seperated by whitespaces.
Comments starting with a '#' are allowed anywhere in the rule files.

  The rule filenames are reserved for packages that have that name (i.e.
the "ssh" package has the right to manage the "/etc/dirwall/ACCEPT/ssh"
rule file).  Local rule files should begin with the word "local-" so
that they don't conflict.


## RULE SYNTAX:

  rule      = [ hostlist ] [ ">" hostlist ] [ "<" proto ] [ "=" extra ]

  hostlist  = [ host [ "," host [...] ] ] [ ":" portlist ]

  host      = [ [ ip [ "/" mask ] ]

  ip        = ( ipv4 dotted decimal address | dns host address )

  mask      = ( ipv4 dotted decimal bitmask | integer bitmask )

  portlist  = [ portrange [ "," portrange [...] ] ]

  portrange = [ port [ "-" port ] ]

  port      = ( ipv4 port integer )

  proto     = "tcp" | "udp" | "icmp" | "all" | ( other from /etc/protocols )

  extra     = [ host ]



## RULE EXAMPLES:

  * allow http access from anywhere:

      echo '>:80<tcp' > /etc/dirwall/ACCEPT/local-http

  * allow ssh access from lan:

      echo '10.0.0.0/24>:22<tcp' > /etc/dirwall/ACCEPT/local-ssh

  * allow dns access from anywhere:

      echo '>:53' > /etc/dirwall/ACCEPT/local-dns

  * enable logging:

      echo 1 > /etc/dirwall/config/LOG

  * don't log samba traffic:

      echo '>:135,137-139,443' > /etc/dirwall/NOLOG/local-samba

  * allow proxy access from 1.2.3.4:

      echo '1.2.3.4>:8080<tcp' > /etc/dirwall/ACCEPT/local-proxy

  * NAT all traffic from 5.6.7.8 to 10.0.0.2:

      echo '1.2.3.4>10.0.0.2:<all=10.0.0.1/24' > /etc/dirwall/NAT/local-lan-2

    (The "<all" is needed just so that it dosn't run the rule twice with
     the default protocol of "tcp,udp".  The "=10.0.0.1/24" should specify
     the local gateway IP/MASK so that IPs in the lan are able to access
     external IPs that are also NATed into the lan.)

(run `/etc/init.d/dirwall restart` after any changes)


## NOTES:

  * rule files can have multiple rules.
  * rule file names ending in '~' will be ignored.
  * rule file comments may begin anywhere with a '#'.
  * not all rules that can be represented by the rule syntax
    are considered to be valid iptables rules.
  * FORWARD rules use the 1st host:port for the initial destination,
    and the 2nd host:port for the final destination.
  * FORWARD rules just use the same port as the 1st port for the
    2nd port if the 2nd port is omitted.
  * FORWARD only works with tcp/udp
  * NAT rules may require the extra field to be set to the (local nics)
    gateway ip/mask ("10.0.0.1/24") so that int->ext->int works.


## TODO:

  * don't print chain name if rule files have no rules (i.e. commented out)
  * more robust handling of invalid rules
  * mangle table support?

