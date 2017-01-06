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
