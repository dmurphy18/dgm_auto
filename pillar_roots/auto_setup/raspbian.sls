{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

## TBD keyid needs to be changed to whatever testing keys id is

build_dest: /srv/debian/{{base_cfg.build_version}}nb{{base_cfg.date_tag}}/pkgs
keyid: 4DD70950
build_release: debian8
build_version: '{{base_cfg.build_version}}'
build_arch: armhf
build_runas: root

