name: Build Grafex Engine

on:
  pull_request:
    branches: [ stable ]
  push:
    branches: [ stable ]
    
jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Haxe
        uses: krdlab/setup-haxe@v1
        with:
          haxe-version: 4.2.5
      
      - name: Install project dependencies
        run: |
          haxelib setup /usr/share/haxe/lib
          haxelib install lime --always --quiet
          haxelib install openfl --always --quiet
          haxelib install flixel --never --quiet
          haxelib install flixel-tools --never --quiet
          haxelib install flixel-ui --never --quiet
          haxelib install hscript --always --quiet
          haxelib install flixel-addons --never --quiet
          haxelib install actuate --always --quiet
          haxelib run lime setup --always --quiet
          haxelib run lime setup flixel --never --quiet
          haxelib run flixel-tools setup --never --quiet
          haxelib git linc_luajit https://github.com/nebulazorua/linc_luajit --always --quiet
          haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc --always --quiet
          haxelib install hxCodec --always --quiet
      
      - name: Build using Lime
        run: |
          lime build windows
      
      - name: Publish build artifacts
        run: echo $(ls)
#         uses: actions/upload-artifact@v3
#           with:
#             name: my-artifact
#             path: path/to/artifact/world.txt
