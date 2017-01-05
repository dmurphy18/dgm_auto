
  'G@os_family:Redhat and G@os:Amazon':
    - auto_setup.amazon

  'G@os_family:Redhat and not G@os:Amazon and G@osmajorrelease:7':
    - auto_setup.redhat7

  'G@os_family:Redhat and not G@os:Amazon and G@osmajorrelease:6':
    - auto_setup.redhat6

  'G@osfullname:Debian and G@osmajorrelease:8 and not G@osfullname:Raspbian':
    - auto_setup.debian8

  'G@osfullname:Debian and G@osmajorrelease:8 and G@osfullname:Raspbian':
    - auto_setup.raspbian

  'G@osfullname:Ubuntu and G@osmajorrelease:16':
    - auto_setup.ubuntu16

  'G@osfullname:Ubuntu and G@osmajorrelease:14':
    - auto_setup.ubuntu14

