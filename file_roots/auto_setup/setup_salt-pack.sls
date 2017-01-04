{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

{% set patch_file = 'version.patch' %}

build_pack_pkgs:
  pkg.installed:
   - pkgs:
     - git


build_pack_user:
  user.present:
    - name: {{base_cfg.build_runas}}
    - groups:
      - adm
    - require:
      - pkg: build_pack_pkgs


build_clean_salt_pack_dir:
  file.absent:
    - name: {{base_cfg.build_salt_pack_dir}}


build_create_salt_pack_dir:
  file.directory:
    - name: {{base_cfg.build_salt_pack_dir}}
    - user: {{base_cfg.build_runas}}
    - dir_mode: 755
    - file_mode: 655


##    - name: https://github.com/saltstack/salt-pack.git
retrieve_desired_salt_pack:
  git.latest:
    - name: https://github.com/dmurphy18/salt-pack.git
    - rev: auto_spack
    - target: {{base_cfg.build_salt_pack_dir}}
    - user: {{base_cfg.build_runas}}


{% if base_cfg.build_specific_tag == False %}

build_cp_salt_targz_rhel7_sources:
  file.copy:
    - name: {{base_cfg.build_salt_pack_dir}}/file_roots/pkg/salt/{{base_cfg.build_version}}/rhel7/sources
    - source: {{base_cfg.build_salt_dir}}/dist/salt-{{base_cfg.build_version_dotted}}nb{{base_cfg.date_tag}}.tar.gz
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


## build_cp_salt_targz_rhel7_salt-fish-completions_dir:
##   file.directory:
##     - name: {{base_cfg.build_salt_pack_dir}}/file_roots/pkg/salt/{{base_cfg.build_version}}/rhel7/sources/fish-completions
##     - user: {{base_cfg.build_runas}}
##     - makedirs: True
##     - user: {{base_cfg.build_runas}}
##     - group: {{base_cfg.build_runas}}
##     - dir_mode: 755
##     - file_mode: 644


build_cp_salt_targz_rhel7_salt-fish-completions:
  cmd.run:
    - name: cp -R {{base_cfg.build_salt_dir}}/pkg/fish-completions {{base_cfg.build_salt_pack_dir}}/file_roots/pkg/salt/{{base_cfg.build_version}}/rhel7/sources/
    - runas: {{base_cfg.build_runas}}

### neither approach really working, so resorted to brute force above
##   file.recurse:
##     - name: {{base_cfg.build_salt_pack_dir}}/file_roots/pkg/salt/{{base_cfg.build_version}}/rhel7/sources/fish-completions
##     - source: salt://../..{{base_cfg.build_salt_dir}}/pkg/fish-completions
##     - force: True
##     - makedirs: True
##     - preserve: True
##     - user: {{base_cfg.build_runas}}
##     - subdir: True
##     - file_mode: keep
##     - include_pat: E@fish

##   module.run:
##     - name: cp.get_dir
##     - path: salt://../..{{base_cfg.build_salt_dir}}/pkg/fish-completions
##     - dest: {{base_cfg.build_salt_pack_dir}}/file_roots/pkg/salt/{{base_cfg.build_version}}/rhel7/sources/fish-completions
##     - force: True
##     - makedirs: True
##     - preserve: True
##     - user: {{base_cfg.build_runas}}
##     - subdir: True
##     - file_mode: keep
##     - include_pat: E@fish


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
    - repl: {{base_cfg.build_version}}
    - show_changes: True
    - count: 1

adjust_branch_curr_salt_pack_version_pkgbuild:
  file.replace:
    - name: {{base_cfg.build_salt_pack_dir}}/pillar_roots/versions/{{base_cfg.build_version}}/pkgbuild.sls
    - pattern: tobereplaced_date
    - repl: nb{{base_cfg.date_tag}}
    - show_changes: True

{% endif %}

## finally setup salt-pack files on master
setup_salt_pack_master_pillar:
  cmd.run:
    - name: cp -f -R {{base_cfg.build_salt_pack_dir}}/pillar_roots/* /srv/pillar/


setup_salt_pack_master_base:
  cmd.run:
    - name: cp -f -R {{base_cfg.build_salt_pack_dir}}/file_roots/* /srv/salt/

