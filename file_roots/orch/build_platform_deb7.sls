{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

build_debian7_init:
  salt.state:
    - tgt: {{base_cfg.minion_debian7}}
    - sls:
      - setup.debian.debian7

build_debian7_highstate:
  salt.state:
    - tgt: {{base_cfg.minion_debian7}}
    - highstate: True
