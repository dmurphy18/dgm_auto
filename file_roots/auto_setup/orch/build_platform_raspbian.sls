{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

{% set minion_tgt = base_cfg.minion_raspbian %}
#
## TODO need to move this to minion to pick off build_arch correctly etc.
{% set os_family = 'debian' %}
{% set os_version = '8' %}
{% set build_arch = 'armhf' %}

{% set minion_platform = 'raspbian' %}
{% set minion_specific = os_family ~ '.' ~ minion_platform %}

{% set nb_destdir = base_cfg.build_version ~ 'nb' ~ base_cfg.date_tag %}
{% set web_server_base_dir = base_cfg.minion_bldressrv_rootdir ~ '/apt/' ~ os_family ~ '/' ~ os_version ~ '/' ~ build_arch %}
{% set web_server_archive_dir = web_server_base_dir ~ '/archive/' ~ nb_destdir %}


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
      - {{web_server_archive_dir}}/
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
    - queue: True
    - sls:
      - repo.{{minion_specific}}
    - require:
      - salt: build_highstate_{{minion_platform}}


remove_current_{{base_cfg.build_version}}_{{minion_platform}}:
  salt.function:
    - name: file.remove
    - tgt: {{base_cfg.minion_bldressrv}}
    - arg:
      - {{web_server_base_dir}}/{{base_cfg.build_version_dotted}}
    - require:
      - salt: sign_packages_{{minion_platform}}


update_current_{{base_cfg.build_version}}_{{minion_platform}}:
 salt.function:
   - name:  file.symlink
   - tgt: {{base_cfg.minion_bldressrv}}
   - arg:
     - {{web_server_archive_dir}}
     - {{web_server_base_dir}}/{{base_cfg.build_version_dotted}}


update_current_{{base_cfg.build_version}}_mode_{{minion_platform}}:
 salt.function:
   - name:  file.lchown
   - tgt: {{base_cfg.minion_bldressrv}}
   - arg:
     - {{web_server_base_dir}}/{{base_cfg.build_version_dotted}}
     - {{base_cfg.minion_bldressrv_username}}
     - www-data


copy_signed_packages_{{minion_platform}}:
  salt.state:
    - tgt: {{minion_tgt}}
    - queue: True
    - sls:
      - auto_setup.copy_build_product
    - require:
      - salt: sign_packages_{{minion_platform}}
      - salt: update_current_{{base_cfg.build_version}}_mode_{{minion_platform}}


