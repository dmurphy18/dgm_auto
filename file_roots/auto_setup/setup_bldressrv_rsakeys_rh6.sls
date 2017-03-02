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
        AAAAB3NzaC1yc2EAAAADAQABAAABAQCnO82/iNcZx+c2i0UXI7ee0oEEvhn1evR5aKkNmZ7Vdb8oAoAo6byzr+Qpxu4a8FUOL04JfvMkgecImdwCSFYzth0VP2G4CZm4uz+qtfHE41yXa6VJ4itkh+QHp+5x3SSB7YbNB47NHrgDhGNfFhV3UU/ny911LmHabqUP0ldgpw/v7RenkCN5hiottr8ql49Z6nW+uZK/1pWEO+esX36F/D2whehP1oTHaWiETOteMs3dggTUItyCwVenU8b03EUhilgT8vTQCXDEld0VZRVoLeETqz8jQ/dTVnsEZBwZLlaC2YJNqzAFEc29GI3XD1NWRqpfCdI7Jjm9NeCm/OgL
    - enc: 'ssh-rsa'
    - hash_known_hosts: False
