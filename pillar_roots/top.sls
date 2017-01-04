{% import "auto_base_map.jinja" as base_cfg %}

base:
  '*':
    - gpg_keys

  'G@os_family:Redhat and G@os:Amazon':
   - amazon

  'G@os_family:Redhat and not G@os:Amazon and G@osmajorrelease:7':
   - redhat7

  'G@os_family:Redhat and not G@os:Amazon and G@osmajorrelease:6':
   - redhat6

  'G@osfullname:Debian and G@osmajorrelease:8 and not G@osfullname:Raspbian':
    - debian8

  'G@osfullname:Debian and G@osmajorrelease:8 and G@osfullname:Raspbian':
    - raspbian

  'G@osfullname:Ubuntu and G@osmajorrelease:16':
    - ubuntu16

  'G@osfullname:Ubuntu and G@osmajorrelease:14':
    - ubuntu14

