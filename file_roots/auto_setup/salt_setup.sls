# Import base config
{% import "auto_setup/auto_base_map.jinja" as base_cfg %}


build_pkgs:
  pkg.installed:
   - pkgs:
     - git


{{base_cfg.build_runas}}:
  user.present:
    - groups:
      - adm
    - require:
      - pkg: build_pkgs


build_clean_salt_code:
  file.absent:
    - name: {{base_cfg.built_salt_dir}}


retrieve_desired_salt:
  git.latest:
    - name: https://github.com/saltstack/salt.git
    - target: {{base_cfg.built_salt_dir}}
{% if base_cfg.build_specific_tag %}
    - rev: {{base_cfg.branch_tag}}
{% else %}
    - branch: {{base_cfg.branch_tag}}
{% endif %}
