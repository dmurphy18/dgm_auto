{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

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
##    - name: https://github.com/dmurphy18/salt-pack.git
retrieve_desired_salt_pack:
  git.latest:
    - name: https://github.com/saltstack/salt-pack.git
    - rev: auto_spack
    - target: {{base_cfg.build_salt_pack_dir}}
    - user: {{base_cfg.build_runas}}


