#!/usr/bin/python2.7
import json
import urllib2
import zipfile
import sys

def download_file(url, dest):# {{{
    with open(dest, 'wb') as destfile:
        data = urllib2.urlopen(url).read()
        destfile.write(data)# }}}
def unzip_file(zippath):# {{{
    with zipfile.ZipFile(zippath) as myzip:
        myzip.extractall()# }}}
def atlauncher_get_server_url(packname,version):# {{{
    data = urllib2.urlopen('https://api.atlauncher.com/v1/pack/%s/%s/' % (packname, version))
    pack_version = json.load(data)
    return pack_version['data']['serverZipURL']# }}}

destfile = 'minecraft.zip'

if sys.argv[1] == 'skyfactory':
    url = atlauncher_get_server_url('SkyFactory', 'latest')
    download_file(url, destfile)
    unzip_file(destfile)
elif sys.argv[1] == 'agrarianskies2':
    url = 'http://minecraft.curseforge.com/modpacks/225550-agrarian-skies-2/files/2241816/download'
    download_file(url, destfile)
    unzip_file(destfile)
elif sys.argv[1] == 'direwolf20':
    url = 'http://ftb.cursecdn.com/FTB2/modpacks/direwolf20_17/1_4_1/direwolf20_17-server.zip'
    download_file(url, destfile)
    unzip_file(destfile)
