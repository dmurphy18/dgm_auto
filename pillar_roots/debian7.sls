{% import "auto_base_map.jinja" as base_cfg %}

## TBD keyid needs to be changed to whatever testing keys id is

build_dest: /srv/debian/{{base_cfg.build_version}}nb{{base_cfg.date_tag}}/pkgs
keyid : DE57BFBE
build_release" : debian7
build_version" : {{base_cfg.build_version}}
build_arch : x86_64

