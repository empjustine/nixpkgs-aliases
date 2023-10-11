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
      apps.aria2c = { type = "app"; program = "${pkgs.aria}/bin/aria2c"; };
      apps.AtomicParsley = { type = "app"; program = "${pkgs.atomicparsley}/bin/AtomicParsley"; };
      apps.atuin = { type = "app"; program = "${pkgs.atuin}/bin/atuin"; };
      apps.bindfs = { type = "app"; program = "${pkgs.bindfs}/bin/bindfs"; };
      apps."mount.fuse.bindfs" = { type = "app"; program = "${pkgs.bindfs}/bin/mount.fuse.bindfs"; };
      apps.black = { type = "app"; program = "${pkgs.black}/bin/black"; };
      apps.blackd = { type = "app"; program = "${pkgs.black}/bin/blackd"; };
      apps.borg = { type = "app"; program = "${pkgs.borgbackup}/bin/borg"; };
      apps.borgfs = { type = "app"; program = "${pkgs.borgbackup}/bin/borgfs"; };
      apps.cntr = { type = "app"; program = "${pkgs.cntr}/bin/cntr"; };
      apps.deno = { type = "app"; program = "${pkgs.deno}/bin/deno"; };
      apps.dialog = { type = "app"; program = "${pkgs.dialog}/bin/dialog"; };
      apps.delv = { type = "app"; program = "${pkgs.dig}/bin/delv"; };
      apps.dig = { type = "app"; program = "${pkgs.dig}/bin/dig"; };
      apps.nslookup = { type = "app"; program = "${pkgs.dig}/bin/nslookup"; };
      apps.nsupdate = { type = "app"; program = "${pkgs.dig}/bin/nsupdate"; };
      apps.dmtxquery = { type = "app"; program = "${pkgs.dmtx-utils}/bin/dmtxquery"; };
      apps.dmtxread = { type = "app"; program = "${pkgs.dmtx-utils}/bin/dmtxread"; };
      apps.dmtxwrite = { type = "app"; program = "${pkgs.dmtx-utils}/bin/dmtxwrite"; };
      apps.docker = { type = "app"; program = "${pkgs.docker-client}/bin/docker"; };
      apps.docker-compose = { type = "app"; program = "${pkgs.docker-compose}/bin/docker-compose"; };
      apps.ffmpeg = { type = "app"; program = "${pkgs.ffmpeg_6-full}/bin/ffmpeg"; };
      apps.ffplay = { type = "app"; program = "${pkgs.ffmpeg_6-full}/bin/ffplay"; };
      apps.ffprobe = { type = "app"; program = "${pkgs.ffmpeg_6-full}/bin/ffprobe"; };
      apps.qt-faststart = { type = "app"; program = "${pkgs.ffmpeg_6-full}/bin/qt-faststart"; };
      apps.gifdiff = { type = "app"; program = "${pkgs.gifsicle}/bin/gifdiff"; };
      apps.gifsicle = { type = "app"; program = "${pkgs.gifsicle}/bin/gifsicle"; };
      apps.git-lfs = { type = "app"; program = "${pkgs.git-lfs}/bin/git-lfs"; };
      apps.gitfs = { type = "app"; program = "${pkgs.gitfs}/bin/gitfs"; };
      apps.gitui = { type = "app"; program = "${pkgs.gitui}/bin/gitui"; };
      apps.patch = { type = "app"; program = "${pkgs.gnupatch}/bin/patch"; };
      apps.gu = { type = "app"; program = "${pkgs.graalvm-ce}/bin/gu"; };
      apps.jar = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jar"; };
      apps.jarsigner = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jarsigner"; };
      apps.java = { type = "app"; program = "${pkgs.graalvm-ce}/bin/java"; };
      apps.javac = { type = "app"; program = "${pkgs.graalvm-ce}/bin/javac"; };
      apps.javadoc = { type = "app"; program = "${pkgs.graalvm-ce}/bin/javadoc"; };
      apps.javap = { type = "app"; program = "${pkgs.graalvm-ce}/bin/javap"; };
      apps.jcmd = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jcmd"; };
      apps.jconsole = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jconsole"; };
      apps.jdb = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jdb"; };
      apps.jdeprscan = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jdeprscan"; };
      apps.jdeps = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jdeps"; };
      apps.jfr = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jfr"; };
      apps.jhsdb = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jhsdb"; };
      apps.jimage = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jimage"; };
      apps.jinfo = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jinfo"; };
      apps.jjs = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jjs"; };
      apps.jlink = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jlink"; };
      apps.jmap = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jmap"; };
      apps.jmod = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jmod"; };
      apps.jps = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jps"; };
      apps.jrunscript = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jrunscript"; };
      apps.jshell = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jshell"; };
      apps.jstack = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jstack"; };
      apps.jstat = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jstat"; };
      apps.jstatd = { type = "app"; program = "${pkgs.graalvm-ce}/bin/jstatd"; };
      apps.keytool = { type = "app"; program = "${pkgs.graalvm-ce}/bin/keytool"; };
      apps.native-image = { type = "app"; program = "${pkgs.graalvm-ce}/bin/native-image"; };
      apps.native-image-configure = { type = "app"; program = "${pkgs.graalvm-ce}/bin/native-image-configure"; };
      apps.pack200 = { type = "app"; program = "${pkgs.graalvm-ce}/bin/pack200"; };
      apps.polyglot = { type = "app"; program = "${pkgs.graalvm-ce}/bin/polyglot"; };
      apps.rebuild-images = { type = "app"; program = "${pkgs.graalvm-ce}/bin/rebuild-images"; };
      apps.rmic = { type = "app"; program = "${pkgs.graalvm-ce}/bin/rmic"; };
      apps.rmid = { type = "app"; program = "${pkgs.graalvm-ce}/bin/rmid"; };
      apps.rmiregistry = { type = "app"; program = "${pkgs.graalvm-ce}/bin/rmiregistry"; };
      apps.serialver = { type = "app"; program = "${pkgs.graalvm-ce}/bin/serialver"; };
      apps.unpack200 = { type = "app"; program = "${pkgs.graalvm-ce}/bin/unpack200"; };
      apps.acyclic = { type = "app"; program = "${pkgs.graphviz}/bin/acyclic"; };
      apps.bcomps = { type = "app"; program = "${pkgs.graphviz}/bin/bcomps"; };
      apps.ccomps = { type = "app"; program = "${pkgs.graphviz}/bin/ccomps"; };
      apps.circo = { type = "app"; program = "${pkgs.graphviz}/bin/circo"; };
      apps.cluster = { type = "app"; program = "${pkgs.graphviz}/bin/cluster"; };
      apps.diffimg = { type = "app"; program = "${pkgs.graphviz}/bin/diffimg"; };
      apps.dijkstra = { type = "app"; program = "${pkgs.graphviz}/bin/dijkstra"; };
      apps.dot = { type = "app"; program = "${pkgs.graphviz}/bin/dot"; };
      apps.dot2gxl = { type = "app"; program = "${pkgs.graphviz}/bin/dot2gxl"; };
      apps.dot_builtins = { type = "app"; program = "${pkgs.graphviz}/bin/dot_builtins"; };
      apps.edgepaint = { type = "app"; program = "${pkgs.graphviz}/bin/edgepaint"; };
      apps.fdp = { type = "app"; program = "${pkgs.graphviz}/bin/fdp"; };
      apps.gc = { type = "app"; program = "${pkgs.graphviz}/bin/gc"; };
      apps.gml2gv = { type = "app"; program = "${pkgs.graphviz}/bin/gml2gv"; };
      apps.graphml2gv = { type = "app"; program = "${pkgs.graphviz}/bin/graphml2gv"; };
      apps.gv2gml = { type = "app"; program = "${pkgs.graphviz}/bin/gv2gml"; };
      apps.gv2gxl = { type = "app"; program = "${pkgs.graphviz}/bin/gv2gxl"; };
      apps.gvcolor = { type = "app"; program = "${pkgs.graphviz}/bin/gvcolor"; };
      apps.gvgen = { type = "app"; program = "${pkgs.graphviz}/bin/gvgen"; };
      apps.gvmap = { type = "app"; program = "${pkgs.graphviz}/bin/gvmap"; };
      apps."gvmap.sh" = { type = "app"; program = "${pkgs.graphviz}/bin/gvmap.sh"; };
      apps.gvpack = { type = "app"; program = "${pkgs.graphviz}/bin/gvpack"; };
      apps.gvpr = { type = "app"; program = "${pkgs.graphviz}/bin/gvpr"; };
      apps.gxl2dot = { type = "app"; program = "${pkgs.graphviz}/bin/gxl2dot"; };
      apps.gxl2gv = { type = "app"; program = "${pkgs.graphviz}/bin/gxl2gv"; };
      apps.mm2gv = { type = "app"; program = "${pkgs.graphviz}/bin/mm2gv"; };
      apps.neato = { type = "app"; program = "${pkgs.graphviz}/bin/neato"; };
      apps.nop = { type = "app"; program = "${pkgs.graphviz}/bin/nop"; };
      apps.osage = { type = "app"; program = "${pkgs.graphviz}/bin/osage"; };
      apps.patchwork = { type = "app"; program = "${pkgs.graphviz}/bin/patchwork"; };
      apps.prune = { type = "app"; program = "${pkgs.graphviz}/bin/prune"; };
      apps.sccmap = { type = "app"; program = "${pkgs.graphviz}/bin/sccmap"; };
      apps.sfdp = { type = "app"; program = "${pkgs.graphviz}/bin/sfdp"; };
      apps.tred = { type = "app"; program = "${pkgs.graphviz}/bin/tred"; };
      apps.twopi = { type = "app"; program = "${pkgs.graphviz}/bin/twopi"; };
      apps.unflatten = { type = "app"; program = "${pkgs.graphviz}/bin/unflatten"; };
      apps.vimdot = { type = "app"; program = "${pkgs.graphviz}/bin/vimdot"; };
      apps.dhall = { type = "app"; program = "${pkgs.haskellPackages.dhall}/bin/dhall"; };
      apps.dhall-to-bash = { type = "app"; program = "${pkgs.haskellPackages.dhall-bash}/bin/dhall-to-bash"; };
      apps.dhall-to-json = { type = "app"; program = "${pkgs.haskellPackages.dhall-json}/bin/dhall-to-json"; };
      apps.dhall-to-yaml = { type = "app"; program = "${pkgs.haskellPackages.dhall-json}/bin/dhall-to-yaml"; };
      apps.json-to-dhall = { type = "app"; program = "${pkgs.haskellPackages.dhall-json}/bin/json-to-dhall"; };
      apps.kubectl = { type = "app"; program = "${pkgs.kubectl}/bin/kubectl"; };
      apps.bsdcat = { type = "app"; program = "${pkgs.libarchive}/bin/bsdcat"; };
      apps.bsdcpio = { type = "app"; program = "${pkgs.libarchive}/bin/bsdcpio"; };
      apps.bsdtar = { type = "app"; program = "${pkgs.libarchive}/bin/bsdtar"; };
      apps.benchmark_xl = { type = "app"; program = "${pkgs.libjxl}/bin/benchmark_xl"; };
      apps.cjpeg_hdr = { type = "app"; program = "${pkgs.libjxl}/bin/cjpeg_hdr"; };
      apps.cjxl = { type = "app"; program = "${pkgs.libjxl}/bin/cjxl"; };
      apps.djxl = { type = "app"; program = "${pkgs.libjxl}/bin/djxl"; };
      apps.jxlinfo = { type = "app"; program = "${pkgs.libjxl}/bin/jxlinfo"; };
      apps.av1encode = { type = "app"; program = "${pkgs.libva-utils}/bin/av1encode"; };
      apps.avcenc = { type = "app"; program = "${pkgs.libva-utils}/bin/avcenc"; };
      apps.avcstreamoutdemo = { type = "app"; program = "${pkgs.libva-utils}/bin/avcstreamoutdemo"; };
      apps.h264encode = { type = "app"; program = "${pkgs.libva-utils}/bin/h264encode"; };
      apps.hevcencode = { type = "app"; program = "${pkgs.libva-utils}/bin/hevcencode"; };
      apps.jpegenc = { type = "app"; program = "${pkgs.libva-utils}/bin/jpegenc"; };
      apps.loadjpeg = { type = "app"; program = "${pkgs.libva-utils}/bin/loadjpeg"; };
      apps.mpeg2vaenc = { type = "app"; program = "${pkgs.libva-utils}/bin/mpeg2vaenc"; };
      apps.mpeg2vldemo = { type = "app"; program = "${pkgs.libva-utils}/bin/mpeg2vldemo"; };
      apps.putsurface = { type = "app"; program = "${pkgs.libva-utils}/bin/putsurface"; };
      apps.putsurface_wayland = { type = "app"; program = "${pkgs.libva-utils}/bin/putsurface_wayland"; };
      apps.sfcsample = { type = "app"; program = "${pkgs.libva-utils}/bin/sfcsample"; };
      apps.vacopy = { type = "app"; program = "${pkgs.libva-utils}/bin/vacopy"; };
      apps.vainfo = { type = "app"; program = "${pkgs.libva-utils}/bin/vainfo"; };
      apps.vavpp = { type = "app"; program = "${pkgs.libva-utils}/bin/vavpp"; };
      apps.vp8enc = { type = "app"; program = "${pkgs.libva-utils}/bin/vp8enc"; };
      apps.vp9enc = { type = "app"; program = "${pkgs.libva-utils}/bin/vp9enc"; };
      apps.vpp3dlut = { type = "app"; program = "${pkgs.libva-utils}/bin/vpp3dlut"; };
      apps.vppblending = { type = "app"; program = "${pkgs.libva-utils}/bin/vppblending"; };
      apps.vppchromasitting = { type = "app"; program = "${pkgs.libva-utils}/bin/vppchromasitting"; };
      apps.vppdenoise = { type = "app"; program = "${pkgs.libva-utils}/bin/vppdenoise"; };
      apps.vpphdr_tm = { type = "app"; program = "${pkgs.libva-utils}/bin/vpphdr_tm"; };
      apps.vppscaling_csc = { type = "app"; program = "${pkgs.libva-utils}/bin/vppscaling_csc"; };
      apps.vppscaling_n_out_usrptr = { type = "app"; program = "${pkgs.libva-utils}/bin/vppscaling_n_out_usrptr"; };
      apps.vppsharpness = { type = "app"; program = "${pkgs.libva-utils}/bin/vppsharpness"; };
      apps.cwebp = { type = "app"; program = "${pkgs.libwebp}/bin/cwebp"; };
      apps.dwebp = { type = "app"; program = "${pkgs.libwebp}/bin/dwebp"; };
      apps.gif2webp = { type = "app"; program = "${pkgs.libwebp}/bin/gif2webp"; };
      apps.img2webp = { type = "app"; program = "${pkgs.libwebp}/bin/img2webp"; };
      apps.webpinfo = { type = "app"; program = "${pkgs.libwebp}/bin/webpinfo"; };
      apps.webpmux = { type = "app"; program = "${pkgs.libwebp}/bin/webpmux"; };
      apps.lnav = { type = "app"; program = "${pkgs.lnav}/bin/lnav"; };
      apps.lshw = { type = "app"; program = "${pkgs.lshw}/bin/lshw"; };
      apps.maturin = { type = "app"; program = "${pkgs.maturin}/bin/maturin"; };
      apps.external-ip = { type = "app"; program = "${pkgs.miniupnpc}/bin/external-ip"; };
      apps.upnpc = { type = "app"; program = "${pkgs.miniupnpc}/bin/upnpc"; };
      apps.mpvpaper = { type = "app"; program = "${pkgs.mpvpaper}/bin/mpvpaper"; };
      apps.mpvpaper-holder = { type = "app"; program = "${pkgs.mpvpaper}/bin/mpvpaper-holder"; };
      apps.dmypy = { type = "app"; program = "${pkgs.mypy}/bin/dmypy"; };
      apps.mypy = { type = "app"; program = "${pkgs.mypy}/bin/mypy"; };
      apps.mypyc = { type = "app"; program = "${pkgs.mypy}/bin/mypyc"; };
      apps.stubgen = { type = "app"; program = "${pkgs.mypy}/bin/stubgen"; };
      apps.stubtest = { type = "app"; program = "${pkgs.mypy}/bin/stubtest"; };
      apps.ncdu = { type = "app"; program = "${pkgs.ncdu}/bin/ncdu"; };
      apps.NetworkManager = { type = "app"; program = "${pkgs.networkmanager}/bin/NetworkManager"; };
      apps.nm-online = { type = "app"; program = "${pkgs.networkmanager}/bin/nm-online"; };
      apps.nmcli = { type = "app"; program = "${pkgs.networkmanager}/bin/nmcli"; };
      apps.nmtui = { type = "app"; program = "${pkgs.networkmanager}/bin/nmtui"; };
      apps.nmtui-connect = { type = "app"; program = "${pkgs.networkmanager}/bin/nmtui-connect"; };
      apps.nmtui-edit = { type = "app"; program = "${pkgs.networkmanager}/bin/nmtui-edit"; };
      apps.nmtui-hostname = { type = "app"; program = "${pkgs.networkmanager}/bin/nmtui-hostname"; };
      apps.nix-bundle = { type = "app"; program = "${pkgs.nix-bundle}/bin/nix-bundle"; };
      apps.nix-run = { type = "app"; program = "${pkgs.nix-bundle}/bin/nix-run"; };
      apps.nix-eval-jobs = { type = "app"; program = "${pkgs.nix-eval-jobs}/bin/nix-eval-jobs"; };
      apps.nix-channel-index = { type = "app"; program = "${pkgs.nix-index}/bin/nix-channel-index"; };
      apps.nix-index = { type = "app"; program = "${pkgs.nix-index}/bin/nix-index"; };
      apps.nix-locate = { type = "app"; program = "${pkgs.nix-index}/bin/nix-locate"; };
      apps.nix-tree = { type = "app"; program = "${pkgs.nix-tree}/bin/nix-tree"; };
      apps.oathtool = { type = "app"; program = "${pkgs.oath-toolkit}/bin/oathtool"; };
      apps.ldapadd = { type = "app"; program = "${pkgs.openldap}/bin/ldapadd"; };
      apps.ldapcompare = { type = "app"; program = "${pkgs.openldap}/bin/ldapcompare"; };
      apps.ldapdelete = { type = "app"; program = "${pkgs.openldap}/bin/ldapdelete"; };
      apps.ldapexop = { type = "app"; program = "${pkgs.openldap}/bin/ldapexop"; };
      apps.ldapmodify = { type = "app"; program = "${pkgs.openldap}/bin/ldapmodify"; };
      apps.ldapmodrdn = { type = "app"; program = "${pkgs.openldap}/bin/ldapmodrdn"; };
      apps.ldappasswd = { type = "app"; program = "${pkgs.openldap}/bin/ldappasswd"; };
      apps.ldapsearch = { type = "app"; program = "${pkgs.openldap}/bin/ldapsearch"; };
      apps.ldapurl = { type = "app"; program = "${pkgs.openldap}/bin/ldapurl"; };
      apps.ldapvc = { type = "app"; program = "${pkgs.openldap}/bin/ldapvc"; };
      apps.ldapwhoami = { type = "app"; program = "${pkgs.openldap}/bin/ldapwhoami"; };
      apps.slapacl = { type = "app"; program = "${pkgs.openldap}/bin/slapacl"; };
      apps.slapadd = { type = "app"; program = "${pkgs.openldap}/bin/slapadd"; };
      apps.slapauth = { type = "app"; program = "${pkgs.openldap}/bin/slapauth"; };
      apps.slapcat = { type = "app"; program = "${pkgs.openldap}/bin/slapcat"; };
      apps.slapdn = { type = "app"; program = "${pkgs.openldap}/bin/slapdn"; };
      apps.slapindex = { type = "app"; program = "${pkgs.openldap}/bin/slapindex"; };
      apps.slapmodify = { type = "app"; program = "${pkgs.openldap}/bin/slapmodify"; };
      apps.slappasswd = { type = "app"; program = "${pkgs.openldap}/bin/slappasswd"; };
      apps.slapschema = { type = "app"; program = "${pkgs.openldap}/bin/slapschema"; };
      apps.slaptest = { type = "app"; program = "${pkgs.openldap}/bin/slaptest"; };
      apps.c_rehash = { type = "app"; program = "${pkgs.openssl}/bin/c_rehash"; };
      apps.openssl = { type = "app"; program = "${pkgs.openssl}/bin/openssl"; };
      apps.overmind = { type = "app"; program = "${pkgs.overmind}/bin/overmind"; };
      apps.env_parallel = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel"; };
      apps."env_parallel.ash" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.ash"; };
      apps."env_parallel.bash" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.bash"; };
      apps."env_parallel.csh" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.csh"; };
      apps."env_parallel.dash" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.dash"; };
      apps."env_parallel.fish" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.fish"; };
      apps."env_parallel.ksh" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.ksh"; };
      apps."env_parallel.mksh" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.mksh"; };
      apps."env_parallel.pdksh" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.pdksh"; };
      apps."env_parallel.sh" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.sh"; };
      apps."env_parallel.tcsh" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.tcsh"; };
      apps."env_parallel.zsh" = { type = "app"; program = "${pkgs.parallel}/bin/env_parallel.zsh"; };
      apps.niceload = { type = "app"; program = "${pkgs.parallel}/bin/niceload"; };
      apps.parallel = { type = "app"; program = "${pkgs.parallel}/bin/parallel"; };
      apps.parcat = { type = "app"; program = "${pkgs.parallel}/bin/parcat"; };
      apps.parset = { type = "app"; program = "${pkgs.parallel}/bin/parset"; };
      apps.parsort = { type = "app"; program = "${pkgs.parallel}/bin/parsort"; };
      apps.sem = { type = "app"; program = "${pkgs.parallel}/bin/sem"; };
      apps.sql = { type = "app"; program = "${pkgs.parallel}/bin/sql"; };
      apps.pipectl = { type = "app"; program = "${pkgs.pipectl}/bin/pipectl"; };
      apps.pipx = { type = "app"; program = "${pkgs.pipx}/bin/pipx"; };
      apps.playerctl = { type = "app"; program = "${pkgs.playerctl}/bin/playerctl"; };
      apps.playerctld = { type = "app"; program = "${pkgs.playerctl}/bin/playerctld"; };
      apps.pdfattach = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdfattach"; };
      apps.pdfdetach = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdfdetach"; };
      apps.pdffonts = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdffonts"; };
      apps.pdfimages = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdfimages"; };
      apps.pdfinfo = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdfinfo"; };
      apps.pdfseparate = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdfseparate"; };
      apps.pdfsig = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdfsig"; };
      apps.pdftocairo = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdftocairo"; };
      apps.pdftohtml = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdftohtml"; };
      apps.pdftoppm = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdftoppm"; };
      apps.pdftops = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdftops"; };
      apps.pdftotext = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdftotext"; };
      apps.pdfunite = { type = "app"; program = "${pkgs.poppler_utils}/bin/pdfunite"; };
      apps.progress = { type = "app"; program = "${pkgs.progress}/bin/progress"; };
      apps.pv = { type = "app"; program = "${pkgs.pv}/bin/pv"; };
      apps.zfec = { type = "app"; program = "${pkgs.python311Packages.zfec}/bin/zfec"; };
      apps.zunfec = { type = "app"; program = "${pkgs.python311Packages.zfec}/bin/zunfec"; };
      apps.rancher = { type = "app"; program = "${pkgs.rancher}/bin/rancher"; };
      apps.rclone = { type = "app"; program = "${pkgs.rclone}/bin/rclone"; };
      apps.rfc = { type = "app"; program = "${pkgs.rfc}/bin/rfc"; };
      apps.roc-conv = { type = "app"; program = "${pkgs.roc-toolkit}/bin/roc-conv"; };
      apps.roc-recv = { type = "app"; program = "${pkgs.roc-toolkit}/bin/roc-recv"; };
      apps.roc-send = { type = "app"; program = "${pkgs.roc-toolkit}/bin/roc-send"; };
      apps.ruff = { type = "app"; program = "${pkgs.ruff}/bin/ruff"; };
      apps.shellcheck = { type = "app"; program = "${pkgs.shellcheck}/bin/shellcheck"; };
      apps.shellharden = { type = "app"; program = "${pkgs.shellharden}/bin/shellharden"; };
      apps.shfmt = { type = "app"; program = "${pkgs.shfmt}/bin/shfmt"; };
      apps.sqlar = { type = "app"; program = "${pkgs.sqlar}/bin/sqlar"; };
      apps.sqlarfs = { type = "app"; program = "${pkgs.sqlar}/bin/sqlarfs"; };
      apps.sqldiff = { type = "app"; program = "${pkgs.sqldiff}/bin/sqldiff"; };
      apps.sqlite3_analyzer = { type = "app"; program = "${pkgs.sqlite-analyzer}/bin/sqlite3_analyzer"; };
      apps.sqlite3 = { type = "app"; program = "${pkgs.sqlite-interactive}/bin/sqlite3"; };
      apps.squashfuse = { type = "app"; program = "${pkgs.squashfuse}/bin/squashfuse"; };
      apps.squashfuse_ll = { type = "app"; program = "${pkgs.squashfuse}/bin/squashfuse_ll"; };
      apps.syncthing = { type = "app"; program = "${pkgs.syncthing}/bin/syncthing"; };
      apps.cifsiostat = { type = "app"; program = "${pkgs.sysstat}/bin/cifsiostat"; };
      apps.iostat = { type = "app"; program = "${pkgs.sysstat}/bin/iostat"; };
      apps.mpstat = { type = "app"; program = "${pkgs.sysstat}/bin/mpstat"; };
      apps.pidstat = { type = "app"; program = "${pkgs.sysstat}/bin/pidstat"; };
      apps.sadf = { type = "app"; program = "${pkgs.sysstat}/bin/sadf"; };
      apps.sar = { type = "app"; program = "${pkgs.sysstat}/bin/sar"; };
      apps.tapestat = { type = "app"; program = "${pkgs.sysstat}/bin/tapestat"; };
      apps.tmux = { type = "app"; program = "${pkgs.tmux}/bin/tmux"; };
      apps.transmission-cli = { type = "app"; program = "${pkgs.transmission}/bin/transmission-cli"; };
      apps.transmission-create = { type = "app"; program = "${pkgs.transmission}/bin/transmission-create"; };
      apps.transmission-daemon = { type = "app"; program = "${pkgs.transmission}/bin/transmission-daemon"; };
      apps.transmission-edit = { type = "app"; program = "${pkgs.transmission}/bin/transmission-edit"; };
      apps.transmission-remote = { type = "app"; program = "${pkgs.transmission}/bin/transmission-remote"; };
      apps.transmission-show = { type = "app"; program = "${pkgs.transmission}/bin/transmission-show"; };
      apps.unpaper = { type = "app"; program = "${pkgs.unpaper}/bin/unpaper"; };
      apps.vips = { type = "app"; program = "${pkgs.vips}/bin/vips"; };
      apps.vipsedit = { type = "app"; program = "${pkgs.vips}/bin/vipsedit"; };
      apps.vipsheader = { type = "app"; program = "${pkgs.vips}/bin/vipsheader"; };
      apps.vipsprofile = { type = "app"; program = "${pkgs.vips}/bin/vipsprofile"; };
      apps.vipsthumbnail = { type = "app"; program = "${pkgs.vips}/bin/vipsthumbnail"; };
      apps.wayland-info = { type = "app"; program = "${pkgs.wayland-utils}/bin/wayland-info"; };
      apps.waypipe = { type = "app"; program = "${pkgs.waypipe}/bin/waypipe"; };
      apps.wayvnc = { type = "app"; program = "${pkgs.wayvnc}/bin/wayvnc"; };
      apps.wayvncctl = { type = "app"; program = "${pkgs.wayvnc}/bin/wayvncctl"; };
      apps.wdomirror = { type = "app"; program = "${pkgs.wdomirror}/bin/wdomirror"; };
      apps.wev = { type = "app"; program = "${pkgs.wev}/bin/wev"; };
      apps.wf-recorder = { type = "app"; program = "${pkgs.wf-recorder}/bin/wf-recorder"; };
      apps.wl-copy = { type = "app"; program = "${pkgs.wl-clipboard}/bin/wl-copy"; };
      apps.wl-paste = { type = "app"; program = "${pkgs.wl-clipboard}/bin/wl-paste"; };
      apps.wl-mirror = { type = "app"; program = "${pkgs.wl-mirror}/bin/wl-mirror"; };
      apps.wl-present = { type = "app"; program = "${pkgs.wl-mirror}/bin/wl-present"; };
      apps.wlrctl = { type = "app"; program = "${pkgs.wlrctl}/bin/wlrctl"; };
      apps.wmctrl = { type = "app"; program = "${pkgs.wmctrl}/bin/wmctrl"; };
      apps.wtype = { type = "app"; program = "${pkgs.wtype}/bin/wtype"; };
      apps.exo-desktop-item-edit = { type = "app"; program = "${pkgs.xfce.exo}/bin/exo-desktop-item-edit"; };
      apps.exo-open = { type = "app"; program = "${pkgs.xfce.exo}/bin/exo-open"; };
      apps.gigolo = { type = "app"; program = "${pkgs.xfce.gigolo}/bin/gigolo"; };
      apps.xrandr = { type = "app"; program = "${pkgs.xorg.xrandr}/bin/xrandr"; };
      apps.koi8rxterm = { type = "app"; program = "${pkgs.xterm}/bin/koi8rxterm"; };
      apps.resize = { type = "app"; program = "${pkgs.xterm}/bin/resize"; };
      apps.uxterm = { type = "app"; program = "${pkgs.xterm}/bin/uxterm"; };
      apps.xterm = { type = "app"; program = "${pkgs.xterm}/bin/xterm"; };
      apps.zathura = { type = "app"; program = "${pkgs.zathura}/bin/zathura"; };
      apps.pzstd = { type = "app"; program = "${pkgs.zstd}/bin/pzstd"; };
      apps.unzstd = { type = "app"; program = "${pkgs.zstd}/bin/unzstd"; };
      apps.zstd = { type = "app"; program = "${pkgs.zstd}/bin/zstd"; };
      apps.zstdcat = { type = "app"; program = "${pkgs.zstd}/bin/zstdcat"; };
      apps.zstdgrep = { type = "app"; program = "${pkgs.zstd}/bin/zstdgrep"; };
      apps.zstdless = { type = "app"; program = "${pkgs.zstd}/bin/zstdless"; };
      apps.zstdmt = { type = "app"; program = "${pkgs.zstd}/bin/zstdmt"; };
      packages.Fabric = pkgs.Fabric;
      packages.alejandra = pkgs.alejandra;
      packages.amdgpu_top = pkgs.amdgpu_top;
      packages.aria = pkgs.aria;
      packages.atomicparsley = pkgs.atomicparsley;
      packages.attr = pkgs.attr;
      packages.atuin = pkgs.atuin;
      packages.avfs = pkgs.avfs;
      packages.azure-cli = pkgs.azure-cli;
      packages.bash-preexec = pkgs.bash-preexec;
      packages.bashate = pkgs.bashate;
      packages.bcc = pkgs.bcc;
      packages.bchunk = pkgs.bchunk;
      packages.bindfs = pkgs.bindfs;
      packages.bitwarden-cli = pkgs.bitwarden-cli;
      packages.black = pkgs.black;
      packages.borgbackup = pkgs.borgbackup;
      packages.brightnessctl = pkgs.brightnessctl;
      packages.bsdiff = pkgs.bsdiff;
      packages.btfs = pkgs.btfs;
      packages.btop = pkgs.btop;
      packages.cdesktopenv = pkgs.cdesktopenv;
      packages.chars = pkgs.chars;
      packages.cicero-tui = pkgs.cicero-tui;
      packages.cntr = pkgs.cntr;
      packages.cool-retro-term = pkgs.cool-retro-term;
      packages.csvs-to-sqlite = pkgs.csvs-to-sqlite;
      packages.czkawka = pkgs.czkawka;
      packages.dar = pkgs.dar;
      packages.dbeaver = pkgs.dbeaver;
      packages.ddcutil = pkgs.ddcutil;
      packages.deno = pkgs.deno;
      packages.dialog = pkgs.dialog;
      packages.dig = pkgs.dig;
      packages.dive = pkgs.dive;
      packages.dmtx-utils = pkgs.dmtx-utils;
      packages.docker-buildx = pkgs.docker-buildx;
      packages.docker-client = pkgs.docker-client;
      packages.docker-compose = pkgs.docker-compose;
      packages.envfs = pkgs.envfs;
      packages.ffmpeg-headless = pkgs.ffmpeg-headless;
      packages.ffmpeg_6-full = pkgs.ffmpeg_6-full;
      packages.ffmpeg_6-headless = pkgs.ffmpeg_6-headless;
      packages.fnott = pkgs.fnott;
      packages.fossil = pkgs.fossil;
      packages.fribidi = pkgs.fribidi;
      packages.fuseiso = pkgs.fuseiso;
      packages.gamescope = pkgs.gamescope;
      packages.gifsicle = pkgs.gifsicle;
      packages.git-filter-repo = pkgs.git-filter-repo;
      packages.git-lfs = pkgs.git-lfs;
      packages.gitFull = pkgs.gitFull;
      packages.gitfs = pkgs.gitfs;
      packages.gitui = pkgs.gitui;
      packages.gmic = pkgs.gmic;
      packages."gnome.file-roller" = pkgs.gnome.file-roller;
      packages."gnome.gvfs" = pkgs.gnome.gvfs;
      packages."gnome.zenity" = pkgs.gnome.zenity;
      packages.gnupatch = pkgs.gnupatch;
      packages.graalvm-ce = pkgs.graalvm-ce;
      packages.graphviz = pkgs.graphviz;
      packages.gvfs = pkgs.gvfs;
      packages."haskellPackages.dhall" = pkgs.haskellPackages.dhall;
      packages."haskellPackages.dhall-bash" = pkgs.haskellPackages.dhall-bash;
      packages."haskellPackages.dhall-json" = pkgs.haskellPackages.dhall-json;
      packages.helvum = pkgs.helvum;
      packages.hivemind = pkgs.hivemind;
      packages.hocr-tools = pkgs.hocr-tools;
      packages.honcho = pkgs.honcho;
      packages.htop = pkgs.htop;
      packages.hwinfo = pkgs.hwinfo;
      packages.hwloc = pkgs.hwloc;
      packages.icoutils = pkgs.icoutils;
      packages.iotop = pkgs.iotop;
      packages.isolate = pkgs.isolate;
      packages.kanshi = pkgs.kanshi;
      packages.kio-fuse = pkgs.kio-fuse;
      packages.krb5 = pkgs.krb5;
      packages.kubectl = pkgs.kubectl;
      packages.kubectl-tree = pkgs.kubectl-tree;
      packages.leptonica = pkgs.leptonica;
      packages.libaom = pkgs.libaom;
      packages.libarchive = pkgs.libarchive;
      packages.libavif = pkgs.libavif;
      packages.libjxl = pkgs.libjxl;
      packages."libsForQt5.ark" = pkgs.libsForQt5.ark;
      packages."libsForQt5.kdeconnect-kde" = pkgs.libsForQt5.kdeconnect-kde;
      packages."libsForQt5.qtstyleplugin-kvantum" = pkgs.libsForQt5.qtstyleplugin-kvantum;
      packages.libuchardet = pkgs.libuchardet;
      packages.libva-utils = pkgs.libva-utils;
      packages.libwebp = pkgs.libwebp;
      packages.light = pkgs.light;
      packages.lnav = pkgs.lnav;
      packages.lshw = pkgs.lshw;
      packages.lurk = pkgs.lurk;
      packages.maturin = pkgs.maturin;
      packages.mimalloc = pkgs.mimalloc;
      packages.minify = pkgs.minify;
      packages.minijail = pkgs.minijail;
      packages.miniupnpc = pkgs.miniupnpc;
      packages.mosh = pkgs.mosh;
      packages.motif = pkgs.motif;
      packages.mpvpaper = pkgs.mpvpaper;
      packages.mypy = pkgs.mypy;
      packages.ncdu = pkgs.ncdu;
      packages.ncpamixer = pkgs.ncpamixer;
      packages.nethogs = pkgs.nethogs;
      packages.networkmanager = pkgs.networkmanager;
      packages.newt = pkgs.newt;
      packages.nip2 = pkgs.nip2;
      packages.nix-bundle = pkgs.nix-bundle;
      packages.nix-eval-jobs = pkgs.nix-eval-jobs;
      packages.nix-index = pkgs.nix-index;
      packages.nix-tree = pkgs.nix-tree;
      packages.nixStatic = pkgs.nixStatic;
      packages.nixos-rebuild = pkgs.nixos-rebuild;
      packages."nodePackages.bash-language-server" = pkgs.nodePackages.bash-language-server;
      packages."nodePackages.eslint" = pkgs.nodePackages.eslint;
      packages."nodePackages.eslint_d" = pkgs.nodePackages.eslint_d;
      packages."nodePackages.prettier" = pkgs.nodePackages.prettier;
      packages."nodePackages.prettier_d_slim" = pkgs.nodePackages.prettier_d_slim;
      packages."nodePackages.pyright" = pkgs.nodePackages.pyright;
      packages."nodePackages.typescript-language-server" = pkgs.nodePackages.typescript-language-server;
      packages."nodePackages.vscode-langservers-extracted" = pkgs.nodePackages.vscode-langservers-extracted;
      packages.numactl = pkgs.numactl;
      packages.oath-toolkit = pkgs.oath-toolkit;
      packages.openal = pkgs.openal;
      packages.openldap = pkgs.openldap;
      packages.openssl = pkgs.openssl;
      packages.overmind = pkgs.overmind;
      packages.par2cmdline = pkgs.par2cmdline;
      packages.parallel = pkgs.parallel;
      packages.pavucontrol = pkgs.pavucontrol;
      packages.pdfgrep = pkgs.pdfgrep;
      packages.perf-tools = pkgs.perf-tools;
      packages.pikchr = pkgs.pikchr;
      packages.pipectl = pkgs.pipectl;
      packages.pipx = pkgs.pipx;
      packages.plantuml-c4 = pkgs.plantuml-c4;
      packages.playerctl = pkgs.playerctl;
      packages.podman-compose = pkgs.podman-compose;
      packages.poppler_utils = pkgs.poppler_utils;
      packages.procodile = pkgs.procodile;
      packages.profile-cleaner = pkgs.profile-cleaner;
      packages.progress = pkgs.progress;
      packages.proxychains-ng = pkgs.proxychains-ng;
      packages.pulseaudio-ctl = pkgs.pulseaudio-ctl;
      packages.pv = pkgs.pv;
      packages."python311Packages.chardet" = pkgs.python311Packages.chardet;
      packages."python311Packages.ftfy" = pkgs.python311Packages.ftfy;
      packages."python311Packages.paramiko" = pkgs.python311Packages.paramiko;
      packages."python311Packages.pyupgrade" = pkgs.python311Packages.pyupgrade;
      packages."python311Packages.xattr" = pkgs.python311Packages.xattr;
      packages."python311Packages.zfec" = pkgs.python311Packages.zfec;
      packages.radeontop = pkgs.radeontop;
      packages.rancher = pkgs.rancher;
      packages.rclone = pkgs.rclone;
      packages.rewritefs = pkgs.rewritefs;
      packages.rfc = pkgs.rfc;
      packages.roc-toolkit = pkgs.roc-toolkit;
      packages.rocm-smi = pkgs.rocm-smi;
      packages.ruff = pkgs.ruff;
      packages.runit = pkgs.runit;
      packages.selinux-python = pkgs.selinux-python;
      packages.selinux-sandbox = pkgs.selinux-sandbox;
      packages.setools = pkgs.setools;
      packages.shellcheck = pkgs.shellcheck;
      packages.shellharden = pkgs.shellharden;
      packages.shfmt = pkgs.shfmt;
      packages.sipcalc = pkgs.sipcalc;
      packages.sommelier = pkgs.sommelier;
      packages.speechd = pkgs.speechd;
      packages.sqlar = pkgs.sqlar;
      packages.sqldiff = pkgs.sqldiff;
      packages.sqlite-analyzer = pkgs.sqlite-analyzer;
      packages.sqlite-interactive = pkgs.sqlite-interactive;
      packages.sqlite-utils = pkgs.sqlite-utils;
      packages.squashfuse = pkgs.squashfuse;
      packages.strace = pkgs.strace;
      packages.stun = pkgs.stun;
      packages.syncthing = pkgs.syncthing;
      packages.sysstat = pkgs.sysstat;
      packages.temurin-bin-17 = pkgs.temurin-bin-17;
      packages.tesseract = pkgs.tesseract;
      packages.tiptop = pkgs.tiptop;
      packages.tmux = pkgs.tmux;
      packages.transmission = pkgs.transmission;
      packages.uni = pkgs.uni;
      packages.unpaper = pkgs.unpaper;
      packages.upnp-router-control = pkgs.upnp-router-control;
      packages.usbtop = pkgs.usbtop;
      packages.vips = pkgs.vips;
      packages.waifu2x-converter-cpp = pkgs.waifu2x-converter-cpp;
      packages.wayland-utils = pkgs.wayland-utils;
      packages.waypipe = pkgs.waypipe;
      packages.wayvnc = pkgs.wayvnc;
      packages.wdomirror = pkgs.wdomirror;
      packages.wev = pkgs.wev;
      packages.wf-recorder = pkgs.wf-recorder;
      packages.wl-clipboard = pkgs.wl-clipboard;
      packages.wl-mirror = pkgs.wl-mirror;
      packages.wlrctl = pkgs.wlrctl;
      packages.wlroots = pkgs.wlroots;
      packages.wmctrl = pkgs.wmctrl;
      packages.wtype = pkgs.wtype;
      packages."xfce.exo" = pkgs.xfce.exo;
      packages."xfce.gigolo" = pkgs.xfce.gigolo;
      packages."xorg.xrandr" = pkgs.xorg.xrandr;
      packages.xterm = pkgs.xterm;
      packages.zarchive = pkgs.zarchive;
      packages.zathura = pkgs.zathura;
      packages.zbar = pkgs.zbar;
      packages.zint = pkgs.zint;
      packages.zstd = pkgs.zstd;

      # special case for az
      apps.az = { type = "app"; program = "${pkgs.azure-cli}/bin/az"; };
      packages.az = pkgs.azure-cli;

      # special case for git-gui, from /libexec/git-core/git-gui
      apps.git-gui = { type = "app"; program = "${pkgs.gitFull}/libexec/git-core/git-gui"; };
      packages.git-gui = pkgs.gitFull;

      # special case for gitk
      apps.gitk = { type = "app"; program = "${pkgs.gitFull}/bin/gitk"; };
      packages.gitk = pkgs.gitFull;
    });
}
