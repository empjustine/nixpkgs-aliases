{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      apps.alejandra = { type = "app"; program = "${pkgs.alejandra}/bin/alejandra"; };
      packages.alejandra = pkgs.alejandra;
      apps.aria2c = { type = "app"; program = "${pkgs.aria}/bin/aria2c"; };
      packages.aria2c = pkgs.aria;
      apps.AtomicParsley = { type = "app"; program = "${pkgs.atomicparsley}/bin/AtomicParsley"; };
      packages.AtomicParsley = pkgs.atomicparsley;
      apps.atuin = { type = "app"; program = "${pkgs.atuin}/bin/atuin"; };
      packages.atuin = pkgs.atuin;
      apps.bindfs = { type = "app"; program = "${pkgs.bindfs}/bin/bindfs"; };
      packages.bindfs = pkgs.bindfs;
      apps."mount.fuse.bindfs" = { type = "app"; program = "${pkgs.bindfs}/bin/mount.fuse.bindfs"; };
      packages."mount.fuse.bindfs" = pkgs.bindfs;
      apps.bw = { type = "app"; program = "${pkgs.bitwarden-cli}/bin/bw"; };
      packages.bw = pkgs.bitwarden-cli;
      apps.black = { type = "app"; program = "${pkgs.black}/bin/black"; };
      packages.black = pkgs.black;
      apps.blackd = { type = "app"; program = "${pkgs.black}/bin/blackd"; };
      packages.blackd = pkgs.black;
      apps.borg = { type = "app"; program = "${pkgs.borgbackup}/bin/borg"; };
      packages.borg = pkgs.borgbackup;
      apps.borgfs = { type = "app"; program = "${pkgs.borgbackup}/bin/borgfs"; };
      packages.borgfs = pkgs.borgbackup;
      apps.btfs = { type = "app"; program = "${pkgs.btfs}/bin/btfs"; };
      packages.btfs = pkgs.btfs;
      apps.btfsstat = { type = "app"; program = "${pkgs.btfs}/bin/btfsstat"; };
      packages.btfsstat = pkgs.btfs;
      apps.btplay = { type = "app"; program = "${pkgs.btfs}/bin/btplay"; };
      packages.btplay = pkgs.btfs;
      apps.cntr = { type = "app"; program = "${pkgs.cntr}/bin/cntr"; };
      packages.cntr = pkgs.cntr;
      apps.deno = { type = "app"; program = "${pkgs.deno}/bin/deno"; };
      packages.deno = pkgs.deno;
      apps.dialog = { type = "app"; program = "${pkgs.dialog}/bin/dialog"; };
      packages.dialog = pkgs.dialog;
      apps.delv = { type = "app"; program = "${pkgs.dig}/bin/delv"; };
      packages.delv = pkgs.dig;
      apps.dig = { type = "app"; program = "${pkgs.dig}/bin/dig"; };
      packages.dig = pkgs.dig;
      apps.nslookup = { type = "app"; program = "${pkgs.dig}/bin/nslookup"; };
      packages.nslookup = pkgs.dig;
      apps.nsupdate = { type = "app"; program = "${pkgs.dig}/bin/nsupdate"; };
      packages.nsupdate = pkgs.dig;
      apps.dmtxquery = { type = "app"; program = "${pkgs.dmtx-utils}/bin/dmtxquery"; };
      packages.dmtxquery = pkgs.dmtx-utils;
      apps.dmtxread = { type = "app"; program = "${pkgs.dmtx-utils}/bin/dmtxread"; };
      packages.dmtxread = pkgs.dmtx-utils;
      apps.dmtxwrite = { type = "app"; program = "${pkgs.dmtx-utils}/bin/dmtxwrite"; };
      packages.dmtxwrite = pkgs.dmtx-utils;
      apps.docker = { type = "app"; program = "${pkgs.docker-client}/bin/docker"; };
      packages.docker = pkgs.docker-client;
      apps.docker-compose = { type = "app"; program = "${pkgs.docker-compose}/bin/docker-compose"; };
      packages.docker-compose = pkgs.docker-compose;
      apps.ffmpeg = { type = "app"; program = "${pkgs.ffmpeg_6-full}/bin/ffmpeg"; };
      packages.ffmpeg = pkgs.ffmpeg_6-full;
      apps.ffplay = { type = "app"; program = "${pkgs.ffmpeg_6-full}/bin/ffplay"; };
      packages.ffplay = pkgs.ffmpeg_6-full;
      apps.ffprobe = { type = "app"; program = "${pkgs.ffmpeg_6-full}/bin/ffprobe"; };
      packages.ffprobe = pkgs.ffmpeg_6-full;
      apps.qt-faststart = { type = "app"; program = "${pkgs.ffmpeg_6-full}/bin/qt-faststart"; };
      packages.qt-faststart = pkgs.ffmpeg_6-full;
      apps.gifdiff = { type = "app"; program = "${pkgs.gifsicle}/bin/gifdiff"; };
      packages.gifdiff = pkgs.gifsicle;
      apps.gifsicle = { type = "app"; program = "${pkgs.gifsicle}/bin/gifsicle"; };
      packages.gifsicle = pkgs.gifsicle;
      apps.git-lfs = { type = "app"; program = "${pkgs.git-lfs}/bin/git-lfs"; };
      packages.git-lfs = pkgs.git-lfs;
      apps.gitfs = { type = "app"; program = "${pkgs.gitfs}/bin/gitfs"; };
      packages.gitfs = pkgs.gitfs;
      apps.gitui = { type = "app"; program = "${pkgs.gitui}/bin/gitui"; };
      packages.gitui = pkgs.gitui;
      apps.gmic = { type = "app"; program = "${pkgs.gmic}/bin/gmic"; };
      packages.gmic = pkgs.gmic;
      apps.patch = { type = "app"; program = "${pkgs.gnupatch}/bin/patch"; };
      packages.patch = pkgs.gnupatch;
      apps.gu = { type = "app"; program = "${pkgs.graalvm-ce}/bin/gu"; };
      packages.gu = pkgs.graalvm-ce;
      apps.jar = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jar"; };
      packages.jar = pkgs.graalvm-ce;
      apps.jarsigner = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jarsigner"; };
      packages.jarsigner = pkgs.graalvm-ce;
      apps.java = { type = "app"; program = "${pkgs.graalvm-ce}/bin/java"; };
      packages.java = pkgs.graalvm-ce;
      apps.javac = { type = "app"; program = "${pkgs.graalvm-ce}/bin/javac"; };
      packages.javac = pkgs.graalvm-ce;
      apps.javadoc = { type = "app"; program = "${pkgs.graalvm-ce}/bin/javadoc"; };
      packages.javadoc = pkgs.graalvm-ce;
      apps.javap = { type = "app"; program = "${pkgs.graalvm-ce}/bin/javap"; };
      packages.javap = pkgs.graalvm-ce;
      apps.jcmd = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jcmd"; };
      packages.jcmd = pkgs.graalvm-ce;
      apps.jconsole = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jconsole"; };
      packages.jconsole = pkgs.graalvm-ce;
      apps.jdb = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jdb"; };
      packages.jdb = pkgs.graalvm-ce;
      apps.jdeprscan = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jdeprscan"; };
      packages.jdeprscan = pkgs.graalvm-ce;
      apps.jdeps = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jdeps"; };
      packages.jdeps = pkgs.graalvm-ce;
      apps.jfr = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jfr"; };
      packages.jfr = pkgs.graalvm-ce;
      apps.jhsdb = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jhsdb"; };
      packages.jhsdb = pkgs.graalvm-ce;
      apps.jimage = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jimage"; };
      packages.jimage = pkgs.graalvm-ce;
      apps.jinfo = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jinfo"; };
      packages.jinfo = pkgs.graalvm-ce;
      apps.jjs = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jjs"; };
      packages.jjs = pkgs.graalvm-ce;
      apps.jlink = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jlink"; };
      packages.jlink = pkgs.graalvm-ce;
      apps.jmap = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jmap"; };
      packages.jmap = pkgs.graalvm-ce;
      apps.jmod = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jmod"; };
      packages.jmod = pkgs.graalvm-ce;
      apps.jps = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jps"; };
      packages.jps = pkgs.graalvm-ce;
      apps.jrunscript = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jrunscript"; };
      packages.jrunscript = pkgs.graalvm-ce;
      apps.jshell = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jshell"; };
      packages.jshell = pkgs.graalvm-ce;
      apps.jstack = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jstack"; };
      packages.jstack = pkgs.graalvm-ce;
      apps.jstat = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jstat"; };
      packages.jstat = pkgs.graalvm-ce;
      apps.jstatd = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jstatd"; };
      packages.jstatd = pkgs.graalvm-ce;
      apps.keytool = { type = "app"; program = "${pkgs.graalvm-ce}/bin/keytool"; };
      packages.keytool = pkgs.graalvm-ce;
      apps.native-image = { type = "app"; program = "${pkgs.graalvm-ce}/bin/native-image"; };
      packages.native-image = pkgs.graalvm-ce;
      apps.native-image-configure = { type = "app"; program = "${pkgs.graalvm-ce}/bin/native-image-configure"; };
      packages.native-image-configure = pkgs.graalvm-ce;
      apps.pack200 = { type = "app"; program = "${pkgs.graalvm-ce}/bin/pack200"; };
      packages.pack200 = pkgs.graalvm-ce;
      apps.polyglot = { type = "app"; program = "${pkgs.graalvm-ce}/bin/polyglot"; };
      packages.polyglot = pkgs.graalvm-ce;
      apps.rebuild-images = { type = "app"; program = "${pkgs.graalvm-ce}/bin/rebuild-images"; };
      packages.rebuild-images = pkgs.graalvm-ce;
      apps.rmic = { type = "app"; program = "${pkgs.graalvm-ce}/bin/rmic"; };
      packages.rmic = pkgs.graalvm-ce;
      apps.rmid = { type = "app"; program = "${pkgs.graalvm-ce}/bin/rmid"; };
      packages.rmid = pkgs.graalvm-ce;
      apps.rmiregistry = { type = "app"; program = "${pkgs.graalvm-ce}/bin/rmiregistry"; };
      packages.rmiregistry = pkgs.graalvm-ce;
      apps.serialver = { type = "app"; program = "${pkgs.graalvm-ce}/bin/serialver"; };
      packages.serialver = pkgs.graalvm-ce;
      apps.unpack200 = { type = "app"; program = "${pkgs.graalvm-ce}/bin/unpack200"; };
      packages.unpack200 = pkgs.graalvm-ce;
      apps.acyclic = { type = "app"; program = "${pkgs.graphviz}/bin/acyclic"; };
      packages.acyclic = pkgs.graphviz;
      apps.bcomps = { type = "app"; program = "${pkgs.graphviz}/bin/bcomps"; };
      packages.bcomps = pkgs.graphviz;
      apps.ccomps = { type = "app"; program = "${pkgs.graphviz}/bin/ccomps"; };
      packages.ccomps = pkgs.graphviz;
      apps.circo = { type = "app"; program = "${pkgs.graphviz}/bin/circo"; };
      packages.circo = pkgs.graphviz;
      apps.cluster = { type = "app"; program = "${pkgs.graphviz}/bin/cluster"; };
      packages.cluster = pkgs.graphviz;
      apps.diffimg = { type = "app"; program = "${pkgs.graphviz}/bin/diffimg"; };
      packages.diffimg = pkgs.graphviz;
      apps.dijkstra = { type = "app"; program = "${pkgs.graphviz}/bin/dijkstra"; };
      packages.dijkstra = pkgs.graphviz;
      apps.dot = { type = "app"; program = "${pkgs.graphviz}/bin/dot"; };
      packages.dot = pkgs.graphviz;
      apps.dot2gxl = { type = "app"; program = "${pkgs.graphviz}/bin/dot2gxl"; };
      packages.dot2gxl = pkgs.graphviz;
      apps.dot_builtins = { type = "app"; program = "${pkgs.graphviz}/bin/dot_builtins"; };
      packages.dot_builtins = pkgs.graphviz;
      apps.edgepaint = { type = "app"; program = "${pkgs.graphviz}/bin/edgepaint"; };
      packages.edgepaint = pkgs.graphviz;
      apps.fdp = { type = "app"; program = "${pkgs.graphviz}/bin/fdp"; };
      packages.fdp = pkgs.graphviz;
      apps.gc = { type = "app"; program = "${pkgs.graphviz}/bin/gc"; };
      packages.gc = pkgs.graphviz;
      apps.gml2gv = { type = "app"; program = "${pkgs.graphviz}/bin/gml2gv"; };
      packages.gml2gv = pkgs.graphviz;
      apps.graphml2gv = { type = "app"; program = "${pkgs.graphviz}/bin/graphml2gv"; };
      packages.graphml2gv = pkgs.graphviz;
      apps.gv2gml = { type = "app"; program = "${pkgs.graphviz}/bin/gv2gml"; };
      packages.gv2gml = pkgs.graphviz;
      apps.gv2gxl = { type = "app"; program = "${pkgs.graphviz}/bin/gv2gxl"; };
      packages.gv2gxl = pkgs.graphviz;
      apps.gvcolor = { type = "app"; program = "${pkgs.graphviz}/bin/gvcolor"; };
      packages.gvcolor = pkgs.graphviz;
      apps.gvgen = { type = "app"; program = "${pkgs.graphviz}/bin/gvgen"; };
      packages.gvgen = pkgs.graphviz;
      apps.gvmap = { type = "app"; program = "${pkgs.graphviz}/bin/gvmap"; };
      packages.gvmap = pkgs.graphviz;
      apps."gvmap.sh" = { type = "app"; program = "${pkgs.graphviz}/bin/gvmap.sh"; };
      packages."gvmap.sh" = pkgs.graphviz;
      apps.gvpack = { type = "app"; program = "${pkgs.graphviz}/bin/gvpack"; };
      packages.gvpack = pkgs.graphviz;
      apps.gvpr = { type = "app"; program = "${pkgs.graphviz}/bin/gvpr"; };
      packages.gvpr = pkgs.graphviz;
      apps.gxl2dot = { type = "app"; program = "${pkgs.graphviz}/bin/gxl2dot"; };
      packages.gxl2dot = pkgs.graphviz;
      apps.gxl2gv = { type = "app"; program = "${pkgs.graphviz}/bin/gxl2gv"; };
      packages.gxl2gv = pkgs.graphviz;
      apps.mm2gv = { type = "app"; program = "${pkgs.graphviz}/bin/mm2gv"; };
      packages.mm2gv = pkgs.graphviz;
      apps.neato = { type = "app"; program = "${pkgs.graphviz}/bin/neato"; };
      packages.neato = pkgs.graphviz;
      apps.nop = { type = "app"; program = "${pkgs.graphviz}/bin/nop"; };
      packages.nop = pkgs.graphviz;
      apps.osage = { type = "app"; program = "${pkgs.graphviz}/bin/osage"; };
      packages.osage = pkgs.graphviz;
      apps.patchwork = { type = "app"; program = "${pkgs.graphviz}/bin/patchwork"; };
      packages.patchwork = pkgs.graphviz;
      apps.prune = { type = "app"; program = "${pkgs.graphviz}/bin/prune"; };
      packages.prune = pkgs.graphviz;
      apps.sccmap = { type = "app"; program = "${pkgs.graphviz}/bin/sccmap"; };
      packages.sccmap = pkgs.graphviz;
      apps.sfdp = { type = "app"; program = "${pkgs.graphviz}/bin/sfdp"; };
      packages.sfdp = pkgs.graphviz;
      apps.tred = { type = "app"; program = "${pkgs.graphviz}/bin/tred"; };
      packages.tred = pkgs.graphviz;
      apps.twopi = { type = "app"; program = "${pkgs.graphviz}/bin/twopi"; };
      packages.twopi = pkgs.graphviz;
      apps.unflatten = { type = "app"; program = "${pkgs.graphviz}/bin/unflatten"; };
      packages.unflatten = pkgs.graphviz;
      apps.vimdot = { type = "app"; program = "${pkgs.graphviz}/bin/vimdot"; };
      packages.vimdot = pkgs.graphviz;
      apps.dhall = { type = "app"; program = "${pkgs.haskellPackages.dhall}/bin/dhall"; };
      packages.dhall = pkgs.haskellPackages.dhall;
      apps.dhall-to-bash = { type = "app"; program = "${pkgs.haskellPackages.dhall-bash}/bin/dhall-to-bash"; };
      packages.dhall-to-bash = pkgs.haskellPackages.dhall-bash;
      apps.dhall-to-json = { type = "app"; program = "${pkgs.haskellPackages.dhall-json}/bin/dhall-to-json"; };
      packages.dhall-to-json = pkgs.haskellPackages.dhall-json;
      apps.dhall-to-yaml = { type = "app"; program = "${pkgs.haskellPackages.dhall-json}/bin/dhall-to-yaml"; };
      packages.dhall-to-yaml = pkgs.haskellPackages.dhall-json;
      apps.json-to-dhall = { type = "app"; program = "${pkgs.haskellPackages.dhall-json}/bin/json-to-dhall"; };
      packages.json-to-dhall = pkgs.haskellPackages.dhall-json;
      apps.kubectl = { type = "app"; program = "${pkgs.kubectl}/bin/kubectl"; };
      packages.kubectl = pkgs.kubectl;
      apps.bsdcat = { type = "app"; program = "${pkgs.libarchive}/bin/bsdcat"; };
      packages.bsdcat = pkgs.libarchive;
      apps.bsdcpio = { type = "app"; program = "${pkgs.libarchive}/bin/bsdcpio"; };
      packages.bsdcpio = pkgs.libarchive;
      apps.bsdtar = { type = "app"; program = "${pkgs.libarchive}/bin/bsdtar"; };
      packages.bsdtar = pkgs.libarchive;
      apps.benchmark_xl = { type = "app"; program = "${pkgs.libjxl}/bin/benchmark_xl"; };
      packages.benchmark_xl = pkgs.libjxl;
      apps.cjpeg_hdr = { type = "app"; program = "${pkgs.libjxl}/bin/cjpeg_hdr"; };
      packages.cjpeg_hdr = pkgs.libjxl;
      apps.cjxl = { type = "app"; program = "${pkgs.libjxl}/bin/cjxl"; };
      packages.cjxl = pkgs.libjxl;
      apps.djxl = { type = "app"; program = "${pkgs.libjxl}/bin/djxl"; };
      packages.djxl = pkgs.libjxl;
      apps.jxlinfo = { type = "app"; program = "${pkgs.libjxl}/bin/jxlinfo"; };
      packages.jxlinfo = pkgs.libjxl;
      apps.cwebp = { type = "app"; program = "${pkgs.libwebp}/bin/cwebp"; };
      packages.cwebp = pkgs.libwebp;
      apps.dwebp = { type = "app"; program = "${pkgs.libwebp}/bin/dwebp"; };
      packages.dwebp = pkgs.libwebp;
      apps.gif2webp = { type = "app"; program = "${pkgs.libwebp}/bin/gif2webp"; };
      packages.gif2webp = pkgs.libwebp;
      apps.img2webp = { type = "app"; program = "${pkgs.libwebp}/bin/img2webp"; };
      packages.img2webp = pkgs.libwebp;
      apps.webpinfo = { type = "app"; program = "${pkgs.libwebp}/bin/webpinfo"; };
      packages.webpinfo = pkgs.libwebp;
      apps.webpmux = { type = "app"; program = "${pkgs.libwebp}/bin/webpmux"; };
      packages.webpmux = pkgs.libwebp;
      apps.lnav = { type = "app"; program = "${pkgs.lnav}/bin/lnav"; };
      packages.lnav = pkgs.lnav;
      apps.lshw = { type = "app"; program = "${pkgs.lshw}/bin/lshw"; };
      packages.lshw = pkgs.lshw;
      apps.maturin = { type = "app"; program = "${pkgs.maturin}/bin/maturin"; };
      packages.maturin = pkgs.maturin;
      apps.external-ip = { type = "app"; program = "${pkgs.miniupnpc}/bin/external-ip"; };
      packages.external-ip = pkgs.miniupnpc;
      apps.upnpc = { type = "app"; program = "${pkgs.miniupnpc}/bin/upnpc"; };
      packages.upnpc = pkgs.miniupnpc;
      apps.mpvpaper = { type = "app"; program = "${pkgs.mpvpaper}/bin/mpvpaper"; };
      packages.mpvpaper = pkgs.mpvpaper;
      apps.mpvpaper-holder = { type = "app"; program = "${pkgs.mpvpaper}/bin/mpvpaper-holder"; };
      packages.mpvpaper-holder = pkgs.mpvpaper;
      apps.dmypy = { type = "app"; program = "${pkgs.mypy}/bin/dmypy"; };
      packages.dmypy = pkgs.mypy;
      apps.mypy = { type = "app"; program = "${pkgs.mypy}/bin/mypy"; };
      packages.mypy = pkgs.mypy;
      apps.mypyc = { type = "app"; program = "${pkgs.mypy}/bin/mypyc"; };
      packages.mypyc = pkgs.mypy;
      apps.stubgen = { type = "app"; program = "${pkgs.mypy}/bin/stubgen"; };
      packages.stubgen = pkgs.mypy;
      apps.stubtest = { type = "app"; program = "${pkgs.mypy}/bin/stubtest"; };
      packages.stubtest = pkgs.mypy;
      apps.ncdu = { type = "app"; program = "${pkgs.ncdu}/bin/ncdu"; };
      packages.ncdu = pkgs.ncdu;
      apps.NetworkManager = { type = "app"; program = "${pkgs.networkmanager}/bin/NetworkManager"; };
      packages.NetworkManager = pkgs.networkmanager;
      apps.nm-online = { type = "app"; program = "${pkgs.networkmanager}/bin/nm-online"; };
      packages.nm-online = pkgs.networkmanager;
      apps.nmcli = { type = "app"; program = "${pkgs.networkmanager}/bin/nmcli"; };
      packages.nmcli = pkgs.networkmanager;
      apps.nmtui = { type = "app"; program = "${pkgs.networkmanager}/bin/nmtui"; };
      packages.nmtui = pkgs.networkmanager;
      apps.nmtui-connect = { type = "app"; program = "${pkgs.networkmanager}/bin/nmtui-connect"; };
      packages.nmtui-connect = pkgs.networkmanager;
      apps.nmtui-edit = { type = "app"; program = "${pkgs.networkmanager}/bin/nmtui-edit"; };
      packages.nmtui-edit = pkgs.networkmanager;
      apps.nmtui-hostname = { type = "app"; program = "${pkgs.networkmanager}/bin/nmtui-hostname"; };
      packages.nmtui-hostname = pkgs.networkmanager;
      apps.nix-bundle = { type = "app"; program = "${pkgs.nix-bundle}/bin/nix-bundle"; };
      packages.nix-bundle = pkgs.nix-bundle;
      apps.nix-run = { type = "app"; program = "${pkgs.nix-bundle}/bin/nix-run"; };
      packages.nix-run = pkgs.nix-bundle;
      apps.nix-channel-index = { type = "app"; program = "${pkgs.nix-index}/bin/nix-channel-index"; };
      packages.nix-channel-index = pkgs.nix-index;
      apps.nix-index = { type = "app"; program = "${pkgs.nix-index}/bin/nix-index"; };
      packages.nix-index = pkgs.nix-index;
      apps.nix-locate = { type = "app"; program = "${pkgs.nix-index}/bin/nix-locate"; };
      packages.nix-locate = pkgs.nix-index;
      apps.nix-tree = { type = "app"; program = "${pkgs.nix-tree}/bin/nix-tree"; };
      packages.nix-tree = pkgs.nix-tree;
      apps.pyright = { type = "app"; program = "${pkgs.nodePackages.pyright}/bin/pyright"; };
      packages.pyright = pkgs.nodePackages.pyright;
      apps.pyright-langserver = { type = "app"; program = "${pkgs.nodePackages.pyright}/bin/pyright-langserver"; };
      packages.pyright-langserver = pkgs.nodePackages.pyright;
      apps.oathtool = { type = "app"; program = "${pkgs.oath-toolkit}/bin/oathtool"; };
      packages.oathtool = pkgs.oath-toolkit;
      apps.ldapadd = { type = "app"; program = "${pkgs.openldap}/bin/ldapadd"; };
      packages.ldapadd = pkgs.openldap;
      apps.ldapcompare = { type = "app"; program = "${pkgs.openldap}/bin/ldapcompare"; };
      packages.ldapcompare = pkgs.openldap;
      apps.ldapdelete = { type = "app"; program = "${pkgs.openldap}/bin/ldapdelete"; };
      packages.ldapdelete = pkgs.openldap;
      apps.ldapexop = { type = "app"; program = "${pkgs.openldap}/bin/ldapexop"; };
      packages.ldapexop = pkgs.openldap;
      apps.ldapmodify = { type = "app"; program = "${pkgs.openldap}/bin/ldapmodify"; };
      packages.ldapmodify = pkgs.openldap;
      apps.ldapmodrdn = { type = "app"; program = "${pkgs.openldap}/bin/ldapmodrdn"; };
      packages.ldapmodrdn = pkgs.openldap;
      apps.ldappasswd = { type = "app"; program = "${pkgs.openldap}/bin/ldappasswd"; };
      packages.ldappasswd = pkgs.openldap;
      apps.ldapsearch = { type = "app"; program = "${pkgs.openldap}/bin/ldapsearch"; };
      packages.ldapsearch = pkgs.openldap;
      apps.ldapurl = { type = "app"; program = "${pkgs.openldap}/bin/ldapurl"; };
      packages.ldapurl = pkgs.openldap;
      apps.ldapvc = { type = "app"; program = "${pkgs.openldap}/bin/ldapvc"; };
      packages.ldapvc = pkgs.openldap;
      apps.ldapwhoami = { type = "app"; program = "${pkgs.openldap}/bin/ldapwhoami"; };
      packages.ldapwhoami = pkgs.openldap;
      apps.slapacl = { type = "app"; program = "${pkgs.openldap}/bin/slapacl"; };
      packages.slapacl = pkgs.openldap;
      apps.slapadd = { type = "app"; program = "${pkgs.openldap}/bin/slapadd"; };
      packages.slapadd = pkgs.openldap;
      apps.slapauth = { type = "app"; program = "${pkgs.openldap}/bin/slapauth"; };
      packages.slapauth = pkgs.openldap;
      apps.slapcat = { type = "app"; program = "${pkgs.openldap}/bin/slapcat"; };
      packages.slapcat = pkgs.openldap;
      apps.slapdn = { type = "app"; program = "${pkgs.openldap}/bin/slapdn"; };
      packages.slapdn = pkgs.openldap;
      apps.slapindex = { type = "app"; program = "${pkgs.openldap}/bin/slapindex"; };
      packages.slapindex = pkgs.openldap;
      apps.slapmodify = { type = "app"; program = "${pkgs.openldap}/bin/slapmodify"; };
      packages.slapmodify = pkgs.openldap;
      apps.slappasswd = { type = "app"; program = "${pkgs.openldap}/bin/slappasswd"; };
      packages.slappasswd = pkgs.openldap;
      apps.slapschema = { type = "app"; program = "${pkgs.openldap}/bin/slapschema"; };
      packages.slapschema = pkgs.openldap;
      apps.slaptest = { type = "app"; program = "${pkgs.openldap}/bin/slaptest"; };
      packages.slaptest = pkgs.openldap;
      apps.c_rehash = { type = "app"; program = "${pkgs.openssl}/bin/c_rehash"; };
      packages.c_rehash = pkgs.openssl;
      apps.openssl = { type = "app"; program = "${pkgs.openssl}/bin/openssl"; };
      packages.openssl = pkgs.openssl;
      apps.overmind = { type = "app"; program = "${pkgs.overmind}/bin/overmind"; };
      packages.overmind = pkgs.overmind;
      apps.env_parallel = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel"; };
      packages.env_parallel = pkgs.parallel;
      apps."env_parallel.ash" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.ash"; };
      packages."env_parallel.ash" = pkgs.parallel;
      apps."env_parallel.bash" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.bash"; };
      packages."env_parallel.bash" = pkgs.parallel;
      apps."env_parallel.csh" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.csh"; };
      packages."env_parallel.csh" = pkgs.parallel;
      apps."env_parallel.dash" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.dash"; };
      packages."env_parallel.dash" = pkgs.parallel;
      apps."env_parallel.fish" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.fish"; };
      packages."env_parallel.fish" = pkgs.parallel;
      apps."env_parallel.ksh" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.ksh"; };
      packages."env_parallel.ksh" = pkgs.parallel;
      apps."env_parallel.mksh" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.mksh"; };
      packages."env_parallel.mksh" = pkgs.parallel;
      apps."env_parallel.pdksh" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.pdksh"; };
      packages."env_parallel.pdksh" = pkgs.parallel;
      apps."env_parallel.sh" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.sh"; };
      packages."env_parallel.sh" = pkgs.parallel;
      apps."env_parallel.tcsh" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.tcsh"; };
      packages."env_parallel.tcsh" = pkgs.parallel;
      apps."env_parallel.zsh" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.zsh"; };
      packages."env_parallel.zsh" = pkgs.parallel;
      apps.niceload = { type = "app"; program = "${pkgs.parallel}/bin/niceload"; };
      packages.niceload = pkgs.parallel;
      apps.parallel = { type = "app"; program = "${pkgs.parallel}/bin/parallel"; };
      packages.parallel = pkgs.parallel;
      apps.parcat = { type = "app"; program = "${pkgs.parallel}/bin/parcat"; };
      packages.parcat = pkgs.parallel;
      apps.parset = { type = "app"; program = "${pkgs.parallel}/bin/parset"; };
      packages.parset = pkgs.parallel;
      apps.parsort = { type = "app"; program = "${pkgs.parallel}/bin/parsort"; };
      packages.parsort = pkgs.parallel;
      apps.sem = { type = "app"; program = "${pkgs.parallel}/bin/sem"; };
      packages.sem = pkgs.parallel;
      apps.sql = { type = "app"; program = "${pkgs.parallel}/bin/sql"; };
      packages.sql = pkgs.parallel;
      apps.pipectl = { type = "app"; program = "${pkgs.pipectl}/bin/pipectl"; };
      packages.pipectl = pkgs.pipectl;
      apps.pipx = { type = "app"; program = "${pkgs.pipx}/bin/pipx"; };
      packages.pipx = pkgs.pipx;
      apps.playerctl = { type = "app"; program = "${pkgs.playerctl}/bin/playerctl"; };
      packages.playerctl = pkgs.playerctl;
      apps.playerctld = { type = "app"; program = "${pkgs.playerctl}/bin/playerctld"; };
      packages.playerctld = pkgs.playerctl;
      apps.pdfattach = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdfattach"; };
      packages.pdfattach = pkgs.poppler_utils;
      apps.pdfdetach = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdfdetach"; };
      packages.pdfdetach = pkgs.poppler_utils;
      apps.pdffonts = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdffonts"; };
      packages.pdffonts = pkgs.poppler_utils;
      apps.pdfimages = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdfimages"; };
      packages.pdfimages = pkgs.poppler_utils;
      apps.pdfinfo = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdfinfo"; };
      packages.pdfinfo = pkgs.poppler_utils;
      apps.pdfseparate = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdfseparate"; };
      packages.pdfseparate = pkgs.poppler_utils;
      apps.pdfsig = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdfsig"; };
      packages.pdfsig = pkgs.poppler_utils;
      apps.pdftocairo = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdftocairo"; };
      packages.pdftocairo = pkgs.poppler_utils;
      apps.pdftohtml = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdftohtml"; };
      packages.pdftohtml = pkgs.poppler_utils;
      apps.pdftoppm = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdftoppm"; };
      packages.pdftoppm = pkgs.poppler_utils;
      apps.pdftops = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdftops"; };
      packages.pdftops = pkgs.poppler_utils;
      apps.pdftotext = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdftotext"; };
      packages.pdftotext = pkgs.poppler_utils;
      apps.pdfunite = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdfunite"; };
      packages.pdfunite = pkgs.poppler_utils;
      apps.progress = { type = "app"; program = "${pkgs.progress}/bin/progress"; };
      packages.progress = pkgs.progress;
      apps.pv = { type = "app"; program = "${pkgs.pv}/bin/pv"; };
      packages.pv = pkgs.pv;
      apps.zfec = { type = "app"; program = "${pkgs.python311Packages.zfec}/bin/zfec"; };
      packages.zfec = pkgs.python311Packages.zfec;
      apps.zunfec = { type = "app"; program = "${pkgs.python311Packages.zfec}/bin/zunfec"; };
      packages.zunfec = pkgs.python311Packages.zfec;
      apps.rancher = { type = "app"; program = "${pkgs.rancher}/bin/rancher"; };
      packages.rancher = pkgs.rancher;
      apps.rclone = { type = "app"; program = "${pkgs.rclone}/bin/rclone"; };
      packages.rclone = pkgs.rclone;
      apps.rfc = { type = "app"; program = "${pkgs.rfc}/bin/rfc"; };
      packages.rfc = pkgs.rfc;
      apps.roc-conv = { type = "app"; program = "${pkgs.roc-toolkit}/bin/roc-conv"; };
      packages.roc-conv = pkgs.roc-toolkit;
      apps.roc-recv = { type = "app"; program = "${pkgs.roc-toolkit}/bin/roc-recv"; };
      packages.roc-recv = pkgs.roc-toolkit;
      apps.roc-send = { type = "app"; program = "${pkgs.roc-toolkit}/bin/roc-send"; };
      packages.roc-send = pkgs.roc-toolkit;
      apps.ruff = { type = "app"; program = "${pkgs.ruff}/bin/ruff"; };
      packages.ruff = pkgs.ruff;
      apps.shellcheck = { type = "app"; program = "${pkgs.shellcheck}/bin/shellcheck"; };
      packages.shellcheck = pkgs.shellcheck;
      apps.shellharden = { type = "app"; program = "${pkgs.shellharden}/bin/shellharden"; };
      packages.shellharden = pkgs.shellharden;
      apps.shfmt = { type = "app"; program = "${pkgs.shfmt}/bin/shfmt"; };
      packages.shfmt = pkgs.shfmt;
      apps.sqlar = { type = "app"; program = "${pkgs.sqlar}/bin/sqlar"; };
      packages.sqlar = pkgs.sqlar;
      apps.sqlarfs = { type = "app"; program = "${pkgs.sqlar}/bin/sqlarfs"; };
      packages.sqlarfs = pkgs.sqlar;
      apps.sqldiff = { type = "app"; program = "${pkgs.sqldiff}/bin/sqldiff"; };
      packages.sqldiff = pkgs.sqldiff;
      apps.sqlite3_analyzer = { type = "app"; program = "${pkgs.sqlite-analyzer}/bin/sqlite3_analyzer"; };
      packages.sqlite3_analyzer = pkgs.sqlite-analyzer;
      apps.sqlite3 = { type = "app"; program = "${pkgs.sqlite-interactive}/bin/sqlite3"; };
      packages.sqlite3 = pkgs.sqlite-interactive;
      apps.squashfuse = { type = "app"; program = "${pkgs.squashfuse}/bin/squashfuse"; };
      packages.squashfuse = pkgs.squashfuse;
      apps.squashfuse_ll = { type = "app"; program = "${pkgs.squashfuse}/bin/squashfuse_ll"; };
      packages.squashfuse_ll = pkgs.squashfuse;
      apps.syncthing = { type = "app"; program = "${pkgs.syncthing}/bin/syncthing"; };
      packages.syncthing = pkgs.syncthing;
      apps.cifsiostat = { type = "app"; program = "${pkgs.sysstat}/bin/cifsiostat"; };
      packages.cifsiostat = pkgs.sysstat;
      apps.iostat = { type = "app"; program = "${pkgs.sysstat}/bin/iostat"; };
      packages.iostat = pkgs.sysstat;
      apps.mpstat = { type = "app"; program = "${pkgs.sysstat}/bin/mpstat"; };
      packages.mpstat = pkgs.sysstat;
      apps.pidstat = { type = "app"; program = "${pkgs.sysstat}/bin/pidstat"; };
      packages.pidstat = pkgs.sysstat;
      apps.sadf = { type = "app"; program = "${pkgs.sysstat}/bin/sadf"; };
      packages.sadf = pkgs.sysstat;
      apps.sar = { type = "app"; program = "${pkgs.sysstat}/bin/sar"; };
      packages.sar = pkgs.sysstat;
      apps.tapestat = { type = "app"; program = "${pkgs.sysstat}/bin/tapestat"; };
      packages.tapestat = pkgs.sysstat;
      apps.ptiptop = { type = "app"; program = "${pkgs.tiptop}/bin/ptiptop"; };
      packages.ptiptop = pkgs.tiptop;
      apps.tiptop = { type = "app"; program = "${pkgs.tiptop}/bin/tiptop"; };
      packages.tiptop = pkgs.tiptop;
      apps.tmux = { type = "app"; program = "${pkgs.tmux}/bin/tmux"; };
      packages.tmux = pkgs.tmux;
      apps.transmission-cli = { type = "app"; program = "${pkgs.transmission}/bin/transmission-cli"; };
      packages.transmission-cli = pkgs.transmission;
      apps.transmission-create = { type = "app"; program = "${pkgs.transmission}/bin/transmission-create"; };
      packages.transmission-create = pkgs.transmission;
      apps.transmission-daemon = { type = "app"; program = "${pkgs.transmission}/bin/transmission-daemon"; };
      packages.transmission-daemon = pkgs.transmission;
      apps.transmission-edit = { type = "app"; program = "${pkgs.transmission}/bin/transmission-edit"; };
      packages.transmission-edit = pkgs.transmission;
      apps.transmission-remote = { type = "app"; program = "${pkgs.transmission}/bin/transmission-remote"; };
      packages.transmission-remote = pkgs.transmission;
      apps.transmission-show = { type = "app"; program = "${pkgs.transmission}/bin/transmission-show"; };
      packages.transmission-show = pkgs.transmission;
      apps.unpaper = { type = "app"; program = "${pkgs.unpaper}/bin/unpaper"; };
      packages.unpaper = pkgs.unpaper;
      apps.vips = { type = "app"; program = "${pkgs.vips}/bin/vips"; };
      packages.vips = pkgs.vips;
      apps.vipsedit = { type = "app"; program = "${pkgs.vips}/bin/vipsedit"; };
      packages.vipsedit = pkgs.vips;
      apps.vipsheader = { type = "app"; program = "${pkgs.vips}/bin/vipsheader"; };
      packages.vipsheader = pkgs.vips;
      apps.vipsprofile = { type = "app"; program = "${pkgs.vips}/bin/vipsprofile"; };
      packages.vipsprofile = pkgs.vips;
      apps.vipsthumbnail = { type = "app"; program = "${pkgs.vips}/bin/vipsthumbnail"; };
      packages.vipsthumbnail = pkgs.vips;
      apps.wayland-info = { type = "app"; program = "${pkgs.wayland-utils}/bin/wayland-info"; };
      packages.wayland-info = pkgs.wayland-utils;
      apps.waypipe = { type = "app"; program = "${pkgs.waypipe}/bin/waypipe"; };
      packages.waypipe = pkgs.waypipe;
      apps.wayvnc = { type = "app"; program = "${pkgs.wayvnc}/bin/wayvnc"; };
      packages.wayvnc = pkgs.wayvnc;
      apps.wayvncctl = { type = "app"; program = "${pkgs.wayvnc}/bin/wayvncctl"; };
      packages.wayvncctl = pkgs.wayvnc;
      apps.wdomirror = { type = "app"; program = "${pkgs.wdomirror}/bin/wdomirror"; };
      packages.wdomirror = pkgs.wdomirror;
      apps.wev = { type = "app"; program = "${pkgs.wev}/bin/wev"; };
      packages.wev = pkgs.wev;
      apps.wf-recorder = { type = "app"; program = "${pkgs.wf-recorder}/bin/wf-recorder"; };
      packages.wf-recorder = pkgs.wf-recorder;
      apps.wl-copy = { type = "app"; program = "${pkgs.wl-clipboard}/bin/wl-copy"; };
      packages.wl-copy = pkgs.wl-clipboard;
      apps.wl-paste = { type = "app"; program = "${pkgs.wl-clipboard}/bin/wl-paste"; };
      packages.wl-paste = pkgs.wl-clipboard;
      apps.wl-mirror = { type = "app"; program = "${pkgs.wl-mirror}/bin/wl-mirror"; };
      packages.wl-mirror = pkgs.wl-mirror;
      apps.wl-present = { type = "app"; program = "${pkgs.wl-mirror}/bin/wl-present"; };
      packages.wl-present = pkgs.wl-mirror;
      apps.wlrctl = { type = "app"; program = "${pkgs.wlrctl}/bin/wlrctl"; };
      packages.wlrctl = pkgs.wlrctl;
      apps.wmctrl = { type = "app"; program = "${pkgs.wmctrl}/bin/wmctrl"; };
      packages.wmctrl = pkgs.wmctrl;
      apps.wtype = { type = "app"; program = "${pkgs.wtype}/bin/wtype"; };
      packages.wtype = pkgs.wtype;
      apps.exo-desktop-item-edit = { type = "app"; program = "${pkgs.xfce.exo}/bin/exo-desktop-item-edit"; };
      packages.exo-desktop-item-edit = pkgs.xfce.exo;
      apps.exo-open = { type = "app"; program = "${pkgs.xfce.exo}/bin/exo-open"; };
      packages.exo-open = pkgs.xfce.exo;
      apps.gigolo = { type = "app"; program = "${pkgs.xfce.gigolo}/bin/gigolo"; };
      packages.gigolo = pkgs.xfce.gigolo;
      apps.koi8rxterm = { type = "app"; program = "${pkgs.xterm}/bin/koi8rxterm"; };
      packages.koi8rxterm = pkgs.xterm;
      apps.resize = { type = "app"; program = "${pkgs.xterm}/bin/resize"; };
      packages.resize = pkgs.xterm;
      apps.uxterm = { type = "app"; program = "${pkgs.xterm}/bin/uxterm"; };
      packages.uxterm = pkgs.xterm;
      apps.xterm = { type = "app"; program = "${pkgs.xterm}/bin/xterm"; };
      packages.xterm = pkgs.xterm;
      apps.zathura = { type = "app"; program = "${pkgs.zathura}/bin/zathura"; };
      packages.zathura = pkgs.zathura;
      apps.pzstd = { type = "app"; program = "${pkgs.zstd}/bin/pzstd"; };
      packages.pzstd = pkgs.zstd;
      apps.unzstd = { type = "app"; program = "${pkgs.zstd}/bin/unzstd"; };
      packages.unzstd = pkgs.zstd;
      apps.zstd = { type = "app"; program = "${pkgs.zstd}/bin/zstd"; };
      packages.zstd = pkgs.zstd;
      apps.zstdcat = { type = "app"; program = "${pkgs.zstd}/bin/zstdcat"; };
      packages.zstdcat = pkgs.zstd;
      apps.zstdgrep = { type = "app"; program = "${pkgs.zstd}/bin/zstdgrep"; };
      packages.zstdgrep = pkgs.zstd;
      apps.zstdless = { type = "app"; program = "${pkgs.zstd}/bin/zstdless"; };
      packages.zstdless = pkgs.zstd;
      apps.zstdmt = { type = "app"; program = "${pkgs.zstd}/bin/zstdmt"; };
      packages.zstdmt = pkgs.zstd;
      # package doesn't contain binaries, or binary name doesn't match package name
      packages.bash-preexec = pkgs.bash-preexec;
      # package doesn't contain binaries, or binary name doesn't match package name
      packages.wlroots = pkgs.wlroots;

      # special case for az
      apps.az = { type = "app"; program = "${pkgs.azure-cli}/bin/az"; };
      packages.az = pkgs.azure-cli;

      # special case for git-gui, from /libexec/git-core/git-gui
      apps.git-gui = { type = "app"; program = "${pkgs.gitFull}/libexec/git-core/git-gui"; };
      packages.git-gui = pkgs.gitFull;
    });
}
