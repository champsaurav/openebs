// +build !experimental

package client

// APIClient is an interface that clients that talk with a openebs server must implement.
type APIClient interface {
	CommonAPIClient
}

// Ensure that Client always implements APIClient.
var _ APIClient = &Client{}
