{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

build_rhel6_init:
  salt.state:
    - tgt: {{base_cfg.minion_rhel6}}
    - sls:
      - setup.redhat.rhel6

build_rhel6_highstate:
  salt.state:
    - tgt: {{base_cfg.minion_rhel6}}
    - highstate: True
