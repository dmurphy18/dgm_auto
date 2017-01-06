{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

build_debian8_init:
  salt.state:
    - tgt: {{base_cfg.minion_debian8}}
    - sls:
      - setup.debian.debian8

build_debian8_highstate:
  salt.state:
    - tgt: {{base_cfg.minion_debian8}}
    - highstate: True
