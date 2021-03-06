{% import "auto_setup/auto_base_map.jinja" as base_cfg %}


{% if base_cfg.build_specific_tag == False %}


{% set spec_file_tarball = 'salt_ubuntu.tar.xz' %}

{% set ubuntu_supported = ['ubuntu1604', 'ubuntu1404'] %}

{% for ubuntu_ver in ubuntu_supported %}

{% set dir_ubuntu_base = base_cfg.build_salt_pack_dir ~ '/file_roots/pkg/salt/' ~ base_cfg.build_version ~ '/' ~ ubuntu_ver %}

build_cp_salt_targz_{{ubuntu_ver}}_sources:
  file.copy:
    - name: {{dir_ubuntu_base}}/sources/salt-{{base_cfg.build_version_full_dotted}}nb{{base_cfg.date_tag}}.tar.gz
    - source: {{base_cfg.build_salt_dir}}/dist/salt-{{base_cfg.build_version_full_dotted}}nb{{base_cfg.date_tag}}.tar.gz
    - force: True
    - makedirs: True
    - preserve: True
    - user: {{base_cfg.build_runas}}
    - subdir: True


adjust_branch_curr_salt_pack_version_{{ubuntu_ver}}_init_date:
  file.replace:
    - name: {{dir_ubuntu_base}}/init.sls
    - pattern: tobereplaced_date
    - repl: nb{{base_cfg.date_tag}}
    - show_changes: True


adjust_branch_curr_salt_pack_version_{{ubuntu_ver}}_init_ver:
  file.replace:
    - name: {{dir_ubuntu_base}}/init.sls
    - pattern: tobereplaced_ver
    - repl: {{base_cfg.build_version_full_dotted}}
    - show_changes: True


unpack_branch_curr_salt_pack_version_{{ubuntu_ver}}_spec:
  module.run:
    - name: archive.tar
    - tarfile: {{dir_ubuntu_base}}/spec/{{spec_file_tarball}}
    - dest: {{dir_ubuntu_base}}/spec
    - cwd: {{dir_ubuntu_base}}/spec
    - runas: {{base_cfg.build_runas}}
    - options: -xvJf

remove_branch_curr_salt_pack_version_{{ubuntu_ver}}_changelog:
  file.absent:
    - name: {{dir_ubuntu_base}}/spec/debian/changelog


touch_branch_curr_salt_pack_version_{{ubuntu_ver}}_changelog:
  file.touch:
    - name: {{dir_ubuntu_base}}/spec/debian/changelog


update_branch_curr_salt_pack_version_{{ubuntu_ver}}_changelog:
  file.append:
    - name: {{dir_ubuntu_base}}/spec/debian/changelog
    - ignore_whitespace: False
    - text: |
        salt ({{base_cfg.build_version_full_dotted}}nb{{base_cfg.date_tag}}+ds-0) stable; urgency=medium

          * Build of Salt {{base_cfg.build_version_full_dotted}}nb{{base_cfg.date_tag}}

         -- Salt Stack Packaging <packaging@saltstack.com>  Mon,  9 Jan 2017 14:34:13 -0600
    - require:
      - file: remove_branch_curr_salt_pack_version_{{ubuntu_ver}}_changelog


pack_branch_curr_salt_pack_version_{{ubuntu_ver}}_spec:
   module.run:
     - name: archive.tar
     - tarfile: {{spec_file_tarball}}
     - dest: {{dir_ubuntu_base}}/spec
     - sources: debian
     - cwd: {{dir_ubuntu_base}}/spec
     - runas: {{base_cfg.build_runas}}
     - options: -cvJf


cleanup_pack_branch_curr_salt_pack_version_{{ubuntu_ver}}_spec:
  file.absent:
    - name: {{dir_ubuntu_base}}/spec/debian

{% endfor %}

{% endif %}

