{% import "auto_setup/auto_base_map.jinja" as base_cfg %}


{% if base_cfg.build_specific_tag == False %}


{% set spec_file_tarball = 'salt_debian.tar.xz' %}

{% set debian_supported = ['debian8', 'debian7'] %}

{% for debian_ver in debian_supported %}

{% set dir_debian_base = base_cfg.build_salt_pack_dir ~ '/file_roots/pkg/salt/' ~ base_cfg.build_version ~ '/' ~ debian_ver' %}

build_cp_salt_targz_{{debian_ver}}_sources:
  file.copy:
    - name: {{dir_debian_base}}/sources/salt-{{base_cfg.build_version_dotted}}nb{{base_cfg.date_tag}}.tar.gz
    - source: {{base_cfg.build_salt_dir}}/dist/salt-{{base_cfg.build_version_dotted}}nb{{base_cfg.date_tag}}.tar.gz
    - force: True
    - makedirs: True
    - preserve: True
    - user: {{base_cfg.build_runas}}
    - subdir: True


adjust_branch_curr_salt_pack_version_{{debian_ver}}_init_date:
  file.replace:
    - name: {{dir_debian_base}}/init.sls
    - pattern: tobereplaced_date
    - repl: nb{{base_cfg.date_tag}}
    - show_changes: True


adjust_branch_curr_salt_pack_version_{{debian_ver}}_init_ver:
  file.replace:
    - name: {{dir_debian_base}}/init.sls
    - pattern: tobereplaced_ver
    - repl: {{base_cfg.build_version_dotted}}
    - show_changes: True


unpack_branch_curr_salt_pack_version_{{debian_ver}}_spec:
  archive.extracted:
    - name: {{dir_debian_base}}/spec
    - source: {{dir_debian_base}}/spec/{{spec_file_tarball}}
    - source_hash: md5=38aac2be731f14a6a26adcd2e8829ca8
    - cmd: {{dir_debian_base}}
    - runas: {{base_cfg.build_runas}}
    - overwrite: True


remove_branch_curr_salt_pack_version_{{debian_ver}}_changelog:
  file.absent:
    - name: {{dir_debian_base}}/spec/debian/changelog


touch_branch_curr_salt_pack_version_{{debian_ver}}_changelog:
  file.touch:
    - name: {{dir_debian_base}}/spec/debian/changelog


update_branch_curr_salt_pack_version_{{debian_ver}}_changelog:
  file.append:
    - name: {{dir_debian_base}}/spec/debian/changelog
    - ignore_whitespace: False
    - text: |
        salt ({{base_cfg.build_version_dotted}}nb{{base_cfg.date_tag}}+ds-0) stable; urgency=medium

           * Build of Salt {{base_cfg.build_version_dotted}} nightly build {{base_cfg.date_tag}}

          -- Salt Stack Packaging <packaging@saltstack.com>  Mon,  9 Jan 2017 14:34:13 -0600
    - require:
      - file: remove_branch_curr_salt_pack_version_{{debian_ver}}_changelog


pack_branch_curr_salt_pack_version_{{debian_ver}}_spec:
   module.run:
     - name: archive.tar
     - tarfile: {{spec_file_tarball}}
     - dest: {{dir_debian_base}}/spec
     - sources: debian
     - cwd: {{dir_debian_base}}/spec
     - runas: {{base_cfg.build_runas}}
     - options: -cvJf


cleanup_pack_branch_curr_salt_pack_version_{{debian_ver}}_spec:
  file.absent:
    - name: {{dir_debian_base}}/spec/debian

{% endfor %}

{% endif %}

