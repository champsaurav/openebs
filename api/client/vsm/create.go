// Copyright 2016 CloudByte, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package vsm

import (
	"fmt"
	"golang.org/x/net/context"

	"github.com/openebs/openebs/api/client"
	"github.com/openebs/openebs/cli"
	"github.com/openebs/openebs/pkg/spf13/cobra"
	"github.com/openebs/openebs/types"
)

type createOptions struct {
	name       string
	ip         string
	ninterface string
	subnet     string
	router     string
	volume     string
	storage    string
}

func NewVSMCreateCommand(openEBSCli *client.OpenEBSCli) *cobra.Command {
	var opts createOptions

	cmd := &cobra.Command{
		Use:   "vsm-create --name=<name> --ip=<IP Address> ..",
		Short: "Create a new VSM",
		Args:  cli.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			return runCreate(openEBSCli, &opts)
		},
	}

	flags := cmd.Flags()

	flags.StringVar(&opts.name, "name", "", "Name of the VSM")
	flags.StringVar(&opts.ip, "ipaddr", "", "IP Address of the VSM")
	flags.StringVarP(&opts.ninterface, "iface", "", "", "Network interface of the VSM")
	flags.StringVarP(&opts.subnet, "subnet", "", "", "Subnet of the VSM")
	flags.StringVarP(&opts.router, "router", "", "", "Router of the VSM")
	flags.StringVarP(&opts.volume, "volume", "", "", "Name of the volume that will get created")
	flags.StringVarP(&opts.storage, "storage", "", "", "Backing storage of the VSM")

	return cmd
}

func runCreate(openEBSCli *client.OpenEBSCli, opts *createOptions) error {
	ctx := context.Background()

	options := types.VSMCreateOptions{
		Name:      opts.name,
		IP:        opts.ip,
		Interface: opts.ninterface,
		Subnet:    opts.subnet,
		Router:    opts.router,
		Volume:    opts.volume,
		Storage:   opts.storage,
	}

	vsm, err := openEBSCli.Client().VSMCreate(ctx, options)
	if err != nil {
		return err
	}

	if len(vsm.Name) > 0 {
		fmt.Fprintf(openEBSCli.Out(), "Created VSM %s\n", vsm.Name)
	}

	//fmt.Fprintf(openEBSCli.Out(), "TODO \n")

	return nil
}
