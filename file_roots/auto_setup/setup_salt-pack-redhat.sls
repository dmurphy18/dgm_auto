{% import "auto_setup/auto_base_map.jinja" as base_cfg %}


{% if base_cfg.build_specific_tag == False %}

## Redhat 7 & 6

build_cp_salt_targz_rhel7_sources:
  file.copy:
    - name: {{base_cfg.build_salt_pack_dir}}/file_roots/pkg/salt/{{base_cfg.build_version}}/rhel7/sources
    - source: {{base_cfg.build_salt_dir}}/dist/salt-{{base_cfg.build_version_full_dotted}}nb{{base_cfg.date_tag}}.tar.gz
    - force: True
    - makedirs: True
    - preserve: True
    - user: {{base_cfg.build_runas}}
    - subdir: True

{% set rpmfiles = ['salt-api', 'salt-api.service', 'salt-master', 'salt-master.service', 'salt-minion', 'salt-minion.service', 'salt-syndic', 'salt-syndic.service', 'salt.bash'] %}

{% for rpmfile in rpmfiles %}

build_cp_salt_targz_rhel7_{{rpmfile.replace('.', '-')}}:
  file.copy:
    - name: {{base_cfg.build_salt_pack_dir}}/file_roots/pkg/salt/{{base_cfg.build_version}}/rhel7/sources
    - source: {{base_cfg.build_salt_dir}}/pkg/rpm/{{rpmfile}}
    - force: True
    - makedirs: True
    - preserve: True
    - user: {{base_cfg.build_runas}}
    - subdir: True

{% endfor %}


build_cp_salt_targz_rhel7_salt-fish-completions:
  cmd.run:
    - name: cp -R {{base_cfg.build_salt_dir}}/pkg/fish-completions {{base_cfg.build_salt_pack_dir}}/file_roots/pkg/salt/{{base_cfg.build_version}}/rhel7/sources/
    - runas: {{base_cfg.build_runas}}


adjust_branch_curr_salt_pack_rhel7_spec:
  file.replace:
    - name: {{base_cfg.build_salt_pack_dir}}/file_roots/pkg/salt/{{base_cfg.build_version}}/rhel7/spec/salt.spec
    - pattern: tobereplaced_date
    - repl: nb{{base_cfg.date_tag}}
    - show_changes: True
    - count: 1

adjust_branch_curr_salt_pack_pkgbuild:
  file.replace:
    - name: {{base_cfg.build_salt_pack_dir}}/pillar_roots/pkgbuild.sls
    - pattern: tobereplaced_date
    - repl: '{{base_cfg.build_version}}'
    - show_changes: True
    - count: 1

adjust_branch_curr_salt_pack_version_pkgbuild:
  file.replace:
    - name: {{base_cfg.build_salt_pack_dir}}/pillar_roots/versions/{{base_cfg.build_version}}/pkgbuild.sls
    - pattern: tobereplaced_date
    - repl: nb{{base_cfg.date_tag}}
    - show_changes: True

update_rhel6_from_rhel7_init:
  cmd.run:
    - name: cp {{base_cfg.build_salt_pack_dir}}/file_roots/pkg/salt/{{base_cfg.build_version}}/rhel7/init.sls {{base_cfg.build_salt_pack_dir}}/file_roots/pkg/salt/{{base_cfg.build_version}}/rhel6/init.sls
    - runas: {{base_cfg.build_runas}}


update_rhel6_from_rhel7_spec:
  cmd.run:
    - name: cp -R {{base_cfg.build_salt_pack_dir}}/file_roots/pkg/salt/{{base_cfg.build_version}}/rhel7/spec {{base_cfg.build_salt_pack_dir}}/file_roots/pkg/salt/{{base_cfg.build_version}}/rhel6/
    - runas: {{base_cfg.build_runas}}


update_rhel6_from_rhel7_sources:
  cmd.run:
    - name: cp -R {{base_cfg.build_salt_pack_dir}}/file_roots/pkg/salt/{{base_cfg.build_version}}/rhel7/sources {{base_cfg.build_salt_pack_dir}}/file_roots/pkg/salt/{{base_cfg.build_version}}/rhel6/
    - runas: {{base_cfg.build_runas}}


{% endif %}

