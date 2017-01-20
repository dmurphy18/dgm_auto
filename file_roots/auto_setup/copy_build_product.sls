{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

{% if grains.get('os') == 'Ubuntu' -%}
{% set os_version = grains.get('osrelease') %}
{% else %}
{% set os_version = grains.get('osmajorrelease') %}
{% endif %}

{% set build_arch = grains.get('osarch') %}


## set platform
{% if grains.get('os_family') == 'Debian' -%}
{% set platform_pkg = 'apt' %}

{% if grains.get('os') == 'Ubuntu' -%}
{% set platform = grains.get('os') -%}
{% else %}
{% set platform = grains.get('os_family') -%}
{% endif %}

{% elif grains.get('os_family') == 'Redhat' -%}
{% set platform_pkg = 'yum' %}

{% if grains.get('os') == 'Amazon' -%}
{% set platform = grains.get('os') -%}
{% else %}
{% set platform = grains.get('os_family') -%}
{% endif %}

{% endif %}

{% set platform_name = platform|lower %}


{% set build_dest = pillar.get('build_dest') %}
{% set nb_srcdir = build_dest ~ '/' ~ platform_name ~ os_version ~ '/' ~ build_arch %}
{% set nb_destdir = base_cfg.build_version ~ 'nb' ~ base_cfg.date_tag %}
{% set web_server_base_dir = base_cfg.minion_bldressrv_rootdir ~ '/' ~ platform_pkg ~ '/' ~ platform_name ~ '/' ~ os_version ~ '/' ~ build_arch ~ '/archive/' ~ nb_destdir %}


## TODO need to figure way to pass pillar data to via publish.publish
## 
## verify_path_on_webserver:
##   module.run:
##     - name : publish.publish
##     - tgt: {{base_cfg.minion_bldressrv}}
##     - m_fun: state.sls
##     - arg: |
##         auto_setup.verify_path
##     - kwargs:
##       - context:
##         base_path: {{web_server_base_dir}}
##         user: {{base_cfg.build_runas}}
##         template: True
## 
##        salt://auto_setup/verify_path pillar='{ "base_path":"{{web_server_base_dir}}/"\, "user":"{{base_cfg.build_runas}}" }'
## 
##    - kwargs:
##        pillar:
##            base_path: {{web_server_base_dir}}/
##            user: {{base_cfg.minion_bldressrv_username}}
##

copy_signed_packages:
  cmd.run:
    - name: |
        scp -i {{base_cfg.rsa_priv_key_absfile}} -r {{nb_srcdir}}/* {{base_cfg.minion_bldressrv_username}}@{{base_cfg.minion_bldressrv_hostname}}:{{web_server_base_dir}}/
    - runas: {{base_cfg.minion_bldressrv_username}}


