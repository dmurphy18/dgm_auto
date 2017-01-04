{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

build_ubuntu1404_init:
  salt.state:
    - tgt: {{base_cfg.minion_ubuntu1404}}
    - sls:
      - setup.ubuntu.ubuntu14

build_ubuntu1404_highstate:
  salt.state:
    - tgt: {{base_cfg.minion_ubuntu1404}}
    - highstate: True
