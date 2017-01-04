{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

build_raspbian_init:
  salt.state:
    - tgt: {{base_cfg.minion_raspbian}}
    - sls:
      - setup.debian.raspbian

build_raspbian_highstate:
  salt.state:
    - tgt: {{base_cfg.minion_raspbian}}
    - highstate: True
