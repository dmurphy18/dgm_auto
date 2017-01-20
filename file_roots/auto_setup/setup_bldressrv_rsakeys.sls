{% import "auto_setup/auto_base_map.jinja" as base_cfg %}


manage_priv_key:
  file.managed:
    - name: {{base_cfg.rsa_priv_key_absfile}}
    - dir_mode: 700
    - mode: 600
    - contents_pillar: bld_res_server_id_rsa_priv_key
    - show_changes: False
    - user: {{base_cfg.build_runas}}
    - group: adm
    - makedirs: True


manage_pub_key:
  module.run:
    - name: cp.get_file
    - path: {{base_cfg.rsa_pub_key_source_file}}
    - dest: {{base_cfg.rsa_pub_key_absfile}}
    - makedirs: True
    - template: jinja


## TODO Need to extract these from {{base_cfg.rsa_pub_key_absfile}}
rsa_load_pub_key:
  module.run:
    - name: ssh.set_known_host
    - user: {{base_cfg.build_runas}}
    - hostname: {{base_cfg.minion_bldressrv_hostname}}
    - key: |
        'AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBDTx2yXXXOtn3Y69WOyzZr1rH21LGe32COF1nZi00SYQEzrqJvgrbCzEmP6S6t3Gpl3klr9UVkzKV0K2RZECO+Y='
    - enc: 'ecdsa-sha2-nistp256'
    - hash_known_hosts: False


