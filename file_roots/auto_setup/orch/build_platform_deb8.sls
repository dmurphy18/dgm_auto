{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

{% set minion_tgt = base_cfg.minion_debian8 %}
{% set minion_platform = 'debian8' %}
{% set minion_specific = 'debian.' ~ minion_platform %}


refresh_pillars_{{minion_platform}}:
  salt.function:
    - name: saltutil.refresh_pillar
    - tgt: {{minion_tgt}}


build_init_{{minion_platform}}:
  salt.state:
    - tgt: {{minion_tgt}}
    - sls:
      - setup.{{minion_specific}}


build_highstate_{{minion_platform}}:
  salt.state:
    - tgt: {{minion_platform}}
    - highstate: True


sign_packages_{{minion_platform}}:
  salt.state:
    - tgt: {{minion_tgt}}
    - sls:
      - repo.{{minion_specific}}

