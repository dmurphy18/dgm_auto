{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

build_rhel7_init:
  salt.state:
    - tgt: {{base_cfg.minion_rhel7}}
    - sls:
      - setup.redhat.rhel7

build_rhel7_highstate:
  salt.state:
    - tgt: {{base_cfg.minion_rhel7}}
    - highstate: True
    - pillar:
        build_dest: /srv/redhat/{{base_cfg.build_version}}nb{{base_cfg.date_tag}}/pkgs
        build_version: {{base_Cfg.build_version}}


build_rhel6_init:
  salt.state:
    - tgt: {{base_cfg.minion_rhel7}}
    - sls:
      - setup.redhat.rhel7


build_rhel6_highstate:
  salt.state:
    - tgt: {{base_cfg.minion_rhel7}}
    - highstate: True
    - pillar:
        build_dest: /srv/redhat/{{base_cfg.build_version}}nb{{base_cfg.date_tag}}/pkgs
        build_version: {{base_Cfg.build_version}}
        build_release: rhel6



