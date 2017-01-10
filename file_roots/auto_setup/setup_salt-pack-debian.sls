{% import "auto_setup/auto_base_map.jinja" as base_cfg %}


{% if base_cfg.build_specific_tag == False %}


## Debian 8

{% set spec_file_tarball = 'salt_debian.tar.xz' %}
{% set dir_deb8_base = base_cfg.build_salt_pack_dir ~ '/file_roots/pkg/salt/' ~ base_cfg.build_version ~ '/debian8' %}

build_cp_salt_targz_deb8_sources:
  file.copy:
    - name: {{dir_deb8_base}}/sources/salt-{{base_cfg.build_version_dotted}}nb{{base_cfg.date_tag}}.tar.gz
    - source: {{base_cfg.build_salt_dir}}/dist/salt-{{base_cfg.build_version_dotted}}nb{{base_cfg.date_tag}}.tar.gz
    - force: True
    - makedirs: True
    - preserve: True
    - user: {{base_cfg.build_runas}}
    - subdir: True


adjust_branch_curr_salt_pack_version_debian8_init_date:
  file.replace:
    - name: {{dir_deb8_base}}/init.sls
    - pattern: tobereplaced_date
    - repl: nb{{base_cfg.date_tag}}
    - show_changes: True


adjust_branch_curr_salt_pack_version_debian8_init_ver:
  file.replace:
    - name: {{dir_deb8_base}}/init.sls
    - pattern: tobereplaced_ver
    - repl: {{base_cfg.build_version_dotted}}
    - show_changes: True


unpack_branch_curr_salt_pack_version_debian8_spec:
  archive.extracted:
    - name: {{dir_deb8_base}}/spec
    - source: {{dir_deb8_base}}/spec/{{spec_file_tarball}}
    - source_hash: md5=38aac2be731f14a6a26adcd2e8829ca8
    - cmd: {{dir_deb8_base}}
    - runas: {{base_cfg.build_runas}}
    - overwrite: True


remove_branch_curr_salt_pack_version_debian8_changelog:
  file.absent:
    - name: {{dir_deb8_base}}/spec/debian/change.log


touch_branch_curr_salt_pack_version_debian8_changelog:
  file.touch:
    - name: {{dir_deb8_base}}/spec/debian/change.log


update_branch_curr_salt_pack_version_debian8_changelog:
  file.append:
    - name: {{dir_deb8_base}}/spec/debian/changelog
    - ignore_whitespace: False
    - text: |
        salt ({{base_cfg.build_version_dotted}}nb{{base_cfg.date_tag}}+ds-0) stable; urgency=medium

           * Build of Salt {{base_cfg.build_version_dotted}} nightly build {{base_cfg.date_tag}}

          -- Salt Stack Packaging <packaging@saltstack.com>  Mon,  9 Jan 2017 14:34:13 -0600
    - require:
      - file: remove_branch_curr_salt_pack_version_debian8_changelog

 
pack_branch_curr_salt_pack_version_debian8_spec:
   module.run:
     - name: archive.tar
     - tarfile: {{spec_file_tarball}}
     - dest: {{dir_deb8_base}}/spec
     - sources: debian
     - cwd: {{dir_deb8_base}}/spec
     - runas: {{base_cfg.build_runas}}
     - options: -cvJf
 

cleanup_pack_branch_curr_salt_pack_version_debian8_spec:
  file.absent:
    - name: {{dir_deb8_base}}/spec/debian


{% endif %}

