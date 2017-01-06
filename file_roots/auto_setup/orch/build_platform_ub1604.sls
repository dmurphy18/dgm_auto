{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

build_ubuntu1604_init:
  salt.state:
    - tgt: {{base_cfg.minion_ubuntu1604}}
    - sls:
      - setup.ubuntu.ubuntu16

build_ubuntu1604_highstate:
  salt.state:
    - tgt: {{base_cfg.minion_ubuntu1604}}
    - highstate: True
