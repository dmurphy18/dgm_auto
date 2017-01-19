{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

{% set minion_tgt = base_cfg.minion_ubuntu1604 %}
{% set minion_platform = 'ubuntu16' %}
{% set minion_specific = 'ubuntu.' ~ minion_platform %}

{% set os_version = '16.04' %}
{% set build_arch = pillar.get('build_arch') %}
{% set build_dest = pillar.get('build_dest') %}
{% set nb_srcdir = build_dest ~ '/' ~ minion_platform ~ '/' ~ build_arch %}
{% set nb_destdir = base_cfg.build_version ~ 'nb' ~ base_cfg.date_tag %}
{% set web_server_base_dir = base_cfg.minion_bldressrv_rootdir ~ '/apt/ubuntu/' ~ os_version ~ '/' ~ build_arch ~ '/archive/' ~ nb_destdir %}


refresh_pillars_{{minion_platform}}:
  salt.function:
    - name: saltutil.refresh_pillar
    - tgt: {{minion_tgt}}


build_init_{{minion_platform}}:
  salt.state:
    - tgt: {{minion_tgt}}
    - sls:
      - setup.{{minion_specific}}


build_bldressrv_rsakeys_{{minion_platform}}:
  salt.state:
    - tgt: {{minion_tgt}}
    - sls:
      - auto_setup.setup_bldressrv_rsakeys


build_bldressrv_basedir_exists_{{minion_platform}}:
  salt.function:
    - name: file.makedirs
    - tgt: {{base_cfg.minion_bldressrv}}
    - arg:
      - {{web_server_base_dir}}/
    - kwarg:
        user: {{base_cfg.minion_bldressrv_username}}
        group: www-data
        mode: 775


build_highstate_{{minion_platform}}:
  salt.state:
    - tgt: {{minion_tgt}}
    - highstate: True


sign_packages_{{minion_platform}}:
  salt.state:
    - tgt: {{minion_tgt}}
    - sls:
      - repo.{{minion_specific}}


copy_signed_packages_{{minion_platform}}:
  salt.function:
    - name: cmd.run
    - tgt: {{minion_tgt}}
    - arg:
      - scp -i {{base_cfg.rsa_priv_key_absfile}} -r {{nb_srcdir}}/* {{base_cfg.minion_bldressrv_username}}@{{base_cfg.minion_bldressrv_hostname}}:{{web_server_base_dir}}/

