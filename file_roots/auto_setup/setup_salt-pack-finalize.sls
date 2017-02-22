{% import "auto_setup/auto_base_map.jinja" as base_cfg %}

remove_any_salt_target_platforms:
  file.absent:
    - name: /srv/salt/pkg/salt/{{base_cfg.build_version}}


## finally setup salt-pack files on master, noting auto_setup should not get overwritten
setup_salt_pack_master_base:
  cmd.run:
    - name: cp -f -R {{base_cfg.build_salt_pack_dir}}/file_roots/* /srv/salt/


setup_salt_pack_master_pillar:
  cmd.run:
    - name: cp -f -R {{base_cfg.build_salt_pack_dir}}/pillar_roots/* /srv/pillar/


##  file.replace:
##    - name: /srv/pillar/top.sls
##    - pattern: 'gpg_keys'
##    - repl: 'auto_setup.gpg_keys_test'
##    - show_changes: True
##    - count: 1
##
adjust_salt_pack_master_pillar_top_keys:
  file.line:
    - name: /srv/pillar/top.sls
    - content: '- auto_setup.gpg_keys_test'
    - match: 'auto_setup.gpg_keys_test'
    - mode: delete
    - show_changes: True
    - backup: True


adjust_salt_pack_master_pillar_top_match:
  file.append:
    - name: /srv/pillar/top.sls
    - ignore_whitespace: False
    - text: |
          ##
              - auto_setup.gpg_keys_test
              - auto_setup.tag_build_date
              - auto_setup.bld_res_server_key

            'G@os_family:Redhat and G@os:Amazon':
              - auto_setup.amazon

            'G@os_family:Redhat and G@osmajorrelease:7 and not G@os:Amazon':
              - auto_setup.redhat7

            'G@os_family:Redhat and G@osmajorrelease:6 and not G@os:Amazon':
              - auto_setup.redhat6

            'G@osfullname:Debian and G@osmajorrelease:8 and not G@osfullname:Raspbian':
              - auto_setup.debian8

            'G@osfullname:Debian and G@osmajorrelease:7':
              - auto_setup.debian7

            'G@osfullname:Debian and G@osmajorrelease:8 and G@osfullname:Raspbian':
              - auto_setup.raspbian

            'G@osfullname:Ubuntu and G@osmajorrelease:16':
              - auto_setup.ubuntu16

            'G@osfullname:Ubuntu and G@osmajorrelease:14':
              - auto_setup.ubuntu14


