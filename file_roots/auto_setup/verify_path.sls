{% set base_path = pillar.get('base_path') %}
{% set user = pillar.get('user') %}

verify_path_webserver:
  file.directory:
    - name: {{base_path}}
    - user: {{user}}
    - group: www-data
    - dir_mode: 775
    - file_mode: 664
    - makedirs: True
    - recurse:
      - user
      - group
      - mode


