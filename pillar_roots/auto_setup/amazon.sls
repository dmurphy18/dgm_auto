{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

## TBD keyid needs to be changed to whatever testing keys id is

build_dest: /srv/amazon/{{base_cfg.build_version}}nb{{base_cfg.date_tag}}/pkgs
keyid: 4DD70950
build_release: amzn
build_version: '{{base_cfg.build_version}}'
build_arch: 'x86_64'
build_runas: builder

