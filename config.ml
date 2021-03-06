open Mirage

let net =
  if_impl Key.is_unix
    (socket_stackv4 [Ipaddr.V4.any])
    (static_ipv4_stack ~arp:farp default_network)

let logger = syslog_udp ~config:(syslog_config ~truncate:1484 "retreat") net

let packages = [
  package ~sublibs:["lwt"] "logs" ;
  package "omd" ;
  package "tyxml" ;
]

let () =
  register "retreat" [
    foreign
      ~deps:[abstract logger]
      ~packages
      "Unikernel.Main"
      ( stackv4 @-> job )
    $ net
  ]
