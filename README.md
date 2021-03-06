#OpenEBS 

[![Build Status](https://travis-ci.org/openebs/openebs.svg?branch=master)](https://travis-ci.org/openebs/openebs)

OpenEBS is a Software Defined Storage (SDS) platform, written in GoLang, that provides the block storage containers called Virtual Storage Machines or VSMs. A VSM is a fully isolated block storage container, has it's own iSCSI stack, full set of storage management APIs and can back up the application consistent data to another VSM or an S3 compatible storage.

OpenEBS can scale to millions of VSMs seamlessly as it manages the metadata of the block storage system at a file level. The block storage for each VSM is managed as one single file or directory. The IO to this file is managed through large size chunks rather than the typical small size blocks. This enables to OpenEBS to provide higher performance for each VSM and to easilyh scale to very large number of VSMs. 

#License
OpenEBS is developed under Apache2 License at the project level. Some components of the project are derived via the GPL license and will continue to be developed under GPL.

#Running a Simple OpenEBS server
<pre-requisites>
TBD

#Building from Sources
<setup the golang environemtn>
OpenEBS requires Go 1.6.3 or above. If you running older version, you can upgrade to 1.6.3 using the following:

```bash
curl -fsSL "https://storage.googleapis.com/golang/go1.6.3.linux-amd64.tar.gz" | tar -xzC /usr/local
```

Fetch the code into your Go workspace.

```bash
mkdir -p $GOPATH/src/github.com/openebs/
cd $GOPATH/src/github.com/openebs/
git clone https://github.com/openebs/openebs.git
cd openebs/
sh auto-version.sh
make build
 
```


## Quick demo of OpenEBS 
[![OpenEBS Demo](https://s7.postimg.org/adw357irf/openebs_demo_png.png)](https://www.youtube.com/watch?v=jeeWIFiC5LQ)
