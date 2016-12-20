{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

{% set patch_file = 'version.patch' %}
{% set uder_version_file = base_cfg.build_salt_dir ~ '/salt/_version.py' %}

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


build_clean_salt_code_dir:
  file.absent:
    - name: {{base_cfg.build_salt_dir}}


build_create_salt_code_dir:
  file.directory:
    - name: {{base_cfg.build_salt_dir}}
    - user: {{base_cfg.build_runas}}
    - dir_mode: 755
    - file_mode: 655


retrieve_desired_salt:
  git.latest:
    - name: https://github.com/saltstack/salt.git
    - target: {{base_cfg.build_salt_dir}}
{% if base_cfg.build_specific_tag %}
    - rev: {{base_cfg.branch_tag}}
{% else %}
    - branch: {{base_cfg.branch_tag}}
{% endif %}


build_clean_patch:
  file.absent:
    - name: {{base_cfg.build_homedir}}/{{patch_file}}


build_remove_version_override:
  file.absent:
    - name: {{uder_version_file}}


{% if base_cfg.build_specific_tag == False %}

build_write_patch:
  file.append:
    - name: {{base_cfg.build_homedir}}/{{patch_file}}
    - text: |
        --- a/version.py    2016-12-13 15:09:00.382911599 -0700
        +++ b/version.py    2016-12-13 15:09:19.479885298 -0700
        @@ -60,7 +60,7 @@
                 r'\.(?P<minor>[\d]{1,2})'
                 r'(?:\.(?P<bugfix>[\d]{0,2}))?'
                 r'(?:\.(?P<mbugfix>[\d]{0,2}))?'
        -        r'(?:(?P<pre_type>rc|a|b|alpha|beta)(?P<pre_num>[\d]{1}))?'
        +        r'(?:(?P<pre_type>rc|a|b|alpha|beta|nb)(?P<pre_num>[\d]{1}))?'
                 r'(?:(?:.*)-(?P<noc>(?:[\d]+|n/a))-(?P<sha>[a-z0-9]{8}))?'
             )
             git_sha_regex = re.compile(r'(?P<sha>[a-z0-9]{7})')


build_apply_patch:
  file.patch:
    - name: {{base_cfg.build_salt_dir}}/salt/version.py
    - source: {{base_cfg.build_homedir}}/{{patch_file}}
    - hash: md5=cdfdbe8ecdee482664c8345e1426d0b9


build_write_version_override:
  file.append:
    - name: {{uder_version_file}}
    - text: |
        from salt.version import SaltStackVersion
        __saltstack_version__ = SaltStackVersion( 2016, 11, 0, 0, 'nb', {{base_cfg.date_tag}}, 0, None )

build_salt_sdist:
  cmd.run:
    - name: python setup.py sdist; exit 0
    - runas: {{base_cfg.build_runas}}
    - cwd: {{base_cfg.build_salt_dir}}


{% endif %}


